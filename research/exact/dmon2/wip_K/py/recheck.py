import sys
sys.path.insert(0, sys.argv[0].rsplit('/', 1)[0])
from cert import justify
from collections import Counter
# usage: recheck.py closF0 candF0 closG candG M use_f2
cF0, kF0, cG, kG, M, f2 = sys.argv[1:7]; M = int(M); f2 = f2 == '1'; um = len(sys.argv) > 7
rd = lambda f: set(l.strip() for l in open(f) if l.strip())
CF0, KF0, CG, KG = rd(cF0), rd(kF0), rd(cG), rd(kG)
assert CG <= CF0, 'G closed walks not a subset of F0'
assert KG <= KF0, 'G candidates not a subset of F0'
rem = CF0 - CG
stat = Counter(); bad = []
for w in sorted(rem):
    r = justify(w, M, f2, um)
    cand = w in KF0
    stat[(cand, (r or 'NONE').split(' ')[0])] += 1
    if r is None and cand: bad.append(w)
# also candidates of F0 that are closed in G but not candidates of G (removed by the leaf test S3 or F2)
rem2 = (KF0 & CG) - KG
for w in sorted(rem2):
    r = justify(w, M, f2, um)
    stat[('leaf', (r or 'NONE').split(' ')[0])] += 1
    if r is None: bad.append(w)
print(f'closedF0={len(CF0)} closedG={len(CG)} removed_closed={len(rem)} removed_at_leaf={len(rem2)} reasons={dict(stat)} UNJUSTIFIED_CANDIDATES={len(bad)}')
for w in bad: print('  UNJUSTIFIED', w)
