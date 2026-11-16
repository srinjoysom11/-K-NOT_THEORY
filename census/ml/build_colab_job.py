"""Build ml/colab_job.py: ONE self-contained script for `colab run`.

    python ml/build_colab_job.py [--states 60000]

`colab run` ships a single script to a fresh VM, so the model code and a
dataset sample are embedded (gzip+base64).  The job prints results to stdout and
the trained weights as a base64 block; decode them with ml/extract_model.py.
"""
import sys, base64, gzip, argparse, os
HERE = os.path.dirname(os.path.abspath(__file__))
ap = argparse.ArgumentParser(); ap.add_argument("--states", type=int, default=60000)
ap.add_argument("--test_starts", type=int, default=120); a = ap.parse_args()

def b64(data: bytes) -> str:
    return base64.b64encode(gzip.compress(data, 9)).decode()

files = {f: b64(open(os.path.join(HERE, f), "rb").read()) for f in ("model.py", "train_il.py", "guided_search.py", "rl_finetune.py")}
# keep whole starts (so the held-out-start validation split stays meaningful)
lines, last, out = open(os.path.join(HERE, "expert_train.txt")).read().splitlines(), None, []
for l in lines:
    out.append(l)
    if len(out) >= a.states and l.split()[0] != last: break
    last = l.split()[0]
data = b64(("\n".join(out) + "\n").encode())
test = b64(("\n".join(open(os.path.join(HERE, "starts_test.txt")).read().splitlines()[:a.test_starts]) + "\n").encode())

job = '''#!/usr/bin/env -S colab run --gpu T4
"""Knot-diagram value-net job: imitation learning (GPU) + guided-search evaluation (CPU).

    colab run --gpu T4 ml/colab_job.py -- --epochs 20 | tee ml/colab_run.log
    python ml/extract_model.py ml/colab_run.log ml/value_net_colab.pt

args: --epochs N (20)  --hidden H (96)  --rl (also run RL fine-tuning)  --eval_starts K (60)  --budget E (200)
"""
import sys, os, base64, gzip, subprocess, time, argparse
ap = argparse.ArgumentParser()
ap.add_argument("--epochs", type=int, default=20); ap.add_argument("--hidden", type=int, default=96)
ap.add_argument("--rl", action="store_true"); ap.add_argument("--eval_starts", type=int, default=60)
ap.add_argument("--budget", type=int, default=200)
args = ap.parse_args()
ROOT = os.environ.get("JOB_ROOT", "/content/ml"); os.makedirs(ROOT, exist_ok=True)
FILES = %(files)r
DATA = %(data)r
TEST = %(test)r
def dec(s): return gzip.decompress(base64.b64decode(s))
def sh(cmd):
    print("$", " ".join(cmd), flush=True); subprocess.run(cmd, check=True)

t0 = time.time()
sh([sys.executable, "-m", "pip", "-q", "install", "regina", "scipy", "numpy"])
for name, blob in FILES.items(): open(os.path.join(ROOT, name), "wb").write(dec(blob))
open(os.path.join(ROOT, "expert_train.txt"), "wb").write(dec(DATA))
open(os.path.join(ROOT, "starts_test.txt"), "wb").write(dec(TEST))
import torch
dev = "cuda" if torch.cuda.is_available() else "cpu"
print("device:", dev, torch.cuda.get_device_name(0) if dev == "cuda" else "", "| cpus:", os.cpu_count(), flush=True)

sh([sys.executable, os.path.join(ROOT, "train_il.py"), os.path.join(ROOT, "expert_train.txt"), os.path.join(ROOT, "value_net.pt"),
    "--epochs", str(args.epochs), "--device", dev, "--hidden", str(args.hidden)])
ckpt = os.path.join(ROOT, "value_net.pt")
if args.rl:
    sh([sys.executable, os.path.join(ROOT, "rl_finetune.py"), ckpt, os.path.join(ROOT, "expert_train.txt"), os.path.join(ROOT, "value_net_rl.pt"), "--device", "cpu"])
    ckpt = os.path.join(ROOT, "value_net_rl.pt")
# held-out evaluation: hard level-12 starts the net never saw (CPU: Regina search)
sh([sys.executable, os.path.join(ROOT, "guided_search.py"), ckpt, os.path.join(ROOT, "starts_test.txt"),
    "--starts", str(args.eval_starts), "--budget", str(args.budget), "--procs", str(max(1, os.cpu_count() or 1))])
print("MODEL_BEGIN"); print(base64.b64encode(open(ckpt, "rb").read()).decode()); print("MODEL_END")
print("total %%.0fs" %% (time.time() - t0))
''' % dict(files=files, data=data, test=test)
open(os.path.join(HERE, "colab_job.py"), "w").write(job)
os.chmod(os.path.join(HERE, "colab_job.py"), 0o755)
print("wrote ml/colab_job.py: %.1f MB, %d states, %d test starts" % (len(job) / 1e6, len(out), a.test_starts))
