#!/bin/bash
# Slab-confined searches in parts, so that a killed run loses at most one part.
#   ./queue_slab_parts.sh "L:n:m L:n:m ..."      (m = number of parts)
# Parts go to out/slab/local/L<L>_n<n>.part<r>_<m>.{txt,log}; a part whose log has "seconds=" is
# skipped. When all m parts of a run exist, out/slab/L<L>_n<n>.{txt,log} are written (survivors
# sorted, node counts added), in the format of the Actions workflow slab-enum.yml.
cd "$(dirname "$0")"
g++ -O3 -march=native -std=c++17 -pthread -o slab slab.cpp || exit 1
src=$(sha256sum slab.cpp | cut -c1-16)
mkdir -p out/slab/local
for item in ${1:-1:38:4 2:32:4 1:40:8 1:42:24}; do
  IFS=: read L n m <<< "$item"
  grep -q "seconds=" out/slab/L${L}_n$n.log 2>/dev/null && continue
  for ((r = 0; r < m; r++)); do
    base=out/slab/local/L${L}_n$n.part${r}_$m
    grep -q "seconds=" $base.log 2>/dev/null && continue
    s=$(date +%s)
    ./slab $n -slab $L -stair -tourcap 3 -part $r $m -out $base.txt.tmp 2> $base.log.tmp || exit 1
    echo "seconds=$(( $(date +%s) - s )) threads=$(nproc) opts=-slab $L -stair -tourcap 3 -part $r $m slab.cpp=$src" >> $base.log.tmp
    mv $base.txt.tmp $base.txt; mv $base.log.tmp $base.log
  done
  python3 - $L $n $m <<'PY'
import re, sys
L, n, m = map(int, sys.argv[1:])
parts = [f"out/slab/local/L{L}_n{n}.part{k}_{m}" for k in range(m)]
logs = [open(p + ".log").read() for p in parts]
assert all("seconds=" in t for t in logs)
words = sorted({w.strip() for p in parts for w in open(p + ".txt") if w.strip()})
tot = lambda key: sum(int(x) for t in logs for x in re.findall(rf"\b{key}=(\d+)", t))
src = set(re.findall(r"slab.cpp=(\w+)", "".join(logs)))
open(f"out/slab/L{L}_n{n}.txt", "w").write("".join(w + "\n" for w in words))
open(f"out/slab/L{L}_n{n}.log", "w").write(
    f"slab={L} N={n} parts={m} nodes={tot('nodes')} survivors={len(words)} "
    f"bfs_limit_hits={tot('bfs_limit_hits')}\n"
    f"seconds={tot('seconds')} threads=4 opts=-slab {L} -stair -tourcap 3 (sum over {m} local parts, "
    f"out/slab/local/) slab.cpp={','.join(sorted(src))}\n")
PY
done
