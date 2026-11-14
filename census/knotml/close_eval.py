import sys, collections, numpy as np, subprocess, time, os
n, d, h, cap = int(sys.argv[1]), sys.argv[2], sys.argv[3], sys.argv[4]
L = np.load(os.path.join(d, f"level_{n}.npz")); ids, lab, alt = L["ids"], L["label"], L["alt"]
out = os.path.join(d, f"close_{n}_{h}.txt")
t = time.time()
r = subprocess.run(["kernel/bfsclose", os.path.join(d, f"search_in_{n}.txt"), out, h, cap] + sys.argv[5:7], capture_output=True, text=True)
dt = time.time() - t
root = np.zeros(len(ids), int); red = np.zeros(len(ids), bool)
for l in open(out):
    i, c, f = l.split(); root[int(i)] = int(c); red[int(i)] = f == "1"
by = collections.defaultdict(set)
for c, i in zip(root, ids): by[c].add(i)
impure = sum(len(v) > 1 for v in by.values())
false_red = int((red & ~lab).sum())
nonred_roots = len({c for c, f in zip(root, red) if not f})
print(f"h={h} cap={cap}: {dt:.1f}s | {r.stderr.strip()}")
print(f"  survivors {len(ids)} -> classes {len(by)} (distinct knots {len(set(ids))}); impure classes {impure}; false reductions {false_red}")
print(f"  proven reducible: {int(red.sum())}/{int((lab).sum())} reducible survivors ({100*red.sum()/lab.sum():.1f}%)")
calls = len({c for c, f in zip(root, red) if not f})
print(f"  SnapPy calls needed: {calls} (vs {len(ids)}): {len(ids)/calls:.1f}x fewer")
