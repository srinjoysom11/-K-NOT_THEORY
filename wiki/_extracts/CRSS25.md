# CRSS25 — New upper bounds for stick numbers
- **Authors:** Jason Cantarella (Univ. Georgia), Andrew Rechnitzer (UBC), Henrik Schumacher (RWTH Aachen), Clayton Shonkwiler (Colorado State)
- **Venue / year / identifiers:** arXiv:2508.18263v1 [math.GT], 25 Aug 2025 (no journal ref printed)
- **File:** papers/2_algorithms/Cantarella-Rechnitzer-Schumacher-Shonkwiler_2025_New_upper_bounds_stick_numbers_2508.18263.pdf   **Pages:** 30
- **Text layer:** partly garbled (formulas; appendix tables lose the boxed/bracketed marks; Table 1/2/3 layout). All tables re-read on page images (pp. 10, 12, 13, 15, 18, 19).

## Abstract
We use a version of simulated annealing with knot-type preserving moves to find polygonal representatives of various knot types with low stick number. These give better bounds on stick numbers of prime knots through 10 crossings, and for the first time give a comprehensive table of stick number bounds on all knots through 13 crossings. These are equal to existing lower bounds (and hence determine the stick number exactly) for 19 knot types whose exact stick number was not known previously.

## Notation and conventions
- **stick[K]** (p. 1): "the minimum number of edges in any polygon in R³ with knot type K." Polygons are closed polygons in R³ (edges need not be equal or unit length) unless "equilateral" is stated. **Equilateral stick number** (p. 15): minimum number of segments in any polygonal realization in which all segments have the same length.
- c[K] = (minimal) crossing number; b[K] = bridge index; sb[K] = superbridge index (p. 10).
- Knot names: Rolfsen table for ≤ 10 crossings (e.g. 3_1, 10_165; the paper writes 31, 929 etc.); **KnotInfo naming convention** for 11–13 crossings, "11n78", "13n5018" (alternating/non-alternating a/n prefix), and the footnote (p. 8) "SnapPy identifies our 10_83 as 10_86 and vice versa, but this is the correct, and expected, behavior" (KnotInfo vs SnapPy naming).
- P_m = P(2, 3, …, 3) = pretzel knot with m threes, c[P_m] = 3m+2 (p. 12); P_4 = P(2,3,3,3,3) (Fig. 7). T_{q,p} torus knot; K_p = twist knot with p half-twists, c[K_p] = p+2 (Table 3 data: c = p+2).
- Appendix A table marks (p. 18): "For knots with boxed edge count, stick[K] is known exactly and in each case our bound matches this known value. For knots with ⟨bracketed⟩ edge count, our bound beats the best previous upper bound on stick[K]. For the remaining knots, stick[K] is not known but our examples match the best existing bounds." Below, [n] = boxed, ⟨n⟩ = bracketed.
- Move names: BFACF (lattice moves), fold move, length-decreasing/-increasing moves, triangle-collapse, triangle-inflation (Section 2).
- α_*, β_*: best constants in α √c[K] ≤ stick[K] ≤ β c[K] (Theorem 2).

