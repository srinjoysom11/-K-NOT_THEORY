#!/usr/bin/env bash
# Run parts of one length, skipping parts already done.
#   usage: run_parts.sh N M R1 [R2 ...]      (runs ./enum N -part R M for each R, in order)
# Extra options for enum go in ENUM_OPTS, and TAG names the output (default psi), e.g.
#   ENUM_OPTS=-prime TAG=prime ./run_parts.sh 30 8 0 1 2 3 4 5 6 7
# ENUM_BIN names the program (default ./enum).
# Output: out/nN_TAG.partR_M.txt and .log; the .log is written only when the part has finished,
# so an interrupted part is simply rerun.  Merge with:  sort -u out/nN_psi.part*_M.txt
set -u
cd "$(dirname "$0")"
N=$1; M=$2; shift 2
mkdir -p out
for R in "$@"; do
  base=out/n${N}_${TAG:-psi}.part${R}_${M}
  [ -s "$base.log" ] && continue
  s=$(date +%s)
  ${ENUM_BIN:-./enum} "$N" ${ENUM_OPTS:-} -part "$R" "$M" -out "$base.txt.tmp" 2> "$base.log.tmp" || { echo "part $R failed" >&2; continue; }
  e=$(date +%s)
  echo "seconds=$((e-s)) host=$(hostname) threads=$(nproc) opts=${ENUM_OPTS:-}" >> "$base.log.tmp"
  mv "$base.txt.tmp" "$base.txt"; mv "$base.log.tmp" "$base.log"
done
