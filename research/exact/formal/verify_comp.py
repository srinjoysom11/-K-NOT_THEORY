#!/usr/bin/env python3
"""Establish CompCert (lean/Len52/Cert.lean) from the logs of the proof runs, and run the cross-checks.

CompCert holds iff checkPart n r = true for every n in `lengths` and r < parts(n) (compCert_of_checks).
A proof run is one execution of `checkpart n r` (CheckMain.lean), which evaluates exactly that Boolean.
For every (n, r) this script requires a log out/lean/parts/n{n}_check.part{r}_{M}.log and output .txt with
  * status=0 (exit status of checkpart, which is 0 iff the Boolean is true),
  * the last line of the output  "RESULT n=n r=r m=M nodes=X words=K ok=true",
  * exactly K word lines before it, and sha256 of the output equal to the logged txtsha,
  * a logged commit at which every source file of the executable is byte-identical to the current one
    (SOURCES below; `lake build checkpart` reads nothing else from the project).
Cross-checks (not part of the proof):
  (a) the union of the words equals the union produced by the C++ program in cross-check mode, and by the
      earlier `search` runs, where those are complete; for unsplit runs the node counts are equal;
  (b) an independent Python colouring count (formal/projections.py) gives exactly 7 colourings;
  (c) an independent Python implementation of Survive (formal/crosscheck/survive.py, written by the
      referee from Spec.lean alone) accepts every output word.
Writes out/lean/COMPCERT.txt."""
import glob, hashlib, os, re, subprocess, sys
HERE = os.path.dirname(os.path.abspath(__file__))
EX = os.path.dirname(HERE)
REPO = os.path.dirname(os.path.dirname(EX))
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(HERE, "crosscheck"))
from projections import colorings
import survive as SV

LENGTHS = [4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34]
def parts(n): return {34: 1024, 32: 256, 30: 64, 28: 2}.get(n, 1)      # = Len52.parts
SOURCES = ["research/exact/lean/Len52/Spec.lean", "research/exact/lean/Len52/Diagram.lean",
           "research/exact/lean/Len52/Search.lean", "research/exact/lean/Len52/Coloring.lean",
           "research/exact/lean/Len52/Cert.lean", "research/exact/lean/CheckMain.lean",
           "research/exact/lean/lakefile.toml", "research/exact/lean/lean-toolchain"]
DIRS = [(7, 13, 31), (-28, -45, 32), (1, -19, 40), (11, -37, 12), (5, 17, 23), (-3, 29, 19)]

def src_hash(paths):
    """the source hash written by lean/run_local.sh: sha256 over the lines (path, sha256(content))"""
    h = "".join(f"{p}\n{hashlib.sha256(open(os.path.join(REPO, p), 'rb').read()).hexdigest()}\n" for p in paths)
    return hashlib.sha256(h.encode()).hexdigest()

def bot_commit(relpath):
    """for a file committed by the GitHub Actions collect job: (author, run id) of the commit that added it"""
    r = subprocess.run(["git", "-C", REPO, "log", "--diff-filter=A", "--format=%an|%s", "--", relpath],
                       capture_output=True, text=True)
    lines = [l for l in r.stdout.splitlines() if l]
    if not lines: return None
    a, msg = lines[-1].split("|", 1)
    m = re.search(r"GitHub Actions run (\d+)", msg)
    return a, (m.group(1) if m else None)

def git_show(commit, path):
    r = subprocess.run(["git", "-C", REPO, "show", f"{commit}:{path}"], capture_output=True)
    return r.stdout if r.returncode == 0 else None

