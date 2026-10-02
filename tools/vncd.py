#!/usr/bin/env python3
"""vncd.py - tiny VNC client for Veency over USB (usbmuxd), for testing the
tweak on a real device from scripts.

    python3 tools/vncd.py serve          connect to Veency (asks for its
                                         password once) and keep the session
                                         open; control port 127.0.0.1:5999
    python3 tools/vncd.py shot out.png [scale]
    python3 tools/vncd.py tap X Y        coordinates in device pixels
    python3 tools/vncd.py dtap X Y       double tap
    python3 tools/vncd.py hold X Y MS    long press
    python3 tools/vncd.py swipe X1 Y1 X2 Y2 [MS]
    python3 tools/vncd.py home | lock    hardware buttons (Veency mapping)
    python3 tools/vncd.py type TEXT
    python3 tools/vncd.py size

The password is read from the terminal only (never from arguments/files).
"""
import getpass, json, os, socket, struct, sys, threading, time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import idev

CTL = ('127.0.0.1', 5999)


def des_response(password, challenge):
    from cryptography.hazmat.decrepit.ciphers.algorithms import TripleDES
    from cryptography.hazmat.primitives.ciphers import Cipher, modes
    key = (password.encode('latin-1') + b'\0' * 8)[:8]
    key = bytes(int('{:08b}'.format(b)[::-1], 2) for b in key)  # VNC bit order
    enc = Cipher(TripleDES(key), modes.ECB()).encryptor()
    return enc.update(challenge) + enc.finalize()


