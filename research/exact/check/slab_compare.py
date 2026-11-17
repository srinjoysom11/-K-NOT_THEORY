#!/usr/bin/env python3
"""slab_compare.py BEST_FILE L -- compare checked witnesses (output of slab_witnesses8.py) with
the published Monte Carlo values (data/slab_published.txt). Marks every polygon shorter than
the published minimum."""
import os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
pub = {}
for line in open(os.path.join(HERE, '..', 'data', 'slab_published.txt')):
    if line.startswith('#') or not line.strip():
        continue
    f = line.split(); pub[f[0]] = [int(x) for x in f[1:]]
L = int(sys.argv[2])
for line in open(sys.argv[1]):
    f = line.split('\t')
    if len(f) < 4:
        continue
    k, n = f[0], int(f[1])
    p = pub.get(k, [None] * 4)[L - 1]
    mark = '  <-- SHORTER THAN PUBLISHED' if p and n < p else ('' if p is None or n == p else '  (above published)')
    print(f'{k}\t{n}\tpublished {p}{mark}')
