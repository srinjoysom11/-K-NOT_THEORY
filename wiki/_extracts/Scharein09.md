# Scharein09 — Bounds for the minimum step number of knots in the simple cubic lattice
- **Authors:** R Scharein, K Ishihara, J Arsuaga, Y Diao, K Shimokawa, M Vazquez
- **Venue / year / identifiers:** J. Phys. A: Math. Theor. 42 (2009) 475006 (24pp), doi:10.1088/1751-8113/42/47/475006; received 10 June 2009, final form 22 September 2009, published 9 November 2009
- **File:** papers/scharein2009.pdf   **Pages:** 25 (p. 1 is an IOPscience cover sheet; printed page k = PDF page k+1)
- **Text layer:** ok (appendix tables flattened; already transcribed to CSV)

## Abstract
Knots are found in DNA as well as in proteins, and they have been shown to be good tools for structural analysis of these molecules. An important parameter to consider in the artificial construction of these molecules is the minimum number of monomers needed to make a knot. Here we address this problem by characterizing, both analytically and numerically, the minimum length (also called minimum step number) needed to form a particular knot in the simple cubic lattice. Our analytical work is based on improvement of a method introduced by Diao to enumerate conformations of a given knot type for a fixed length. This method allows us to extend the previously known result on the minimum step number of the trefoil knot 3_1 (which is 24) to the knots 4_1 and 5_1 and show that the minimum step numbers for the 4_1 and 5_1 knots are 30 and 34, respectively. Using an independent method based on the BFACF algorithm, we provide a complete list of numerical estimates (upper bounds) of the minimum step numbers for prime knots up to ten crossings, which are improvements over current published numerical results. We enumerate all minimum lattice knots of a given type and partition them into classes defined by BFACF type 0 moves.

## Notation and conventions
- Step = unit lattice segment; x-, y-, z-steps by direction. Minimum step number = least number of steps of a lattice polygon of type K (p. 3–4).
- **Definition 1 (p. 4).** Two lattice polygons are equivalent if they can be superimposed by a rigid motion (translations, rotations and reflections); the class is a *canonical lattice polygon*. Orientation not considered. ⚠ In §4 reflections are only applied for achiral knots (p. 8), so for chiral knots the classes are effectively up to rotation + translation.
- a, b, c = numbers of x, y, z steps, WLOG c ≥ max{a, b}; π = projection along z; G = π(K) weighted planar graph; m(e), m(v) multiplicities; total multiplicity m = a + b ≤ 2n/3 (p. 4).
- **Definition 2 (p. 5).** Reducible: step number can be reduced by type 0 and −2 moves only; otherwise irreducible. Minimal ⇒ irreducible, not conversely.
- **Definition 3 (p. 9).** Type 0 equivalent: related by a finite sequence of BFACF type 0 moves. **Definition 4.** Taut: no type 0 move applies (type 0 class has one element).
- NEWSUD strings; *standard form* = lexicographically least among 24 rotations × n shifts × 2 orientations (reverse = reverse string and swap N↔S, E↔W, U↔D), plus reflections for achiral knots (p. 8).
- Table A1 columns: S = min step bound, R = canonical polygons found in phase 1, E = after phases 1+2, C = number of type 0 classes. Table A2: S = min stick bound, C = number of conformations; superscript k = improvement from the separate stick search.

## Numbered statements
- **Theorem 1 [20] (p. 4).** Any two lattice polygons of the same knot type are related by a finite sequence of BFACF moves (type 0, 2, −2). Quoted (Janse van Rensburg–Whittington 1991).
- **Theorem 2 (p. 5).** The minimum step number of 4_1 is 30 and the minimum step number of 5_1 is 34. *Proof outlined here; full proofs in [16, 17] ("will be reported elsewhere").*
- **Proposition 1 (p. 5).** Let K be an irreducible lattice polygon with n steps of a nontrivial prime knot type. Then G = π(K) is contained in rectangles of size (k/2 + 1) × ((n − 2k)/8 + 1) for an integer k with 2 ≤ k ≤ n/6. (Follows from Prop. 2.)
- **Proposition 2 (p. 6).** Let K be an irreducible lattice polygon with n steps of nontrivial prime knot type. Then K is contained in boxes of size (k/2 + 1) × (l/2 + 1) × ((n − 2(k+l))/4 + 1) for integers k and l where 2 ≤ k ≤ n/6 and k ≤ l ≤ (n − 2k)/4. *Proved here.* Proof idea: if a plane z = a (a half-integer) meets K in exactly 2 points then a neighbouring plane is empty (else composite or reducible), so interior planes meet K in ≥ 4 points; hence s_i ≥ 4D_i(K) − 4, D_i ≤ s_i/4 + 1; with s_x = 2k ≤ s_y = 2l ≤ s_z; k = 1 would be 1-bridge hence trivial.
- **Proposition 3 [17] (p. 6).** Let e be an edge of G with end points v_1, v_2. If 2m(e) ≥ m(v_1) and 2m(e) > m(v_2), then K is reducible. *Quoted; proof not given.*
- **Proposition 4 [17] (p. 6).** c(K) ≤ Σ_{v∈G} T(m(v)/2) − Σ_{e∈G} T(m(e)) + 3(f − 1), where T(x) = (x−2)(x−3)/2 and f is the number of faces of G. *Quoted; proof not given.* Sharp (= 4) for the Fig. 1 graph, which therefore cannot carry 5_1.