class VNC:
    def __init__(self, port):
        self.port = port
        self.password = None
        self.lock = threading.Condition()
        self.sock = None
        self.w = self.h = 0
        self.fb = bytearray()
        self.updates = 0
        self.buttons = 0
        self.alive = False

    # --- connection -----------------------------------------------------
    def connect(self):
        devs = idev.list_devices()
        if not devs:
            raise RuntimeError('no device on usbmuxd')
        s = idev.mux_connect(devs[0]['DeviceID'], self.port)
        rd = lambda n: idev._recvn(s, n)
        ver = rd(12)
        minor = int(ver[8:11])
        s.sendall(b'RFB 003.008\n' if minor >= 8 else b'RFB 003.003\n')
        if minor >= 7:
            n = rd(1)[0]
            if n == 0:
                raise RuntimeError('server refused: %r' % rd(struct.unpack('>I', rd(4))[0]))
            types = list(rd(n))
            sec = 2 if 2 in types else 1 if 1 in types else None
            if sec is None:
                raise RuntimeError('unsupported security types %r' % types)
            s.sendall(bytes([sec]))
        else:
            sec = struct.unpack('>I', rd(4))[0]
        if sec == 2:
            if self.password is None:
                self.password = getpass.getpass('Veency password: ')
            s.sendall(des_response(self.password, rd(16)))
        if sec == 2 or minor >= 8:
            if struct.unpack('>I', rd(4))[0] != 0:
                self.password = None
                raise RuntimeError('VNC authentication failed')
        s.sendall(b'\x01')  # shared
        w, h = struct.unpack('>HH', rd(4))
        rd(16)
        rd(struct.unpack('>I', rd(4))[0])
        # 32bpp little-endian BGRX
        s.sendall(struct.pack('>B3xBBBBHHHBBB3x', 0, 32, 24, 0, 1, 255, 255, 255, 16, 8, 0))
        s.sendall(struct.pack('>BxHiii', 2, 3, 0, 1, -223))  # raw, copyrect, desktopsize
        with self.lock:
            self.sock, self.w, self.h = s, w, h
            self.fb = bytearray(w * h * 4)
            self.alive = True
        self.request(False)
        print('[vncd] connected %dx%d' % (w, h), flush=True)

    def request(self, incremental=True):
        self.sock.sendall(struct.pack('>BBHHHH', 3, 1 if incremental else 0, 0, 0, self.w, self.h))

    def reader(self):
        s = self.sock
        rd = lambda n: idev._recvn(s, n)
        while True:
            t = rd(1)[0]
            if t == 0:
                rd(1)
                for _ in range(struct.unpack('>H', rd(2))[0]):
                    x, y, w, h, enc = struct.unpack('>HHHHi', rd(12))
                    if enc == 0:
                        data = rd(w * h * 4)
                        with self.lock:
                            for row in range(h):
                                o = ((y + row) * self.w + x) * 4
                                self.fb[o:o + w * 4] = data[row * w * 4:(row + 1) * w * 4]
                    elif enc == 1:
                        sx, sy = struct.unpack('>HH', rd(4))
                        with self.lock:
                            rows = [bytes(self.fb[((sy + r) * self.w + sx) * 4:((sy + r) * self.w + sx + w) * 4]) for r in range(h)]
                            for r in range(h):
                                o = ((y + r) * self.w + x) * 4
                                self.fb[o:o + w * 4] = rows[r]
                    elif enc == -223:
                        with self.lock:
                            self.w, self.h = w, h
                            self.fb = bytearray(w * h * 4)
                        print('[vncd] resized %dx%d' % (w, h), flush=True)
                    else:
                        raise RuntimeError('unexpected encoding %d' % enc)
                with self.lock:
                    self.updates += 1
                    self.lock.notify_all()
                time.sleep(0.05)
                self.request(True)
            elif t == 1:
                rd(3)
                rd(6 * struct.unpack('>H', rd(2))[0])
            elif t == 2:
                pass
            elif t == 3:
                rd(3)
                rd(struct.unpack('>I', rd(4))[0])
            else:
                raise RuntimeError('unknown server message %d' % t)

    # --- input ----------------------------------------------------------
    def pointer(self, mask, x, y):
        self.buttons = mask
        self.sock.sendall(struct.pack('>BBHH', 5, mask, int(x), int(y)))

    def key(self, sym, down):
        self.sock.sendall(struct.pack('>BBxxI', 4, 1 if down else 0, sym))

    def shot(self, path, scale=1.0):
        from PIL import Image
        with self.lock:
            n = self.updates
            self.request(False)
            end = time.time() + 5
            while self.updates == n and time.time() < end:
                self.lock.wait(end - time.time())
            img = Image.frombytes('RGB', (self.w, self.h), bytes(self.fb), 'raw', 'BGRX')
        if scale != 1.0:
            img = img.resize((int(self.w * scale), int(self.h * scale)), Image.LANCZOS)
        img.save(path)
        return {'path': os.path.abspath(path), 'size': [self.w, self.h]}

    def handle(self, args):
        cmd = args[0]
        if not self.alive:
            return {'error': 'not connected'}
        if cmd == 'size':
            return {'size': [self.w, self.h]}
        if cmd == 'shot':
            return self.shot(args[1], float(args[2]) if len(args) > 2 else 1.0)
        if cmd == 'tap':
            x, y = int(args[1]), int(args[2])
            self.pointer(0, x, y); time.sleep(0.03)
            self.pointer(1, x, y); time.sleep(0.08)
            self.pointer(0, x, y)
            return {'ok': True}
        if cmd == 'dtap':
            x, y = int(args[1]), int(args[2])
            for _ in range(2):
                self.pointer(1, x, y); time.sleep(0.06)
                self.pointer(0, x, y); time.sleep(0.09)
            return {'ok': True}
        if cmd == 'hold':
            x, y, ms = int(args[1]), int(args[2]), int(args[3])
            self.pointer(1, x, y); time.sleep(ms / 1000.0)
            self.pointer(0, x, y)
            return {'ok': True}
        if cmd == 'swipe':
            x1, y1, x2, y2 = [int(a) for a in args[1:5]]
            ms = int(args[5]) if len(args) > 5 else 300
            steps = max(6, ms // 20)
            self.pointer(1, x1, y1)
            for i in range(1, steps + 1):
                time.sleep(ms / 1000.0 / steps)
                self.pointer(1, x1 + (x2 - x1) * i // steps, y1 + (y2 - y1) * i // steps)
            time.sleep(0.05)
            self.pointer(0, x2, y2)
            return {'ok': True}
        if cmd in ('home', 'lock', 'btn'):
            mask = {'home': 4, 'lock': 2}.get(cmd) or int(args[1])
            self.pointer(mask, 0, 0); time.sleep(0.15)
            self.pointer(0, 0, 0)
            return {'ok': True}
        if cmd == 'type':
            for ch in ' '.join(args[1:]):
                sym = {'\n': 0xff0d, '\b': 0xff08}.get(ch, ord(ch))
                self.key(sym, True); self.key(sym, False); time.sleep(0.03)
            return {'ok': True}
        if cmd == 'keysym':
            sym = int(args[1], 0)
            self.key(sym, True); self.key(sym, False)
            return {'ok': True}
        return {'error': 'unknown command %s' % cmd}


def serve(port):
    v = VNC(port)
    v.connect()  # first connect in the foreground so the password prompt is visible

    def loop():
        while True:
            try:
                v.reader()
            except Exception as e:
                v.alive = False
                print('[vncd] disconnected: %s' % e, flush=True)
            while True:
                time.sleep(2)
                try:
                    v.connect()
                    break
                except Exception as e:
                    print('[vncd] reconnect failed: %s' % e, flush=True)
    threading.Thread(target=loop, daemon=True).start()

    srv = socket.socket()
    srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    srv.bind(CTL)
    srv.listen(4)
    print('[vncd] control on %s:%d' % CTL, flush=True)
    while True:
        c, _ = srv.accept()
        try:
            line = b''
            while not line.endswith(b'\n'):
                chunk = c.recv(4096)
                if not chunk:
                    break
                line += chunk
            args = json.loads(line.decode())
            try:
                res = v.handle(args)
            except Exception as e:
                res = {'error': repr(e)}
            c.sendall((json.dumps(res) + '\n').encode())
        finally:
            c.close()


def client(args):
    s = socket.create_connection(CTL, timeout=30)
    s.sendall((json.dumps(args) + '\n').encode())
    data = b''
    while True:
        chunk = s.recv(65536)
        if not chunk:
            break
        data += chunk
    res = json.loads(data.decode())
    print(json.dumps(res))
    return 1 if 'error' in res else 0


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)
    if sys.argv[1] == 'serve':
        serve(int(sys.argv[2]) if len(sys.argv) > 2 else 5900)
    else:
        sys.exit(client(sys.argv[1:]))
