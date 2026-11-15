ARC CHECK: independent Python re-implementation of the arc-closure census
==========================================================================

arc_check.py L
  Enumerates walks from the definition (first step e or u, self-avoiding, z>=0,
  no reversal, no (a,c,-a) triple, end at z=0, B != A, L+d >= 22 for tested).
  Pruning only: "z must still be able to return to 0". Prints walks_ending_on_level0,
  tested, one_bridge, printed, the maxima histograms per axis, and the printed words.

arc_alexander.py WORDS_FILE [PROCESSES]
  Reads words (last field per line). Own check that each word is a closed
  self-avoiding polygon; Alexander polynomial via identify_words.alexander_of
  (repo spherogram + alexander path). Prints the polynomial tally.

Commands run (from research/exact/check):
  python3 arc_check.py 11 ; ... 12 ; ... 13 ; ... 14
  ../arcknot 15 > SCRATCH/arc15_words.txt      (C++ generator, not modified)
  python3 arc_alexander.py SCRATCH/arc15_words.txt 2

Numbers (Python vs C++ as reported)
  L=11  walks 314485 vs 2557 (DIFFERENT)   tested 2047 vs 2047 (same)
        one_bridge 2047 same, printed 0 same, histograms same
  L=12  walks 1185873 vs 104901 (DIFFERENT) tested 82757 vs 82757 (same)
        histograms same
  L=13  walks 4566909 vs 1094730 (DIFFERENT) tested 883811 vs 883811 (same)
        histograms same
  L=14  walks 17402869 vs 7444933 (DIFFERENT) tested 6238626 vs 6238626 (same)
        histograms same, printed 0 same
  L=15  Alexander tally of the 15608 C++ words: [1] 15608 (expected [1]).
        702 words give no diagram (None -> [1]); the other 14906 simplify to
        zero crossings. All 15608 pass the own closed-SAW check.

Notes
  - Walk count cross-check: a naive brute force over all words of length 8 and 10
    gives 5962 and 82545, the same as arc_check.py. So the walk-count gap is not
    an enumeration bug in arc_check.py; the cause is not identified.
  - B == A closed walks: none occurred at any L run (0 excluded).
  - Tested sets and all local-maxima histograms agree exactly for L=11..14.
