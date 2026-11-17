#!/usr/bin/env python3
"""
identify6.py -- knot types of lattice polygons with crossing number at most 6.

    python3 identify6.py WORDS_FILE [--chir]

Like identify_rigorous.py, with the table extended to the ten knots with at most 6 crossings:
0_1, 3_1, 4_1, 5_1, 5_2, 6_1, 6_2, 6_3, 3_1#3_1 (granny), 3_1#-3_1 (square).
Each word is checked to be a closed self-avoiding polygon; its diagram is simplified to at
most 6 crossings (so the knot is one of the ten); the Alexander polynomial separates them
except granny / square, which are separated by the Jones polynomial computed from the Kauffman
bracket state sum (check/witness40.py): the square knot is its own mirror image, so its
polynomial is symmetric under A -> 1/A, the granny knot's is not.
With --chir a sign is added for the chiral types: the sign of (largest + smallest exponent)
of f(A) = (-A^3)^(-w) <D>; mirror images have opposite signs, and '+' is the class of the
trefoil with f = A^4 + A^12 - A^16. (For the chiral knots in the table the span of the Jones
polynomial is not symmetric about 0, so the sign is never 0.)
Output: one line per word (length, crossings, polynomial, verdict, word), a TALLY block and a
last line 'ALL RESOLVED' or 'UNRESOLVED: k words'.
"""
import collections
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(HERE, 'check'))
import identify_rigorous as ir            # noqa: E402
from alexander import alexander           # noqa: E402
from witness40 import f_poly              # noqa: E402

ir.MAX_CROSSINGS = 6
KNOWN = dict(ir.KNOWN)
KNOWN.update({(2, -5, 2): '6_1', (1, -3, 3, -3, 1): '6_2', (1, -3, 5, -3, 1): '6_3',
              (1, -2, 3, -2, 1): 'granny-or-square'})
NAMES = ['0_1', '3_1', '4_1', '5_1', '5_2', '6_1', '6_2', '6_3', '3_1#3_1', '3_1#-3_1']
AMPHICHIRAL = {'0_1', '4_1', '6_3', '3_1#-3_1'}


def classify(word, chir=False):
    """(crossings, polynomial, verdict) for one word; verdict in NAMES (with sign), or
    UNRESOLVED / INCONSISTENT."""
    n, pd = ir.best_diagram(word)
    poly = alexander(pd)
    if n > 6:
        return n, poly, 'UNRESOLVED'
    verdict = KNOWN.get(ir.canonical(poly), 'INCONSISTENT')
    f = None
    if verdict == 'granny-or-square':
        f = f_poly(pd)
        verdict = '3_1#-3_1' if f == {-e: c for e, c in f.items()} else '3_1#3_1'
    if chir and verdict in NAMES and verdict not in AMPHICHIRAL:
        f = f or f_poly(pd)
        s = max(f) + min(f)                 # 0 only for a symmetric span
        verdict += '+' if s > 0 else '-'
    return n, poly, verdict


def main():
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    chir = '--chir' in sys.argv
    if len(args) != 1:
        sys.exit('usage: identify6.py WORDS_FILE [--chir]')
    rows = []
    for word in ir.read_words(args[0]):
        ok, reason = ir.is_self_avoiding_polygon(word)
        if not ok:
            rows.append((len(word), 'BAD'))
            print(f'{len(word)}\t-\tnot-polygon:{reason}\tBAD\t{word}', flush=True)
            continue
        try:
            n, poly, verdict = classify(word, chir)
        except Exception as e:  # noqa: BLE001
            rows.append((len(word), 'ERROR'))
            print(f'{len(word)}\t-\terror:{e}\tERROR\t{word}', flush=True)
            continue
        rows.append((len(word), verdict))
        print(f'{len(word)}\t{n}\t{poly}\t{verdict}\t{word}', flush=True)
    tally = collections.Counter(rows)
    print('TALLY')
    print('count\tlength\tverdict')
    for (length, verdict), cnt in sorted(tally.items()):
        print(f'{cnt}\t{length}\t{verdict}')
    bad = sum(1 for _l, v in rows if v.rstrip('+-') not in NAMES and v not in NAMES)
    print(f'UNRESOLVED: {bad} words' if bad else 'ALL RESOLVED')


if __name__ == '__main__':
    main()
