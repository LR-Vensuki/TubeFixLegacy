#!/usr/bin/env python3
"""idev.py - minimal usbmuxd + lockdownd client for old iOS devices (5/6), no
libimobiledevice needed. Uses the pairing record iTunes/3uTools/usbmuxd
already made. Commands:
    python3 tools/idev.py info              device model / iOS version
    python3 tools/idev.py syslog 120        live syslog for 120 s (grep TubeFixLegacy)
    python3 tools/idev.py afc2 ls /path     browse the file system (needs AFC2)
"""
import socket, struct, plistlib, ssl, sys, os, tempfile, time

MUX = '/var/run/usbmuxd'

def _mux_msg(sock, payload, tag=1):
    data = plistlib.dumps(payload)
    sock.sendall(struct.pack('<IIII', 16 + len(data), 1, 8, tag) + data)
    hdr = _recvn(sock, 16)
    ln, ver, typ, tg = struct.unpack('<IIII', hdr)
    return plistlib.loads(_recvn(sock, ln - 16))

def _recvn(sock, n):
    buf = b''
    while len(buf) < n:
        c = sock.recv(n - len(buf))
        if not c:
            raise EOFError('socket closed')
        buf += c
    return buf

def mux_base():
    return {'ClientVersionString': 'idev.py', 'ProgName': 'idev.py', 'kLibUSBMuxVersion': 3}

def list_devices():
    s = socket.socket(socket.AF_UNIX); s.connect(MUX)
    p = mux_base(); p['MessageType'] = 'ListDevices'
    r = _mux_msg(s, p); s.close()
    return r.get('DeviceList', [])

def read_pair_record(udid):
    s = socket.socket(socket.AF_UNIX); s.connect(MUX)
    p = mux_base(); p['MessageType'] = 'ReadPairRecord'; p['PairRecordID'] = udid
    r = _mux_msg(s, p); s.close()
    if 'PairRecordData' in r:
        return plistlib.loads(r['PairRecordData'])
    with open('/var/lib/lockdown/%s.plist' % udid, 'rb') as f:
        return plistlib.load(f)

def mux_connect(devid, port):
    s = socket.socket(socket.AF_UNIX); s.connect(MUX)
    p = mux_base(); p['MessageType'] = 'Connect'; p['DeviceID'] = devid
    p['PortNumber'] = socket.htons(port)
    r = _mux_msg(s, p)
    if r.get('Number', 1) != 0:
        raise RuntimeError('mux connect failed %r' % r)
    return s

class PlistConn:
    def __init__(self, sock):
        self.sock = sock
    def send(self, obj):
        d = plistlib.dumps(obj)
        self.sock.sendall(struct.pack('>I', len(d)) + d)
    def recv(self):
        ln = struct.unpack('>I', _recvn(self.sock, 4))[0]
        raw = _recvn(self.sock, ln)
        try:
            return plistlib.loads(raw)
        except Exception:
            import re
            raw = re.sub(rb'[\x00-\x08\x0b\x0c\x0e-\x1f]', b'?', raw)
            return plistlib.loads(raw)
    def req(self, obj):
        self.send(obj); return self.recv()

def _ssl_wrap(sock, pr):
    ctx = ssl.SSLContext(ssl.PROTOCOL_TLS_CLIENT)
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE
    import warnings
    warnings.simplefilter('ignore', DeprecationWarning)
    ver = os.environ.get('IDEV_TLS', 'TLSv1')
    ctx.minimum_version = getattr(ssl.TLSVersion, ver)
    ctx.maximum_version = getattr(ssl.TLSVersion, ver)
    ctx.options |= ssl.OP_NO_TICKET | getattr(ssl, "OP_LEGACY_SERVER_CONNECT", 0x4)
    ctx.set_ciphers('ALL:@SECLEVEL=0')
    d = tempfile.mkdtemp()
    cf = os.path.join(d, 'c.pem'); kf = os.path.join(d, 'k.pem')
    open(cf, 'wb').write(pr['HostCertificate']); open(kf, 'wb').write(pr['HostPrivateKey'])
    ctx.load_cert_chain(cf, kf)
    return ctx.wrap_socket(sock, server_hostname=None)

class Lockdown:
    def __init__(self, dev=None):
        devs = list_devices()
        if not devs:
            raise RuntimeError('no device')
        self.dev = dev or devs[0]
        self.devid = self.dev['DeviceID']
        self.udid = self.dev['Properties']['SerialNumber']
        self.pr = read_pair_record(self.udid)
        self.c = PlistConn(mux_connect(self.devid, 62078))
        r = self.c.req({'Label': 'idev', 'Request': 'QueryType'})
        r = self.c.req({'Label': 'idev', 'Request': 'StartSession', 'HostID': self.pr['HostID'],
                        'SystemBUID': self.pr.get('SystemBUID', '')})
        if 'Error' in r:
            raise RuntimeError('StartSession: %r' % r)
        self.session = r['SessionID']
        if r.get('EnableSessionSSL'):
            self.c.sock = _ssl_wrap(self.c.sock, self.pr)
    def get_value(self, domain=None, key=None):
        q = {'Label': 'idev', 'Request': 'GetValue'}
        if domain: q['Domain'] = domain
        if key: q['Key'] = key
        return self.c.req(q).get('Value')
    def start_service(self, name):
        r = self.c.req({'Label': 'idev', 'Request': 'StartService', 'Service': name})
        if 'Error' in r:
            raise RuntimeError('StartService %s: %r' % (name, r))
        s = mux_connect(self.devid, r['Port'])
        if r.get('EnableServiceSSL'):
            s = _ssl_wrap(s, self.pr)
        return s

