"""
fingerprint.py -- "knotword -> knot" with first-course invariants only.

fingerprint(pd) = (Alexander polynomial, Jones polynomial up to mirror image), both
computed from a PD code by elementary means:
  * Alexander: research/code/alexander.py (determinant of the crossing/arc matrix);
  * Jones: Kauffman bracket state sum. Each crossing is smoothed in one of two ways;
    a state with a A-smoothings, b B-smoothings and L loops contributes
    A^(a-b) * (-A^2 - A^-2)^(L-1);  Jones = (-A^3)^(-writhe) * bracket.
    Cost 2^(#crossings), fine up to about 20 crossings.
The Jones polynomial is stored as a dict {exponent of A: coefficient} and replaced by
the smaller of itself and its mirror (A -> 1/A), because mirror images have the same
minimal length and our table does not distinguish them.

Run as a script to measure how well the fingerprint separates the 801 prime knots
with 3..11 crossings (writes research/out/fingerprint_table.json and prints collisions):
  py -3.12 research/code/fingerprint.py
"""
import collections
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from alexander import alexander  # noqa: E402


def _writhe(pd):
    n2 = 2 * len(pd)
    return sum(1 if (d + 1) % n2 == b else -1 for a, b, c, d in pd)


def bracket(pd):
    n = len(pd)
    labels = sorted({x for X in pd for x in X})
    idx = {x: i for i, x in enumerate(labels)}
    P = [tuple(idx[x] for x in X) for X in pd]
    m = len(labels)
    tally = collections.Counter()
    for state in range(1 << n):
        par = list(range(m))

        def find(x):
            while par[x] != x:
                par[x] = par[par[x]]
                x = par[x]
            return x
        loops, ones = m, 0
        for k, (a, b, c, d) in enumerate(P):
            if state >> k & 1:
                pairs = ((a, d), (b, c))
                ones += 1
            else:
                pairs = ((a, b), (c, d))
            for x, y in pairs:
                rx, ry = find(x), find(y)
                if rx != ry:
                    par[rx] = ry
                    loops -= 1
        tally[(n - 2 * ones, loops)] += 1
    poly = collections.Counter()
    for (e, loops), cnt in tally.items():
        term = {0: 1}
        for _ in range(loops - 1):              # multiply by (-A^2 - A^-2)
            nt = collections.Counter()
            for k, v in term.items():
                nt[k + 2] -= v
                nt[k - 2] -= v
            term = nt
        for k, v in term.items():
            poly[k + e] += v * cnt
    return {k: v for k, v in poly.items() if v}


def jones(pd):
    """Jones polynomial in the variable A (t = A^-4), up to mirror image, as a sorted tuple."""
    if not pd:
        return ((0, 1),)
    w = _writhe(pd)
    out = {}
    for sign_w in (w, -w):                      # the A/B naming depends on a PD convention; accept either
        j = {k - 3 * sign_w: v * (-1) ** (sign_w % 2) for k, v in bracket(pd).items()}
        if all(k % 4 == 0 for k in j):
            out = j
            break
    assert out, 'bracket normalisation failed'
    mirror = {-k: v for k, v in out.items()}
    return min(tuple(sorted(out.items())), tuple(sorted(mirror.items())))


def fingerprint(pd):
    return (tuple(alexander(pd)), jones(pd))


def fingerprint_of_word(word, max_crossings=18):
    """Simplify the projection with spherogram, then fingerprint. Returns None if still too big."""
    sys.path.insert(0, os.path.join(HERE, '..', '..', 'code'))
    import latticeknot as lk
    L = lk.to_spherogram([lk.word_to_vertices(word)])
    if L is None:
        return ((1,), ((0, 1),))
    L.simplify('global')
    pd = [tuple(x) for x in L.PD_code()]
    if len(pd) > max_crossings:
        return None
    return fingerprint(pd)


if __name__ == '__main__':
    import spherogram
    import seeds as sd
    table = {}
    for c in range(3, 12):
        for name, sn in sd.knot_list(c):
            table[name] = fingerprint([tuple(x) for x in spherogram.Link(sn).PD_code()])
        print(c, 'crossings done', flush=True)
    for label, key in (('Alexander only', lambda f: f[0]), ('Jones only', lambda f: f[1]), ('Alexander + Jones', lambda f: f)):
        groups = collections.defaultdict(list)
        for k, f in table.items():
            groups[key(f)].append(k)
        uniq = sum(1 for g in groups.values() if len(g) == 1)
        big = sorted((g for g in groups.values() if len(g) > 1), key=len, reverse=True)
        print(f'{label}: {len(groups)} distinct values for {len(table)} knots; {uniq} knots identified uniquely; '
              f'{len(big)} collision groups, largest {len(big[0]) if big else 0}')
        if label == 'Alexander + Jones':
            for g in big:
                print('   collide:', ' '.join(g))
    json.dump({k: [list(f[0]), [list(t) for t in f[1]]] for k, f in table.items()},
              open(os.path.join(HERE, '..', 'out', 'fingerprint_table.json'), 'w'))
