#!/usr/bin/env python
# mkdeb.py - builds a Debian package without dpkg-deb (OS X 10.8 has none).
#
#   python mkdeb.py <control file> <staging dir> <output dir>
#   python mkdeb.py --xxd <file> <C identifier>     (xxd -i replacement)
#
# Produces debian-binary + control.tar.gz + data.tar.gz in an ar archive,
# which is what Cydia's dpkg on iOS 5/6 expects. Every entry is owned by
# root:wheel; directories and Mach-O files are 0755, everything else 0644.
# Finder/SMB droppings (.DS_Store, ._*) are left out.
# Works with Python 2.7 and 3.x.

import io
import os
import sys
import tarfile
import time
import gzip

SKIP_NAMES = ('.DS_Store', '.gitkeep')


def is_macho(path):
    try:
        with open(path, 'rb') as f:
            magic = f.read(4)
    except IOError:
        return False
    return magic in (b'\xfe\xed\xfa\xce', b'\xce\xfa\xed\xfe', b'\xfe\xed\xfa\xcf', b'\xcf\xfa\xed\xfe', b'\xca\xfe\xba\xbe')


def tar_gz(members, now):
    """members: list of (archive name, source path or None for dirs, bytes or None)."""
    raw = io.BytesIO()
    tar = tarfile.open(fileobj=raw, mode='w', format=tarfile.GNU_FORMAT)
    for name, path, data in members:
        info = tarfile.TarInfo(name)
        info.uid = info.gid = 0
        info.uname = 'root'
        info.gname = 'wheel'
        info.mtime = now
        if data is None and path is None:
            info.type = tarfile.DIRTYPE
            info.mode = 0o755
            tar.addfile(info)
        else:
            if data is None:
                with open(path, 'rb') as f:
                    data = f.read()
            info.size = len(data)
            info.mode = 0o755 if (path and (is_macho(path) or os.access(path, os.X_OK) and name.startswith('./DEBIAN'))) else 0o644
            tar.addfile(info, io.BytesIO(data))
    tar.close()
    out = io.BytesIO()
    gz = gzip.GzipFile(fileobj=out, mode='wb', mtime=now)
    gz.write(raw.getvalue())
    gz.close()
    return out.getvalue()


def ar_member(name, data, now):
    header = '%-16s%-12d%-6d%-6d%-8s%-10d`\n' % (name, now, 0, 0, '100644', len(data))
    blob = header.encode('ascii') + data
    if len(data) % 2:
        blob += b'\n'
    return blob


def staged_members(stage):
    members = [('./', None, None)]
    total = 0
    for dirpath, dirnames, filenames in os.walk(stage):
        dirnames[:] = sorted(d for d in dirnames if not d.startswith('._') and d != 'DEBIAN')
        rel = os.path.relpath(dirpath, stage)
        if rel != '.':
            members.append(('./' + rel.replace(os.sep, '/') + '/', None, None))
        for fn in sorted(filenames):
            if fn in SKIP_NAMES or fn.startswith('._'):
                continue
            path = os.path.join(dirpath, fn)
            name = './' + os.path.normpath(os.path.join(rel, fn)).replace(os.sep, '/')
            members.append((name, path, None))
            total += os.path.getsize(path)
    return members, total


def main(argv):
    if len(argv) >= 2 and argv[1] == '--xxd':
        data = open(argv[2], 'rb').read()
        ident = argv[3]
        body = ', '.join('0x%02x' % (b if isinstance(b, int) else ord(b)) for b in data)
        sys.stdout.write('unsigned char %s[] = {\n  %s\n};\nunsigned int %s_len = %d;\n' % (ident, body, ident, len(data)))
        return 0

    control_path, stage, outdir = argv[1], argv[2], argv[3]
    now = int(time.time())
    fields = []
    for line in open(control_path).read().splitlines():
        if line.strip():
            fields.append(line.rstrip())
    members, total = staged_members(stage)
    fields = [f for f in fields if not f.startswith('Installed-Size:')]
    fields.append('Installed-Size: %d' % ((total + 1023) // 1024))
    control = ('\n'.join(fields) + '\n').encode('utf-8')

    get = dict(f.split(':', 1) for f in fields if ':' in f and not f.startswith(' '))
    package = get['Package'].strip()
    version = get['Version'].strip()
    arch = get.get('Architecture', 'iphoneos-arm').strip()

    control_tar = tar_gz([('./', None, None), ('./control', None, control)], now)
    data_tar = tar_gz(members, now)

    if not os.path.isdir(outdir):
        os.makedirs(outdir)
    out = os.path.join(outdir, '%s_%s_%s.deb' % (package, version, arch))
    with open(out, 'wb') as f:
        f.write(b'!<arch>\n')
        f.write(ar_member('debian-binary', b'2.0\n', now))
        f.write(ar_member('control.tar.gz', control_tar, now))
        f.write(ar_member('data.tar.gz', data_tar, now))
    print('[TubeFixLegacy] wrote %s (%d files, %d KB installed)' % (out, len([m for m in members if m[1]]), (total + 1023) // 1024))
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
