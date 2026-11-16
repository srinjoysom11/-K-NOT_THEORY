#!/usr/bin/env bash
# Local validation of -stair (15 Nov): waits for the n = 30 cap-3 cross-check, stops the old queue,
# then runs n = 30 and n = 32 with -stair. The sorted union of the parts must be a subset of
# out/nN_prime.txt that contains every shortest polygon (same census counts).
cd "$(dirname "$0")"
until [ "$(ls out/n30_primec3.part*_8.log 2>/dev/null | wc -l)" -ge 8 ]; do sleep 20; done
pkill -f queue_c3.sh; sleep 3; pkill -f "run_parts.sh 32 32"; pkill -f "enum 32 -prime -tourcap 3"; sleep 1
rm -f out/n32_primec3.part*.tmp
export ENUM_BIN=./enum_s ENUM_OPTS="-stair -tourcap 3" TAG=stair
./run_parts.sh 30 8 $(seq 0 7)
./run_parts.sh 32 32 $(seq 0 31)
