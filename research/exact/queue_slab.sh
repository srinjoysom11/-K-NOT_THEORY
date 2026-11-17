#!/bin/bash
# Slab-confined searches, one after another: lines "L n" on stdin or the default list below.
# Output out/slab/L<L>_n<n>.txt (survivors) and .log (statistics, seconds, source hash).
# A finished run (log has a "seconds=" line) is skipped, so the script can be restarted.
cd "$(dirname "$0")"
g++ -O3 -march=native -std=c++17 -pthread -o slab slab.cpp || exit 1
src=$(sha256sum slab.cpp | cut -c1-16)
list="${1:-1:22 1:24 1:26 1:28 1:30 1:32 1:34 1:36 2:22 2:24 2:26 2:28 2:30 1:38 2:32 1:40 2:34 1:42}"
for item in $list; do
  L=${item%%:*}; n=${item##*:}; base=out/slab/L${L}_n$n
  grep -q "seconds=" $base.log 2>/dev/null && continue
  s=$(date +%s)
  ./slab $n -slab $L -stair -tourcap 3 -out $base.txt.tmp 2> $base.log.tmp || exit 1
  echo "seconds=$(( $(date +%s) - s )) threads=$(nproc) opts=-slab $L -stair -tourcap 3 slab.cpp=$src" >> $base.log.tmp
  mv $base.txt.tmp $base.txt; mv $base.log.tmp $base.log
done
