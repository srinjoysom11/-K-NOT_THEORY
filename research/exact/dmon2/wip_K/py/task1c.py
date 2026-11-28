import sys
sys.path.insert(0, sys.argv[0].rsplit('/', 1)[0])
from l3lib import *
from collections import Counter
for fn in sys.argv[1:]:
    inv={'e':'w','w':'e','n':'s','s':'n','u':'d','d':'u'}
    W = [l.strip() for l in open(fn) if l.strip()]
    W = [w for w in W if not any(w[(i+2)%len(w)]==inv[w[i]] for i in range(len(w)))]
    c = Counter(); miss = Counter()
    for w in W:
        r = analyse(w)
        c['tot'] += 1; c['L3'] += r['L3']; c['L3*ax'] += r['L3ax']; c['L3*9'] += r['L3all']
        c['L3*9_not_L3'] += r['L3all'] and not r['L3']
        c['L3_and_L3*9'] += r['L3all'] and r['L3']
        c['L3_and_L3*ax'] += r['L3ax'] and r['L3']
        if r['L3'] and not r['L3all']:
            m = min(min(s[1] for s in info) for (A, p, info) in r['planes'] if not info[0][2] and not info[1][2])
            miss[m] += 1
    print(fn, dict(c)); print('  L3 kills missed by L3*(9): shortest side length histogram', sorted(miss.items()))
