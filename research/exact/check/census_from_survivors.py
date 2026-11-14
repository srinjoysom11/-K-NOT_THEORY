#!/usr/bin/env python3
"""
census_from_survivors.py -- flip + symmetry census seeded by a list of lattice words.

Usage:
    python3 census_from_survivors.py WORDS_FILE [--alex "1,-3,1"] [--limit 2000000]

WORDS_FILE: one word per line. Blank lines and lines starting with '#' are skipped.
If a line has several whitespace-separated fields the word is the LAST field.
Lines whose word is not made only of the letters e w n s u d are skipped.

Steps:
  1. read words (closed, self-avoiding ones only; others are reported and dropped)
  2. optional Alexander filter (up to reversal and overall sign), using
     identify_words.alexander_of from research/exact
  3. corner-flip closure (BFS on canon values) from the kept polygons;
     flip classes = connected components of that closure
  4. G-closure: apply all 48 signed permutations to the closure, canon each image
  5. statistics: T_rot (24 rotations only), T (all 48), G-orbits, achirality
  6. summary block

Reuses canon, flips, group, apply_g, word_to_verts, verts_to_word from
research/exact/check/crosscheck.py and alexander_of from research/exact/identify_words.py.
Single-threaded.
"""
import argparse
import os
import random
import sys
import time
import warnings
from collections import Counter, defaultdict, deque

HERE = os.path.dirname(os.path.abspath(__file__))
EXACT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
sys.path.insert(0, EXACT)
warnings.filterwarnings('ignore', message='Plink failed to import tkinter')

from crosscheck import (canon, flips, group, apply_g,  # noqa: E402
                        word_to_verts, verts_to_word, is_closed_saw)

LETTERS = set('ewnsud')
SAMPLE_CHECK = 200
SAMPLE_SEED = 12345


def read_words(path):
    words = []
    skipped = 0
    with open(path) as fh:
        for line in fh:
            s = line.strip()
            if not s or s.startswith('#'):
                continue
            w = s.split()[-1]
            if not w or set(w) - LETTERS:
                skipped += 1
                continue
            words.append(w)
    return words, skipped


def parse_alex(text):
    return [int(x) for x in text.split(',') if x.strip() != '']


def strip_zeros(p):
    p = list(p)
    while p and p[0] == 0:
        p.pop(0)
    while p and p[-1] == 0:
        p.pop()
    return p


def alex_matches(poly, target):
    p = strip_zeros(poly)
    t = strip_zeros(target)
    cands = [t, t[::-1], [-c for c in t], [-c for c in t[::-1]]]
    return p in cands


def alexander_of(word):
    import identify_words as iw  # repo code: research/exact/identify_words.py
    return iw.alexander_of(word)


