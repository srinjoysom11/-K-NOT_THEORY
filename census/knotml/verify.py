"""Post-level verification: find a knot that carries two canonical ids.

SnapPea's canonical cell decomposition is computed numerically; on ties two diagrams of the same
knot can get different canonical retriangulations (Burton, Sec. 4.2 and 6.3).  Equal hyperbolic volume
is necessary for equality, so every duplicate lies in a volume group; each pair in a group is tested
with SnapPy's isometry test (equal canonical decompositions => homeomorphic complements => same knot
up to mirror, by Gordon-Luecke).

    KNOT_DATA=data_v3 python -m knotml.verify 14       # report duplicates among ids of all levels <= 14
"""
import json, os, sys, itertools, collections, multiprocessing as mp
import snappy
from . import pipeline as P


def _vol(s):
    try:
        return s, round(float(snappy.Manifold(s).volume()), 6)
    except Exception:
        return s, None


def _iso(pair):
    a, b = pair
    try:
        return pair, bool(snappy.Manifold(a).is_isometric_to(snappy.Manifold(b)))
    except Exception:
        return pair, None


def duplicates(max_level):
    ids = json.load(open(os.path.join(P.DATA, "known.json")))["ids"]
    level = {i[2:]: v for i, v in ids.items() if i.startswith("H:") and 0 < v <= max_level}
    with mp.Pool(P.NPROC) as pool:
        vols = pool.map(_vol, list(level), chunksize=256)
        groups = collections.defaultdict(list)
        for s, v in vols:
            if v is not None:
                groups[v].append(s)
        pairs = [p for g in groups.values() if len(g) > 1 for p in itertools.combinations(g, 2)]
        res = pool.map(_iso, pairs, chunksize=64)
    return [(p, level[p[0]], level[p[1]]) for p, r in res if r], sum(1 for _, r in res if r is None), len(pairs), len(level)


if __name__ == "__main__":
    dup, errs, npairs, nids = duplicates(int(sys.argv[1]))
    print(f"{nids} hyperbolic ids, {npairs} equal-volume pairs tested, {errs} test errors")
    print(f"duplicate ids (one knot, two signatures): {len(dup)}")
    for (a, b), la, lb in dup:
        print(f"  levels {la}/{lb}: {a[:36]} == {b[:36]}")
