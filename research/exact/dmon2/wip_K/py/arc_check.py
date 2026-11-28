"""Independent enumeration (Python) of the arcs of arcinj.cpp: half-space z >= 1, start (0,0,1) entered by u, end at z = 1
left by d, self-avoiding, no reversal / U-turn (also with the two crossing letters), first horizontal letter e, first
n/s letter n.  Counts: arcs, non-geodesic, non-injective along z, along the 9 directions, along D9 + D(K=3); and
certificate search for the last ones."""
import sys
sys.path.insert(0, sys.argv[0].rsplit('/', 1)[0])
from cert import inj_any, D9, DX, certificate
from l3lib import VEC
L = int(sys.argv[1])
LET = 'ewnsud'; INV = {'e': 'w', 'w': 'e', 'n': 's', 's': 'n', 'u': 'd', 'd': 'u'}
cnt = dict(arcs=0, ng=0, ax=0, n9=0, nx=0, nocert=0)
def rec(path, word, seenH, seenNS):
    k = len(word)
    if k == L:
        if path[-1][2] != 1: return
        full = 'u' + word + 'd'
        if any(full[i + 2] == INV[full[i]] or full[i + 1] == INV[full[i]] for i in range(len(full) - 2)) or full[-1] == INV[full[-2]]: return
        cnt['arcs'] += 1
        if L == abs(path[-1][0]) + abs(path[-1][1]): return
        cnt['ng'] += 1
        if inj_any(path, 2, 0, [(0, 0, 1)]): return
        cnt['ax'] += 1
        if inj_any(path, 2, 0, D9): return
        cnt['n9'] += 1
        if inj_any(path, 2, 0, DX): return
        cnt['nx'] += 1
        if certificate(path, 2, 0, D9 + DX) is None: cnt['nocert'] += 1; print('NOCERT', full)
        return
    prev = ('u' + word)[-1]; prev2 = ('u' + word)[-2] if k >= 1 else None
    for c in LET:
        if c == INV[prev] or (prev2 and c == INV[prev2]): continue
        if not seenH and c in 'wns': continue
        if not seenNS and c == 's': continue
        v = VEC[c]; q = (path[-1][0] + v[0], path[-1][1] + v[1], path[-1][2] + v[2])
        if q[2] < 1 or q[2] - 1 > L - k - 1 or q in S: continue
        S.add(q); path.append(q)
        rec(path, word + c, seenH or c in 'ewns', seenNS or c in 'ns')
        path.pop(); S.discard(q)
S = {(0, 0, 1)}
rec([(0, 0, 1)], '', False, False)
print(f'L={L}', cnt)
