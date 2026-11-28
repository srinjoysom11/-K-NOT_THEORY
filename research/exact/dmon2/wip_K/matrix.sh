#!/bin/bash
cd "$(dirname "$0")"
for n in 24 26 28 30 32; do
  for M in 0 8 11 16; do
    ./run.sh enum_s3 $n G1m$M -tauz 0 -stairg 9 -arcmin $M -dumpcand out/cand_G1m${M}_n$n.txt
    ./run.sh enum_s3 $n G2m$M -plane4 -tauz 1 -stairg 9 -arcmin $M -dumpcand out/cand_G2m${M}_n$n.txt
  done
  ./run.sh enum_s3 $n G2k0m16 -plane4 -tauz 1 -stairg 0 -arcmin 16
  ./run.sh enum_s3 $n G2k1m16 -plane4 -tauz 1 -stairg 1 -arcmin 16
  ./run.sh enum_s3 $n G2k9m16nl -plane4 -tauz 1 -stairg 9 -arcmin 16 -nos3leaf
done
echo done > out/matrix.done
