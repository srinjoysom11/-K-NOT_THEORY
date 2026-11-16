#!/usr/bin/env python3
"""Independent Python cross-check of the n=24 word lists (tasks 1-6).

Written only from the task definitions:
  word letters e,w,n,s,u,d = +x,-x,+y,-y,+z,-z; polygon starts at the origin.
  canon = min over 2n start/direction readings, letter order e<w<n<s<u<d.
  G = 48 signed permutations of the coordinates.
  corner flip: swap two consecutive unequal steps (a,b) -> (b,a) at a corner
  v when v' = p+q-v is not a vertex of the polygon.

Usage:  python3 crosscheck.py            (single-threaded, ~1 minute)
Writes results.json next to this file and prints every number.
"""
import itertools
import json
import os
import time
from collections import Counter, defaultdict

A_PATH = "/home/user/-K-NOT_THEORY/research/exact/out/n24_nopsi.txt"
B_PATH = "/home/user/-K-NOT_THEORY/research/exact/out/n24_psi.txt"
HERE = os.path.dirname(os.path.abspath(__file__))
N = 24
PUBLISHED_TOTAL = 3328

VEC = {'e': (1, 0, 0), 'w': (-1, 0, 0), 'n': (0, 1, 0),
       's': (0, -1, 0), 'u': (0, 0, 1), 'd': (0, 0, -1)}
LET = {v: k for k, v in VEC.items()}
ORDER = str.maketrans('ewnsud', 'abcdef')     # e<w<n<s<u<d
BACK = str.maketrans('abcdef', 'ewnsud')
INVT = str.maketrans('ewnsud', 'wesndu')      # letter inversion


def load(path):
    with open(path) as f:
        return [ln.strip() for ln in f if ln.strip()]


def word_to_verts(F):
    """Vertices visited, starting at origin (len(F) points)."""
    x = y = z = 0
    vs = [(0, 0, 0)]
    for c in F[:-1]:
        dx, dy, dz = VEC[c]
        x += dx; y += dy; z += dz
        vs.append((x, y, z))
    return vs


def verts_to_word(vs):
    """Letters of the closed cycle vs[0]->vs[1]->...->vs[0]."""
    n = len(vs)
    out = []
    for j in range(n):
        a = vs[j]; b = vs[(j + 1) % n]
        out.append(LET[(b[0] - a[0], b[1] - a[1], b[2] - a[2])])
    return ''.join(out)


def canon(F):
    """Smallest reading of the cycle F over all 2n starts and both directions."""
    n = len(F)
    Fm = F.translate(ORDER)
    Rm = F[::-1].translate(INVT).translate(ORDER)   # backward reading, inverted
    F2 = Fm + Fm
    R2 = Rm + Rm
    best = min(min(F2[i:i + n] for i in range(n)),
               min(R2[i:i + n] for i in range(n)))
    return best.translate(BACK)


def is_closed_saw(F):
    vs = word_to_verts(F)
    x = y = z = 0
    for c in F:
        dx, dy, dz = VEC[c]
        x += dx; y += dy; z += dz
    return (x, y, z) == (0, 0, 0) and len(set(vs)) == len(F)


# ---------- group G (48 signed permutations) ----------
def group():
    G = []
    for perm in itertools.permutations(range(3)):
        inv = sum(1 for i in range(3) for j in range(i + 1, 3) if perm[i] > perm[j])
        for signs in itertools.product((1, -1), repeat=3):
            det = (-1) ** inv * signs[0] * signs[1] * signs[2]
            G.append((perm, signs, det))
    assert len(G) == 48
    return G


def apply_g(g, vs):
    perm, signs, _ = g
    return [tuple(signs[i] * v[perm[i]] for i in range(3)) for v in vs]


# ---------- corner flips ----------
def flips(F):
    """Yield (k, F') for every legal corner flip of the cycle F."""
    n = len(F)
    vs = word_to_verts(F)
    vset = set(vs)
    for k in range(n):
        a = F[(k - 1) % n]     # step into corner vertex v_k
        b = F[k]               # step out of corner vertex v_k
        if a == b:
            continue           # collinear p,v,q: no change
        v = vs[k]
        va, vb = VEC[a], VEC[b]
        vp = (v[0] - va[0] + vb[0], v[1] - va[1] + vb[1], v[2] - va[2] + vb[2])
        if vp in vset:
            continue           # v' would be a vertex: illegal
        L = list(F)
        i, j = (k - 1) % n, k
        L[i], L[j] = L[j], L[i]
        yield k, ''.join(L)


# ---------- pushed-down test ----------
def pushed_pattern(a, b):
    H = 'ewns'
    return ((a == 'u' and b in H) or (a in H and b == 'd') or
            (a == 'n' and b in 'ew') or (a in 'ew' and b == 's'))


