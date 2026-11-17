#!/usr/bin/env python3
"""
arcslab_pairs.py -- which composite knots can a twice-crossed plane give in a slab?

    python3 check/arcslab_pairs.py W L1 L2 ...     (reads out/arcslab/w<W>_L<L>.left)

The .left files hold the closures (from arcslab.cpp) that unknot_cert could not shrink, as
lines "length word"; the first L letters of the word are the arc b. Coordinates of arcslab:
the wall is the level z = 0, the confined direction is y (0 <= y <= W), x is free.
For every such closure this script
  * identifies the knot type with chirality sign (identify6.classify);
  * recovers the end points A, B of the arc in the wall, for every position of the arc in the
    strip, as a key (y_A, dx, y_B) with dx = x_B - x_A >= 0 (ends exchanged if necessary);
  * adds the mirror image in x (the enumeration lists only one of each mirror pair): the key
    with y_A, y_B exchanged and the opposite chirality.
A polygon cut by a wall into arcs a (in front) and b (behind) has type [a] # mirror[b*], where
b* is the reflection of b in the wall, an arc of the enumerated family with the same end
points as a. So for trefoil arcs: equal signs of a and b* give the square knot, opposite signs
the granny knot, with |a| + |b| + 2 edges.
"""
import collections
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..'))
import identify6 as i6          # noqa: E402

STEP = {'e': (1, 0, 0), 'w': (-1, 0, 0), 'n': (0, 1, 0), 's': (0, -1, 0), 'u': (0, 0, 1), 'd': (0, 0, -1)}


def norm_key(ya, dx, yb):
    if dx < 0 or (dx == 0 and yb < ya):
        return (yb, -dx, ya)
    return (ya, dx, yb)


def main():
    W = int(sys.argv[1])
    Ls = [int(x) for x in sys.argv[2:]]
    table = {}                                    # L -> {(key, verdict)}
    for L in Ls:
        path = os.path.join(HERE, '..', 'out', 'arcslab', f'w{W}_L{L}.left')
        entries = set()
        types = collections.Counter()
        nwords = 0
        for line in open(path):
            f = line.split()
            if len(f) != 2:
                continue
            nwords += 1
            word = f[1]
            _n, _poly, verdict = i6.classify(word, True)
            types[verdict] += 1
            if verdict == '0_1':
                continue
            x = y = z = 0
            ys = [0]
            for c in word[:L]:
                d = STEP[c]
                x += d[0]; y += d[1]; z += d[2]
                ys.append(y)
            assert z == 0
            mirror = verdict[:-1] + ('-' if verdict[-1] == '+' else '+') if verdict[-1] in '+-' else verdict
            for y0 in range(-min(ys), W - max(ys) + 1):
                entries.add((norm_key(y0, x, y0 + y), verdict))
                entries.add((norm_key(y0, -x, y0 + y), mirror))
        table[L] = entries
        print(f'L={L}: {nwords} closures left by unknot_cert; types {dict(types)}')
        bykey = collections.defaultdict(set)
        for key, v in entries:
            bykey[key].add(v)
        for key in sorted(bykey):
            print(f'    ends (y_A, dx, y_B) = {key}: {sorted(bykey[key])}')
    print('pairs (|a|, |b|) -> polygon length and composite types possible:')
    for i, L1 in enumerate(Ls):
        for L2 in Ls[i:]:
            out = set()
            for key, v1 in table[L1]:
                for key2, v2 in table[L2]:
                    if key2 != key:
                        continue
                    if v1[:3] == v2[:3] == '3_1':
                        out.add('square' if v1 == v2 else 'granny')
                    else:
                        out.add(f'{v1} # mirror {v2}')
            print(f'    ({L1}, {L2}) -> n = {L1 + L2 + 2}: {sorted(out) if out else "none"}')


if __name__ == '__main__':
    main()
