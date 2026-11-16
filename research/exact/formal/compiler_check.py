#!/usr/bin/env python3
"""Compiler-diversity check (not part of the proof).  Re-runs parts of the computation with a checkpart
binary whose project code was compiled by a different C compiler (gcc instead of Lean's bundled clang)
and compares the SHA-256 of each output with the txtsha in the accepted log.
usage: compiler_check.py BINARY n:r [n:r ...]     appends to out/lean/COMPILER_CHECK.txt"""
import hashlib, os, re, subprocess, sys
from concurrent.futures import ThreadPoolExecutor
EX = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
def parts(n): return {34: 1024, 32: 256, 30: 64, 28: 2}.get(n, 1)
binary = sys.argv[1]
items = [tuple(map(int, a.split(":"))) for a in sys.argv[2:]]
bsha = hashlib.sha256(open(binary, "rb").read()).hexdigest()
def one(nr):
    n, r = nr; M = parts(n)
    log = open(os.path.join(EX, f"out/lean/parts/n{n}_check.part{r}_{M}.log")).read()
    want = re.search(r"txtsha=(\w+)", log).group(1)
    out = subprocess.run([binary, str(n), str(r)], capture_output=True).stdout
    got = hashlib.sha256(out).hexdigest()
    line = f"n={n} r={r} m={M} logged={want[:16]} gcc-build={got[:16]} {'IDENTICAL' if got == want else 'DIFFERENT'}"
    print(line, flush=True); return line
with ThreadPoolExecutor(max_workers=os.cpu_count() or 1) as ex:
    lines = list(ex.map(one, items))
with open(os.path.join(EX, "out/lean/COMPILER_CHECK.txt"), "a") as f:
    f.write(f"# checkpart with project code compiled by gcc 13.3 (-O3 -march=native), binary sha256 {bsha}\n")
    f.write("\n".join(lines) + "\n")
