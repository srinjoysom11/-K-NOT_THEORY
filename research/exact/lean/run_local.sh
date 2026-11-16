#!/usr/bin/env bash
# Local runs, same file layout and log format as lean-enum.yml.
# usage: lean/run_local.sh ENGINE N M R1 R2 ...      (ENGINE = check | lean | cpp; for check, M = Len52.parts N)
# Provenance (review round 2, R2-2): the source hash `src` of the executable is computed BEFORE the build,
# the sources must be committed and unchanged (git status clean) before the build and after every part, and
# `src` is written to every log; verify_comp.py accepts a local part only if `src` equals the hash of the
# current sources.
cd "$(dirname "$0")/.."
eng=$1 n=$2 m=$3; shift 3
SRC="lean/Len52/Spec.lean lean/Len52/Diagram.lean lean/Len52/Search.lean lean/Len52/Coloring.lean lean/Len52/Cert.lean lean/CheckMain.lean lean/lakefile.toml lean/lean-toolchain"
[ $eng = cpp ] && SRC="enum.cpp"
srchash() { for f in $SRC; do printf '%s\n%s\n' "research/exact/$f" "$(sha256sum $f | cut -c1-64)"; done | sha256sum | cut -c1-64; }
clean() { [ -z "$(git status --porcelain -- $SRC)" ]; }
clean || { echo "uncommitted changes in the sources of the executable; refusing to run" >&2; exit 1; }
src=$(srchash); commit=$(git rev-parse HEAD)
export PATH=/opt/lean/lean-4.25.0-linux/bin:$PATH
if [ $eng = cpp ]; then g++ -O3 -march=native -std=c++17 -pthread -o enum enum.cpp || exit 1; bin=./enum
else ( cd lean && lake build search checkpart > /dev/null ) || exit 1
     bin=./lean/.lake/build/bin/$([ $eng = check ] && echo checkpart || echo search); fi
binsha=$(sha256sum $bin | cut -c1-64)
mkdir -p out/lean/parts
for r in "$@"; do
  if [ $eng = check ]; then case $n in 34) M=1024;; 32) M=256;; 30) M=64;; 28) M=2;; *) M=1;; esac; else M=$m; fi
  base=out/lean/parts/n${n}_${eng}.part${r}_${M}
  [ -f $base.log ] && grep -q seconds= $base.log && continue
  s=$(date +%s)
  case $eng in
    check) $bin $n $r > $base.txt.tmp 2> $base.log.tmp; st=$? ;;
    lean)  $bin $n 9 $m $r > $base.txt.tmp 2> $base.log.tmp; st=$? ;;
    cpp)   $bin $n -tourcap 0 -nomst -noreduce -threads 1 -part $r $m -out $base.txt.tmp 2> $base.log.tmp; st=$? ;;
  esac
  e=$(date +%s)
  { clean && [ "$(srchash)" = "$src" ] && [ "$(sha256sum $bin | cut -c1-64)" = "$binsha" ]; } || { echo "sources or binary changed during the run" >&2; rm -f $base.*.tmp; exit 1; }
  echo "status=$st binsha=$binsha txtsha=$(sha256sum $base.txt.tmp | cut -c1-64)" >> $base.log.tmp
  echo "src=$src built_at=$commit" >> $base.log.tmp
  echo "seconds=$((e-s)) host=$(hostname) engine=$eng commit=$commit" >> $base.log.tmp
  mv $base.txt.tmp $base.txt; mv $base.log.tmp $base.log
done