def main():
    cur = {p: open(os.path.join(REPO, p), "rb").read() for p in SOURCES}
    cur_src = src_hash(SOURCES)
    runs = set()
    commit_ok = {}
    def same_sources(c):
        if c not in commit_ok:
            commit_ok[c] = all(git_show(c, p) == cur[p] for p in SOURCES)
        return commit_ok[c]
    out = []; ok = True; allwords = []
    for n in LENGTHS:
        M = parts(n); words = set(); bad = []; nodes1 = None
        for r in range(M):
            b = os.path.join(EX, f"out/lean/parts/n{n}_check.part{r}_{M}")
            try:
                log = open(b + ".log").read(); raw = open(b + ".txt", "rb").read()
            except FileNotFoundError:
                bad.append((r, "missing")); continue
            lines = raw.decode().splitlines()
            m = re.search(r"status=(\d+) binsha=(\w+) txtsha=(\w+)", log)
            c = re.search(r"seconds=\d+ .*commit=(\w+)", log)
            res = re.fullmatch(r"RESULT n=(\d+) r=(\d+) m=(\d+) nodes=(\d+) words=(\d+) ok=(\w+)",
                               lines[-1] if lines else "")
            why = None
            if not m or not c: why = "log incomplete"
            elif m.group(1) != "0": why = f"status {m.group(1)}"
            elif m.group(3) != hashlib.sha256(raw).hexdigest(): why = "output sha mismatch"
            elif not res: why = "no RESULT line"
            elif (int(res.group(1)), int(res.group(2)), int(res.group(3))) != (n, r, M): why = "RESULT for another part"
            elif res.group(6) != "true": why = "ok=false"
            elif int(res.group(5)) != len(lines) - 1: why = "word count mismatch"
            elif "host=github-actions" in log:
                # built from a clean checkout of the logged commit; the part must have been committed by the
                # collect job of a GitHub Actions run (R2-3)
                bc = bot_commit(os.path.relpath(b + ".log", REPO))
                if not same_sources(c.group(1)): why = f"commit {c.group(1)[:8]} has different sources"
                elif not bc or bc[0] != "github-actions[bot]" or not bc[1]: why = "not committed by a GitHub Actions run"
                else: runs.add(bc[1])
            else:
                sm = re.search(r"src=(\w+)", log)
                if not sm or sm.group(1) != cur_src: why = "local run: source hash missing or different"
            if why: bad.append((r, why)); continue
            words |= set(lines[:-1])
            if M == 1: nodes1 = int(res.group(4))
        line = f"n={n} parts={M} accepted={M - len(bad)} words={len(words)}"
        if nodes1 is not None: line += f" nodes={nodes1}"
        if bad:
            ok = False
            line += " REJECTED " + "; ".join(f"{r}:{why}" for r, why in bad[:8]) + (" ..." if len(bad) > 8 else "")
        # cross-check (a)
        for eng in ("cpp", "lean"):
            Ms = {int(re.search(r"_(\d+)\.log$", f).group(1))
                  for f in glob.glob(os.path.join(EX, f"out/lean/parts/n{n}_{eng}.part*_*.log"))}
            for Mc in sorted(Ms):
                fs = [os.path.join(EX, f"out/lean/parts/n{n}_{eng}.part{r}_{Mc}") for r in range(Mc)]
                if all(os.path.exists(f + ".txt") and os.path.exists(f + ".log")
                       and "seconds=" in open(f + ".log").read() for f in fs):
                    cw = {w.strip() for f in fs for w in open(f + ".txt") if w.strip()}
                    line += f" | {eng}(M={Mc}): words {'SAME' if cw == words else 'DIFFERENT'}"
                    if Mc == 1 and nodes1 is not None:
                        cn = int(re.search(r"nodes=(\d+)", open(fs[0] + ".log").read()).group(1))
                        line += f", nodes {'SAME' if cn == nodes1 else 'DIFFERENT'}"
                else:
                    done = sum(1 for f in fs if os.path.exists(f + ".log") and "seconds=" in open(f + ".log").read())
                    line += f" | {eng}(M={Mc}): {done}/{Mc} parts"
        out.append(line); allwords += sorted(words)
    out.append(f"GitHub Actions runs that produced accepted parts: {' '.join(sorted(runs)) or 'none'}")
    out.append(f"COMPCERT (all checkPart n r = true, by the logs above): {'HOLDS' if ok else 'NOT ESTABLISHED'}")
    # cross-checks (b), (c)
    LET = {c: i for i, c in enumerate("ewnsud")}
    nb = sum(1 for w in allwords if next((x for D in DIRS if (x := colorings(w, D)) is not None), None) != 7)
    ns = sum(1 for w in allwords if not SV.survive([LET[c] for c in w]))
    out.append(f"cross-check (b) python colourings: {len(allwords) - nb} of {len(allwords)} words have exactly 7")
    out.append(f"cross-check (c) independent Survive checker: {len(allwords) - ns} of {len(allwords)} words accepted")
    open(os.path.join(EX, "out/lean/all_words.txt"), "w").write("".join(w + "\n" for w in allwords))
    open(os.path.join(EX, "out/lean/COMPCERT.txt"), "w").write("\n".join(out) + "\n")
    print("\n".join(out))

if __name__ == "__main__":
    main()
