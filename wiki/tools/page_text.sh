#!/bin/bash
# usage: bash wiki/tools/page_text.sh KEY first last  -> per-page text with true PDF page numbers
cd "C:/Users/Lenovo/Desktop/Sophomoron/MA498-Knots"
K=$1; P=$(awk -F'\t' -v k="$K" '$1==k{print $3}' wiki/tools/sources.tsv)
for n in $(seq $2 $3); do echo "[[p$n]]"; pdftotext -enc UTF-8 -f $n -l $n "$P" - 2>/dev/null | sed -E 's/[.•]{6,}//g; s/[ \t]+/ /g' | grep -v '^ *$'; done
