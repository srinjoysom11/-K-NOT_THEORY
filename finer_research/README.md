# Finer research: the 11-crossing table and what predicts lattice length

Written 12 Nov 2026 on branch `finer_research` (branched from `research/len11-table`).
Labels as in `research/PLAN.md`: **[E]** established (source key from `wiki/SOURCES.md`),
**[C]** computed here (script and output file given), **[J]** proposal or conjecture
(with the check that would settle it).

Len(K) = least number of unit steps of a simple-cubic lattice polygon of knot type K.
c = crossing number, a = arc index (= grid index).

## 1. The open problem chosen, and why

`wiki/open-problems.md` item **A6: "Tables beyond 10 crossings. No minimal-length table
exists for 11 or more crossings."** It is the item that is literally Goal 1 (numerical
tables), it is the backbone of `research/PLAN.md` (task T6), and it is the only item
where a few CPU-hours produce results that are new by construction.

Items considered and set aside: A1 (certify Len beyond 5_1) needs proofs by exhaustive
enumeration and belongs to a later phase; A3 (arithmetic patterns in families) was
already tried for trefoil sums with no improvement; D17-D19 are about the move set, not
the table.

## 2. What had already been done

Literature:
- [E] Proved values: Len(3_1) = 24 [Diao93], Len(4_1) = 30 and Len(5_1) = 34 [Scharein09].
- [E] Best-known upper bounds for all 249 prime knots with at most 10 crossings
  [Scharein09], found in 2009 by BFACF annealing (100 cycles of 100,000 moves at
  fugacity up to 0.2 then 60,000 at 0.02); at most 7 crossings re-minimised by [JvRR11].
- [E] For 11 crossings the literature has exactly two values, both from the "step of
  10" families in [JvRR11] Table 1: the torus knot T(2,11) at 64 and the 11-crossing
  twist knot at 66. Nothing else.
- [E] Rigorous upper bounds in terms of arc index: a knot is realised with (a-2, a-1,
  a-1) sticks in the three directions, giving bounds quadratic in a [HNO14len]; they are
  loose (112 for 8 crossings against the numerical 52).
- [E] No lower bound on Len in terms of arc index appears in any of the 66 papers in
  the wiki. The only general lower bounds are Len > braid index [Diao19] and
  4 Len + 6 >= c for alternating knots [Diao22].

This repository (branch `research/len11-table`):
- [C] Seeds for all 801 prime knots with 3-11 crossings from planar diagrams.
- [C] Calibration: 245 of 249 literature values reproduced with 24 runs, the other 4
  with 240 runs, none beaten.
- [C] A first 11-crossing table, all 552 knots verified, **24 runs per knot**, flagged
  in PLAN.md as "some values probably 2 too long".

## 3. Questions asked here

1. How loose is the first 11-crossing table? (PLAN.md T6, first bullet.)
2. Is there a knot invariant that predicts Len well enough to say *which* table
   entries are probably too long, so that search effort can be aimed?
3. Does the starting polygon matter? The project's seeds come from planar diagrams;
   minimal grid diagrams give a second, independent family of seeds.
4. Are any of the 2009 literature values for 10 crossings improvable?

## 4. Results

### 4.1 Arc index and crossing number together predict Len to within about one step [C]

Script `code/invariant_table.py` joins the 249 literature values and the first
11-crossing table with KnotInfo invariants (`out/len_vs_invariants.csv`).

- Correlation of Len with arc index 0.93, with crossing number 0.88, with hyperbolic
  volume 0.75, with braid index 0.42 (249 literature values).
- Least-squares fit on the 249 literature values only:
  **Len ~ 2.80 a + 2.54 c + 2.2**, root-mean-square error 1.24 (Len is always even, so
  this is less than one lattice step of 2). On all 801 knots: 2.84 a + 2.64 c + 0.95,
  RMS 1.35.
- For alternating knots a = c + 2, so the fit is a line in c of slope about 5.3; the
  information in a is in the non-alternating knots, where a <= c.
- Lengths by arc index (literature values, at most 10 crossings):

| a | Len values (number of knots) |
|---|---|
| 5 | 24 (1) |
| 6 | 30 (1) |
| 7 | 34, 36, 42 |
| 8 | 40-50 (8 knots) |
| 9 | 44-56 (22) |
| 10 | 48-58 (50) |
| 11 | 54-58 (41) |
| 12 | 58-64 (123) |

- [J] **Lower envelope.** In all 801 values Len - 4a >= 4, with equality only for the
  trefoil; the minimum of Len - 4a per arc index is 4, 6, 6, 8, 8, 8, 10, 10, 12 for
  a = 5..13. Conjecture: Len(K) >= 4 a(K) + 4. Our 11-crossing values are upper bounds,
  so only the three proved values test it rigorously; the check is a proof, and the
  natural route is to turn a lattice polygon into an arc presentation and count pages
  against edges. Read Huh-Oh 2005 (paywalled, reading list section 7 item 10) first:
  it relates lattice sticks to arc index and may already contain a version of this.

