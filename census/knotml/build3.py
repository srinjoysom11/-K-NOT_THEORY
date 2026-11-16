"""Census pipeline v3: everything heavy is native.

   C++ shadows  ->  flype-class reduction (one shadow per alternating knot, identified natively)
   -> C++ generation with bigon (R2) pruning + Regina simplify  ->  sharded Reidemeister closure
   -> native SnapPea-kernel identity on one representative per class.

    KNOT_DATA=data_v3 python -m knotml.build3 3 12 [h D A cap]

No learned component is in the correctness path; every pruning step is a proof (Regina-checked
Reidemeister moves, R2 bigon criterion, flyping theorem), and the census is checked against the
published counts at every level."""
from __future__ import annotations
import sys, os, time, json, subprocess, tempfile
from . import pipeline as P, kernel as K
from .diagrams import pd_code
from .native_id import native_ids
from .build import EXPECTED, resolve_composites
from .build2 import closure
import multiprocessing as mp

SHADOWS = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "kernel", "shadows")


def _recanon(sig):
    """Re-canonize a stored hyperbolic id to a fixpoint of SnapPy's isometry_signature (the canonical
    retriangulation).  The extracted kernel occasionally returns a non-canonical retriangulation (found:
    a 20-tet triangulation where the canonical one has 28 tets, one knot carrying two ids at n=14)."""
    import snappy
    cur = sig
    for _ in range(3):
        try:
            nxt = snappy.Manifold(cur).isometry_signature()
        except Exception:
            return sig, sig
        if nxt == cur:
            break
        cur = nxt
    return sig, cur


def canonicalize_new(ids, known_ids):
    """Map every not-yet-known hyperbolic id to its canonical fixpoint (equal canonical ids prove sameness)."""
    cand = sorted({i for i in ids if i.startswith("H:") and i not in known_ids})
    if not cand:
        return ids, 0
    with mp.Pool(P.NPROC) as pool:
        res = pool.map(_recanon, [c[2:] for c in cand], chunksize=64)
    mp_ = {"H:" + a: "H:" + b for a, b in res}
    changed = sum(1 for a, b in res if a != b)
    return [mp_.get(i, i) for i in ids], changed


class LS:
    """Lightweight shadow read back from a shadows file (what pd_code needs)."""
    def __init__(self, n, lab, arr0, arr1):
        self.n, self.lab, self.arr = n, lab, [[a, b] for a, b in zip(arr0, arr1)]


def read_blocks(path):
    lines = open(path).read().split("\n")
    count = int(lines[0]); blocks = [lines[1 + 5 * i: 6 + 5 * i] for i in range(count)]
    return blocks


def parse(block):
    n = int(block[0]); lab = list(map(int, block[1].split())); a0 = list(map(int, block[2].split())); a1 = list(map(int, block[3].split()))
    return LS(n, lab, a0, a1)


def run(lo, hi, params):
    known = P.load_known()
    for n in range(lo, hi + 1):
        T0 = time.time()
        with tempfile.TemporaryDirectory() as tmp:
            t0 = time.time()
            subprocess.run([SHADOWS, str(n), tmp], check=True, stderr=subprocess.DEVNULL)
            t_enum = time.time() - t0
            t0 = time.time()
            blocks = read_blocks(os.path.join(tmp, f"shadows_{n}.txt"))
            alt_pds = []
            for line in open(os.path.join(tmp, f"altpd_{n}.txt")):
                t = list(map(int, line.split())); alt_pds.append([tuple(t[2 + 4 * c: 6 + 4 * c]) for c in range(t[1])])
            ids = native_ids(alt_pds) if os.environ.get("FLYPE_REDUCE", "1") == "1" else list(range(len(alt_pds)))
            seen, keep = set(), []
            for i, idv in enumerate(ids):
                if idv not in seen:
                    seen.add(idv); keep.append(i)
            t_reduce = time.time() - t0
            reduced = os.path.join(tmp, "reduced.txt")
            with open(reduced, "w") as f:
                f.write(f"{len(keep)}\n")
                for i in keep: f.write("\n".join(blocks[i]) + "\n")
            shadows = [parse(blocks[i]) for i in keep]
            t0 = time.time()
            surv, keys, alts, n_c, n_s, _, _, n_pruned = K.candidates_file(reduced)
            t_gen = time.time() - t0
        reps, rep_alt, st = closure(n, shadows, surv, params, keys, alts)
        t0 = time.time(); ids = native_ids([pd_code(shadows[int(surv[i][0])], int(surv[i][1])) for i in reps]); t_id = time.time() - t0
        kn = known["ids"]
        t0 = time.time(); ids, n_recanon = canonicalize_new(ids, kn); t_recanon = time.time() - t0
        new, rep_of = set(), {}
        for i, idv in zip(reps, ids):
            if idv in kn: continue
            new.add(idv); rep_of.setdefault(idv, surv[i])
        new_alt = {idv for i, idv in zip(reps, ids) if idv not in kn and rep_alt[i]}
        new_non = new - new_alt
        comp = resolve_composites(shadows, new_non, rep_of, n)
        new_non -= comp
        for i in comp: kn[i] = -1
        for i in new_alt | new_non: kn[i] = n
        known["levels"][str(n)] = [len(new_alt), len(new_non)]
        P.save_known(known)
        exp = EXPECTED.get(n)
        ok = "" if exp is None else ("  OK" if (len(new_alt), len(new_non)) == exp else f"  MISMATCH expected {exp}")
        print(json.dumps(dict(n=n, shadows_all=len(blocks), shadows_kept=len(keep), diagrams_built=n_c, pruned_by_bigons=n_pruned,
                              survivors=len(surv), identified=len(reps), new_alt=len(new_alt), new_nonalt=len(new_non),
                              t_enum=round(t_enum, 2), t_reduce=round(t_reduce, 2), t_gen=round(t_gen, 2), t_close=round(st["t_close"], 2),
                              t_write=round(st["t_write"], 2), t_id=round(t_id, 2), t_recanon=round(t_recanon, 1), recanonicalized=n_recanon, wall=round(time.time() - T0, 2))) + ok, flush=True)


if __name__ == "__main__":
    lo, hi = int(sys.argv[1]), int(sys.argv[2])
    params = tuple(int(x) for x in (sys.argv[3:7] if len(sys.argv) >= 7 else (2, 3, 5, 200)))
    run(lo, hi, params)
