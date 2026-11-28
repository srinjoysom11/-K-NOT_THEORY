#!/bin/bash
# usage: F.sh BIN N [extra flags...]   ; F flags with -walk 8 N/2
B=$1; N=$2; shift 2
exec $B $N -alt 4 -stair -aotc -aotm -tourcap 3 -face -plane4 -aotp -crank -adapt 1 -tourcap 0 -mstonly -ax1d -hk 5 -hkw -cycleaf -tau 1 -tauz 1 -tauax 1 -walk 8 $((N/2)) -threads 1 "$@"