def rot_images(F, G):
    """All 48 (or subset) canonical images of cycle word F under group elements."""
    vs = word_to_verts(F)
    out = {}
    for g in G:
        out[g] = canon(verts_to_word(apply_g(g, vs)))
    return out


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('words_file')
    ap.add_argument('--alex', default=None,
                    help='Alexander coefficient list, lowest degree first, e.g. "1,-3,1"')
    ap.add_argument('--limit', type=int, default=2000000,
                    help='abort if the flip closure exceeds this many polygons')
    args = ap.parse_args()
    t0 = time.time()

    # ---- 1. read ----
    raw, skipped = read_words(args.words_file)
    print(f"read {len(raw)} words from {args.words_file} "
          f"({skipped} lines skipped: not made of e/w/n/s/u/d)")
    G = group()
    ROT = [g for g in G if g[2] == 1]
    IMP = [g for g in G if g[2] == -1]
    assert len(ROT) == 24 and len(IMP) == 24

    valid = []
    bad_closure = 0
    for w in raw:
        if is_closed_saw(w):
            valid.append(w)
        else:
            bad_closure += 1
    if bad_closure:
        print(f"dropped {bad_closure} words that are not closed self-avoiding polygons")
    seeds_words = valid

    # ---- 2. Alexander filter ----
    if args.alex is not None:
        target = parse_alex(args.alex)
        kept = []
        errs = 0
        for w in seeds_words:
            try:
                a = alexander_of(w)
            except AssertionError:
                errs += 1
                continue
            if alex_matches(a, target):
                kept.append(w)
        print(f"Alexander filter {target} (up to reversal and sign): "
              f"kept {len(kept)} of {len(seeds_words)} words"
              + (f" ({errs} failed to compute)" if errs else ""))
        seeds_words = kept
    else:
        print("no Alexander filter")

    if not seeds_words:
        sys.exit("error: no words kept")
    lengths = Counter(len(w) for w in seeds_words)
    if len(lengths) != 1:
        sys.exit(f"error: kept words have different lengths: {dict(lengths)}")
    n = next(iter(lengths))
    seeds = sorted({canon(w) for w in seeds_words})
    print(f"kept words = {len(seeds_words)}, distinct seeds (canon) = {len(seeds)}, n = {n}")

    # ---- 3. flip closure, components = flip classes ----
    comp_of = {}
    comp_sizes = []
    for s in seeds:
        if s in comp_of:
            continue
        cid = len(comp_sizes)
        comp_of[s] = cid
        q = deque([s])
        size = 1
        while q:
            u = q.popleft()
            for _k, F2 in flips(u):
                c = canon(F2)
                if c not in comp_of:
                    comp_of[c] = cid
                    q.append(c)
                    size += 1
                    if len(comp_of) > args.limit:
                        sys.exit(f"error: flip closure exceeded --limit {args.limit}")
        comp_sizes.append(size)
    F_size = len(comp_of)
    dist = Counter(comp_sizes)
    print(f"flip closure F = {F_size}")
    print(f"flip classes inside F = {len(comp_sizes)}; "
          f"size distribution (size: count) = {dict(sorted(dist.items()))}")

    # ---- 4. G-closure ----
    closure = set(comp_of)
    T_set = set()
    for u in closure:
        vs = word_to_verts(u)
        for g in G:
            T_set.add(canon(verts_to_word(apply_g(g, vs))))
    T = len(T_set)
    pool = sorted(T_set)

    T_rot_set = set()
    for u in closure:
        vs = word_to_verts(u)
        for g in ROT:
            T_rot_set.add(canon(verts_to_word(apply_g(g, vs))))
    T_rot = len(T_rot_set)
    print(f"T_rot (24 rotations applied to F) = {T_rot}")
    print(f"T (48 symmetries applied to F)    = {T}")

    # diagnostic: flip classes of the whole final set T (components of the flip graph on T)
    tcomp_seen = set()
    tcomp_sizes = []
    for s in pool:
        if s in tcomp_seen:
            continue
        tcomp_seen.add(s)
        q = deque([s])
        size = 1
        while q:
            u = q.popleft()
            for _k, F2 in flips(u):
                c = canon(F2)
                if c in T_set and c not in tcomp_seen:
                    tcomp_seen.add(c)
                    q.append(c)
                    size += 1
        tcomp_sizes.append(size)
    print(f"flip classes of the full set T = {len(tcomp_sizes)}; "
          f"size distribution (size: count) = {dict(sorted(Counter(tcomp_sizes).items()))}")

    # check: union over G is closed under flips (sample)
    rng = random.Random(SAMPLE_SEED)
    sample = rng.sample(pool, min(SAMPLE_CHECK, len(pool)))
    outside = 0
    flip_results = 0
    for u in sample:
        for _k, F2 in flips(u):
            flip_results += 1
            if canon(F2) not in T_set:
                outside += 1
    print(f"flip-closure check on {len(sample)} random polygons of T: "
          f"{flip_results} flip results, {outside} outside T "
          f"({'closed' if outside == 0 else 'NOT closed'})")

    # ---- 5. G-orbits, achirality ----
    seen = set()
    orbit_sizes = []
    achiral = 0
    for u in pool:
        if u in seen:
            continue
        imgs = rot_images(u, G)
        orb = set(imgs.values())
        seen |= orb
        orbit_sizes.append(len(orb))
    # achirality: polygon equal to a mirror image up to rotation+translation
    for u in pool:
        vs = word_to_verts(u)
        rot_c = {canon(verts_to_word(apply_g(g, vs))) for g in ROT}
        imp_c = {canon(verts_to_word(apply_g(g, vs))) for g in IMP}
        if rot_c & imp_c:
            achiral += 1
    orbits = len(orbit_sizes)
    osd = dict(sorted(Counter(orbit_sizes).items()))
    print(f"G-orbits in final set = {orbits}; orbit-size distribution (size: count) = {osd}")
    print(f"achiral polygons (mirror image equals a rotation image) = {achiral} of {T}")
    print(f"T equals union of disjoint orbits: {sum(orbit_sizes) == T}")

    print(f"\nelapsed {time.time() - t0:.1f} s")
    print("\n=== SUMMARY ===")
    print(f"n={n}  kept={len(seeds_words)}  F={F_size}  flip_classes={len(comp_sizes)}  "
          f"T_rot={T_rot}  T={T}  G_orbits={orbits}  "
          f"flip_classes_of_T={len(tcomp_sizes)}")


if __name__ == '__main__':
    main()
