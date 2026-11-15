#!/usr/bin/env python3
"""
identify_rigorous.py -- rigorous-style identification of small knot types of
simple-cubic-lattice polygons given as nsewud words.

Usage:
    python3 identify_rigorous.py WORDS_FILE

WORDS_FILE: one word per line. Blank lines and lines starting with '#' are ignored.
If a line has several whitespace-separated fields, the word is the LAST field.

For each word:
  a. Check from the definition that the word is a closed self-avoiding polygon
     (letters in nsewud, vertices returned to start, no vertex visited twice).
     Otherwise verdict BAD.
  b. Build the spherogram Link. Simplify with L.simplify('global'). If more than
     5 crossings remain, up to 30 further attempts: each on a fresh copy of the
     unsimplified link, L.backtrack(steps=30) then L.simplify('global'). The
     smallest diagram found is kept. (Backtracking is random; random.seed is set
     per word so the output is reproducible.) Stops early once <= 5 crossings.
  c. Alexander polynomial of the smallest diagram via the repo's alexander(pd),
     normalised up to reversal and overall sign.
  d. Verdict: if the smallest diagram has <= 5 crossings, the polynomial must be
     one of: [1] 0_1, [1,-1,1] 3_1, [1,-3,1] 4_1, [1,-1,1,-1,1] 5_1, [2,-3,2] 5_2
     (otherwise INCONSISTENT). If no diagram with <= 5 crossings was found,
     verdict UNRESOLVED with the smallest crossing count and the polynomial.

Output: one tab-separated line per word:
    length  min_crossings  alexander  verdict  word
then a TALLY block (count, length, verdict per distinct (length, verdict)) and a
final line 'ALL RESOLVED' or 'UNRESOLVED: k words', where k counts every word whose
verdict is not one of the five knot names (UNRESOLVED, INCONSISTENT, BAD, ERROR).

The repo modules (code/latticeknot.py and research/code/alexander.py) are imported by
adding their directories to sys.path; no code is copied.
"""
import collections
import os
import random
import sys
import warnings

warnings.filterwarnings('ignore', message='Plink failed to import tkinter')

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'code'))
sys.path.insert(0, os.path.join(ROOT, 'research', 'code'))

import latticeknot as lk  # noqa: E402
from alexander import alexander  # noqa: E402

VALID = set('nsewud')
DIRS = {'e': (1, 0, 0), 'w': (-1, 0, 0), 'n': (0, 1, 0), 's': (0, -1, 0),
        'u': (0, 0, 1), 'd': (0, 0, -1)}
MAX_CROSSINGS = 5
RETRIES = 30
BACKTRACK_STEPS = 30
KNOWN = {
    (1,): '0_1',
    (1, -1, 1): '3_1',
    (1, -3, 1): '4_1',
    (1, -1, 1, -1, 1): '5_1',
    (2, -3, 2): '5_2',
}


def read_words(path):
    words = []
    with open(path) as fh:
        for line in fh:
            s = line.strip()
            if not s or s.startswith('#'):
                continue
            words.append(s.split()[-1])
    return words


def is_self_avoiding_polygon(word):
    """Direct check from the definition. Returns (ok, reason)."""
    if not word:
        return False, 'empty word'
    if set(word) - VALID:
        return False, 'bad letters'
    x = (0, 0, 0)
    seen = {x}
    for i, ch in enumerate(word):
        dx, dy, dz = DIRS[ch]
        x = (x[0] + dx, x[1] + dy, x[2] + dz)
        last = i == len(word) - 1
        if last:
            if x != (0, 0, 0):
                return False, 'word does not close'
            break
        if x in seen:                       # only the final step may return to the start
            return False, 'vertex revisited'
        seen.add(x)
    return True, ''


def canonical(poly):
    """Normalise up to overall sign and reversal."""
    p = list(poly)
    while len(p) > 1 and p[-1] == 0:
        p.pop()
    if p and p[-1] < 0:
        p = [-c for c in p]
    return min(tuple(p), tuple(p[::-1]))


def best_diagram(word):
    """Return (min_crossings, pd) of the smallest diagram found."""
    random.seed(0)
    base = lk.to_spherogram([lk.word_to_vertices(word)])
    if base is None:
        return 0, []

    def crossings_and_pd(L):
        return len(L.crossings), [tuple(x) for x in L.PD_code()]

    L = base.copy()
    L.simplify('global')
    best_n, best_pd = crossings_and_pd(L)
    if best_n <= MAX_CROSSINGS:
        return best_n, best_pd
    for _ in range(RETRIES):
        M = base.copy()
        M.backtrack(steps=BACKTRACK_STEPS)
        M.simplify('global')
        n, pd = crossings_and_pd(M)
        if n < best_n:
            best_n, best_pd = n, pd
        if best_n <= MAX_CROSSINGS:
            break
    return best_n, best_pd


def main():
    if len(sys.argv) != 2:
        sys.exit('usage: identify_rigorous.py WORDS_FILE')
    rows = []
    for word in read_words(sys.argv[1]):
        length = len(word)
        ok, reason = is_self_avoiding_polygon(word)
        if not ok:
            rows.append((length, '-', f'not-polygon:{reason}', 'BAD', word))
            print(f'{length}\t-\tnot-polygon:{reason}\tBAD\t{word}', flush=True)
            continue
        try:
            n, pd = best_diagram(word)
            poly = alexander(pd)
        except Exception as e:  # noqa: BLE001  (report, do not crash the batch)
            rows.append((length, '-', f'error:{e}', 'ERROR', word))
            print(f'{length}\t-\terror:{e}\tERROR\t{word}', flush=True)
            continue
        key = canonical(poly)
        if n <= MAX_CROSSINGS:
            verdict = KNOWN.get(key, 'INCONSISTENT')
        else:
            verdict = 'UNRESOLVED'
        rows.append((length, n, str(poly), verdict, word))
        print(f'{length}\t{n}\t{poly}\t{verdict}\t{word}', flush=True)

    tally = collections.Counter((r[0], r[3]) for r in rows)
    print('TALLY')
    print('count\tlength\tverdict')
    for (length, verdict), cnt in sorted(tally.items()):
        print(f'{cnt}\t{length}\t{verdict}')
    unresolved = sum(1 for r in rows if r[3] not in KNOWN.values())
    if unresolved:
        print(f'UNRESOLVED: {unresolved} words')
    else:
        print('ALL RESOLVED')


if __name__ == '__main__':
    main()
