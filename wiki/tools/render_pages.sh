#!/bin/bash
# usage: bash wiki/tools/render_pages.sh KEY page...   renders 80dpi pages into wiki/figures/KEY/pNN.png
cd "C:/Users/Lenovo/Desktop/Sophomoron/MA498-Knots"
K=$1; shift
P=$(awk -F'\t' -v k="$K" '$1==k{print $3}' wiki/tools/sources.tsv)
mkdir -p wiki/figures/$K
for n in "$@"; do pdftoppm -r 80 -png -f $n -l $n "$P" wiki/figures/$K/tmp 2>/dev/null; mv wiki/figures/$K/tmp*.png wiki/figures/$K/p$(printf %02d $n).png; done
ls wiki/figures/$K | tr '\n' ' '