def pushed_check(F):
    """Return (number of pattern corners, list of violating corner indices)."""
    n = len(F)
    vs = word_to_verts(F)
    vset = set(vs)
    hits, viol = 0, []
    for k in range(n):
        a = F[(k - 1) % n]
        b = F[k]
        if not pushed_pattern(a, b):
            continue
        hits += 1
        p = vs[(k - 1) % n]; v = vs[k]; q = vs[(k + 1) % n]
        vp = (p[0] + q[0] - v[0], p[1] + q[1] - v[1], p[2] + q[2] - v[2])
        if vp not in vset:
            viol.append(k)
    return hits, viol


def main():
    t0 = time.time()
    res = {}
    A = load(A_PATH)
    B = load(B_PATH)
    print(f"loaded A={len(A)} words, B={len(B)} words")

    # ---------- Task 1: validation ----------
    print("\n== Task 1: validation ==")
    fail = Counter()
    triples = Counter()
    for label, words in (("A", A), ("B", B)):
        for F in words:
            if len(F) != N:
                fail[(label, "length")] += 1
            if any(c not in VEC for c in F):
                fail[(label, "bad letter")] += 1
                continue
            x = y = z = 0
            for c in F:
                dx, dy, dz = VEC[c]; x += dx; y += dy; z += dz
            if (x, y, z) != (0, 0, 0):
                fail[(label, "not closed")] += 1
            vs = word_to_verts(F)
            if len(set(vs)) != len(vs):
                fail[(label, "self-intersecting")] += 1
            least = min(vs, key=lambda v: (v[2], v[1], v[0]))
            if least != (0, 0, 0):
                fail[(label, "start not least in (z,y,x)")] += 1
            nx = F.count('e') + F.count('w')
            ny = F.count('n') + F.count('s')
            nz = F.count('u') + F.count('d')
            if not (nz <= ny <= nx):
                fail[(label, "axis ordering")] += 1
            if label == "A":
                triples[(nx, ny, nz)] += 1
    print("failures by kind:", dict(fail) if fail else "none (all 0)")
    res["task1_failures"] = {f"{k[0]}:{k[1]}": v for k, v in fail.items()}
    print("A distinct input words:", len(set(A)), " B distinct:", len(set(B)))
    print("A multiset of (x,y,z) counts:", sorted(triples.items()))
    res["task1_A_triples"] = {str(k): v for k, v in sorted(triples.items())}

    # ---------- Task 2: canon ----------
    print("\n== Task 2: canonical forms up to translation ==")
    canA = [canon(F) for F in A]
    canB = [canon(F) for F in B]
    setA, setB = set(canA), set(canB)
    print(f"distinct canon(A) = {len(setA)} (of {len(A)} words)")
    print(f"distinct canon(B) = {len(setB)} (of {len(B)} words)")
    print(f"B canons subset of A canons: {setB <= setA} "
          f"(B not in A: {len(setB - setA)})")
    res["task2"] = {"A_distinct": len(setA), "B_distinct": len(setB),
                    "B_subset_of_A": setB <= setA,
                    "B_not_in_A": len(setB - setA)}

    # ---------- Task 3: symmetry expansion ----------
    print("\n== Task 3: symmetry expansion (G of order 48) ==")
    G = group()
    union = set()
    orbit_of = {}                 # frozenset of canons -> number of A polygons in it
    chiral_bad = []
    achiral = 0
    for F in A:
        vs = word_to_verts(F)
        S = set()
        proper = set()
        improper = set()
        for g in G:
            c = canon(verts_to_word(apply_g(g, vs)))
            S.add(c)
            (proper if g[2] == 1 else improper).add(c)
        union |= S
        key = frozenset(S)
        orbit_of[key] = orbit_of.get(key, 0) + 1
        if proper & improper:
            achiral += 1
            chiral_bad.append(F)
    orbits = list(orbit_of.keys())
    sizes = sorted((len(o) for o in orbits), reverse=True)
    disjoint = sum(sizes) == len(union)
    total = len(union)
    print(f"distinct canon values over all images of A (union) = {total}")
    print(f"  equals published {PUBLISHED_TOTAL}? {total == PUBLISHED_TOTAL}")
    print(f"number of G-orbits hit by A = {len(orbits)}")
    print(f"orbit sizes multiset (count: size): {dict(Counter(sizes))}")
    print(f"orbits pairwise disjoint (sum of sizes == union): {disjoint}")
    print(f"A polygons per orbit (distinct counts): {dict(Counter(orbit_of.values()))}")
    print(f"achiral polygons (equal to mirror up to rotation+translation): {achiral}")
    res["task3"] = {"union": total, "equals_3328": total == PUBLISHED_TOTAL,
                    "n_orbits": len(orbits),
                    "orbit_size_multiset": dict(Counter(sizes)),
                    "disjoint": disjoint, "achiral_count": achiral,
                    "A_per_orbit_distribution": dict(Counter(orbit_of.values()))}

    # ---------- Task 4: flip graph ----------
    print("\n== Task 4: corner-flip graph on the symmetry-expanded node set ==")
    nodes = sorted(union)
    parent = {u: u for u in nodes}

    def find(u):
        while parent[u] != u:
            parent[u] = parent[parent[u]]
            u = parent[u]
        return u

    def unite(u, v):
        ru, rv = find(u), find(v)
        if ru != rv:
            parent[ru] = rv

    outside = 0
    flip_results = 0
    bad_flip = 0
    edges = set()
    for u in nodes:
        for k, F2 in flips(u):
            flip_results += 1
            if not is_closed_saw(F2):
                bad_flip += 1
            c = canon(F2)
            if c not in union:
                outside += 1
                continue
            if c != u:
                edges.add(tuple(sorted((u, c))))
            unite(u, c)
    comp = defaultdict(list)
    for u in nodes:
        comp[find(u)].append(u)
    comp_list = list(comp.values())
    sizes4 = sorted((len(c) for c in comp_list), reverse=True)
    print(f"nodes = {len(nodes)}, flip results = {flip_results}")
    print(f"flip results OUTSIDE node set = {outside} (expect 0)")
    print(f"flip results that are not valid closed SAWs = {bad_flip}")
    print(f"undirected edges = {len(edges)}")
    print(f"connected components = {len(comp_list)}")
    print(f"component sizes (count: size): {dict(Counter(sizes4))}")
    res["task4"] = {"nodes": len(nodes), "flip_results": flip_results,
                    "outside": outside, "invalid_flip_results": bad_flip,
                    "edges": len(edges), "components": len(comp_list),
                    "component_size_multiset": dict(Counter(sizes4))}

    # ---------- Task 5: normal-form coverage ----------
    print("\n== Task 5: does every A-containing component contain a B polygon? ==")
    n_with_A = 0
    n_with_A_and_B = 0
    failing = []
    for c in comp_list:
        has_A = any(u in setA for u in c)
        if not has_A:
            continue
        n_with_A += 1
        has_B = any(u in setB for u in c)
        if has_B:
            n_with_A_and_B += 1
        else:
            failing.append((len(c), min(c, key=lambda w: (len(w), w))))
    print(f"components containing an A-polygon = {n_with_A}")
    print(f"of those, containing a B-polygon = {n_with_A_and_B}")
    print(f"components with A but no B: {len(failing)}")
    for sz, w in failing[:5]:
        print(f"  size {sz}, representative {w}")
    comps_no_A = sum(1 for c in comp_list if not any(u in setA for u in c))
    print(f"components with no A-polygon at all: {comps_no_A}")
    res["task5"] = {"components_with_A": n_with_A,
                    "with_A_and_B": n_with_A_and_B,
                    "failing": [{"size": s, "word": w} for s, w in failing[:5]],
                    "n_failing": len(failing),
                    "components_without_A": comps_no_A}

    # ---------- Task 6: pushed-down condition ----------
    print("\n== Task 6: pushed-down condition ==")
    bv = 0
    b_bad_words = []
    b_hits = 0
    for F in B:
        hits, viol = pushed_check(F)
        b_hits += hits
        bv += len(viol)
        if viol:
            b_bad_words.append((F, viol))
    print(f"B: pattern corners tested = {b_hits}, violations = {bv} (expect 0)")
    if b_bad_words:
        F, viol = b_bad_words[0]
        print(f"  example: {F} corner(s) {viol}")
    a_ok = 0
    a_hits = 0
    a_example = None
    for F in A:
        hits, viol = pushed_check(F)
        a_hits += hits
        if not viol:
            a_ok += 1
        elif a_example is None:
            a_example = (F, viol)
    print(f"A: pattern corners tested = {a_hits}")
    print(f"A: words with no violation at any corner = {a_ok} of {len(A)}")
    if a_example:
        print(f"  first A word with a violation: {a_example[0]} corner(s) {a_example[1]}")
    res["task6"] = {"B_violations": bv, "B_pattern_corners": b_hits,
                    "A_words_all_corners_ok": a_ok, "A_pattern_corners": a_hits,
                    "A_example_violation": a_example[0] if a_example else None}

    print(f"\nelapsed {time.time() - t0:.1f} s")
    with open(os.path.join(HERE, "results.json"), "w") as f:
        json.dump(res, f, indent=2, sort_keys=True)


if __name__ == "__main__":
    main()
