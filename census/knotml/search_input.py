"""Export simplify()-survivors of a level as PD codes for kernel/search.

    python -m knotml.search_input 11 data_cpp
Writes <dir>/search_in_<n>.txt and <dir>/search_meta_<n>.npz (labels)."""
import sys, os, pickle
import numpy as np
from . import maps
from .diagrams import pd_code

n, d = int(sys.argv[1]), sys.argv[2]
L = np.load(os.path.join(d, f"level_{n}.npz"))
import pickle
pk = os.path.join('data_v2', 'levels12.pkl')
lv = pickle.load(open(pk, 'rb')) if os.path.exists(pk) else maps.nonseparable_maps(n)
sh = maps.knot_shadows(n, lv)
cands = L["cands"]; alt = L["alt"]; label = L["label"]
with open(os.path.join(d, f"search_in_{n}.txt"), "w") as f:
    for i, (si, bits) in enumerate(cands):
        pd = pd_code(sh[int(si)], int(bits))
        f.write(f"{i} {n} " + " ".join(str(v) for c in pd for v in c) + "\n")
np.savez(os.path.join(d, f"search_meta_{n}.npz"), alt=alt, label=label)
print("wrote", len(cands), "diagrams;", int((~alt & label).sum()), "reducible non-alt,", int((~alt & ~label).sum()), "minimal non-alt")
