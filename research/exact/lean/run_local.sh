#!/usr/bin/env bash
# Local runs of the verified search (and the C++ cross-check), same file layout as lean-enum.yml.
# usage: lean/run_local.sh ENGINE N M R1 R2 ...      (ENGINE = lean | cpp)
cd "$(dirname "$0")/.."
eng=$1 n=$2 m=$3; shift 3
mkdir -p out/lean/parts
for r in "$@"; do
  base=out/lean/parts/n${n}_${eng}.part${r}_${m}
  [ -f $base.log ] && grep -q seconds= $base.log && continue
  s=$(date +%s)
  if [ $eng = lean ]; then ./lean/.lake/build/bin/search $n 9 $m $r > $base.txt.tmp 2> $base.log.tmp
  else ./enum $n -tourcap 0 -nomst -noreduce -threads 1 -part $r $m -out $base.txt.tmp 2> $base.log.tmp; fi
  e=$(date +%s)
  echo "seconds=$((e-s)) host=$(hostname) engine=$eng commit=$(git rev-parse HEAD)" >> $base.log.tmp
  mv $base.txt.tmp $base.txt; mv $base.log.tmp $base.log
done
