#!/usr/bin/env python3
"""
slab_census.py -- number of polygons of one knot type in a slab, from the output of slab.cpp.

    python3 check/slab_census.py WORDS_FILE --alex "1,-1,1" [--limit 5000000]

Steps: keep the words with the given Alexander polynomial (up to reversal and sign); close the
set under corner flips (a flip never leaves the bounding box of the polygon, so the closure
stays in the slab); apply the 16 symmetries of the slab (signed permutations of the axes that
keep the z-axis); count distinct polygons up to translation. With the 8 symmetries of
determinant +1 only, the count splits by chirality.
If the search output contains a polygon of every flip class (up to the symmetries the search
uses), the count is the number of shortest polygons of that knot type in the slab.
With --all48 the input is the output of the unconfined search (enum.cpp, normal form with
#z <= #y <= #x) and all 48 symmetries are applied: at n = Len(K) this gives the shortest polygons
of K in every slab in which Len(K) is attained.
The height of every polygon (z-extent) is also tallied, which gives the counts for narrower
slabs at the same length.
"""
import argparse
import os
import sys
from collections import Counter, deque

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(HERE, '..'))
from crosscheck import canon, flips, group, apply_g, word_to_verts, verts_to_word, is_closed_saw  # noqa: E402


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('file')
    ap.add_argument('--alex', default=None)
    ap.add_argument('--limit', type=int, default=5000000)
    ap.add_argument('--out', default=None, help='write all polygons found (one word per line)')
    ap.add_argument('--all48', action='store_true',
                    help='input is unconfined enum.cpp output: apply all 48 symmetries, then count by height')
    a = ap.parse_args()
    words = [l.split()[-1] for l in open(a.file) if l.strip() and not l.startswith('#')]
    words = [w for w in words if set(w) <= set('ewnsud') and is_closed_saw(w)]
    if a.alex:
        from identify_words import alexander_of
        want = tuple(int(x) for x in a.alex.split(','))

        def norm(p):
            p = list(p)
            if p and p[-1] < 0:
                p = [-c for c in p]
            return min(tuple(p), tuple(p[::-1]))
        words = [w for w in words if norm(alexander_of(w)) == norm(want)]
    print(f'seed words with this polynomial: {len(words)}')
    seen = set()
    q = deque()
    for w in words:
        c = canon(w)
        if c not in seen:
            seen.add(c); q.append(c)
    while q:
        w = q.popleft()
        for _k, f in flips(w):
            c = canon(f)
            if c not in seen:
                seen.add(c); q.append(c)
                if len(seen) > a.limit:
                    sys.exit('limit hit')
    print(f'flip closure: {len(seen)}')
    G16 = list(group()) if a.all48 else [g for g in group() if g[0][2] == 2]
    assert len(G16) == (48 if a.all48 else 16)
    allp = {}
    for w in seen:
        vs = word_to_verts(w)
        for g in G16:
            allp[canon(verts_to_word(apply_g(g, vs)))] = 1
    if a.out:
        with open(a.out, 'w') as f:
            for w in sorted(allp):
                f.write(w + '\n')
    hs = Counter()
    for w in allp:
        zs = [v[2] for v in word_to_verts(w)]
        hs[max(zs) - min(zs)] += 1
    print(f'polygons up to translation (16 slab symmetries applied; 48 with --all48): {len(allp)}')
    print('by height (z-extent): ' + ' '.join(f'{h}:{c}' for h, c in sorted(hs.items())))
    tot = 0
    for h, c in sorted(hs.items()):
        tot += c
        print(f'  in the slab 0 <= z <= {h}: {tot}')


if __name__ == '__main__':
    main()
