#!/bin/bash
cd "$(dirname "$0")"
for M in 14 13 12; do ./run.sh enum_s3 30 gG2m$M -plane4 -tauz 1 -stairg 1 -arcmin $M; done
for M in 15 14 13; do ./run.sh enum_s3 32 gG2m$M -plane4 -tauz 1 -stairg 1 -arcmin $M; done
echo done > out/gap.done
