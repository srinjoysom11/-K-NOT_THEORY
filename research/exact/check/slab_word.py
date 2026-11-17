#!/usr/bin/env python3
"""slab_word.py WORD [WORD...] -- length, height (z-extent), self-avoidance and knot type (identify6)."""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
import identify6 as i6
D = {'e': (1, 0, 0), 'w': (-1, 0, 0), 'n': (0, 1, 0), 's': (0, -1, 0), 'u': (0, 0, 1), 'd': (0, 0, -1)}
for w in sys.argv[1:]:
    p = [(0, 0, 0)]
    for c in w:
        d = D[c]; q = p[-1]; p.append((q[0] + d[0], q[1] + d[1], q[2] + d[2]))
    ok = p[-1] == (0, 0, 0) and len(set(p[:-1])) == len(w)
    zs = [v[2] for v in p]
    print(len(w), 'height', max(zs) - min(zs), 'saw' if ok else 'NOT-A-POLYGON', i6.classify(w, True)[2], w)
