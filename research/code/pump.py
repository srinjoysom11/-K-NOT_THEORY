"""
pump.py -- look for a repeatable 16-step unit inside short polygons of trefoil sums.

Idea. Write a cyclic word of (3_1)^k as  X B1 Y B2  where the two blocks have
|B1| + |B2| = 16 and opposite displacements. "Pumping" m times gives
        W(m) = X B1^(m+1) Y B2^(m+1),
a closed word of length |W| + 16 m. If W(m) is self-avoiding and has the Alexander
polynomial (t^2 - t + 1)^(k+m) for m = 1..M, the pair (B1, B2) is a candidate proof of
        Len((3_1)^n) <= 16 n + 8   for all n.
Alexander polynomials do not determine the knot type, so a hit is a CANDIDATE:
the paper still needs the picture argument that each period is one trefoil summand.

  py -3.12 research/code/pump.py            (reads research/out/trefoil_sums.csv)
"""
import csv
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..', '..', 'code'))
sys.path.insert(0, HERE)
import latticeknot as lk  # noqa: E402
from alexander import alexander  # noqa: E402

D = {'e': (1, 0, 0), 'w': (-1, 0, 0), 'n': (0, 1, 0), 's': (0, -1, 0), 'u': (0, 0, 1), 'd': (0, 0, -1)}


def disp(s):
    return tuple(sum(D[c][i] for c in s) for i in range(3))


def self_avoiding(w):
    x = (0, 0, 0)
    seen = {x}
    for c in w[:-1]:
        x = (x[0] + D[c][0], x[1] + D[c][1], x[2] + D[c][2])
        if x in seen:
            return False
        seen.add(x)
    return True


def trefoil_power(n):
    p = [1]
    for _ in range(n):
        q = [0] * (len(p) + 2)
        for i, a in enumerate(p):
            for j, b in enumerate((1, -1, 1)):
                q[i + j] += a * b
        p = q
    return p


def alex_ok(w, n):
    try:
        return alexander(lk.pd_code([lk.word_to_vertices(w)])) == trefoil_power(n)
    except AssertionError:
        return False


def search(word, k, M=4, period=16):
    L, hits = len(word), []
    for i in range(L):
        w = word[i:] + word[:i]                      # B1 starts at position 0
        for l1 in range(1, period):
            l2 = period - l1
            b1 = w[:l1]
            d1 = disp(b1)
            if d1 == (0, 0, 0):
                continue
            for j in range(l1, L - l2 + 1):
                b2 = w[j:j + l2]
                if tuple(-t for t in disp(b2)) != d1:
                    continue
                y, x = w[l1:j], w[j + l2:]
                ok = True
                for m in range(1, M + 1):
                    wm = b1 * (m + 1) + y + b2 * (m + 1) + x
                    if not self_avoiding(wm) or not alex_ok(wm, k + m):
                        ok = False
                        break
                if ok:
                    hits.append((b1, y, b2, x))
    return hits


if __name__ == '__main__':
    rows = list(csv.DictReader(open(os.path.join(HERE, '..', 'out', 'trefoil_sums.csv'))))
    out = open(os.path.join(HERE, '..', 'out', 'pump_hits.txt'), 'w')
    for r in rows:
        n = int(r['n'])
        if int(r['best_length']) != 24 + 16 * (n - 1) or n < 2:
            continue
        hits = search(r['word'], n)
        print(f'n={n} length={len(r["word"])}: {len(hits)} pumpable decompositions', flush=True)
        for b1, y, b2, x in hits:
            out.write(f'{n} B1={b1} Y={y} B2={b2} X={x}\n')
        out.flush()
