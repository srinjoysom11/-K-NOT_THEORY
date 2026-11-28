import sys
sys.path.insert(0, sys.argv[0].rsplit('/', 1)[0])
from l3lib import *
from collections import Counter
for n in map(int, sys.argv[1:]):
    C0 = [l.strip() for l in open(f'out/cand_F0_n{n}.txt') if l.strip()]
    CF = set(l.strip() for l in open(f'out/cand_F_n{n}.txt') if l.strip())
    assert CF <= set(C0)
    c = Counter(); miss = Counter(); planes = Counter()
    for w in C0:
        r = analyse(w); f2 = f2_kill(w)
        c['tot'] += 1; c['inF'] += w in CF
        c['L3'] += r['L3']; c['F2'] += f2; c['L3|F2'] += r['L3'] or f2
        c['L3*ax'] += r['L3ax']; c['L3*9'] += r['L3all']
        c['L3*ax|F2'] += r['L3ax'] or f2; c['L3*9|F2'] += r['L3all'] or f2
        if w not in CF and not (r['L3'] or f2): c['notF_unexplained'] += 1
        if w in CF and r['L3']: c['inF_but_L3'] += 1
        if r['L3all'] and not r['L3']: c['L3*_not_L3'] += 1
        if r['L3'] and not r['L3all']:
            m = min(min(s[1] for s in info) for (A, p, info) in r['planes'] if not info[0][2] and not info[1][2])
            miss[m] += 1
    print(n, dict(c)); print('  L3 kills missed by L3*(9 dirs): shortest side length histogram', sorted(miss.items()))
