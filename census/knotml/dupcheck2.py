import json, sys, itertools, multiprocessing as mp, snappy

def test(pair):
    a, b = pair
    try:
        return pair, bool(snappy.Manifold(a).is_isometric_to(snappy.Manifold(b)))
    except Exception as e:
        return pair, None

if __name__ == "__main__":
    d = sys.argv[1]
    groups = json.load(open(f"{d}/volume_groups.json"))
    ids = json.load(open(f"{d}/known.json"))["ids"]
    level = {i[2:]: v for i, v in ids.items() if i.startswith("H:")}
    pairs = [p for g in groups.values() for p in itertools.combinations(g, 2)]
    print("pairs to test:", len(pairs), flush=True)
    with mp.Pool(4) as pool:
        res = pool.map(test, pairs, chunksize=64)
    dup = [(p, r) for p, r in res if r]
    unk = [p for p, r in res if r is None]
    print("isometric pairs (= one knot with two ids):", len(dup), "| tests that errored:", len(unk))
    for (a, b), _ in dup[:10]:
        print("  levels", level[a], level[b], "|", a[:40], "|", b[:40])
