"""Glue to the C++ generation kernel (kernel/gen.cpp)."""
from __future__ import annotations
import os, subprocess, tempfile, time
from . import pipeline as P

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BIN = os.path.join(ROOT, "kernel", "gen")


def available() -> bool:
    return os.path.exists(BIN)


def bigon_constraints(sh):
    """For every bigon (2-sided face) with crossings u, v: the diagram is R2-reducible
    exactly when s_u XOR s_v == c (the same strand is over at both crossings).  Those
    assignments can be skipped without ever building the diagram."""
    out = []
    for cyc in sh.faces:
        if len(cyc) != 2:
            continue
        h = cyc[0]
        a = sh.alp[h]
        u, v = h >> 2, a >> 2
        if u == v:
            continue
        out.append((u, v, ((h & 3) & 1) ^ ((a & 3) & 1)))
    return out


def export_shadows(shadows, path):
    with open(path, "w") as f:
        f.write(f"{len(shadows)}\n")
        for sh in shadows:
            n = sh.n
            f.write(f"{n}\n")
            f.write(" ".join(map(str, sh.lab)) + "\n")
            f.write(" ".join(str(sh.arr[c][0]) for c in range(n)) + "\n")
            f.write(" ".join(str(sh.arr[c][1]) for c in range(n)) + "\n")
            cons = bigon_constraints(sh)
            f.write(str(len(cons)) + " " + " ".join(f"{u} {v} {c}" for u, v, c in cons) + "\n")


def candidates(n, shadows, nproc=None, workdir=None):
    """Same contract as pipeline.candidates:
    (survivors, n_processed, n_simplified, cpu_build_and_sig, cpu_simplify)"""
    nproc = nproc or P.NPROC
    P.set_shadows(shadows)
    with tempfile.TemporaryDirectory(dir=workdir) as tmp:
        sp = os.path.join(tmp, "shadows.txt")
        export_shadows(shadows, sp)
        procs = []
        for i in range(nproc):
            out = os.path.join(tmp, f"out_{i}.txt")
            procs.append((out, subprocess.Popen([BIN, sp, str(i), str(nproc), out])))
        surv, keys, alts, tot = [], [], [], [0, 0, 0.0, 0.0, 0.0]
        for out, p in procs:
            if p.wait() != 0:
                raise RuntimeError("kernel shard failed")
            for line in open(out):
                if line.startswith("#stats"):
                    a = line.split()[1:]
                    tot[0] += int(a[0]); tot[1] += int(a[1])
                    tot[2] += float(a[3]); tot[3] += float(a[4]); tot[4] += float(a[5])
                else:
                    si, bits, skey, alt = line.split()
                    surv.append((int(si), int(bits)))
                    keys.append(int(skey)); alts.append(int(alt))
    candidates.keys, candidates.alts = keys, alts      # shard keys / alternating flags of the survivors
    return surv, tot[0], tot[1], tot[2] + tot[4], tot[3]


def candidates_file(shadow_path, nproc=None):
    """Like candidates(), but the shadows come from a file written by kernel/shadows.
    -> (survivors, keys, alts, n_processed, n_simplified, cpu_build_and_sig, cpu_simplify, n_pruned)"""
    nproc = nproc or P.NPROC
    with tempfile.TemporaryDirectory() as tmp:
        procs = []
        for i in range(nproc):
            out = os.path.join(tmp, f"out_{i}.txt")
            procs.append((out, subprocess.Popen([BIN, shadow_path, str(i), str(nproc), out])))
        surv, keys, alts, tot = [], [], [], [0, 0, 0.0, 0.0, 0]
        for out, p in procs:
            if p.wait() != 0:
                raise RuntimeError("kernel shard failed")
            for line in open(out):
                if line.startswith("#stats"):
                    a = line.split()[1:]
                    tot[0] += int(a[0]); tot[1] += int(a[1]); tot[2] += float(a[3]) + float(a[5]); tot[3] += float(a[4]); tot[4] += int(a[6])
                else:
                    si, bits, skey, alt = line.split()
                    surv.append((int(si), int(bits))); keys.append(int(skey)); alts.append(int(alt))
    return surv, keys, alts, tot[0], tot[1], tot[2], tot[3], tot[4]
