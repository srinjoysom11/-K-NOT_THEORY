"""Census pipeline v2: C++ generation -> HOMFLY-sharded Reidemeister closure ->
SnapPy on one representative per surviving class.

    KNOT_DATA=data_v2 python -m knotml.build2 3 12 [h D A cap]

Every pruning/merging step is a Regina-checked sequence of Reidemeister moves
or a HOMFLY difference, so the census is exact (checked against the published
counts), with no learned component in the correctness path."""
from __future__ import annotations
import sys, os, time, json, subprocess, tempfile, pickle
import numpy as np
from . import maps, pipeline as P, kernel as K
from .diagrams import pd_code, make_link, homfly_key, alt_bits
from .native_id import native_ids
from .build import EXPECTED, resolve_composites

BFS = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "kernel", "bfsclose")


def _hk(item):
    si, bits = item
    return homfly_key(make_link(P._SHADOWS[si], int(bits)))


def closure(n, shadows, surv, params, keys, alts):
    """-> (representatives, stats).  One representative per class not proven reducible."""
    h, D, A, cap = params
    P.set_shadows(shadows)
    t_key = 0.0
    NP = P.NPROC
    M = (1 << 64) - 1
    shard = [(((k * 0x9E3779B97F4A7C15) & M) >> 32) % NP for k in keys]   # mixed Jones-hash key from the C++ kernel
    tw0 = time.time()
    with tempfile.TemporaryDirectory() as tmp:
        files = [open(os.path.join(tmp, f"in{s}.txt"), "w") for s in range(NP)]
        for i, (c, s) in enumerate(zip(surv, shard)):
            pd = pd_code(shadows[int(c[0])], int(c[1]))
            files[s].write(f"{i} {n} " + " ".join(str(v) for t in pd for v in t) + "\n")
        for f in files: f.close()
        t_write = time.time() - tw0
        t0 = time.time()
        procs = [subprocess.Popen([BFS, os.path.join(tmp, f"in{s}.txt"), os.path.join(tmp, f"out{s}.txt"),
                                   str(h), str(cap), str(D), str(A)], stderr=subprocess.DEVNULL) for s in range(NP)]
        for p in procs: p.wait()
        t_close = time.time() - t0
        reps, reducible, seen = [], 0, {}
        cls_alt, rows = {}, []
        for s in range(NP):
            for l in open(os.path.join(tmp, f"out{s}.txt")):
                i, root, red = l.split(); i = int(i)
                rows.append((s, root, i, red))
                if alts[i]: cls_alt[(s, root)] = True
        for s, root, i, red in rows:
            if red == "1":
                reducible += 1
            elif (s, root) not in seen:
                seen[(s, root)] = i; reps.append(i)
        rep_alt = {i: cls_alt.get(k, False) for k, i in seen.items()}
    return reps, rep_alt, dict(t_key=t_key, t_close=t_close, t_write=t_write, proven_reducible=reducible, classes_to_identify=len(reps))


def reduce_by_alt_knot(shadows):
    """One shadow per alternating knot.  By the Menasco-Thistlethwaite flyping theorem two shadows
    whose alternating diagrams are the same knot are related by flypes, and a flype carries any
    crossing assignment to a diagram of the same knot with the same number of crossings (Burton 3.2),
    so one representative shadow per class suffices for the whole census."""
    ids = native_ids([pd_code(sh, alt_bits(sh)) for sh in shadows])
    seen, keep = set(), []
    for sh, i in zip(shadows, ids):
        if i not in seen:
            seen.add(i); keep.append(sh)
    return keep


def run(lo, hi, params, levels):
    known = P.load_known()
    for n in range(lo, hi + 1):
        T0 = time.time()
        t0 = time.time(); shadows = maps.knot_shadows(n, levels); n_shadows_all = len(shadows)
        shadows = reduce_by_alt_knot(shadows) if os.environ.get('FLYPE_REDUCE', '1') == '1' else shadows
        t_shadows = time.time() - t0
        t0 = time.time(); surv, n_c, n_s, _, _ = K.candidates(n, shadows); t_gen = time.time() - t0
        keys, alts = list(K.candidates.keys), list(K.candidates.alts)
        reps, rep_alt, st = closure(n, shadows, surv, params, keys, alts)
        t0 = time.time(); ids = native_ids([pd_code(shadows[int(surv[i][0])], int(surv[i][1])) for i in reps]); t_id = time.time() - t0
        kn = known["ids"]
        new, rep_of = set(), {}
        for i, idv in zip(reps, ids):
            if idv in kn: continue
            new.add(idv); rep_of.setdefault(idv, surv[i])
        t_alt = 0.0
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
        print(json.dumps(dict(n=n, shadows_all=n_shadows_all, shadows_kept=len(shadows), processed=n_c, survivors=len(surv), reps_identified=len(reps), new_alt=len(new_alt),
                              new_nonalt=len(new_non), t_shadows=round(t_shadows, 2), t_gen=round(t_gen, 2), t_write=round(st['t_write'], 2), t_alt=round(t_alt, 2), t_key=round(st["t_key"], 2),
                              t_close=round(st["t_close"], 2), t_id=round(t_id, 2), wall=round(time.time() - T0, 2))) + ok, flush=True)


if __name__ == "__main__":
    lo, hi = int(sys.argv[1]), int(sys.argv[2])
    params = tuple(int(x) for x in (sys.argv[3:7] if len(sys.argv) >= 7 else (2, 3, 40, 1000)))
    cache = os.path.join(P.DATA, f"levels{hi}.pkl")
    if os.path.exists(cache):
        levels = pickle.load(open(cache, "rb"))
    else:
        levels = maps.nonseparable_maps(hi)
        pickle.dump(levels, open(cache, "wb"))
    run(lo, hi, params, levels)
