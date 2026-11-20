#!/bin/bash
# usage: run_dmon_bench.sh BIN TAG N "flags"   -> out/dmon/N_TAG.{txt,log}; prints nodes, seconds, survivors
BIN=$1; TAG=$2; N=$3; FL=$4
D=$(dirname "$0")/out/dmon; mkdir -p "$D"
s=$(date +%s.%N)
$BIN $N $FL -out "$D/n${N}_${TAG}.txt" 2> "$D/n${N}_${TAG}.log"
e=$(date +%s.%N)
printf "t=%.1f\n" "$(echo "$e-$s" | bc)" >> "$D/n${N}_${TAG}.log"
echo "n=$N $TAG [$FL]: $(tr '\n' ' ' < "$D/n${N}_${TAG}.log")"