## Key equations and quantitative claims outside numbered statements
- p. 3: [9] (Diao 1993) proved minimum step number 24 for any nontrivial knot, attained only by the trefoil.
- p. 7: Proof outline for 4_1: polygons ≤ 24 steps are trivial or trefoil [9, 10]; irreducible nontrivial K with n = 26 or 28 has a projection with total multiplicity ≤ 18, inside a 2 × 4 or 3 × 3 rectangle, ≤ 6 faces (Euler characteristic); Props 2–4 prune; remaining realizations are trivial or trefoil. 5_1 "follows the same steps but the calculations are more involved".
- p. 8: BFACF move probabilities p(0) = (1 + z²)/(2(1 + 3z²)), p(2) = z²/(1 + 3z²), p(−2) = 1/(1 + 3z²); 0 ≤ z ≤ z_c = 0.2134 ("inverse of the connective constant").
- p. 9: run schedule: z uniform in (0, 0.2) for 100 000 iterations, then 60 000 iterations at z = 0.02; cycle repeated 100 times ("quite arbitrary").
- p. 10–11 (§5.1): **75 canonical trefoils** in **3 type-0 classes** (1-1…1-18, 2-1…2-56, 3-1); 3-1 is taut. 27 canonical polygons missing from [10] (Diao94), some of [10]'s counted twice. 75 × 24 = 1800 → 1664 distinct after removing symmetric duplicates → ×2 reflections = **3328, "not 3496 as reported in [10]"**.
- p. 11 (§5.2–5.3): 4_1 has 76 canonical polygons, 5_1 has 142; totals up to translation 1664, 1824, 3336 for 3_1, 4_1, 5_1 (one chirality), doubled for chiral knots ⇒ **3328, 1824, 6672**.
- p. 12 (§5.5): one canonical polygon only for 8_3, 8_7, 9_31, 10_72, 10_123; ~2000 for 8_2; 152 374 for 10_140; 5_2 has 2362 ⚠ (Table A1 prints 2 396 for 5_2; conclusion p. 13 says 2362).
- p. 12 (§5.6): stick-number search: z random in (0.13, 0.19), 100 000 BFACF iterations, then all possible −2 moves, count direction changes; repeated up to several hours. New minimum-stick candidates for 5_1, 5_2, 6_1, 6_3, 7_2–7_7, 8_2, 8_3, 8_4, 8_5, 8_7, 8_19, 10_27. Confirms 3_1 = 12, 4_1 = 14 [14].
- p. 13: "non-alternating knots generally require less steps".

## Methods / algorithms
Minimum Step Algorithm ([9], p. 5) with refinements (p. 6):
0. (new) Enumerate all rectangles in Z² satisfying Prop. 1.
1′. For each rectangle, enumerate weighted planar graphs with total multiplicity ≤ 2n/3 (each edge weight ≥ 1).
2. For each graph, generate all knot diagrams projecting onto it.
3. For each diagram enumerate lattice realizations with ≤ n steps and determine knot type. Props 3–4 discard reducible / low-crossing graphs.

Numerical search (p. 8–9):
- Phase 1: BFACF on a fixed-type polygon, alternating high/low z; keep the shortest; discard if longer than current bound; standardize; add new canonical polygons to the list.
- Phase 2 (expansion): exhaustive type-0-only BFACF from every found polygon; keep new canonical polygons. Needed for some 9- and 10-crossing knots.
- Standardization algorithm as in Notation (24 rotations, all shifts, both orientations, reflections if achiral; lexicographically least). Example: UENNWWSWDDEEUUUNWWDDESSE → DDDEEUUWSWWNNEDESSEUUWWN.

## Tables
- **Table 1 (p. 10)** — "The 27 canonical lattice polygons missing from [10]." Labels: 1-1…1-6, 2-1, 2-6, 2-7, 2-11, 2-12, 2-16, 2-17, 2-21, 2-22, 2-23, 2-24, 2-28, 2-29, 2-32, 2-33, 2-35, 2-48, 2-49, 2-50, 2-54, 3-1 (words identical to the same labels in Table A3; see CSV).
- **Table 2 (p. 12)** — "Numerical estimates on n, the number of prime knot types realizable by a lattice polygon with step number up to s."

