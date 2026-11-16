#!/usr/bin/env python3
"""Reproduction of GitHub Actions proof parts (review round 2, R2-3).

For a random sample of accepted GitHub parts (engine check), re-run `checkpart n r` locally (built from the
current, committed sources) and compare the SHA-256 of the output with the logged one; checkpart's output is
deterministic.  Also archives, for every GitHub Actions run named by a collect commit, the run and job
metadata from the GitHub API (run id, head commit, job names, conclusions, timestamps) to
out/lean/gha_runs/<run>.json.  Appends results to out/lean/REPRO.txt.
usage: formal/repro.py SAMPLE_SIZE [SEED]"""
import glob, hashlib, json, os, random, re, subprocess, sys
HERE = os.path.dirname(os.path.abspath(__file__)); EX = os.path.dirname(HERE); REPO = os.path.dirname(os.path.dirname(EX))
BIN = os.path.join(EX, "lean/.lake/build/bin/checkpart")

def main():
    k = int(sys.argv[1]); seed = int(sys.argv[2]) if len(sys.argv) > 2 else 2026
    import shutil
    if shutil.which("lake"):
        subprocess.run(["lake", "build", "checkpart"], cwd=os.path.join(EX, "lean"), check=True, capture_output=True)
    else:  # no toolchain in this container: use the existing build of the (unchanged, hash-checked) sources
        print("lake not found: using the existing build", BIN, flush=True)
    gh = []
    for f in glob.glob(os.path.join(EX, "out/lean/parts/n*_check.part*_*.log")):
        log = open(f).read()
        if "host=github-actions" in log and "status=0" in log:
            g = re.search(r"n(\d+)_check\.part(\d+)_(\d+)\.log$", f)
            gh.append((int(g.group(1)), int(g.group(2)), int(g.group(3)), f, re.search(r"txtsha=(\w+)", log).group(1)))
    random.seed(seed); sample = random.sample(sorted(gh), min(k, len(gh)))
    def rerun(item):
        n, r, M, f, sha = item
        out = subprocess.run([BIN, str(n), str(r)], capture_output=True).stdout
        mine = hashlib.sha256(out).hexdigest()
        line = f"n={n} r={r} m={M} logged={sha[:16]} rerun={mine[:16]} {'IDENTICAL' if mine == sha else 'DIFFERENT'}"
        print(line, flush=True)
        return line
    from concurrent.futures import ThreadPoolExecutor
    with ThreadPoolExecutor(max_workers=os.cpu_count() or 1) as ex:
        lines = list(ex.map(rerun, sample))
    # archive run metadata
    os.makedirs(os.path.join(EX, "out/lean/gha_runs"), exist_ok=True)
    r = subprocess.run(["git", "-C", REPO, "log", "--format=%s", "--author=github-actions"], capture_output=True, text=True)
    for run in sorted(set(re.findall(r"run (\d+)", r.stdout))):
        jobs = []; page = 1
        while True:
            j = json.loads(subprocess.run(["gh", "api", f"repos/srinjoysom11/-K-NOT_THEORY/actions/runs/{run}/jobs?per_page=100&page={page}"],
                                          capture_output=True, text=True).stdout or "{}")
            js = j.get("jobs", [])
            jobs += [{k2: x.get(k2) for k2 in ("id", "name", "status", "conclusion", "started_at", "completed_at", "head_sha")} for x in js]
            if len(js) < 100: break
            page += 1
        meta = json.loads(subprocess.run(["gh", "api", f"repos/srinjoysom11/-K-NOT_THEORY/actions/runs/{run}"],
                                         capture_output=True, text=True).stdout or "{}")
        keep = {k2: meta.get(k2) for k2 in ("id", "name", "head_sha", "event", "status", "conclusion", "created_at", "updated_at", "html_url")}
        json.dump({"run": keep, "jobs": jobs}, open(os.path.join(EX, f"out/lean/gha_runs/{run}.json"), "w"), indent=1)
    with open(os.path.join(EX, "out/lean/REPRO.txt"), "a") as fo:
        fo.write(f"# sample of {len(sample)} GitHub parts (seed {seed}), re-run with checkpart built from {subprocess.run(['git','-C',REPO,'rev-parse','HEAD'],capture_output=True,text=True).stdout.strip()}\n")
        fo.write("\n".join(lines) + "\n")

if __name__ == "__main__":
    main()