## Numbered statements
**Theorem 1 (p. 2, restated p. 10), proved here (computer-found upper bound + quoted lower bound).** The following knots have stick number equal to 10: 11n_i with i ∈ {71, 75, 76, 78}; 13n_j with j ∈ {225, 230, 285, 288, 307, 584, 586, 593} and j ∈ {602, 603, 604, 607, 608, 1192, 5018}. (4 + 8 + 7 = 19 knot types, matching the abstract's "19".)
Proof idea: they found 10-stick realizations (upper bound 10). Each is a 4-bridge knot (11-crossing: Musick [45]; 13-crossing: Blair–Kjuchukova–Morrison [8, 44]). Eq. (1): b[K] < sb[K] ≤ (1/2) stick[K] (Kuiper [37], Jin [34]); so a 4-bridge knot has stick[K] ≥ 10.

**Theorem 2 (p. 3, restated p. 11), proved here from quoted results.** There are constants α_* and β_* so that for any α < α_* and β > β_* there is some C so that for all knot types with crossing number c[K] > C, we have α √c[K] ≤ stick[K] ≤ β c[K]. Further, α_* ∈ [√2, 2] while β_* ∈ [2/3, 3/2].
Proof (p. 11–12, steps as printed): (a) Adams et al. [1]: stick[T_{p+1,p}] = 2p+2; c[T_{p+1,p}] = p²−1 gives Eq. (2): stick[T_{p+1,p}] = 2√(c[T_{p+1,p}]+1) + 2, so α_* ≤ 2. (b) Calvo's bound [14] (improving Negami [46]) for all knots: stick[K] ≥ √2 √(c[K] + 1/8) + 7/2, so α_* ≥ √2. (c) Huh–Oh [31] for all nontrivial knots, Eq. (3): stick[K] ≤ (3/2) c[K] + 3/2, so β_* ≤ 3/2. (d) For β_* ≥ 2/3 use pretzel knots P_m = P(2,3,…,3): reduced alternating diagram ⇒ c[P_m] = 3m+2 [36]; bridge index b[P_m] = m+1 [5, 9]; by (1) stick[P_m] ≥ 2 sb[P_m] ≥ 2(b[P_m]+1) = (2/3) c[P_m] + 8/3.
Footnote p. 3: "in the course of proving Theorem 2, we established that these pretzel knots have stick[K] ≥ (2/3) c[K]." (⚠ the exact proved bound is (2/3)c + 8/3, i.e. at least (2/3)c.)

**Conjecture 3 (p. 14).** For all knots K with c[K] ≥ 12, stick[K] ≤ c[K]. ("slightly stronger than the conjecture that β_* ≤ 1", p. 13; supported by all 12- and 13-crossing knots, where stick[K] ≤ c[K] was verified (p. 12); known for 2-bridge knots [30].)

**Theorem 4 (p. 15), proved here.** The knot 9_29 has equilateral stick number equal to 9.
Proof idea: stick[9_29] = 9 [13, 51], so a 9-stick equilateral realization suffices. Found in two steps: (i) minimise deviation from unit edge lengths without changing knot type by replacing triangles of consecutive edges by triangles with at least one unit edge, giving a 9-edge 9_29 with all edge lengths in [1, 1.00000455]; rescale the 9 edge vectors to length exactly 1 (double precision), close with conformal barycenter closure [22]; checked with Knoodle that the knot is still 9_29. (ii) Millett–Rawdon [43] criterion Eq. (4): for an n-edge polygon P of knot type K there is a nearby equilateral realization with unit edges if for all i = 1…n, |L_i − 1| < min( μ(P), μ(P)²/n⁴ ) (⚠ the printed fraction reads "µ(P)² / n⁴" in the text layer garbled; text on p. 16 uses n = 9: "…µ(P)²/9⁴"), where L_i is the length of the i-th edge and μ(P) is the minimum distance between non-adjacent edges. For their 9_29: μ(P) = 1.84536 × 10⁻⁴ (between the 4th and 8th edges); maximum deviation from unit length 2.22045 × 10⁻¹⁶ (first and ninth edges); so |L_i − 1| < 10^{−7.58} min(μ(P), μ(P)²/9⁴) (⚠ as printed: the factor 10^{−7.58} is the ratio of deviation to the bound, which is how the paper expresses that it "easily satisfies" (4)).

## Key equations and quantitative claims outside numbered statements
- p. 1–2: bounds given for all knots through 13 crossings (12 965 knot types; total = 1+1+2+3+7+21+49+165+552+2176+9988 for c = 3…13, matches Table 1) and for some twist knots, torus knots, pretzel knots, random alternating and non-alternating knots with up to 64 crossings. "We suspect these bounds are fairly tight; our code finds configurations that achieve the stick number for all knots with fewer than 100 crossings for which the stick numbers are known exactly (mostly small knots and some torus knots)." (heuristic claim)
- p. 2: improved best-known upper bounds for 3 of the 9-crossing knots (incl. 9_36), 18 of the 10-crossing knots (incl. 10_37), 62.5% of 11-crossing, 83.2% of 12-crossing, 99.9% of 13-crossing knots. ⚠ Appendix A shows 17 bracketed 10-crossing knots (10_9, 10_10, 10_31, 10_33, 10_37, 10_52, 10_60, 10_61, 10_76, 10_86, 10_87, 10_92, 10_96, 10_97, 10_101, 10_123, 10_154); 9-crossing bracketed: 9_6, 9_23, 9_36 (3, consistent).
- p. 9: "In every case, we were able to find configurations which matched the existing bounds, and for 12 160 of 12 965 knot types, we were able to improve them."
- p. 9: minimum distance between non-adjacent edges in any of the knots found: 4.18148 × 10⁻⁷ (between the 10th and 12th edges of 13n2931) — "several orders of magnitude away from being numerically singular".
- p. 2 Fig. 1 / p. 3 Fig. 2: 10-stick 11n78 and 13n5018; 10-stick 9_36 and 11-stick 10_37 (each improves the previous best upper bound by 1).
- p. 3 footnote 1/p. 3: (2, 3,…, 3) pretzel knots up to 98 crossings: no configuration with stick[K] < c[K] − 1 found (p. 3); p. 13: P_m for 3 ≤ m ≤ 28: could not reduce edges below c[P_m] − 1 ("weakly suggests β_* ≥ 1").
- p. 4: BFACF moves preserve knot type [33]; lattice search is "several orders of magnitude" faster than searching n-gons (comparison made in text, no numbers).
- p. 5 (Fig. 3 caption) example 9_29: start lattice 168 edges → near-minimal lattice 58 edges → off-lattice equilateral 10-stick → minimal 9 sticks. Known: a 56-edge lattice 9_29 exists [50]; Theorem 4 gives 9-stick equilateral.
- p. 8: typical run ~10 minutes per knot on average; some runs several hours; early run reduces stick number by 0–2 edges within seconds.
- p. 9: Jones polynomial checks for (q,2)- and (q,3)-torus knots and all twist knots (against known Jones polynomial), pretzel and large knots (Jones polynomial of polygon = that of input diagram); (q,p)-torus knots with 4 ≤ p < q ≤ 32: Alexander polynomial at −1 and at 100 random unit-circle points; magnitudes of values in [0.000013, 274.2], relative errors all < 1.53 × 10⁻⁹.
- p. 12 (Section 4): (q,2)-torus knots: Johnson–Mills–Trapp [35] handcrafted construction with ⌊(2/3)(q+1)⌋ + 4 edges; since c[T_{q,2}] = q, stick[T_{q,2}] ≲ (2/3) c. The authors found configurations equal to this bound for all 3 ≤ q ≤ 31, none better ("suggesting that it may be optimal").
- p. 12: T_{q,3}, 4 ≤ q ≤ 26: data suggests stick[T_{q,3}] ≲ (5/16) c[T_{q,3}] for large q (no explicit formula conjectured); compare known stick[T_{q,3}] ≲ (1/3) c[T_{q,3}] from [35].
- p. 13 Table 3 caption: data "consistent with the conjecture stick[K_p] ≤ ⌊2p/3⌋ + 6". (Checked here: ⌊2p/3⌋+6 equals the tabulated value for every p = 1…20.)
- p. 13: large random untabulated knots up to 64 crossings from prime summands of equilateral random polygons with a few thousand edges; initial lattice embeddings via Knoodle REAPR had 9k–34k lattice edges; flat embeddings sometimes needed to grow to almost twice their initial length before shrinking; "In each case we were able to reduce the configuration down to one that required fewer sticks than its crossing number."
- Fig. 8 data (p. 14): four large knots: 28 ≤ c[K] ≤ 32 → stick ≤ 25; 46 ≤ c[K] ≤ 64 → stick ≤ 40; c[K] = 32 → stick ≤ 23; c[K] = 64 → stick ≤ 48. Lower bound on c for non-alternating knots from the span of the Jones polynomial; diagrams of the alternating ones are reduced so c is exact; all four hyperbolic (hence prime).
- p. 15: only remaining knot with ≤ 10 crossings for which best known stick and equilateral stick bounds differed was 9_29 (stick 9); Rawdon–Scharein [49] list of candidates whittled down [28, 42, 56].

## Methods / algorithms
1. (p. 4) Approach: search the space of polygons of fixed knot type K, minimising edge number (vs. sampling n-gons and classifying).
2. (p. 4) Initial lattice embeddings: knots ≤ 10 crossings: Rechnitzer's lattice-minimal configurations [50] (building on [53]); knots with 11–13 crossings: KnotInfo [39] off-lattice realisations converted to lattice polygons using KnotPlot [52] "embed clk"; all other knots: planar diagram code → Knoodle "REAPR" embedding (orthogonal graph layout for x,y; integer height function minimising total variation subject to over/under constraints).
3. (p. 4–5) Lattice simulated annealing with BFACF moves (Fig. 4: choose an edge and an adjacent lattice face, replace the face's edges by the complement). Reject at once if it creates self-intersection (hash-table check in constant time, Rust); accept if edge count stays equal or drops; accept an increase with a small fixed probability. Finds very short simple-cubic lattice configurations "in a few seconds". (Footnote 2: from lattice-minimal embeddings one can get minimal embeddings on FCC/BCC lattices [32].)
4. (p. 6–8) Off-lattice annealing with knot-type preserving moves, each accepted only if the swept triangles don't meet the rest of the polygon ("triangle checks", conservative floating-point predicates; failing moves rejected; final knot-type re-check): (a) fold move (Fig. 5): rotate vertex a of consecutive vertices o, a, p about line op by random angle; (b) length-decreasing move on four consecutive vertices o,a,b,p (rejected if |o−p|>2; else new vertex c with |o−c| = |c−p| = 1 in a random plane through op; Fig. 6 top); (c) length-increasing move on three consecutive vertices o,c,p → isosceles trapezoid o,a,b,p with |oa| = |ab| = |bp| = 1 (Fig. 6 bottom). Choose among moves uniformly at random; accept if edge count same/decreases, small fixed probability if it increases.
5. (p. 7) Last stage (edge lengths no longer fixed): keep rotation moves, replace edge-count-changing moves by "triangle-collapse" (delete c from o,c,p; rejected immediately if |o−p|² ≤ 1/8) and "triangle-inflation" (on adjacent o,p: choose unit vector r ⟂ op at random, (t,u) uniform in [−1/2, 3/2]×[0,1], c = o + t(p−o) + u r). Same acceptance rule.
6. (p. 8) Run on average ~10 min per knot, up to several hours; keep the polygon with the fewest edges.
7. (p. 8–9) Validation: for ≤ 13 crossings: pyknotid [58] → PD code → SnapPy [24] identify complement in census (all but two correct; exceptions 13n4587 and 13n4639, non-hyperbolic satellites); also Knoodle [54] simplify PD and compare with KnotInfo PD codes (incl. mirror/reverse symmetry), "For all 12 965 knot types in our experiment, Knoodle confirmed that our stick knots were isotopic to KnotInfo's PD codes." For > 13 crossings: Jones/Alexander polynomial checks (see above).
8. (p. 15–16) Equilateralisation of 9_29: see Theorem 4.
9. (p. 13, App. B) Large knots: diagram → lattice embedding (Fig. 11) → BFACF reduction (Fig. 12) → unit sticks (Fig. 13) → arbitrary sticks (Fig. 14).

## Tables
**Table 1 (p. 10)** — "Frequencies of different stick numbers, by crossing number." (rows c = crossing number, columns = stick number; verified on image; row sums reproduce the number of prime knots with c crossings: 1, 1, 2, 3, 7, 21, 49, 165, 552, 2176, 9988)

| c \ stick | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 |
|---|---|---|---|---|---|---|---|---|
| 3 | 1 | | | | | | | |
| 4 | | 1 | | | | | | |
| 5 | | | 2 | | | | | |
| 6 | | | 3 | | | | | |
| 7 | | | | 7 | | | | |
| 8 | | | 2 | 4 | 15 | | | |
| 9 | | | | 14 | 35 | | | |
| 10 | | | | | 94 | 71 | | |
| 11 | | | | | 160 | 362 | 30 | |
| 12 | | | | | 122 | 1156 | 898 | |
| 13 | | | | | 108 | 2397 | 6509 | 974 |

**Table 2 (p. 12)** — "Computed bounds for stick numbers of T_{q,3} torus knots. It would be interesting to find a formula or systematic construction of polygons that matches this data." (verified on image)

| q | 4 | 5 | 7 | 8 | 10 | 11 | 13 | 14 | 16 | 17 | 19 | 20 | 22 | 23 | 25 | 26 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| c[T_{q,3}] | 8 | 10 | 14 | 16 | 20 | 22 | 26 | 28 | 32 | 34 | 38 | 40 | 44 | 46 | 50 | 52 |
| stick[T_{q,3}] ≤ | 8 | 10 | 12 | 12 | 13 | 14 | 15 | 16 | 18 | 18 | 19 | 20 | 21 | 22 | 23 | 24 |

**Table 3 (p. 13)** — "Stick number bounds obtained by our algorithm for the twist knot K_p where p is the number of half-twists. The data is consistent with the conjecture stick[K_p] ≤ ⌊2p/3⌋ + 6." (verified on image)

| p | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
|---|---|---|---|---|---|---|---|---|---|---|
| c[K_p] | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 |
| stick[K_p] ≤ | 6 | 7 | 8 | 8 | 9 | 10 | 10 | 11 | 12 | 12 |

| p | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 |
|---|---|---|---|---|---|---|---|---|---|---|
| c[K_p] | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 |
| stick[K_p] ≤ | 13 | 14 | 14 | 15 | 16 | 16 | 17 | 18 | 18 | 19 |

**Appendix A table (pp. 18–19)** — "Stick Number Bounds for Prime Knots Through 10 Crossings": number of edges found for every knot in the Rolfsen table (upper bound on stick number). [n] = boxed (stick number known exactly, matches), ⟨n⟩ = bracketed (improves best previous upper bound), plain = matches best existing bound but stick number unknown. Transcribed from the images (pp. 18, 19), verified against Table 1 counts per crossing number.
- 3_1 [6]; 4_1 [7]; 5_1, 5_2 [8]; 6_1, 6_2, 6_3 [8]; 7_1–7_7 all [9].
- 8-crossing: 8_1–8_15: 10 (plain, 15 knots); 8_16, 8_17, 8_18: [9]; 8_19, 8_20: [8]; 8_21: [9]. (8 sticks: 2; 9: 4; 10: 15, matching Table 1.)
- 9-crossing: 10 plain: 9_1–9_5, 9_7–9_22, 9_24–9_28, 9_30–9_33, 9_37, 9_38; ⟨10⟩: 9_6, 9_23, 9_36; [9]: 9_29, 9_34, 9_35, 9_39–9_49. (9: 14; 10: 35 ✓.)
- 10-crossing, 11 edges plain: 10_1–10_7, 10_11–10_15, 10_20–10_30, 10_32, 10_34–10_36, 10_38–10_47, 10_49–10_51, 10_53–10_55, 10_57–10_59, 10_62–10_67, 10_69–10_75, 10_77–10_81, 10_88, 10_89, 10_95, 10_98, 10_99; ⟨11⟩: 10_37, 10_76 (total 71 ✓).
- 10-crossing, 10 edges plain: 10_8, 10_16–10_19, 10_48, 10_56, 10_68, 10_82–10_85, 10_90, 10_91, 10_93, 10_94, 10_100, 10_102–10_108, 10_109–10_122, 10_125–10_153, 10_155–10_165; ⟨10⟩: 10_9, 10_10, 10_31, 10_33, 10_52, 10_60, 10_61, 10_86, 10_87, 10_92, 10_96, 10_97, 10_101, 10_123, 10_154; [10]: 10_124 (the only boxed 10-crossing entry; total 10-edge = 94 ✓).
- ⚠ 17 bracketed 10-crossing entries in the appendix vs "18 of the 10-crossing knots" in the Introduction (p. 2).
- Extended table for all knots through 13 crossings is NOT in the PDF: "supplementary data… added to KnotInfo [39]"; coordinates in Harvard Dataverse [21].

**Figure 9 vertex coordinates (p. 15)** — equilateral 9-stick 9_29, printed vertex coordinates (x, y, z) per vertex (read as rows; vertex 9 = origin; consistent: |v1 − v9| = 1 and |v2 − v1| ≈ 1):

| v | x | y | z |
|---|---|---|---|
| 1 | −0.017 051 888 829 626 03 | −0.847 207 076 944 167 3 | 0.530 989 078 854 793 5 |
| 2 | 0.041 386 237 542 474 724 | 0.042 653 219 806 056 85 | 0.078 514 065 562 654 17 |
| 3 | −0.006 817 402 438 744 069 | −0.940 681 361 702 461 1 | 0.253 812 410 968 505 04 |
| 4 | −0.028 582 515 259 995 032 | −0.090 197 448 753 375 88 | 0.779 362 973 406 308 2 |
| 5 | 0.066 296 623 104 643 79 | −0.062 567 787 352 289 02 | −0.215 742 322 989 025 63 |
| 6 | 0.069 140 209 761 038 49 | −0.240 797 253 620 237 52 | 0.768 242 520 069 428 2 |
| 7 | −0.361 754 131 401 988 3 | −0.769 237 649 531 642 2 | 0.036 750 336 431 982 22 |
| 8 | 0.291 771 627 361 753 77 | −0.571 116 012 666 725 6 | 0.767 265 154 651 463 3 |
| 9 | 0 | 0 | 0 |

## Figures
- **Fig. 1 (p. 2)** — "10-stick realizations of 11n78 (left) and 13n5018 (right). Both are shown in orthographic perspective, viewed from the direction of the positive z-axis relative to the vertex coordinates given in the dataset [21]." *What it shows:* two ten-edge polygons, drawn as thick line figures. Image: ../figures/CRSS25/p02.png
- **Fig. 2 (p. 3)** — "A 10-stick 9_36 (left) and an 11-stick 10_37. For both knots this improves the previous best upper bound on stick number by 1…" Image: ../figures/CRSS25/p03.png
- **Fig. 3 (p. 5)** — pipeline on 9_29: lattice with 168 edges → near-minimal lattice with 58 edges → equilateral 10-stick → minimal 9-stick. Image: ../figures/CRSS25/p05.png
- **Fig. 4 (p. 6)** — BFACF deformation moves on the cubic lattice (edge + adjacent face, replace by complement). **Fig. 5 (p. 6)** — fold move: rotate apex a of triangle o, a, p about base edge op to a′. Image: ../figures/CRSS25/p06.png
- **Fig. 6 (p. 8)** — length-decreasing move (4 vertices → 3; top row) and length-increasing move (3 → 4 in an isosceles trapezoid; bottom row). Image: ../figures/CRSS25/p08.png
- **Fig. 7 (p. 11)** — pretzel knot P_4 = P(2,3,3,3,3), a reduced alternating diagram.
- **Fig. 8 (p. 14)** — four large untabulated knots with c and stick bounds (see numbers above); non-alternating (top), alternating (bottom). Image: ../figures/CRSS25/p14.png
- **Fig. 9 (p. 15)** — equilateral 9-stick 9_29 with vertex coordinates. Image: ../figures/CRSS25/p15.png
- **Fig. 10 (p. 20)** — initial diagrams of the four large knots. **Fig. 11 (p. 21)** — initial lattice embeddings with 9242 (90 corners), 25720 (156 corners), 9212 (100 corners), 34420 (208 corners) lattice edges (order as in Fig. 8: top row non-alternating, bottom row alternating; panel order of the captions on p. 21). **Fig. 12 (p. 22)** — reduced lattice embeddings with 174, 310, 186, 382 lattice edges. **Fig. 13 (p. 23)** — unit-stick embeddings with 26, 52, 28, 74 unit sticks. **Fig. 14 (p. 24)** — stick embeddings with 25, 40, 23, 48 sticks. Image (Fig. 14): ../figures/CRSS25/p24.png

## Stated limitations, open problems, future work
- p. 8: could not be absolutely sure of reaching the minimum stick number unless a lower bound is matched ("which was quite rare").
- p. 3–4: "In general, none of these configurations are guaranteed to be minimal" (p. 5 Fig. 3 caption).
- p. 12: no explicit formula for the T_{q,3} data (Table 2): "It would be interesting to find a formula or systematic construction."
- p. 13: "it seem[s] interesting to try to find polygonal versions of [P_m] with fewer sticks. We hope that someone will try." Conjecture 3 (above).
- p. 14: distribution of stick[K] over prime knots with a given crossing number is unknown; "one could collect data on this distribution for all prime knot types through 20 crossings" using Burton [12] and Thistlethwaite [59].
- p. 15: open whether equilateral stick number is a distinct invariant from stick number; "It seems unlikely that stick number and equilateral stick number are always the same, but it remains a substantial challenge to find a specific knot on which they differ." (p. 16)
- p. 3: stick[K] ≤ c[K] observed for every knot examined with ≥ 12 crossings; β_* = 1 may be the lowest value for which Theorem 2 holds.
- p. 9: for > 13 crossings only invariant-based (weaker) knot-type checks.

## References worth following
- [1] Adams, Brennan, Greilsheimer, Woo, Stick numbers and composition of knots and links, JKTR 6 (1997) (stick[T_{p+1,p}] = 2p+2).
- [14] Calvo, Geometric knot spaces and polygonal isotopy, JKTR 10 (2001) (lower bound √2√(c+1/8)+7/2); [46] Negami, Ramsey theorems for knots, links and spatial graphs, TAMS 324 (1991).
- [31] Huh, Oh, An upper bound on stick number of knots, JKTR 20 (2011) (stick ≤ 3c/2 + 3/2); [30] Huh, No, Oh, Stick numbers of 2-bridge knots and links, PAMS 139 (2011).
- [35] Johnson, Mills, Trapp, Stick and Ramsey numbers of torus links, JKTR 22 (2013).
- [34] Jin, Polygon indices and superbridge indices of torus knots and links, JKTR 6 (1997); [37] Kuiper, A new knot invariant, Math. Ann. 278 (1987).
- [43] Millett, Rawdon, Energy, ropelength, and other physical aspects of equilateral knots, J Comput Phys 186 (2003) (equilateral criterion Eq. 4).
- [45] Musick, Minimal bridge projections for 11-crossing prime knots (arXiv:1208.4233); [8] Blair, Kjuchukova, Morrison, Coxeter quotients of knot groups through 16 crossings, Exp. Math. 34 (2025).
- [49] Rawdon, Scharein, Upper bounds for equilateral stick numbers (2002); [51] Scharein thesis 1998; [13] Calvo thesis 1998.
- [28] Eddy, Shonkwiler, New stick number bounds from random sampling of confined polygons, Exp. Math. 31 (2022); [50] Rechnitzer, minimal lattice knots page (2011); [53] Scharein et al. 2009.
- [33] Janse van Rensburg, Whittington, The BFACF algorithm and knotted polygons (BFACF preserves knot type).

## Extraction notes
- Pages rendered: 2, 3, 5, 6, 8, 10, 12, 13, 14, 15, 18, 24. Tables 1–3 and Appendix A (pp. 18–19) read from images; Fig. 9 coordinates read from the image (rows as vertices); figures other than 9 only described from captions.
- ⚠ Intro "18 of the 10-crossing knots" vs 17 bracketed entries in Appendix A; Millett–Rawdon expression in Theorem 4 proof (the text layer lost the fraction; "µ(P)²/n⁴" read with n = 9 on p. 16); the proof states |L_i − 1| < 10^{−7.58} min(…), which is an expression of the margin.
- The full 12 965-knot table (through 13 crossings) is only in supplementary data / KnotInfo, not in the PDF.
