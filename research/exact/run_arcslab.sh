#!/bin/bash
# Half-slab arc lemma: ./run_arcslab.sh W MINSUM L1 L2 ...   (logs in out/arcslab/, restartable)
cd "$(dirname "$0")"
g++ -O3 -std=c++17 -o arcslab arcslab.cpp && g++ -O3 -std=c++17 -o unknot_cert unknot_cert.cpp || exit 1
W=$1; S=$2; shift 2
for L in "$@"; do
  log=out/arcslab/w${W}_L$L.log
  grep -q "seconds=" $log 2>/dev/null && continue
  s=$(date +%s)
  ./arcslab $L -w $W -minsum $S 2> $log.tmp | ./unknot_cert > out/arcslab/w${W}_L$L.left.tmp 2>> $log.tmp
  echo "seconds=$(( $(date +%s) - s )) arcslab.cpp=$(sha256sum arcslab.cpp | cut -c1-16)" >> $log.tmp
  mv out/arcslab/w${W}_L$L.left.tmp out/arcslab/w${W}_L$L.left; mv $log.tmp $log
done
