#!/usr/bin/env bash
# Local runs, same file layout and log format as lean-enum.yml.
# usage: lean/run_local.sh ENGINE N M R1 R2 ...      (ENGINE = check | lean | cpp; M is ignored for check)
# Refuses to run if the sources of the executable differ from the committed ones, and rebuilds first.
cd "$(dirname "$0")/.."
eng=$1 n=$2 m=$3; shift 3
if [ -n "$(git status --porcelain -- lean/Len52/Spec.lean lean/Len52/Diagram.lean lean/Len52/Search.lean lean/Len52/Coloring.lean lean/Len52/Cert.lean lean/CheckMain.lean lean/SearchMain.lean lean/lakefile.toml lean/lean-toolchain enum.cpp)" ]; then
  echo "uncommitted changes in the sources of the executables; refusing to run" >&2; exit 1; fi
export PATH=/opt/lean/lean-4.25.0-linux/bin:$PATH
( cd lean && lake build search checkpart > /dev/null ) || exit 1
[ $eng = cpp ] && { g++ -O3 -march=native -std=c++17 -pthread -o enum enum.cpp || exit 1; }
mkdir -p out/lean/parts
for r in "$@"; do
  if [ $eng = check ]; then case $n in 34) M=1024;; 32) M=256;; 30) M=64;; 28) M=2;; *) M=1;; esac; else M=$m; fi   # = Len52.parts
  base=out/lean/parts/n${n}_${eng}.part${r}_${M}
  [ -f $base.log ] && grep -q seconds= $base.log && continue
  s=$(date +%s)
  case $eng in
    check) ./lean/.lake/build/bin/checkpart $n $r > $base.txt.tmp 2> $base.log.tmp; st=$?; bin=./lean/.lake/build/bin/checkpart ;;
    lean)  ./lean/.lake/build/bin/search $n 9 $m $r > $base.txt.tmp 2> $base.log.tmp; st=$?; bin=./lean/.lake/build/bin/search ;;
    cpp)   ./enum $n -tourcap 0 -nomst -noreduce -threads 1 -part $r $m -out $base.txt.tmp 2> $base.log.tmp; st=$?; bin=./enum ;;
  esac
  e=$(date +%s)
  echo "status=$st binsha=$(sha256sum $bin | cut -c1-64) txtsha=$(sha256sum $base.txt.tmp | cut -c1-64)" >> $base.log.tmp
  echo "seconds=$((e-s)) host=$(hostname) engine=$eng commit=$(git rev-parse HEAD)" >> $base.log.tmp
  mv $base.txt.tmp $base.txt; mv $base.log.tmp $base.log
done
