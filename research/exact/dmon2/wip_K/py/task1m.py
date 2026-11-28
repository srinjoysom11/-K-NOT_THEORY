import sys
sys.path.insert(0, sys.argv[0].rsplit('/', 1)[0])
from l3lib import *
from cert import one_max
from collections import Counter
inv = {'e':'w','w':'e','n':'s','s':'n','u':'d','d':'u'}
for fn in sys.argv[1:]:
    W = [l.strip() for l in open(fn) if l.strip()]
    W = [w for w in W if not any(w[(i+2)%len(w)] == inv[w[i]] for i in range(len(w)))]
    c = Counter(); sides = Counter()
    for w in W:
        r = analyse(w); lm = False; l3s = r['L3all']
        for A, p, sd in twice_crossed(w):
            for sigma, arc in sd:
                if geodesic(arc): continue
                om = one_max(arc, A, p); inj = r['L3all']
                sides['NGside'] += 1; sides['NGside_onemax'] += om
                if om: lm = True
        c['tot'] += 1; c['L3'] += r['L3']; c['L3*9'] += l3s; c['LM'] += lm; c['L3_and_LM'] += r['L3'] and lm; c['L3*9|LM'] += l3s or lm
    print(fn, dict(c), dict(sides))
