#!/bin/bash
cd "$(dirname "$0")"
printf "%-12s %4s %12s %9s %6s\n" tag N nodes seconds words
for n in 24 26 28 30 32; do for t in F0 F G1m0 G1m8 G1m11 G1m16 G2m0 G2m8 G2m11 G2m16 G2k0m16 G2k1m16 G2k9m16nl; do f=out/${t}_n$n.log; [ -f $f ] || continue; grep -q seconds $f || continue
printf "%-12s %4s %12s %9s %6s\n" $t $n $(grep -o 'nodes=[0-9]*' $f | cut -d= -f2) $(grep -o 'seconds=[0-9.]*' $f | tail -1 | cut -d= -f2) $(grep -o 'survivors=[0-9]*' $f | cut -d= -f2); done; done
