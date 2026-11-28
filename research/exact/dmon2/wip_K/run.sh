#!/bin/bash
# usage: run.sh BIN N TAG extra-opts...   (common part of F / F0 without -stair -plane4 -tauz)
B=$1; N=$2; TAG=$3; shift 3
H=$((N/2))
COMMON="-alt 4 -aotc -aotm -tourcap 3 -face -aotp -crank -adapt 1 -tourcap 0 -mstonly -ax1d -hk 5 -hkw -cycleaf -tau 1 -tauax 1 -walk 8 $H -threads 1"
s=$(date +%s.%N)
./$B $N $COMMON "$@" -out out/${TAG}_n$N.txt 2> out/${TAG}_n$N.log
e=$(date +%s.%N)
echo "seconds=$(echo "$e - $s" | bc)" >> out/${TAG}_n$N.log
