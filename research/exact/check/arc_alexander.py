#!/usr/bin/env python3
"""
arc_alexander.py WORDS_FILE [PROCESSES]

Reads closure words (one per line; if several fields, the last one is the word).
For each word:
  - checks with its own code that it is a closed self-avoiding lattice polygon
    (letters nsewud, returns to the origin, no repeated vertex before closing);
  - computes the Alexander polynomial with the repo's alexander_of from
    research/exact/identify_words.py (spherogram via latticeknot + repo alexander);
    a zero-crossing diagram (to_spherogram returns None) gives [1].
Prints the tally of polynomials and the number of failed polygon checks.

Usage: python3 arc_alexander.py /path/to/words.txt [2]
"""
import collections
import multiprocessing as mp
import os
import sys

EXACT_DIR = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
sys.path.insert(0, EXACT_DIR)
import identify_words as iw  # noqa: E402  (repo module: alexander_of uses latticeknot + alexander)

STEP = {'e': (1, 0, 0), 'w': (-1, 0, 0), 'n': (0, 1, 0),
        's': (0, -1, 0), 'u': (0, 0, 1), 'd': (0, 0, -1)}


def is_closed_saw(word):
    """Own check: closed self-avoiding polygon, vertices A..(before A) distinct."""
    if not word or set(word) - set(STEP):
        return False, 'bad-letters'
    p = (0, 0, 0)
    seen = {p}
    for s in word[:-1]:
        dx, dy, dz = STEP[s]
        p = (p[0] + dx, p[1] + dy, p[2] + dz)
        if p in seen:
            return False, 'self-intersecting'
        seen.add(p)
    dx, dy, dz = STEP[word[-1]]
    if (p[0] + dx, p[1] + dy, p[2] + dz) != (0, 0, 0):
        return False, 'not-closed'
    return True, ''


def read_words(path):
    words = []
    with open(path) as fh:
        for line in fh:
            s = line.strip()
            if not s or s.startswith('#'):
                continue
            words.append(s.split()[-1])
    return words


def work(word):
    ok, why = is_closed_saw(word)
    if not ok:
        return word, why, None
    alex = iw.alexander_of(word)
    return word, '', str(alex)


def main():
    if len(sys.argv) not in (2, 3):
        sys.exit('usage: arc_alexander.py WORDS_FILE [PROCESSES]')
    words = read_words(sys.argv[1])
    procs = int(sys.argv[2]) if len(sys.argv) == 3 else 1
    tally = collections.Counter()
    failed = collections.Counter()
    examples = {}
    if procs > 1:
        with mp.Pool(procs) as pool:
            results = pool.map(work, words, chunksize=64)
    else:
        results = [work(w) for w in words]
    for word, why, alex in results:
        if alex is None:
            failed[why] += 1
            continue
        tally[alex] += 1
        if alex != '[1]' and alex not in examples:
            examples[alex] = word
    print(f'words read: {len(words)}')
    print(f'polygon check failures: {sum(failed.values())} {dict(failed)}')
    print('TALLY polynomial count')
    for poly, cnt in sorted(tally.items(), key=lambda kv: (-kv[1], kv[0])):
        print(f'{poly}\t{cnt}')
    for poly, word in examples.items():
        print(f'example non-trivial {poly}: {word}')


if __name__ == '__main__':
    main()
