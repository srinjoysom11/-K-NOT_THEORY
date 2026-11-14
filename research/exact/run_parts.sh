#!/usr/bin/env bash
# Run parts of one length, skipping parts already done.
#   usage: run_parts.sh N M R1 [R2 ...]      (runs ./enum N -part R M for each R, in order)
# Output: out/nN_psi.partR_M.txt and .log; the .log is written only when the part has finished,
# so an interrupted part is simply rerun.  Merge with:  sort -u out/nN_psi.part*_M.txt
set -u
cd "$(dirname "$0")"
N=$1; M=$2; shift 2
mkdir -p out
for R in "$@"; do
  base=out/n${N}_psi.part${R}_${M}
  [ -s "$base.log" ] && continue
  s=$(date +%s)
  ./enum "$N" -part "$R" "$M" -out "$base.txt.tmp" 2> "$base.log.tmp" || { echo "part $R failed" >&2; continue; }
  e=$(date +%s)
  echo "seconds=$((e-s)) host=$(hostname) threads=$(nproc)" >> "$base.log.tmp"
  mv "$base.txt.tmp" "$base.txt"; mv "$base.log.tmp" "$base.log"
done
