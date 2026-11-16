#!/usr/bin/env bash
# Train / evaluate the imitation-learning value net on a Colab GPU with google-colab-cli.
#
# One-time setup on YOUR machine (needs a browser; the sandbox cannot do this):
#   pip install google-colab-cli                       # python >= 3.13, Linux/macOS
#   gcloud auth application-default login --scopes=openid,https://www.googleapis.com/auth/cloud-platform,https://www.googleapis.com/auth/userinfo.email,https://www.googleapis.com/auth/colaboratory
#   colab whoami                                       # should print your email and the colaboratory scope
#
# Then, from the repo root:
#   bash ml/colab_run.sh train T4      # imitation learning on a T4
#   bash ml/colab_run.sh rl A100       # RL fine-tuning
# Fallback if the GPU is not available on your account: use CPU by passing "cpu".
set -euo pipefail
MODE="${1:-train}"; GPU="${2:-T4}"; S="knot-${MODE}"
GPUFLAG=(); DEVICE=cuda
if [ "$GPU" != "cpu" ]; then GPUFLAG=(--gpu "$GPU"); else DEVICE=cpu; fi

colab new -s "$S" "${GPUFLAG[@]}"
trap 'colab stop -s "$S" || true' EXIT            # always release the VM (compute units!)

echo '!pip -q install regina scipy numpy' | colab exec -s "$S"
echo '!mkdir -p /content/ml' | colab exec -s "$S"
for f in model.py train_il.py guided_search.py rl_finetune.py; do colab upload -s "$S" "ml/$f" "/content/ml/$f"; done
colab upload -s "$S" ml/expert_train.txt /content/ml/expert_train.txt
colab upload -s "$S" ml/starts_test.txt  /content/ml/starts_test.txt

case "$MODE" in
  train)
    colab exec -s "$S" --env DEVICE="$DEVICE" -f /dev/stdin <<'PY'
import os, subprocess
subprocess.run(["python", "/content/ml/train_il.py", "/content/ml/expert_train.txt", "/content/ml/value_net.pt",
                "--epochs", "20", "--device", os.environ["DEVICE"], "--hidden", "96"], check=True)
PY
    colab download -s "$S" /content/ml/value_net.pt ml/value_net_colab.pt ;;
  rl)
    colab upload -s "$S" ml/value_net.pt /content/ml/value_net.pt
    colab exec -s "$S" -f /dev/stdin <<'PY'
import subprocess
subprocess.run(["python", "/content/ml/rl_finetune.py", "/content/ml/value_net.pt", "/content/ml/expert_train.txt",
                "/content/ml/value_net_rl.pt"], check=True)
PY
    colab download -s "$S" /content/ml/value_net_rl.pt ml/value_net_rl.pt ;;
esac
echo "done; VM released"
