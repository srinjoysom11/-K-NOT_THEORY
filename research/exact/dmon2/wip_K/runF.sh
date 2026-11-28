#!/bin/bash
# usage: runF.sh BIN N TAG extra...
B=$1; N=$2; TAG=$3; shift 3
H=$((N/2))
COMMON="-alt 4 -aotc -aotm -tourcap 3 -face -aotp -crank -adapt 1 -tourcap 0 -mstonly -ax1d -hk 5 -hkw -cycleaf -tau 1 -tauax 1 -walk 8 $H -threads 1"
case $TAG in
 F)  OPTS="-stair -plane4 -tauz 1";;
 F0) OPTS="-tauz 0";;
 *)  OPTS="";;
esac
s=$(date +%s.%N)
./$B $N $COMMON $OPTS "$@" -out out/${TAG}_n$N.txt 2> out/${TAG}_n$N.log
e=$(date +%s.%N)
echo "seconds=$(echo "$e - $s" | bc)" >> out/${TAG}_n$N.log