| s | 4 | 24 | 30 | 34 | 36 | 40 | 42 | 44 | 46 | 48 | 50 | 52 | 54 | 56 | 58 | 60 | 62 | 64 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| n | 1 | 2 | 3 | 4 | 5 | 8 | 9 | 14 | 18 | 22 | 40 | 49 | 74 | 119 | 130 | 175 | 244 | 250 |

- **Table 3 (p. 12)** — "Crossing numbers and minimum step numbers of prime knots"

| Crossing number | Alternating | Non-alternating |
|---|---|---|
| 3 | 24 | – |
| 4 | 30 | – |
| 5 | 34–36 | – |
| 6 | 40 | – |
| 7 | 44–46 | – |
| 8 | 48–52 | 42–46 |
| 9 | 54–58 | 48–52 |
| 10 | 58–64 | 48–58 |

- **Table A1 (pp. 13–15)** — min step bounds S, R, E, C for all 249 prime knots ≤ 10 crossings: `wiki/data/scharein2009_tableA1_min_step.csv`; rendered as [../lattice-length/tables-minimal-length.md](../lattice-length/tables-minimal-length.md).
- **Table A2 (pp. 15–16)** — min lattice stick number bounds: `wiki/data/scharein2009_tableA2_lattice_stick.csv`.
- **Table A3 (pp. 16–25)** — the 75 canonical 24-step trefoils with drawings: `wiki/data/scharein2009_tableA3_trefoil_24_canonical.csv`.
- **Table A4** — mentioned on p. 3 ("tables A1–A4") ⚠ not found in the PDF; the appendix after Table A3 contains example NEWSUD words per knot (per p. 10) — not transcribed.

## Figures
- **Fig. 1 (p. 4)** — Three knot diagrams obtained from one weighted graph G. Image: ../figures/Scharein09/p04.png
- **Fig. 2 (p. 5)** — BFACF type 0, 2, −2 moves (open circle = unoccupied site). Image: ../figures/Scharein09/p05.png
- **Fig. 3 (p. 7)** — Weighted graph with edge e satisfying Prop. 3 (m(e) = 4, m(v_1) = 8, m(v_2) = 6), a 3D conformation showing reducibility, and a second graph with m(e) = 6. Image: ../figures/Scharein09/p07.png
- **Fig. 4 (p. 7)** — Realizations of 4_1 and 5_1 with 30 and 34 steps (KnotPlot). Image: ../figures/Scharein09/p07.png
- **Fig. 5 (p. 10)** — Standard lattice polygons 1-1, 2-1, 3-1 (projections not recorded in [10]). Image: ../figures/Scharein09/p10.png
- Drawings of all 75 trefoils follow Table A3 (pp. 16–25). Images: ../figures/Scharein09/p16.png, p17.png

## Stated limitations, open problems, future work
- p. 3: all numbers except 3_1, 4_1, 5_1 "are only upper bounds … since they have not been analytically proved"; "we expect most of these numbers to be very close to the corresponding minimum step numbers (if not already the minima)".
- p. 13: enumeration-based methods will be hard to extend to knots with many realizations "such as the 5_2 knot, which has 2362 canonical lattice polygons. More powerful analytical results will be needed".
- p. 12: there exist minimum-stick representatives that are not minimum-step polygons.

## References worth following
- [9] Diao Y 1993 Minimal knotted polygons on the cubic lattice, JKTR 2 413–425.
- [10] Diao Y 1994 The number of smallest knots on the cubic lattice, J. Stat. Phys. 74 1247–1254.
- [14] cited for the lattice stick numbers 3_1 = 12, 4_1 = 14 (reference entry not transcribed).
- [16, 17] Ishihara, Shimokawa et al., full proofs of Theorem 2 and Props 3–4 (to appear).
- [18] Janse van Rensburg E J 1999 Minimal lattice knots, in *Ideal Knots*.
- [20] Janse van Rensburg E J, Whittington S G 1991 The BFACF algorithm and knotted polygons, J. Phys. A 24 5553.
- [23] Madras N, Slade G, *The Self-Avoiding Walk* (BFACF description).

## Extraction notes
- Written by the wiki author directly. Props 1–4 and Theorem 2 checked against 110-dpi renders of pp. 5–6 (11 Nov 2026). Tables A1–A3 were transcribed earlier to CSV (see wiki/data); Tables 2–3 from text layer (simple, unambiguous).
- ⚠ 5_2 canonical count: 2 396 (Table A1, both R and E) vs 2362 (p. 13 text).
- ⚠ "tables A1–A4" on p. 3 but no Table A4 heading found.
- Figure pages rendered: 4, 5, 6, 7, 10, 12, 16, 17.
