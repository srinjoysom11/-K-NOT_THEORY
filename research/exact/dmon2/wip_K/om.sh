#!/bin/bash
cd "$(dirname "$0")"
until [ -f out/gap.done ]; do sleep 10; done
for n in 28 30 32; do ./run.sh enum_s3b $n oG2m0 -plane4 -tauz 1 -stairg 1 -onemax; ./run.sh enum_s3b $n oG1m0 -tauz 0 -stairg 1 -onemax; done
for M in 14 13 12; do ./run.sh enum_s3b 30 oG2m$M -plane4 -tauz 1 -stairg 1 -arcmin $M -onemax; done
for M in 15 14 13; do ./run.sh enum_s3b 32 oG2m$M -plane4 -tauz 1 -stairg 1 -arcmin $M -onemax; done
./run.sh enum_s3b 32 oG2m16 -plane4 -tauz 1 -stairg 1 -arcmin 16 -onemax
echo done > out/om.done
