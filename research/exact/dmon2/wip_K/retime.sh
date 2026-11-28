#!/bin/bash
cd "$(dirname "$0")"
for n in 28 30 32; do
  ./run.sh enum_v $n tF0 -tauz 0
  ./run.sh enum_v $n tF -stair -plane4 -tauz 1
  ./run.sh enum_s3 $n tG1 -tauz 0 -stairg 1 -arcmin 16
  ./run.sh enum_s3 $n tG2 -plane4 -tauz 1 -stairg 1 -arcmin 16
  ./run.sh enum_s3 $n tG2k0 -plane4 -tauz 1 -stairg 0 -arcmin 16
done
echo done > out/retime.done
