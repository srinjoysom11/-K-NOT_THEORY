#!/usr/bin/env python3
"""
witness40.py -- upper bounds Len <= 40 for 6_1, 6_2, 6_3, 3_1 # 3_1 (granny) and
3_1 # -3_1 (square): one 40-edge polygon each, identified without trusting how it was found.

    python3 check/witness40.py            (reads out/witness40.txt, prints one line per word)

For each word:
  a. it is a closed self-avoiding polygon with 40 edges (checked from the definition);
  b. its diagram is simplified (spherogram) to 6 crossings, so the knot has crossing number
     at most 6;
  c. the Alexander polynomial is computed from that diagram. Among the knots with at most 6
     crossings (0_1, 3_1, 4_1, 5_1, 5_2, 6_1, 6_2, 6_3, 3_1 # 3_1, 3_1 # -3_1) it separates all
     types except the last two;
  d. for the last two the Kauffman bracket of the 6-crossing diagram is computed by the state
     sum (64 states) and normalised by the writhe to f(A) = (-A^3)^(-w) <D>, the Jones
     polynomial with t = A^-4 (as a test, f came out the same on diagrams of the same polygon
     with 6 to 18 crossings, and equals A^4 + A^12 - A^16 for the 24-edge trefoil). The
     square knot is its own mirror image, so its f is unchanged under A -> 1/A; the granny
     knot's f = f(3_1)^2 is not.
The sources of the words: 6_1, 6_2, 6_3 from data/rechnitzer_SC_minimal.json; the granny knot
from research/out/trefoil_sums.csv; the square knot from an annealing run started at a
diagram of 3_1 # mirror(3_1) (17 Nov 2026).
"""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..'))
import identify_rigorous as ir          # noqa: E402  (sets sys.path for the repo modules)
import latticeknot as lk                # noqa: E402
from alexander import alexander         # noqa: E402

ir.MAX_CROSSINGS = 6
ALEX = {(2, -5, 2): '6_1', (1, -3, 3, -3, 1): '6_2', (1, -3, 5, -3, 1): '6_3',
        (1, -2, 3, -2, 1): '3_1#3_1 or 3_1#-3_1'}


def bracket(pd):
    """Kauffman bracket of a PD code as {exponent of A: coefficient}."""
    n = len(pd)
    out = {}
    for mask in range(1 << n):
        parent = {}

        def find(x):
            while parent.setdefault(x, x) != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x

        a_count = 0
        for i, (a, b, c, d) in enumerate(pd):
            if mask >> i & 1:
                pairs = ((a, b), (c, d)); a_count += 1
            else:
                pairs = ((a, d), (b, c))
            for x, y in pairs:
                parent[find(x)] = find(y)
        loops = len({find(x) for x in list(parent)})
        # A^(a - b) * (-A^2 - A^-2)^(loops - 1)
        term = {a_count - (n - a_count): 1}
        for _ in range(loops - 1):
            nt = {}
            for e, c in term.items():
                nt[e + 2] = nt.get(e + 2, 0) - c
                nt[e - 2] = nt.get(e - 2, 0) - c
            term = nt
        for e, c in term.items():
            out[e] = out.get(e, 0) + c
    return {e: c for e, c in out.items() if c}


def writhe(pd):
    """Sum of crossing signs of a knot diagram given as a PD code (a = incoming under strand,
    then counterclockwise). The over strand runs b -> d or d -> b."""
    n2 = 2 * len(pd)
    w = 0
    for a, b, c, d in pd:
        fwd = (d - b) % n2 == 1            # over strand runs from b to d
        w += -1 if fwd else 1              # sign that makes f invariant (tested on unsimplified diagrams)
    return w


def f_poly(pd):
    br = bracket(pd)
    w = writhe(pd)
    sign = -1 if w % 2 else 1
    return {e - 3 * w: sign * c for e, c in br.items()}


def main():
    path = os.path.join(HERE, '..', 'out', 'witness40.txt')
    bad = 0
    for line in open(path):
        if not line.strip() or line.startswith('#'):
            continue
        name, word = line.split()
        ok, reason = ir.is_self_avoiding_polygon(word)
        n, pd = ir.best_diagram(word) if ok else (-1, [])
        al = ir.canonical(alexander(pd)) if ok else ()
        verdict = ALEX.get(al, '?') if (ok and n == 6 and len(word) == 40) else 'FAIL'
        extra = ''
        if verdict.startswith('3_1#'):
            f = f_poly(pd)
            sym = f == {-e: c for e, c in f.items()}
            verdict = '3_1#-3_1' if sym else '3_1#3_1'
            extra = ' f(A)=' + ' '.join(f'{c:+d}A^{e}' for e, c in sorted(f.items()))
        good = verdict == name
        bad += not good
        print(f'{name}\tlen={len(word)}\tcrossings={n}\talexander={list(al)}\t{verdict}\t'
              f'{"OK" if good else "MISMATCH"}{extra}')
    print('ALL WITNESSES OK' if not bad else f'FAILED: {bad}')
    sys.exit(1 if bad else 0)


if __name__ == '__main__':
    main()
