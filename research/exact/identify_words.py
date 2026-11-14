#!/usr/bin/env python3
"""
identify_words.py -- identify knot types of simple-cubic-lattice polygons given as nsewud words.

Usage:
    python3 identify_words.py WORDS_FILE

WORDS_FILE: one word per line. Blank lines and lines starting with '#' are ignored.
If a line has several whitespace-separated fields, the word is the LAST field.

Output: one tab-separated line per word:  length  alexander  name  word
then a TALLY block: count, length, alexander, name for each distinct (length, alexander, name).

The repo modules (code/latticeknot.py and research/code/alexander.py) are imported by
adding their directories to sys.path; no code is copied.
"""
import collections
import os
import sys
import warnings

warnings.filterwarnings('ignore', message='Plink failed to import tkinter')

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'code'))
sys.path.insert(0, os.path.join(ROOT, 'research', 'code'))

import latticeknot as lk  # noqa: E402
from alexander import alexander  # noqa: E402

VALID = set('nsewud')


def read_words(path):
    words = []
    with open(path) as fh:
        for line in fh:
            s = line.strip()
            if not s or s.startswith('#'):
                continue
            words.append(s.split()[-1])
    return words


def name_of(word):
    """SnapPy/repo identification name; 'non-hyperbolic' when snappy returns no names."""
    info = lk.identify([lk.word_to_vertices(word)])
    if 'name' in info:                      # repo returns 'unknot/unlink' for zero crossings
        return info['name']
    names = [n[:-len('(0,0)')] if n.endswith('(0,0)') else n for n in info.get('snappy_identify', [])]
    if names:
        return ','.join(names)
    if 'identify_error' in info:
        return 'error:' + info['identify_error']
    return 'non-hyperbolic'


def alexander_of(word):
    """Alexander polynomial (lowest degree first) of the simplified diagram from spherogram."""
    L = lk.to_spherogram([lk.word_to_vertices(word)])
    if L is None:
        return [1]
    L.simplify('global')
    pd = [tuple(x) for x in L.PD_code()]
    return alexander(pd)


def main():
    if len(sys.argv) != 2:
        sys.exit('usage: identify_words.py WORDS_FILE')
    tally = collections.Counter()
    for word in read_words(sys.argv[1]):
        if not word or set(word) - VALID:
            print(f'{len(word)}\tERROR\tbad-letters\t{word}')
            continue
        try:
            alex = alexander_of(word)
            name = name_of(word)
        except AssertionError as e:          # word does not close
            print(f'{len(word)}\tERROR\t{e}\t{word}')
            continue
        print(f'{len(word)}\t{alex}\t{name}\t{word}', flush=True)
        tally[(len(word), str(alex), name)] += 1
    print('TALLY')
    print('count\tlength\talexander\tname')
    for (length, alex, name), cnt in sorted(tally.items()):
        print(f'{cnt}\t{length}\t{alex}\t{name}')


if __name__ == '__main__':
    main()
