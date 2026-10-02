#!/usr/bin/env python
# regenerate.py - refreshes xcode/sources/*.txt (file lists, taken from the
# Theos Makefiles so both builds compile the same files) and
# xcode/generated/ (Logos output for every .x file, used by build.sh when
# Perl/Logos can't run). Run it after adding/removing/editing sources:
#     python xcode/regenerate.py
# Works with Python 2.7 (OS X 10.8) and 3.x.
import os, re, glob, subprocess, sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
TARGETS = [('googleapp', 'TubeFixLegacy'), ('classic', 'TubeFixLegacyClassic'), ('preferences', 'TubeFixLegacyPrefs')]

def makefile_files(subdir, name):
    text = open(os.path.join(ROOT, subdir, 'Makefile')).read().replace('\\\n', ' ')
    variables = {'THEOS_PROJECT_DIR': ROOT}
    for m in re.finditer(r'^([A-Za-z_]+)\s*[:+]?=\s*(.*)$', text, re.M):
        if m.group(1) in ('COMMON', 'LIB_DIR', 'COMMON_GOOGLE', 'GOOGLE_APP_FILES'):
            variables[m.group(1)] = m.group(2).strip()
    def expand(s):
        for _ in range(5):
            s = re.sub(r'\$\((\w+)\)', lambda m: variables.get(m.group(1), m.group(0)), s)
        return s
    m = re.search(r'^' + name + r'_FILES\s*[:+]?=\s*(.*)$', text, re.M)
    words = expand(m.group(1))
    files = []
    for shell in re.findall(r'\$\(shell find (\S+) -type f -name \'\*\.(\w+)\'\)', words):
        files += sorted(glob.glob(os.path.join(shell[0], '**', '*.' + shell[1]), recursive=True) if sys.version_info[0] >= 3
                        else [os.path.join(dp, f) for dp, dn, fn in os.walk(shell[0]) for f in fn if f.endswith('.' + shell[1])])
    words = re.sub(r'\$\(shell [^)]*\)', ' ', words)
    for w in words.split():
        path = w if os.path.isabs(w) else os.path.join(ROOT, subdir, w)
        files.append(os.path.normpath(path))
    out = []
    for f in files:
        rel = os.path.relpath(os.path.normpath(f), ROOT)
        if rel not in out:
            out.append(rel)
    return out

def main():
    logos = os.path.join(ROOT, 'xcode', 'logos', 'bin', 'logos.pl')
    for subdir, name in TARGETS:
        files = makefile_files(subdir, name)
        with open(os.path.join(ROOT, 'xcode', 'sources', name + '.txt'), 'w') as f:
            f.write('\n'.join(files) + '\n')
        print('%s: %d files' % (name, len(files)))
        for rel in files:
            if not rel.endswith('.x'):
                continue
            out = os.path.join(ROOT, 'xcode', 'generated', rel + '.m')
            if not os.path.isdir(os.path.dirname(out)):
                os.makedirs(os.path.dirname(out))
            data = subprocess.check_output(['perl', logos, '-c', 'generator=MobileSubstrate', '-c', 'warnings=error', rel], cwd=ROOT)
            open(out, 'wb').write(data)

if __name__ == '__main__':
    main()
