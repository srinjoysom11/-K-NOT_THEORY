# State of the art and traps (for Goal 1)

Compiled from `READING_LIST.md` §0-1, `wiki/00-notation.md`, `wiki/open-problems.md`
and `research/PLAN.md` (12 Nov 2026). Source keys resolve in `wiki/SOURCES.md`.
Re-check against those files if they have changed since.

## Proved exact values (the only three)

| knot | Len | source |
|---|---|---|
| 3_1 | 24 | [Diao93] proof |
| 4_1 | 30 | [Scharein09], full proof in unpublished Ishihara 2009 preprints |
| 5_1 | 34 | [Scharein09], same |

Also proved: trefoil in a 1-slab needs 26 [Ishihara12]; Borromean rings 36 (Uberti et
al. 1998; Eppstein 2021). Everything else is an upper bound.

## Best-known upper bounds <= 10 crossings

From [Scharein09] (2009 KnotPlot search) and [JvRR11] (<= 7 crossings minimised by
BFACF/GAS). Stored and re-verified in `data/rechnitzer_SC_minimal.csv`: all 249 are
closed self-avoiding polygons, genus matches KnotInfo, SnapPy names every hyperbolic
one; the 6 non-hyperbolic are the torus knots 3_1 5_1 7_1 8_19 9_1 10_124.

Distribution of the 249 values: 24, 30, 34, 36, 40x3, 42, 44x5, 46x4, 48x4, 50x18,
52x9, 54x25, 56x45, 58x11, 60x45, 62x69, 64x6. The 8-10 crossing values have not been
re-attacked on SC since 2009 (the 62s and 64s are the first targets).

Counts of minimal polygons [JvRR11] (unrooted, both chiralities): 3_1 24 (3328),
4_1 30 (3648), 5_1 34 (6672), 5_2 36 (114912). [Diao94] printed 3496 for the trefoil;
[Scharein09] corrected it to 3328.

## Computed here so far [C] (branch research/len11-table)

- Calibration on 249 knots <= 10 crossings: 245 equal to the literature with 24 runs;
  the other 4 (9_31, 10_13, 10_27, 10_72) reach it with 240 runs; none shorter.
- First 11-crossing table, all 552 verified, 24 runs only:
  alternating K11a: 64 (19 knots), 66 (165), 68 (170), 70 (13);
  non-alternating K11n: 54 (1), 56 (13), 58 (20), 60 (79), 62 (63), 64 (9).
- Trefoil sums n = 2..10: no improvement on 24 + 16(n - 1) (unproved pattern [JvRR11]).
- Fingerprint (Alexander + Jones): 801/801 correct candidate set, 707 unique, 0.044 s.
- Knot-type growth Q >= 1.1031 (789 types with a polygon of <= 68 steps); relies on
  JvRP95 Thm 10 as quoted in the wiki, re-read the original before citing.
- Benchmark, 12 hard knots x 20 runs, B = 16M: Scharein schedule 129/240 solved,
  untuned record-to-record (z = 0.10, delta = 4) 100/240.

## General upper bounds in crossing number c (context for the paper)

| bound | source |
|---|---|
| Len <= 136 c^{3/2} + 84c + 22c^{1/2} + 11 | Diao-Ernst-Yu 2004 |
| Len <= 1.5c^2 + 2c + 0.5 (non-trefoil) | [HNO14len] |
| Len <= min{3/4 c^2 + 5c + 17/4, 5/8 c^2 + 7.5c + 71/8} | [HKNO14] |
| Len <= 8c + 2 for 2-bridge knots and links | [HHKNO14] |
| s_L <= 3c + 2 | [HNO12stick] |

## Lattice facts the search relies on

- Len is even in SC (bipartite lattice).
- BFACF moves: neutral corner flip, +2, -2; each is an isotopy across a unit square, so
  knot type is preserved [JvRW91 Thm 3.11]. BFACF is ergodic within a knot type in SC
  for unrooted polygons; minimal polygons are disconnected under neutral moves alone
  (connecting them needs +2 for 4_1, +4 for 6_3) [Ozawa26merge].
- Critical fugacity z_c = 1/mu ~ 0.2134, mu ~ 4.6844 (SC growth constant) [JvRP95].
- At fixed fugacity with uniform vertex choice the stationary weight is proportional to
  n z^n [JvRR10bfacf eq. 9]; this is what the T3f swap rule uses.
- Lattice stick number s_L = number of corners; it is a free byproduct column.

## Traps

- **c(K) clash:** project brief's c(K) = Len(K); literature c(K) = crossing number.
- **Ropelength convention:** radius vs diameter differ by 2. In the radius convention
  Rop <= 2 Len. Klotz et al. use diameter. Check before multiplying or dividing.
- **Perko pair:** KnotInfo 10_162..10_165 = SnapPy / old Rolfsen 10_163..10_166.
- **Chirality:** mirror images have the same Len; counts may include both chiralities
  (3328 = 2 x 1664). Canonical forms that drop reflections keep chirality.
- **Rooted vs unrooted:** rooted count = unrooted x length.
- **"34.7":** misquote in KA23 of Diao 2003; best proved absolute ropelength constant in
  this collection is 31.32 [DDS04].
- **Unverified claims:** Klotz 2026's 2.0996 c^{3/4} constant is LLM-assisted and not
  interval-certified [Klotz26llm]; do not use it as established.

## Papers most relevant to Goal 1

[JvRR11] (minimal lengths and counts, GAS), [Scharein09] (the table and the annealing
schedule), [CRSS25] (modern annealing beat old stick-number tables: the playbook),
[JvRR10bfacf] and [JvRW91] (moves, ergodicity), [Ozawa26merge] (move graphs, frozen
states), [Wagner21] and [CEWW24] (cross-entropy and PatternBoost for T3e/T4b),
[BKBO22] and [Vandans20] (classifiers on step words: writhe shortcut warning).
