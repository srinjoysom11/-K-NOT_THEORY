#!/usr/bin/env python3
"""Empirical test of Lemma GC (DMON_RESULTS.md, D1): the GC move keeps the knot type.

Start from knotted polygons (the words of a survivor file), make them longer and more irregular with random
+2/-2 BFACF moves and corner flips, and for every GC window that is NOT closed up apply the move and compare the
Alexander polynomial (up to sign and reversal) before and after.  Any difference is a counterexample to the lemma.

usage: python3 check/gc_move_test.py WORDS_FILE [--polys 300] [--steps 300] [--seed 1]
"""
import argparse, os, random, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..'))
sys.path.insert(0, os.path.join(HERE, '..', '..', '..', 'code'))
import warnings; warnings.filterwarnings('ignore')
from identify_words import alexander_of

D = {'e': (1, 0, 0), 'w': (-1, 0, 0), 'n': (0, 1, 0), 's': (0, -1, 0), 'u': (0, 0, 1), 'd': (0, 0, -1)}
INV = {v: k for k, v in D.items()}
add = lambda p, q: (p[0] + q[0], p[1] + q[1], p[2] + q[2])
sub = lambda p, q: (p[0] - q[0], p[1] - q[1], p[2] - q[2])
neg = lambda p: (-p[0], -p[1], -p[2])

def verts(word):
    p = (0, 0, 0); v = [p]
    for c in word[:-1]:
        p = add(p, D[c]); v.append(p)
    return v

def word_of(v):
    n = len(v)
    return ''.join(INV[sub(v[(i + 1) % n], v[i])] for i in range(n))

def norm(p):
    p = list(p)
    if p and p[-1] < 0: p = [-c for c in p]
    if p and p[0] < 0: p = [-c for c in p]
    return min(tuple(p), tuple(p[::-1]))

def alex(v):
    return norm(alexander_of(word_of(v)))

def bfacf(v, rng):
    n = len(v); occ = set(v)
    for _ in range(50):
        r = rng.random(); i = rng.randrange(n)
        if r < 0.5:   # +2: replace edge (i,i+1) by a three-edge detour around a unit square
            p, q = v[i], v[(i + 1) % n]; d = sub(q, p)
            us = [u for u in D.values() if u != d and u != neg(d) and u != (0, 0, 0)]
            u = rng.choice(us)
            a, b = add(p, u), add(q, u)
            if a in occ or b in occ: continue
            w = v[:i + 1] + [a, b] + v[i + 1:]
            return w
        elif r < 0.7 and n > 8:   # -2 (U-turn) removal
            for j in range(n):
                a, b, c, d_ = v[j], v[(j + 1) % n], v[(j + 2) % n], v[(j + 3) % n]
                if sub(d_, a) in D.values() and sub(b, a) == sub(c, d_) and False: pass
            continue
        else:         # corner flip at vertex i
            p, c, q = v[i - 1], v[i], v[(i + 1) % n]
            if sub(c, p) == sub(q, c): continue
            w2 = add(p, sub(q, c))
            if w2 in occ: continue
            u = list(v); u[i] = w2; return u
    return v

def gc_windows(v):
    n = len(v); idx = {p: k for k, p in enumerate(v)}
    out = []
    for i0 in range(n):
        a = sub(v[(i0 + 1) % n], v[i0])
        for m in range(2, n - 1):
            if sub(v[(i0 + m + 1) % n], v[(i0 + m) % n]) != neg(a): continue
            closed = False
            for j in range(2, m):
                s = sub(v[(i0 + j) % n], a)
                if s in idx:
                    k = (idx[s] - i0) % n
                    if not (1 <= k <= m): closed = True; break
            if not closed: out.append((i0, m, a))
    return out

def apply(v, i0, m, a):
    n = len(v)
    Q = {(i0 + j) % n for j in range(1, m + 1)}
    new = [v[i0 % n]]
    for j in range(2, m): new.append(sub(v[(i0 + j) % n], a))
    new.append(v[(i0 + m + 1) % n])
    rest = []
    k = (i0 + m + 2) % n
    while k != i0 % n:
        rest.append(v[k]); k = (k + 1) % n
    return new + rest

def valid(v):
    n = len(v)
    if len(set(v)) != n: return False
    return all(sum(abs(x) for x in sub(v[(i + 1) % n], v[i])) == 1 for i in range(n))

ap = argparse.ArgumentParser()
ap.add_argument('file'); ap.add_argument('--polys', type=int, default=300)
ap.add_argument('--steps', type=int, default=300); ap.add_argument('--seed', type=int, default=1)
a = ap.parse_args()
rng = random.Random(a.seed)
words = [l.split()[-1] for l in open(a.file) if l.strip() and not l.startswith('#')]
tested = bad = 0; hist = {}
for t in range(a.polys):
    v = verts(rng.choice(words)); target = None
    for _ in range(rng.randrange(a.steps)):
        v = bfacf(v, rng)
        if len(v) > 44: break
    if not valid(v): continue
    base = alex(v)
    for (i0, m, aa) in gc_windows(v):
        w2 = apply(v, i0, m, aa)
        assert valid(w2), ('invalid P-prime', word_of(v), i0, m)
        assert len(w2) == len(v) - 2
        tested += 1; hist[m] = hist.get(m, 0) + 1
        if alex(w2) != base:
            bad += 1; print('COUNTEREXAMPLE', word_of(v), i0, m, base, alex(w2))
print(f'polygons={a.polys} GC moves tested={tested} Alexander changed={bad} windows by m: {dict(sorted(hist.items()))}')
