"""Build the exact census level by level and save labelled data.

Per level n:
  1. enumerate shadows, resolve crossings, dedupe diagrams (Regina signatures)
  2. cheap exact filter: Regina simplify() (R1/R2 local minimum + random R3).
     Success is a proof the diagram is not minimal, so those are dropped.
  3. survivors: features, then rigorous identity (SnapPy canonical signature)
  4. new ids (not seen at lower levels) are the census knots at n crossings.

    python -m knotml.build 3 10
"""
from __future__ import annotations
import sys, time, json, os, functools
import numpy as np
from . import maps, pipeline as P, kernel as K
from .diagrams import make_link, pd_code

# prime knots with exactly n crossings: (alternating, non-alternating)  [Thistlethwaite 2023, Table 3]
EXPECTED = {3: (1, 0), 4: (1, 0), 5: (2, 0), 6: (3, 0), 7: (7, 0), 8: (18, 3),
            9: (41, 8), 10: (123, 42), 11: (367, 185), 12: (1288, 888), 13: (4878, 5110), 14: (19536, 27436)}


@functools.lru_cache(maxsize=None)
def torus_ids(max_c=13):
    """HOMFLY ids of torus knots T(p,q) with crossing number <= max_c.
    A new non-hyperbolic id matching one of these is a genuine prime torus
    knot: no exhaustive search needed (and none can succeed)."""
    import math, regina
    from .diagrams import homfly_key
    out = set()
    for p in range(2, max_c + 2):
        for q in range(p + 1, max_c + 2):
            if math.gcd(p, q) == 1 and q * (p - 1) <= max_c:
                out.add("N:" + homfly_key(regina.ExampleLink.torus(p, q)))
    return out


def resolve_composites(shadows, new_ids, rep, n):
    """Non-hyperbolic new ids may be composite knots with < n crossings
    (e.g. granny/square at n=8, 3_1#4_1 at n=9).  Exhaustive Reidemeister
    search, as in Burton Sec. 5.1.  Returns the set that are composite."""
    comp = set()
    tori = torus_ids()
    for k in new_ids:
        if not k.startswith("N:") or k in tori:
            continue
        si, bits = rep[k]
        L = make_link(shadows[si], int(bits))
        for h in (1, 2):                      # height 3 is exponential and cannot succeed on a prime knot
            if L.simplifyExhaustive(h, P.NPROC) and L.size() < n:
                comp.add(k)
                break
    return comp


def build_level(n, levels, known):
    shadows = maps.knot_shadows(n, levels)
    P.set_shadows(shadows)
    t0 = time.time(); surv, n_cands, n_simp, cpu_gen, cpu_simp = (K.candidates if K.available() and os.environ.get('KNOT_KERNEL', 'cpp') == 'cpp' else P.candidates)(n, shadows); t_cand = time.time() - t0
    t0 = time.time(); X, alt = P.featurize(surv); t_feat = time.time() - t0
    t0 = time.time(); ids = P.identify_all(surv); t_id = time.time() - t0
    kn = known["ids"]
    seen_lower = np.array([i in kn for i in ids])
    new_alt, new_non, rep = set(), set(), {}
    for c, i, a, r in zip(surv, ids, alt, seen_lower):
        if r:
            continue
        (new_alt if a else new_non).add(i)
        rep.setdefault(i, c)
    new_non -= new_alt
    comp = resolve_composites(shadows, new_non, rep, n)
    new_non -= comp
    for i in comp:
        kn[i] = -1
    for i in new_alt | new_non:
        kn[i] = n
    label = np.array([(i in kn and kn[i] != n) for i in ids])      # prunable: not a new prime knot
    known["levels"][str(n)] = [len(new_alt), len(new_non)]
    np.savez_compressed(os.path.join(P.DATA, f"level_{n}.npz"), X=X, alt=alt, label=label,
                        cands=np.array(surv), n_cands=n_cands, n_simplified=n_simp, cpu_gen=cpu_gen, cpu_simp=cpu_simp,
                        ids=np.array([hash(i) & 0x7FFFFFFFFFFFFFFF for i in ids]),
                        t_feat=t_feat, t_id=t_id)
    return dict(n=n, shadows=len(shadows), candidates=n_cands, simplified_away=n_simp,
                survivors=len(surv), surv_nonalt=int((~alt).sum()),
                surv_prunable_frac=round(float(label[~alt].mean()), 4) if (~alt).any() else None,
                new_alt=len(new_alt), new_nonalt=len(new_non),
                distinct_ids_among_survivors=len(set(ids)),
                t_gen_and_simplify_wall=round(t_cand, 2), cpu_gen=round(cpu_gen, 1), cpu_simplify=round(cpu_simp, 1), t_feat=round(t_feat, 2), t_id=round(t_id, 2))


def main():
    lo, hi = int(sys.argv[1]), int(sys.argv[2])
    levels = maps.nonseparable_maps(hi)
    known = P.load_known()
    for n in range(lo, hi + 1):
        r = build_level(n, levels, known)
        P.save_known(known)
        exp = EXPECTED.get(n)
        ok = "" if exp is None else ("  OK" if (r["new_alt"], r["new_nonalt"]) == exp else f"  MISMATCH expected {exp}")
        print(json.dumps(r) + ok, flush=True)


if __name__ == "__main__":
    main()
