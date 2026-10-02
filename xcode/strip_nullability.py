#!/usr/bin/env python3
"""Remove Objective-C nullability annotations and __kindof so headers parse
with Apple LLVM 4.2 (Xcode 4.6.3). Annotations carry no runtime meaning."""
import re, sys
PROP = re.compile(r'(@property\s*\()([^)]*)(\))')
WORDS = {'nullable', 'nonnull', 'null_resettable', 'null_unspecified'}
def fix_prop(m):
    parts = [p.strip() for p in m.group(2).split(',')]
    parts = [p for p in parts if p and p not in WORDS]
    return m.group(1) + ', '.join(parts) + m.group(3)
def strip(s):
    s = PROP.sub(fix_prop, s)
    s = re.sub(r'\b(_Nullable|_Nonnull|_Null_unspecified|__nullable|__nonnull|__null_unspecified)\b\s?', '', s)
    s = re.sub(r'\(\s*(nullable|nonnull|null_unspecified)\s+', '(', s)
    s = re.sub(r'\b__kindof\s+', '', s)
    return s
if __name__ == '__main__':
    n = 0
    for f in sys.argv[1:]:
        t = open(f, encoding='utf-8', errors='surrogateescape').read()
        u = strip(t)
        if u != t:
            open(f, 'w', encoding='utf-8', errors='surrogateescape').write(u); n += 1
    print(n, 'files changed')
