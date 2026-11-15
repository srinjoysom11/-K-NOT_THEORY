#!/usr/bin/env python3
"""Establish CompCert (lean/Len52/Main.lean) from the finished search parts, and run the cross-checks.

For every length n in Main.lean's `lengths` and every part r < parts(n):
  1. the Lean part log out/lean/parts/n{n}_lean.part{r}_{M}.log exists, is finished ("seconds="),
     and was produced by a commit whose lean/Len52/Search.lean equals the current one;
  2. the union of the Lean words for n is computed;
  3. `lake exe certify` (the compiled verified colorCheck) is run on all of them: every word must pass.
Cross-checks (not part of the proof):
  4. the C++ cross-check-mode words (out/lean/parts/n{n}_cpp.*), where available, have the same union;
  5. for unsplit runs (M = 1), the node counts of the two programs are equal;
  6. an independent Python colouring count (formal/projections.py) gives 7 colourings for every word.
Writes out/lean/COMPCERT.txt."""
import glob, os, re, subprocess, sys
HERE = os.path.dirname(os.path.abspath(__file__))
EX = os.path.dirname(HERE)
sys.path.insert(0, HERE)
from projections import diagram, colorings

LENGTHS = [4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34]
def parts(n): return {34: 1024, 32: 256, 30: 64, 28: 2}.get(n, 1)
LET = "ewnsud"

def search_hash_at(commit):
    try:
        return subprocess.run(["git", "-C", EX, "show", f"{commit}:research/exact/lean/Len52/Search.lean"],
                              capture_output=True, text=True, check=True).stdout
    except subprocess.CalledProcessError:
        return None

def main():
    cur = open(os.path.join(EX, "lean/Len52/Search.lean")).read()
    seen_commits = {}
    out = []; ok = True; allwords = []
    for n in LENGTHS:
        M = parts(n); words = set(); nodes = 0; missing = []
        for r in range(M):
            b = os.path.join(EX, f"out/lean/parts/n{n}_lean.part{r}_{M}")
            if not (os.path.exists(b + ".log") and os.path.exists(b + ".txt")):
                missing.append(r); continue
            log = open(b + ".log").read()
            m = re.search(r"commit=(\w+)", log)
            if "seconds=" not in log or not m:
                missing.append(r); continue
            c = m.group(1)
            if c not in seen_commits: seen_commits[c] = (search_hash_at(c) == cur)
            if not seen_commits[c]:
                out.append(f"n={n} part {r}: produced by commit {c} whose Search.lean differs"); ok = False
            nodes += int(re.search(r"nodes=(\d+)", log).group(1))
            words |= {w.strip() for w in open(b + ".txt") if w.strip()}
        line = f"n={n} parts={M} missing={len(missing)} words={len(words)} nodes_sum_over_parts={nodes}"
        if missing: ok = False; line += f" MISSING {missing[:20]}"
        # cross-check 4/5
        cpp = glob.glob(os.path.join(EX, f"out/lean/parts/n{n}_cpp.part*_*.log"))
        if cpp:
            Ms = {int(re.search(r"_(\d+)\.log$", f).group(1)) for f in cpp}
            for Mc in Ms:
                fs = [os.path.join(EX, f"out/lean/parts/n{n}_cpp.part{r}_{Mc}") for r in range(Mc)]
                if all(os.path.exists(f + ".txt") and "seconds=" in open(f + ".log").read() for f in fs):
                    cw = {w.strip() for f in fs for w in open(f + ".txt") if w.strip()}
                    line += f" cpp(M={Mc}):{'SAME' if cw == words else 'DIFFERENT'}"
                    if cw != words: ok = False
                    if Mc == 1 and M == 1:
                        cn = int(re.search(r"nodes=(\d+)", open(fs[0] + ".log").read()).group(1))
                        line += f" nodes:{'SAME' if cn == nodes else 'DIFFERENT'}"
                else:
                    line += f" cpp(M={Mc}):incomplete"
        out.append(line); allwords += sorted(words)
    # 3: the verified colour check on every word
    wf = os.path.join(EX, "out/lean/all_words.txt")
    open(wf, "w").write("".join(w + "\n" for w in allwords))
    r = subprocess.run([os.path.join(EX, "lean/.lake/build/bin/certify"), wf], capture_output=True, text=True)
    out.append("certify (verified colorCheck): " + r.stdout.strip().splitlines()[-1])
    if r.returncode != 0: ok = False
    # 6: independent Python colouring count
    bad = 0
    for w in allwords:
        res = None
        for D in [(7, 13, 31), (-28, -45, 32), (1, -19, 40), (11, -37, 12), (5, 17, 23), (-3, 29, 19)]:
            res = colorings(w, D)
            if res is not None: break
        if res != 7: bad += 1
    out.append(f"python colourings: {len(allwords) - bad} of {len(allwords)} words have exactly 7 colourings")
    out.append("COMPCERT " + ("HOLDS" if ok and bad == 0 else "NOT ESTABLISHED"))
    open(os.path.join(EX, "out/lean/COMPCERT.txt"), "w").write("\n".join(out) + "\n")
    print("\n".join(out))

if __name__ == "__main__":
    main()
