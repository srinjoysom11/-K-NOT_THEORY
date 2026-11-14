"""Decode the weights block printed by colab_job.py:  python ml/extract_model.py run.log out.pt"""
import sys, base64
t = open(sys.argv[1]).read()
b = t.split("MODEL_BEGIN", 1)[1].split("MODEL_END", 1)[0].strip()
open(sys.argv[2], "wb").write(base64.b64decode(b)); print("wrote", sys.argv[2])
