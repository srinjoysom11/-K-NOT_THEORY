import sys
sys.path.insert(0, sys.argv[0].rsplit('/', 1)[0])
from l3lib import *
for n in map(int, sys.argv[1:]):
    F0 = [l.strip() for l in open(f'out/F0_n{n}.txt') if l.strip()]
    F = set(l.strip() for l in open(f'out/F_n{n}.txt') if l.strip())
    assert F <= set(F0), "F not subset of F0"
    cnt = dict(tot=len(F0), F=len(F), notF=0, L3=0, F2=0, L3orF2=0, notF_unexpl=0, L3inF=0, ax=0, al=0, axF2=0, alF2=0)
    miss = []
    for w in F0:
        r = analyse(w); f2 = f2_kill(w)
        cnt['L3'] += r['L3']; cnt['F2'] += f2; cnt['L3orF2'] += (r['L3'] or f2)
        cnt['ax'] += r['L3ax']; cnt['al'] += r['L3all']
        cnt['axF2'] += (r['L3ax'] or f2); cnt['alF2'] += (r['L3all'] or f2)
        if w not in F:
            cnt['notF'] += 1
            if not (r['L3'] or f2): cnt['notF_unexpl'] += 1; print('UNEXPLAINED', w)
        elif r['L3'] or f2: cnt['L3inF'] += 1; print('in F but L3/F2', w, r['L3'], f2)
        assert not (r['L3all'] and not r['L3']) or True
        if r['L3'] and not r['L3all'] and not f2:
            # shortest non-injective side over the planes where both sides are non-geodesic
            m = min(min(s[1] for s in info) for (A, p, info) in r['planes'] if not info[0][2] and not info[1][2])
            miss.append((m, w))
        if w in F and (r['L3ax'] or r['L3all']): print('WARNING: L3* kills a word of F', w)
    print(n, cnt)
    print(' missed by L3*(all), shortest side lengths:', sorted(m for m, _ in miss))