# ---------------- AFC ----------------
AFC_MAGIC = b'CFA6LPAA'
class AFC:
    OP_STATUS=1; OP_DATA=2; OP_READ_DIR=3; OP_REMOVE=8; OP_MKDIR=9; OP_GET_FILE_INFO=10
    OP_FILE_OPEN=13; OP_FILE_OPEN_RES=14; OP_READ=15; OP_WRITE=16; OP_FILE_CLOSE=20; OP_RENAME=24
    def __init__(self, sock):
        self.s = sock; self.pkt = 0
    def _send(self, op, data=b'', payload=b''):
        self.pkt += 1
        this_len = 40 + len(data)
        tot = this_len + len(payload)
        self.s.sendall(AFC_MAGIC + struct.pack('<QQQQ', tot, this_len, self.pkt, op) + data + payload)
    def _recv(self):
        h = _recvn(self.s, 40)
        magic, tot, this_len, pkt, op = h[:8], *struct.unpack('<QQQQ', h[8:])
        body = _recvn(self.s, tot - 40)
        if op == self.OP_STATUS:
            code = struct.unpack('<Q', body[:8])[0]
            if code != 0:
                raise OSError('AFC error %d' % code)
        return op, body
    def listdir(self, path):
        self._send(self.OP_READ_DIR, path.encode() + b'\0')
        op, body = self._recv()
        return [x.decode('utf-8', 'replace') for x in body.split(b'\0') if x and x not in (b'.', b'..')]
    def stat(self, path):
        self._send(self.OP_GET_FILE_INFO, path.encode() + b'\0')
        op, body = self._recv()
        parts = body.split(b'\0')
        return dict(zip([p.decode() for p in parts[0::2]], [p.decode() for p in parts[1::2]]))
    def read(self, path):
        self._send(self.OP_FILE_OPEN, struct.pack('<Q', 1) + path.encode() + b'\0')
        op, body = self._recv()
        fd = struct.unpack('<Q', body[:8])[0]
        out = bytearray()
        while True:
            self._send(self.OP_READ, struct.pack('<QQ', fd, 1 << 20))
            op, body = self._recv()
            if not body: break
            out += body
        self._send(self.OP_FILE_CLOSE, struct.pack('<Q', fd)); self._recv()
        return bytes(out)
    def write(self, path, data):
        self._send(self.OP_FILE_OPEN, struct.pack('<Q', 3) + path.encode() + b'\0')  # 3 = wb
        op, body = self._recv()
        fd = struct.unpack('<Q', body[:8])[0]
        for i in range(0, len(data), 1 << 16):
            self._send(self.OP_WRITE, struct.pack('<Q', fd), data[i:i + (1 << 16)]); self._recv()
        self._send(self.OP_FILE_CLOSE, struct.pack('<Q', fd)); self._recv()
    def remove(self, path):
        self._send(self.OP_REMOVE, path.encode() + b'\0'); self._recv()
    def mkdir(self, path):
        self._send(self.OP_MKDIR, path.encode() + b'\0'); self._recv()
    def rename(self, a, b):
        self._send(self.OP_RENAME, a.encode() + b'\0' + b.encode() + b'\0'); self._recv()

def main():
    cmd = sys.argv[1] if len(sys.argv) > 1 else 'info'
    if cmd == 'list':
        for d in list_devices(): print(d)
        return
    ld = Lockdown()
    if cmd == 'info':
        v = ld.get_value()
        for k in ('DeviceName', 'ProductType', 'ProductVersion', 'BuildVersion', 'CPUArchitecture', 'UniqueDeviceID'):
            print(k, '=', v.get(k))
    elif cmd == 'apps':
        c = PlistConn(ld.start_service('com.apple.mobile.installation_proxy'))
        c.send({'Command': 'Browse', 'ClientOptions': {'ApplicationType': 'Any'}})
        while True:
            r = c.recv()
            for a in r.get('CurrentList', []) or []:
                print('%s\t%s\t%s\t%s\t%s' % (a.get('CFBundleIdentifier'), a.get('CFBundleShortVersionString'), a.get('CFBundleVersion'), a.get('CFBundleDisplayName') or a.get('CFBundleName'), a.get('Path')))
            if r.get('Status') == 'Complete' or 'Error' in r: break
    elif cmd == 'syslog':
        secs = float(sys.argv[2]) if len(sys.argv) > 2 else 30
        s = ld.start_service('com.apple.syslog_relay')
        s.settimeout(1.0)
        end = time.time() + secs
        buf = b''
        while time.time() < end:
            try:
                c = s.recv(65536)
                if not c: break
                sys.stdout.write(c.replace(b'\x00', b'').decode('utf-8', 'replace')); sys.stdout.flush()
            except socket.timeout:
                pass
    elif cmd in ('afc2', 'afc'):
        svc = 'com.apple.afc2' if cmd == 'afc2' else 'com.apple.afc'
        a = AFC(ld.start_service(svc))
        sub = sys.argv[2]
        if sub == 'ls':
            for n in sorted(a.listdir(sys.argv[3])): print(n)
        elif sub == 'stat':
            print(a.stat(sys.argv[3]))
        elif sub == 'get':
            data = a.read(sys.argv[3]); open(sys.argv[4], 'wb').write(data); print(len(data), 'bytes')
        elif sub == 'put':
            a.write(sys.argv[4], open(sys.argv[3], 'rb').read()); print('ok')
        elif sub == 'rm':
            a.remove(sys.argv[3]); print('ok')
        elif sub == 'mv':
            a.rename(sys.argv[3], sys.argv[4]); print('ok')
        elif sub == 'mkdir':
            a.mkdir(sys.argv[3]); print('ok')
    else:
        print('unknown cmd')

if __name__ == '__main__':
    main()
