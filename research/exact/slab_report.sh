#!/bin/bash
# One line per finished slab run: L, n, nodes, survivors, seconds, knot types (identify_rigorous.py).
cd "$(dirname "$0")"
for log in $(ls out/slab/L*_n*.log | sort -t_ -k1,1 -k2,2V); do
  b=${log%.log}; L=$(echo $b | sed 's/.*L\([0-9]*\)_n.*/\1/'); n=${b##*_n}
  nodes=$(grep -o "nodes=[0-9]*" $log | cut -d= -f2); sv=$(grep -o "survivors=[0-9]*" $log | cut -d= -f2)
  sec=$(grep -o "^seconds=[0-9]*" $log | cut -d= -f2)
  if [ -s $b.txt ]; then
    t=$(python3 identify_rigorous.py $b.txt 2>&1 | awk '/^TALLY/{f=1;next} f&&/^[0-9]/{printf "%s x %s, ", $1, $3} /ALL RESOLVED/{printf "ALL RESOLVED"} /UNRESOLVED/{printf "UNRESOLVED"}')
  else t="-"; fi
  echo "L=$L n=$n nodes=$nodes survivors=$sv seconds=$sec | $t"
done
