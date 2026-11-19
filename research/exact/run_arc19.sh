#!/bin/bash
# D5: knotted 19-edge half-space arcs.  ./run_arc19.sh [M] [J]  -> out/dmon/arcL_L/ part files; restartable
# (a part is skipped when its log has "seconds="); J parts run at a time.  Needs arcknot.cpp -part.
cd "$(dirname "$0")"
L=${L:-19}; M=${1:-64}; J=${2:-4}
D=out/dmon/arc$L; mkdir -p $D
[ -x ./arcknot ] || g++ -O3 -std=c++17 -o arcknot arcknot.cpp
[ -x ./unknot_cert ] || g++ -O3 -std=c++17 -o unknot_cert unknot_cert.cpp
one() {
  r=$1; f=$D/part${r}_$M
  grep -q "seconds=" $f.log 2>/dev/null && return
  s=$(date +%s)
  ./arcknot $L -part $r $M 2> $f.log.tmp | ./unknot_cert > $f.left.tmp 2>> $f.log.tmp
  echo "seconds=$(( $(date +%s) - s )) arcknot.cpp=$(sha256sum arcknot.cpp | cut -c1-16)" >> $f.log.tmp
  mv $f.left.tmp $f.left; mv $f.log.tmp $f.log
}
export -f one; export D M L
seq 0 $((M-1)) | xargs -P $J -I{} bash -c 'one {}'
echo ALL_PARTS_DONE