### 4.2 The published 11-crossing values are reproduced [C]

T(2,11) is K11a367 (two-bridge [11]) and the 11-crossing twist knot is K11a247
(Conway [9 2]). The first table has 64 and 66 for them, equal to [JvRR11] Table 1.

### 4.3 Grid-diagram seeds: verified for all 801 knots, but no better than diagram seeds [C]

`code/grid_seeds.py` turns KnotInfo's minimal grid diagram of each knot into a lattice
polygon (vertical segments at height 1, horizontal at height 0, a unit vertical edge at
each mark) and verifies it like every other seed. 801 of 801 are the right knot once
the naming swap below is applied; mean seed length 128 steps against 134 for the
diagram seeds (`out/grid_seeds.csv`, `out/grid_seeds.json`).

Benchmark, same annealer (Scharein schedule), same budget of 16 million attempted moves,
same RNG seeds 1-40, 12 hard knots (`out/bench/seed_compare.md`):

| start | solved runs | 95% interval |
|---|---|---|
| diagram seeds | 247 / 480 = 0.515 | [0.470, 0.559] |
| grid seeds | 251 / 480 = 0.523 | [0.478, 0.567] |

Verdict: **no difference.** The starting polygon is forgotten within the budget, so the
seed is not what limits the search; effort belongs in the move schedule (PLAN.md T2,
T3). The grid seeds remain useful as an independent second certificate chain.
(The 40-run diagram-seed score of 0.515 is close to the 129 / 240 = 0.54 recorded in
PLAN.md for 20 runs.)

### 4.4 A naming trap: 10_83 and 10_86 [C], [E]

