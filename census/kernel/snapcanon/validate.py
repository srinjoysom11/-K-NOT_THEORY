#!/usr/bin/env python3
"""Validate snapcanon_cli against SnapPy's reference identity.

Run with the project venv (from this directory, after `make`):

    python3 -I validate.py DATA [--data2 SMALLER]
        [--timing-n 1000] [--timing-reps 3] [--mirror-n 300]
        [--cache FILE.json] [--workdir DIR]

Reference (exactly the loop from the task statement):

    M = snappy.Link(pd).exterior()
    for _ in range(25):
        if M.solution_type() == "all tetrahedra positively oriented":
            return M.isometry_signature()
        M.randomize()
    # -> not hyperbolic

Checks
  A  partition: for diagrams that both sides call hyperbolic, the induced partitions
     must be identical (bijection between classes).  Also reports status agreement.
  B  timing: ms per diagram for the CLI and for the Python reference on the same
     first --timing-n diagrams, repeated --timing-reps times (median reported), with
     the load average before and after.
  C  optional: the same partition check on a second, smaller file (--data2).
  M  mirror invariance: the CLI and SnapPy signatures of the mirror image
     (spherogram Link.mirror()) must equal those of the original diagram.
"""
import argparse
import json
import os
import statistics
import subprocess
import tempfile
import time

HERE = os.path.dirname(os.path.abspath(__file__))
CLI = os.path.join(HERE, "snapcanon_cli")
HYP = "all tetrahedra positively oriented"


def read_diagrams(path, limit=None):
    out = []
    with open(path) as f:
        for line in f:
            p = line.split()
            if not p:
                continue
            n = int(p[1])
            vals = [int(x) for x in p[2:2 + 4 * n]]
            pd = [tuple(vals[4 * k: 4 * k + 4]) for k in range(n)]
            out.append((p[0], pd))
            if limit is not None and len(out) >= limit:
                break
    return out


def write_diagrams(path, items):
    with open(path, "w") as f:
        for name, pd in items:
            f.write("%s %d %s\n" % (name, len(pd), " ".join(str(x) for t in pd for x in t)))


def snappy_identity(snappy, pd):
    """The reference loop from the task.  Returns (is_hyperbolic, signature_or_None)."""
    M = snappy.Link(pd).exterior()
    for _ in range(25):
        if M.solution_type() == HYP:
            return True, M.isometry_signature()
        M.randomize()
    return False, None


def run_cli(path, retri=25, shard=None, seed=None):
    cmd = [CLI, "--retriangulations", str(retri)]
    if seed is not None:
        cmd += ["--seed", str(seed)]
    if shard is not None:
        cmd += ["--shard", str(shard[0]), str(shard[1])]
    cmd.append(path)
    res = subprocess.run(cmd, capture_output=True, text=True, check=True)
    out = {}
    for line in res.stdout.splitlines():
        parts = line.split(" ", 2)
        status = int(parts[1])
        sig = parts[2] if len(parts) > 2 and parts[2] != "-" else None
        out[parts[0]] = (status, sig)
    return out


