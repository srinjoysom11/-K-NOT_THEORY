#!/bin/bash
# run2.sh TAG N flags... : like run.sh but records wall and user CPU seconds
tag=$1; n=$2; shift 2
d=/tmp/claude-0/-home-user--K-NOT-THEORY/3cb4b54a-fd55-5f00-b74c-5b7e57676d03/scratchpad/agents/J_next
o=$d/out/${tag}_$n
TIMEFORMAT='%R %U'
tt=$( { time $d/${FSH:-F.sh} ${BIN:-$d/enum_u_final} $n "$@" -out $o.txt 2>$o.err ; } 2>&1 )
sm=DIFF; if [ -f $d/ref_$n.txt ]; then cmp -s $o.txt $d/ref_$n.txt && sm=same; else sm=noref; fi
nodes=$(grep -o ' nodes=[0-9]*' $o.err | cut -d= -f2)
printf "%-22s N=%d nodes=%10s wall=%7.2f user=%7.2f %s\n" "$tag" $n $nodes $tt $sm | tee -a $d/results2.txt
