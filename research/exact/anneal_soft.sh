#!/bin/bash
# Upper bounds in a slab by annealing with a soft wall (bfacf_soft.c).
#   ./anneal_soft.sh HS SEEDS "name:braid;name:braid;..." [FIRST_SEED]  -> out/slab/witness_L<HS>.txt (appends)
# Start polygons from braid2slab.py (1-slab); hard limit HS + 2 levels, soft limit HS.
# Each result line: name length word; check with check/slab_word.py.
cd "$(dirname "$0")"
gcc -O2 -o bfacf_soft bfacf_soft.c || exit 1
HS=$1; SEEDS=$2; F=${4:-1}; IFS=';' read -ra ITEMS <<< "$3"
out=out/slab/witness_L$HS.txt
for it in "${ITEMS[@]}"; do
  name=${it%%:*}; b=${it#*:}
  w=$(python3 braid2slab.py "$b") || continue
  for s in $(seq $F $((F + SEEDS - 1))); do
    r=$(./bfacf_soft $((HS + 2)) $HS 0.7 0.05 $w $s 300 50000 50000 0.40 0.05)
    echo "$name ${r#BEST }" >> $out
  done
done