The grid seed built from KnotInfo's 10_83 is identified by SnapPy as its 10_86 and vice
versa. [CRSS25] p. 8 footnote says the same ("SnapPy identifies our 10_83 as 10_86 and
vice versa ... expected"). `data/rechnitzer_SC_minimal.csv` gives them different
lengths (62 and 60) and its rows were verified against SnapPy names, so in KnotInfo
numbering the two lengths are the other way round. `wiki/00-notation.md` records the
Perko renumbering (10_162 onward) but not this swap; it should.

### 4.5 The ten literature values furthest above the fit did not move [C]

The largest positive residuals among the 249 literature values are 10_160 (56), the six
alternating knots at 64 (10_81, 10_90, 10_96, 10_109, 10_118, 10_120), 9_46 (50),
10_135 and 10_144 (58). Each got 4 rounds of 100 annealing runs started from the
literature polygon, restarting from the best word (`out/outliers_in.txt`,
`out/outliers_raw.txt`; command in section 6).

Result: **0 of 10 improved** in 4,000 runs. This is not a lower bound (PLAN.md rule 2),
but it says the 2009 values are not loose in the way the first 11-crossing table is,
and that a residual of +3 against the fit is within the real spread of Len.

### 4.6 The deeper 11-crossing search

Every knot of the first table got 40 more annealing runs (2 rounds of 20, the second
restarting from the best word of the first), about 8.8 billion attempted moves in total.
`code/analyze_round2.py` re-verified every changed polygon; outputs
`out/table_11_crossings_v2.csv` (the new table, with words) and `out/round2_summary.md`.

- [C] 552 of 552 knots processed, **0 verification failures**.
- [C] **30 knots (5.4%) dropped, all by exactly 2**; none by 4 or more. 29 of the 30
  are alternating (29 / 367 = 7.9%); 1 of 185 non-alternating (0.5%).
- [C] Distribution of best lengths after the deeper search:

| | 54 | 56 | 58 | 60 | 62 | 64 | 66 | 68 | 70 |
|---|---|---|---|---|---|---|---|---|---|
| alternating (367), first table | | | | | | 19 | 165 | 170 | 13 |
| alternating (367), now | | | | | | 21 | 186 | 151 | 9 |
| non-alternating (185), first table | 1 | 13 | 20 | 79 | 63 | 9 | | | |
| non-alternating (185), now | 1 | 13 | 20 | 79 | 64 | 8 | | | |

- [C] By arc index: a = 9: 56-58 (4 knots); a = 10: 54-62 (46); a = 11: 58-64 (135);
  a = 13: 64-70 (367). The lower envelope of 4.1 is unchanged (64 = 4*13 + 12 at
  a = 13; 54 = 4*10 + 14 is above the earlier minimum at a = 10).
- [C] The two published values (K11a367 at 64, K11a247 at 66) did not move.
- [C] **The fit does flag loose entries, statistically.** Residual of the first-table
  value against the literature-only fit, and the fraction that dropped:

| residual | knots | dropped | fraction |
|---|---|---|---|
| below -1 | 36 | 0 | 0.00 |
| -1 to 1 | 242 | 2 | 0.01 |
| 1 to 3 | 248 | 23 | 0.09 |
| 3 to 5 | 26 | 5 | 0.19 |

  So 28 of the 30 drops came from the half of the table with residual above +1. Mean
  residual of the 11-crossing table went from +0.35 to +0.24 (literature values: 0 by
  construction), RMS from 1.43 to 1.38.

Reading: the first table was about 5% loose at this depth, far less than the "probably
many" feared, and the looseness sits in the alternating knots at 68 and 70. The table
is not converged: the mean residual is still positive and the 9 knots left at 70 and
the 151 at 68 are the obvious suspects. These are upper bounds only (PLAN.md rule 2).
An early partial count (4 drops in the first 28 knots) overstated the rate; the first
knots in census order happen to be the looser ones.

## 5. What is new here, and the finer goals

New in this folder, as far as the 66 papers in the wiki go (a literature search finding
nothing is not proof of novelty; re-check before claiming it in a paper):
- the quantitative link between Len and arc index, and the lower-envelope conjecture;
- verified grid-diagram lattice seeds for every prime knot up to 11 crossings, and the
  measurement that seed choice does not matter;
- a tightened 11-crossing table (section 4.6).

Finer goals, in order:

- **F1. Finish tightening the 11-crossing table.** Repeat rounds of 40 runs until a
  whole round changes fewer than 1% of the entries; report the drop rate per round as
  the convergence curve. Done when two successive rounds agree on at least 99%.
- **F2. Aim the next rounds with the fit.** For the 2009 values a large residual did
  not mean a loose value (4.5), but in the 11-crossing table the drop rate rises from
  0% to 19% with the residual (4.6). Next round: 200 runs each on the 274 knots with
  residual above +1 (the 9 at length 70 first), instead of 40 runs on all 552. Track
  the mean residual per round; a converged table should be near 0.
- **F3. Extend the fit to 12 crossings before searching.** KnotInfo has arc index for
  all 2176 knots; predicted lengths give each knot a target, which turns the 12-crossing
  run into a benchmark with per-knot stopping targets instead of a blind search.
- **F4. Test the lower envelope where it can be proved.** Len >= 4a + 4 for a = 5, 6, 7
  says 24, 28, 32: true for 3_1 (24) and 4_1 (30), and for arc index 7 it would give
  Len >= 32 for 5_1, 5_2 and 8_19 (known: 34 proved, 36, 42). So the first non-trivial
  case is whether some argument gives Len(5_2) >= 32 or better. An exhaustive closure
  below length 36 (PLAN.md T3c) on 5_2 would decide whether 36 is exact.
- **F5. Fix the naming.** Add the 10_83 / 10_86 swap to `wiki/00-notation.md` and to
  the name mapping in `research/code/seeds.py`, next to the Perko note.
- **F6. Stop working on seeds.** The benchmark settles it; do not spend time on
  alternative embeddings (KnotPlot, Knoodle PolyFold) for the purpose of search speed.

## 6. How to reproduce

```
g++ -O2 -std=c++17 -pthread -o bfacf_batch research/code/bfacf_batch.cpp
g++ -O2 -std=c++17 -pthread -o bench research/code/bench.cpp
pip install snappy database_knotinfo numpy

python finer_research/code/invariant_table.py
python finer_research/code/grid_seeds.py

# seed benchmark (hard12_grid.txt = bench_hard12.txt with grid seeds substituted)
./bench research/data/bench_hard12.txt finer_research/out/bench/seed_compare_raw.txt diagram_seed 40 16000000 0 2 cycle 0.2 0.02 100000 60000
./bench finer_research/out/bench/hard12_grid.txt finer_research/out/bench/seed_compare_raw.txt grid_seed 40 16000000 0 2 cycle 0.2 0.02 100000 60000
python finer_research/code/seed_compare.py

# literature outliers: 4 rounds x 100 runs, RNG seeds 700000 + 1000*round + i
./bfacf_batch finer_research/out/outliers_in.txt finer_research/out/outliers_raw.txt 4 100 100 100000 60000 0.2 0.02 700000 2

# deeper 11-crossing search: 2 rounds x 20 runs from the words of research/out/c11.csv,
# RNG seeds 500000 + 1000*round + i
./bfacf_batch finer_research/out/c11_round2_in.txt finer_research/out/c11_round2_raw.txt 2 20 100 100000 60000 0.2 0.02 500000 4
python finer_research/code/analyze_round2.py
```

The search output does not depend on the thread count (one RNG stream per run).
Papers were read from `papers/` and the extracts in `wiki/_extracts/`: Scharein09,
JvRR11, HNO14len, HKNO14, CRSS25, JvRW91, JvRR10bfacf, Ozawa26merge, Diao19, Diao22.
