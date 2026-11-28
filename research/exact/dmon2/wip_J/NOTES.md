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
