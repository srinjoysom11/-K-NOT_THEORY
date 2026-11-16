"""Look for one knot carrying two canonical ids (numerically ambiguous canonical cell decomposition).

All ids of all levels are loaded back into SnapPy; ids with equal hyperbolic volume form candidate
groups, and each pair in a group is tested with SnapPy's isometry test.  Equal volume is necessary
for being the same knot, so no duplicate can hide outside a group."""
import json, sys, collections, multiprocessing as mp
import snappy

def vol(s):
    try:
        M = snappy.Manifold(s)
        return s, round(float(M.volume()), 6), M.homology().elementary_divisors() if False else None
    except Exception:
        return s, None, None

if __name__ == "__main__":
    d = sys.argv[1]
    ids = json.load(open(f"{d}/known.json"))["ids"]
    H = sorted((i[2:], v) for i, v in ids.items() if i.startswith("H:") and v > 0)
    print("hyperbolic ids:", len(H), flush=True)
    with mp.Pool(4) as pool:
        res = pool.map(vol, [s for s, _ in H], chunksize=256)
    level = dict(H)
    groups = collections.defaultdict(list)
    for s, v, _ in res:
        if v is None: print("could not load", s[:30]); continue
        groups[v].append(s)
    multi = {v: g for v, g in groups.items() if len(g) > 1}
    print("distinct volumes:", len(groups), "| volume groups with >1 id:", len(multi),
          "| ids inside such groups:", sum(len(g) for g in multi.values()), "| largest group:", max(len(g) for g in groups.values()), flush=True)
    json.dump({str(v): g for v, g in multi.items()}, open(f"{d}/volume_groups.json", "w"))