def partition_check(ref, cand, label):
    """ref, cand: id -> signature, restricted to the diagrams both sides call hyperbolic."""
    fwd, bwd, bad = {}, {}, []
    for k in ref:
        if k not in cand:
            bad.append((k, ref[k], None))
            continue
        r, c = ref[k], cand[k]
        if fwd.setdefault(r, c) != c or bwd.setdefault(c, r) != r:
            bad.append((k, r, c))
    return {
        "label": label,
        "hyperbolic_ref": len(ref),
        "hyperbolic_cand": len(cand),
        "classes_ref": len(set(ref.values())),
        "classes_cand": len(set(cand.values())),
        "mismatches": len(bad),
        "mismatch_examples": bad[:10],
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("data")
    ap.add_argument("--data2", help="optional smaller file for check C")
    ap.add_argument("--limit", type=int, default=None)
    ap.add_argument("--timing-n", type=int, default=1000)
    ap.add_argument("--timing-reps", type=int, default=3)
    ap.add_argument("--mirror-n", type=int, default=300)
    ap.add_argument("--npz", help="level npz with an 'ids' hash array (cross-check only)")
    ap.add_argument("--cache", help="JSON cache of the SnapPy reference results")
    ap.add_argument("--workdir", help="scratch directory (default: a fresh temp dir)")
    args = ap.parse_args()

    import snappy   # the project venv
    import spherogram

    workdir = args.workdir or tempfile.mkdtemp(prefix="snapcanon_validate_")
    os.makedirs(workdir, exist_ok=True)
    report = {"data": os.path.abspath(args.data)}

    diagrams = read_diagrams(args.data, args.limit)
    report["diagrams"] = len(diagrams)

    # ---- SnapPy reference, cached -------------------------------------------------
    ref = None
    if args.cache and os.path.exists(args.cache):
        with open(args.cache) as f:
            cached = json.load(f)
        if cached.get("data") == os.path.abspath(args.data) and cached.get("n") == len(diagrams):
            ref = {k: (bool(v[0]), v[1]) for k, v in cached["ref"].items()}
    if ref is None:
        t0 = time.time()
        ref = {name: snappy_identity(snappy, pd) for name, pd in diagrams}
        report["snappy_reference_seconds"] = round(time.time() - t0, 1)
        if args.cache:
            with open(args.cache, "w") as f:
                json.dump({"data": os.path.abspath(args.data), "n": len(diagrams),
                           "ref": {k: [v[0], v[1]] for k, v in ref.items()}}, f)

    # ---- A: partition check on search_in_11 ------------------------------------
    subset_path = os.path.join(workdir, "subset_%d.txt" % len(diagrams))
    write_diagrams(subset_path, diagrams)
    cand = run_cli(subset_path, retri=25)
    ref_hyp = {k: v[1] for k, v in ref.items() if v[0]}
    cand_hyp = {k: v[1] for k, v in cand.items() if v[0] == 0}
    disagree = [k for k in ref if ref[k][0] != (cand[k][0] == 0)]
    status_counts = {}
    for st, _ in cand.values():
        status_counts[st] = status_counts.get(st, 0) + 1
    A = partition_check(ref_hyp, cand_hyp, os.path.basename(args.data))
    A["ref_nonhyperbolic"] = len(ref) - len(ref_hyp)
    A["cand_nonhyperbolic"] = len(cand) - len(cand_hyp)
    A["cand_status_counts"] = status_counts
    A["hyperbolic_status_disagreements"] = len(disagree)
    A["disagreement_examples"] = [(k, ref[k][0], cand[k]) for k in disagree[:10]]
    report["A"] = A

    if args.npz:
        import numpy as np
        ids = np.load(args.npz)["ids"].tolist()
        names = [d[0] for d in diagrams]
        if len(ids) == len(names):
            f2, b2, bad = {}, {}, 0
            for k, h in zip(names, ids):
                if not ref[k][0]:
                    continue
                r = ref[k][1]
                if f2.setdefault(r, h) != h or b2.setdefault(h, r) != r:
                    bad += 1
            report["A_npz_ids_partition_mismatches"] = bad
        else:
            report["A_npz_ids_partition_mismatches"] = "length differs"

    # ---- C: second file --------------------------------------------------------
    if args.data2:
        d2 = read_diagrams(args.data2)
        ref2 = {name: snappy_identity(snappy, pd) for name, pd in d2}
        c2 = run_cli(args.data2, retri=25)
        r2 = {k: v[1] for k, v in ref2.items() if v[0]}
        cc2 = {k: v[1] for k, v in c2.items() if v[0] == 0}
        C = partition_check(r2, cc2, os.path.basename(args.data2))
        C["ref_nonhyperbolic"] = len(ref2) - len(r2)
        C["cand_nonhyperbolic"] = len(c2) - len(cc2)
        C["status_disagreements"] = sum(1 for k in ref2 if ref2[k][0] != (c2[k][0] == 0))
        report["C"] = C

    # ---- B: timing ----------------------------------------------------------------
    if args.timing_n > 0:
        sub = diagrams[: args.timing_n]
        sub_path = os.path.join(workdir, "timing_subset.txt")
        write_diagrams(sub_path, sub)
        cli_ms, py_ms = [], []
        load_before = os.getloadavg()
        for _ in range(args.timing_reps):
            t0 = time.perf_counter()
            run_cli(sub_path, retri=25)
            cli_ms.append((time.perf_counter() - t0) * 1000.0 / len(sub))
        for _ in range(args.timing_reps):
            t0 = time.perf_counter()
            for _name, pd in sub:
                snappy_identity(snappy, pd)
            py_ms.append((time.perf_counter() - t0) * 1000.0 / len(sub))
        report["B"] = {
            "n": len(sub),
            "cli_ms_per_diagram_runs": [round(x, 3) for x in cli_ms],
            "cli_ms_median": round(statistics.median(cli_ms), 3),
            "python_ms_per_diagram_runs": [round(x, 3) for x in py_ms],
            "python_ms_median": round(statistics.median(py_ms), 3),
            "loadavg_before": load_before,
            "loadavg_after": os.getloadavg(),
            "cpu_count": os.cpu_count(),
        }

    # ---- M: mirror invariance ----------------------------------------------------------
    if args.mirror_n > 0:
        sub = diagrams[: args.mirror_n]
        mirrored = []
        for name, pd in sub:
            mpd = [tuple(t) for t in spherogram.Link(pd).mirror().PD_code()]
            mirrored.append((name, mpd))
        mir_path = os.path.join(workdir, "mirror_subset.txt")
        write_diagrams(mir_path, mirrored)
        mc = run_cli(mir_path, retri=25)
        same = sum(1 for k, _ in sub if mc[k] == cand[k])
        snappy_mismatch = 0
        for (name, pd), (_, mpd) in zip(sub[:100], mirrored[:100]):
            hm, ho = snappy_identity(snappy, mpd), ref[name]
            if hm[0] != ho[0] or (hm[0] and hm[1] != ho[1]):
                snappy_mismatch += 1
        report["M"] = {
            "n": len(sub),
            "cli_mirror_equal_to_original": same,
            "snappy_mirror_mismatches_first100": snappy_mismatch,
        }

    print(json.dumps(report, indent=2, default=str))


if __name__ == "__main__":
    main()
