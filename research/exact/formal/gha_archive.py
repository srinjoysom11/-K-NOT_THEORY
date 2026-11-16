#!/usr/bin/env python3
"""Archive the GitHub Actions evidence for the proof runs into out/lean/gha_runs/<run id>/.

What ties a committed part to a genuine execution of the frozen code is not the author name on the
commit (anyone can set git user.name), but GitHub's own record of the run: the job logs, which the
repository owner cannot edit (only delete), together with the run's head commit and workflow file.
GitHub keeps job logs for a limited time (90 days by default) and artifacts for 30 days, so this script
copies the record into the repository:

  run.json        id, workflow path, head commit, event, attempts, conclusion, times, URL
  jobs.json       every job of every attempt: id, attempt, name, conclusion, head commit, times
  artifacts.json  every artifact: id, name, size, sha256 digest (as GitHub reports it)
  logs/<job>.log.gz   the full log of every job, as served by the API (gzip -n, so it is reproducible)

verify_comp.py then accepts a GitHub part only if its committed .log is byte-identical to the block the
job printed (`cat lparts/*.log`) in an archived log of a lean-enum run whose head commit has the frozen
sources.  Usage: gha_archive.py [run id ...]; with no arguments, every run named in a commit message
"... GitHub Actions run N (collected by run M)" is archived (both N and M).
"""
import gzip, json, os, re, subprocess, sys, time
HERE = os.path.dirname(os.path.abspath(__file__))
EX = os.path.dirname(HERE)
REPO = os.path.dirname(os.path.dirname(EX))
SLUG = "srinjoysom11/-K-NOT_THEORY"

def api(path, raw=False):
    for t in range(6):
        r = subprocess.run(["gh", "api", path], capture_output=True)
        if r.returncode == 0:
            return r.stdout if raw else json.loads(r.stdout)
        if b"HTTP 404" in r.stderr or b"HTTP 410" in r.stderr:
            return None     # e.g. a job that never ran, or a log GitHub no longer has
        time.sleep(10 * (t + 1))
    raise RuntimeError(f"gh api {path}: {r.stderr.decode()[:200]}")

def runs_from_git():
    log = subprocess.run(["git", "-C", REPO, "log", "--format=%s"], capture_output=True, text=True).stdout
    ids = set()
    for m in re.finditer(r"GitHub Actions run (\d+)(?: \(collected by run (\d+)\))?", log):
        ids.update(x for x in m.groups() if x)
    return sorted(ids)

def archive(run):
    d = os.path.join(EX, "out/lean/gha_runs", str(run))
    meta = api(f"repos/{SLUG}/actions/runs/{run}")
    if meta["path"] not in (".github/workflows/lean-enum.yml", ".github/workflows/lean-collect.yml",
                            ".github/workflows/lean-proof.yml"):
        print(f"run {run}: {meta['path']} is not a proof workflow; skipped"); return
    os.makedirs(os.path.join(d, "logs"), exist_ok=True)
    keep = {k: meta.get(k) for k in ("id", "name", "path", "head_branch", "head_sha", "event", "status",
                                     "conclusion", "run_attempt", "created_at", "run_started_at",
                                     "updated_at", "html_url")}
    jobs = []
    for att in range(1, (meta.get("run_attempt") or 1) + 1):
        page = 1
        while True:
            js = api(f"repos/{SLUG}/actions/runs/{run}/attempts/{att}/jobs?per_page=30&page={page}")["jobs"]
            jobs += [{"attempt": att, **{k: j.get(k) for k in ("id", "name", "status", "conclusion", "head_sha",
                                                                "started_at", "completed_at")}} for j in js]
            if len(js) < 30: break
            page += 1
    arts = []; page = 1
    while True:
        a = api(f"repos/{SLUG}/actions/runs/{run}/artifacts?per_page=100&page={page}")["artifacts"]
        arts += [{k: x.get(k) for k in ("id", "name", "size_in_bytes", "digest", "expired", "created_at")} for x in a]
        if len(a) < 100: break
        page += 1
    got = 0
    for j in jobs:
        f = os.path.join(d, "logs", f"{j['id']}.log.gz")
        if os.path.exists(f) or j["status"] != "completed": continue
        raw = api(f"repos/{SLUG}/actions/jobs/{j['id']}/logs", raw=True)
        if raw is None:
            print(f"  job {j['id']} ({j['name']}, {j['conclusion']}): no log available"); continue
        with open(f, "wb") as fo:
            fo.write(gzip.compress(raw, mtime=0))
        got += 1
    json.dump(keep, open(os.path.join(d, "run.json"), "w"), indent=1)
    json.dump(sorted(jobs, key=lambda j: (j["attempt"], j["id"])), open(os.path.join(d, "jobs.json"), "w"), indent=1)
    json.dump(sorted(arts, key=lambda a: a["id"]), open(os.path.join(d, "artifacts.json"), "w"), indent=1)
    print(f"run {run}: {keep['path']} at {keep['head_sha'][:8]}, {len(jobs)} jobs ({got} new logs), {len(arts)} artifacts")

if __name__ == "__main__":
    for run in (sys.argv[1:] or runs_from_git()):
        archive(run)
