#!/usr/bin/env python3
"""Remove Objective-C lightweight generic arguments from Foundation
collection types (NSArray<NSString *> * -> NSArray *) so the code builds
with pre-Xcode-7 compilers / SDKs. Protocol qualifiers (id<P>, NSObject<P>)
are left alone. Usage: strip_generics.py file..."""
import re, sys
COLL = r'(?:NSArray|NSMutableArray|NSDictionary|NSMutableDictionary|NSSet|NSMutableSet|NSOrderedSet|NSMutableOrderedSet|NSEnumerator|NSCache|NSHashTable|NSMapTable|NSCountedSet|NSFastEnumeration|GPB\w*ObjectDictionary)'
def strip(src):
    out = []; i = 0
    rx = re.compile(r'\b' + COLL + r'\s*<')
    while True:
        m = rx.search(src, i)
        if not m: out.append(src[i:]); break
        # find matching '>'
        j = m.end(); depth = 1
        while j < len(src) and depth:
            if src[j] == '<': depth += 1
            elif src[j] == '>': depth -= 1
            j += 1
        inner = src[m.end():j-1]
        # a generic argument list contains a '*' or is a plain type/protocol list used as type args
        # (NSArray<id<P>>); a comparison like "a < b" would contain operators we don't expect
        if depth == 0 and re.fullmatch(r'[\w\s\*,<>_]*', inner) and ('*' in inner or re.fullmatch(r'\s*id\s*(<[\w\s,]*>)?\s*(,\s*id\s*(<[\w\s,]*>)?\s*)*', inner) or re.fullmatch(r'[\s\w,]*', inner)):
            name = src[m.start():m.end()-1].rstrip()
            out.append(src[i:m.start()]); out.append(name)
            i = j
        else:
            out.append(src[i:m.end()]); i = m.end()
    return ''.join(out)
if __name__ == '__main__':
    n = 0
    for f in sys.argv[1:]:
        s = open(f, encoding='utf-8', errors='surrogateescape').read()
        t = strip(s)
        if t != s:
            open(f, 'w', encoding='utf-8', errors='surrogateescape').write(t); n += 1
            print('stripped', f)
    print(n, 'files changed')
