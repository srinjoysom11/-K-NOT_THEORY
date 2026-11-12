# Deeper search on the 11-crossing table: summary

knots processed: 552 of 552; verification failures: 0 []

knots whose bound dropped: 30 (5.4%); by 2: 30, by 4: 0, more: 0


## alternating (K11a): 367 knots, 29 dropped

| length | first table | after deeper search |
|---|---|---|
| 64 | 19 | 21 |
| 66 | 165 | 186 |
| 68 | 170 | 151 |
| 70 | 13 | 9 |

## non-alternating (K11n): 185 knots, 1 dropped

| length | first table | after deeper search |
|---|---|---|
| 54 | 1 | 1 |
| 56 | 13 | 13 |
| 58 | 20 | 20 |
| 60 | 79 | 79 |
| 62 | 63 | 64 |
| 64 | 9 | 8 |

## By arc index

| arc index | knots | dropped | lengths after |
|---|---|---|---|
| 9 | 4 | 0 | {56: 3, 58: 1} |
| 10 | 46 | 0 | {54: 1, 56: 10, 58: 13, 60: 18, 62: 4} |
| 11 | 135 | 1 | {58: 6, 60: 61, 62: 60, 64: 8} |
| 13 | 367 | 29 | {64: 21, 66: 186, 68: 151, 70: 9} |

## Does the invariant fit flag improvable knots?

Fit on the 249 literature values only: Len ~ 2.795*arc + 2.545*c + 2.214.

| round-1 residual (value minus prediction) | knots | dropped | fraction |
|---|---|---|---|
| [-99, -1) | 36 | 0 | 0.00 |
| [-1, 1) | 242 | 2 | 0.01 |
| [1, 3) | 248 | 23 | 0.09 |
| [3, 5) | 26 | 5 | 0.19 |

RMS residual of the 11-crossing values against the literature-only fit: 1.43 before, 1.38 after; mean residual +0.35 before, +0.24 after.

