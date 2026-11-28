# J_next: enum_u, working notes

## Fixed source
`enum_u_fixed.cpp` (binary `enum_u_fixed`). It is round 2 (`enum_u_final2.cpp`) plus two fixes:

1. **Stale dead first letters (the bug that lost words).** `w3_dfsc` / `w3_dfsf` now set `w_dead1 = 0` when they enter the root. Before, if the root returned at once (a one-step walk Hd -> Tl, possible when no obligation is pending), it kept the dead-letter mask of the previous GW3 call. `-w3inc` then pruned the head child that had those letters.
2. **Heuristic cache at the epoch wrap.** `ghH` is now cleared when the 24-bit epoch wraps. This bug never showed up: it needs more than 16.7M GW3 calls in one Search object.

`enum_diag.cpp`: the same source with `-target WORD` (follow one word and print the test that kills it, plus the TRUEWALK check of the true middle walk inside GW3) and `-targetpre` (follow the word only down to the split depth, then search that task in full). `enum_bug` is the old source with the same options.

## Flags
- U1 (round 1) = F + `-gwv 1 -walkc 2 -pre1 -w3ent 2 -w3nb 3 -w3inc 1 -walk 8 N/2+2`
- U2 (round 2) = F + `-gwv 1 -walkc 2 -pre1 -w3ent 2 -w3nb 4 -w3inc 2 -walk 8 N/2+2`

## Verification after the fix (`results2.txt`, rows `X_fix_*`, `W_*`)
- N = 24, 26, 28, 30, 32, 34: U1 and U2 are byte-identical to the F reference files `ref_N.txt`.
- N = 36: U2 gives 2312 words, sha256 b33f059d1597efb9 (the sha the coordinator gave for F). It recovers the 2 words that the old U lost (`verifyU/u36.txt`).
- The three N = 40 words: found again, both along their own construction (`-target`) and in a full search of their tasks (`-targetpre`). Before the fix, that full search of the two tasks lost 2 of them.

## Timings (user seconds)

| N | F | U2 | U1 | U2 nodes |
|---|---|---|---|---|
| 30 | 15.8 | 3.55 | 3.97 | 1,836,461 |
| 32 | 69.1 | 14.9 | 16.2 | 6,902,227 |
| 34 | 378 (F, earlier) | 62.2 | 68.5 | 26,209,303 |
| 36 | — | 340 | — | 122,717,449 |

Nothing of mine is running now.

## Round 3: UG (primeness-free plane rules merged)
enum_ug.cpp = enum_u_fixed.cpp + patch_ug1.py + patch_ug2.py (K's patch.py / patch2.py with the file names changed and one
anchor adapted to the cinf line). FG.sh = F.sh with -stair replaced by -stairg 1 -arcmin 16.
UG = FG.sh + U2 flags. Words = U2 = F at N = 24..32 (byte-identical), and at N = 34 with -arcmin 16 and with -arcmin 17.
Nodes UG/U2: 24 37,835/39,004; 26 104,745/106,819; 28 386,871/395,112; 30 1,816,384/1,836,461; 32 6,821,836/6,902,227;
34 60,124,525 (M=16) and 26,008,496 (M=17) / 26,209,303. Time (user s) N=30 3.77-3.86 vs 3.51-3.67; N=32 15.6 vs 14.7-15.0;
N=34 150.3 (M=16), 65.8 (M=17) vs 63.5. Incremental GW3 setup: only 13% of calls have the parent's B table (17% the same
site set): not implemented.
