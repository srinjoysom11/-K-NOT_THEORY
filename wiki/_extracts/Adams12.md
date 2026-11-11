# Adams12 — Stick Index of Knots and Links in the Cubic Lattice
- **Authors:** Colin Adams, Michelle Chu, Thomas Crawford, Stephanie Jensen, Kyler Siegel, Liyang Zhang
- **Venue / year / identifiers:** arXiv:1205.5256v1 [math.GT] 23 May 2012 (header "Date: November 6, 2018"). 2000 MSC 57M50.
- **File:** papers/4_links/Adams-et-al_2012_Stick_index_knots_links_cubic_lattice_1205.5256.pdf   **Pages:** 16
- **Text layer:** ok

## Abstract
The cubic lattice stick index of a knot type is the least number of sticks necessary to construct the knot type in the 3-dimensional cubic lattice. We present the cubic lattice stick index of various knots and links, including all (p, p+1)-torus knots, and show how composing and taking satellites can be used to obtain the cubic lattice stick index for a relatively large infinite class of knots. Additionally, we present several bounds relating cubic lattice stick index to other known invariants.

## Notation and conventions
- Lattice: "the 3-dimensional cubic lattice (ℝ×ℤ×ℤ) ∪ (ℤ×ℝ×ℤ) ∪ (ℤ×ℤ×ℝ)" (p. 1). "Throughout, we will let K represent a fixed conformation of a knot and [K] the collection of all conformations of a given knot type" (p. 1).
- **Definition 1 (p. 1).** "A *stick* of a lattice stick conformation K is a maximal line segment of K in ℝ³ … An *x-stick* of K is a stick parallel to the x-axis." y-, z-sticks similarly.
- **Definition 2 (p. 1–2).** "The *lattice stick number* s_CL(K) of a lattice stick conformation K is the number of constituent sticks of K. We minimize s_CL(K) over all lattice stick conformations K ∈ [K] and we call this number the *lattice stick index* s_CL[K] of the knot type [K]. A lattice stick conformation realizing this minimum is called a *minimal lattice conformation*." (Note: s_CL(K) = conformation; s_CL[K] = invariant. Section 6 title/Thm 6.1 also uses "lattice stick number" for links' invariant.)
- **Definition 3 (p. 2).** Bridge index b[K] = min_{K∈[K]} min_{v∈S²} (# of local maxima when K is projected to v).
- **Definition 4 (p. 4).** Clean L / exterior L: S = four consecutive sticks s1,s2,s3,s4, s1 ∥ s4, s2 ⊥ s3 and both ⊥ s1,s4; R = closed rectangle with two edges given by s2, s3. "If s1 and s4 lie to the same side of the plane containing R and R ∩ K ⊂ S, we call S a *clean L* of K. If in addition K is entirely contained in one of the two closed half-spaces defined by the plane containing R, we call S an *exterior L*."
- **Definition 5 (p. 6).** A stick S has torsion π/2 if, looking down S, the projections of the adjacent sticks form an angle π/2 ("torsion stick"). Every lattice conformation of a nontrivial knot has at least two torsion sticks.
- J_n (p. 6): n-component link formed by duplicating a minimal lattice conformation J of [J] (n−1) times, translating each copy by (1,1,−1) from the previous.
- **Definition 6 (p. 6).** Permutation word: braid word in which any two strings cross at most once and all crossings in the same direction (equivalently a positive or negative braid).
- **Definition 7 (p. 6).** K "differs from J_n by a permutation word ω" if there exist n parallel sticks of J_n (translates of a single stick of J, giving a trivial braid) which, replaced by ω, yield K.
- |P_x|, |P_y|, |P_z| = number of x, y, z sticks (p. 7). *Properly leveled* (p. 8): vertices in {1,…,|P_x|}×{1,…,|P_y|}×{1,…,|P_z|}, exactly two x-stick endpoints at each level x=i; for links with C_x trivial components in planes ⊥ x-axis, levels x = 1,…,|P_x|+C_x, each containing either two endpoints of x-sticks or a component.
- c[K] crossing index (abbrev. c); α[K] arc index (Definition 8, p. 10: least number of pages in an arc presentation).
- Link names in Table 1 are Rolfsen-style n^μ_k (e.g. 6^3_2 = 6 crossings, 3 components, number 2).

## Numbered statements
**Lemma 2.1 (p. 2).** s_CL[K] ≥ 6b[K]. (Also found by Promislow and van Rensburg [10].) Concerns: knots (nontrivial; p. 12 says it "holds only for nontrivial knots, which cannot lie entirely in a plane").
Proof idea: a minimal conformation has at least b[K] local maxima in each of x, y, z; each local z-maximum gives two distinct z-sticks, so ≥ 2b[K] sticks in each direction. Remark (p. 3): with exactly 6b[K] sticks, each stick connects a local min to a local max in its own direction and lies at a local extremum in the other two directions.

**Theorem 2.2 (p. 3).** Knots 8_20, 8_21, and 9_46 all have lattice stick index 18. [proved here; knots]
Proof idea: all are 3-bridge; Lemma 2.1 + Figure 1 constructions.

**Theorem 2.3 (p. 3).** s_CL[T_{p,p+1}] = 6p for p ≥ 2. [proved here; knots; (p,p+1)-torus knots]
Proof idea: b[T_{p,p+1}] = p [11]; Figure 2 pattern gives 6p sticks.

**Theorem 3.1 (p. 4).** Let K1 and K2 be minimal lattice conformations realizing s_CL[K_i] = 6b[K_i] for i = 1,2 such that K1 has an exterior L and K2 has a clean L. Then s_CL[K1#K2] = s_CL[K1] + s_CL[K2] − 6. [proved here; knots]
Proof idea: uses Schubert b[K1#K2] = b[K1]+b[K2]−1; expand K2 in five half-spaces, scale so rectangles R1, R2 coincide, remove R1, R2 and consolidate remaining four sticks of L1, L2 into two z-sticks (Fig. 3); minimal by Lemma 2.1.

**Corollary 3.2 (p. 5).** For K1,…,Kn minimal lattice knot conformations realizing s_CL[K_i] = 6b[K_i] for i = 1,…,n each possessing one exterior L and at least one other clean L, s_CL[K1#…#Kn] = s_CL[K1] + ⋯ + s_CL[Kn] − 6(n−1). [by induction; knots]

**Proposition 4.1 (p. 6).** Satellite knots K that differ from J_n by a single permutation word ω have cubic lattice stick index 6nb[J]. [proved here; knots; companion [J] with s_CL[J] = 6b[J] assumed in section intro, p. 5]
Proof idea: b[K] ≥ nb[J] [11] gives lower bound; J_n has 6nb[J] sticks; at a torsion stick a, extend/shorten b_i and c_j by j−i units and connect with a vertical stick (Figs. 4–5).

**Corollary 4.2 (p. 7).** Let S_n be the collection of knots which differ from J_n by at most one permutation word for each torsion stick of J. All knots in S_n have cubic lattice stick index 6nb[J].

**Remark 5.1 (p. 8–9).** For a properly leveled lattice link K with z-projection P, slight y-translations of x-sticks projecting to the same line (and analogously for y-sticks) give a link diagram P′, a z-projection of a slight perturbation of K, with z-stick images very short and not involved in any crossings (Fig. 7).

**Theorem 5.1 (p. 9).** s_CL[K] ≥ 3√(c[K] + 2). [proved here; knots]
Proof idea: c ≤ |P_x||P_y|, with |P_x|+|P_y| ≤ 2s_CL/3, giving c ≤ s_CL²/9; at least two x-/y-stick pairs adjacent (directly or via a z-stick) cannot cross, so c ≤ s_CL²/9 − 2 (eq. 5.1); invert.

**Lemma 5.2 (p. 10).** s_CL[K] ≤ 6α[K] − 16. [proved here; knots; holds when there are ≥ 7 pages; for fewer pages only trefoil and figure-eight arise, which "have lattice stick conformations that beat this bound" (p. 11)]
Proof idea: arc presentation with z binding axis; first three pages at θ = π/2, π, 3π/2, each realized by three sticks; count (3)(3)+2+4+5+5+1+6(α−7) = 6α−16 (p. 11).

**Corollary 5.3 (p. 12).** s_CL[K] ≤ 6c[K] − 4. [from Lemma 5.2 and α ≤ c+2 [1]]

**Theorem 6.1 (p. 12).** The lattice stick number of certain links are as listed in Table 1. [proved here; links]
Values: 0^2_1 = 8, 2^2_1 = 8, 7^2_7 = 16, 8^2_15 = 18, 8^2_16 = 18, 6^3_2 = 12, 6^3_3 = 12.
Proof idea: s_CL[L] ≥ s_CL[K1] + ⋯ + s_CL[Kn] for components K_i, plus Figure 9 conformations. (6b bound does not hold for arbitrary links as components may be planar.)

**Proposition 6.2 (p. 12).** Let L be a two-component link conformation with linking number n and suppose that one of the components is entirely contained in a plane. Then the number of sticks in the conformation is at least 4n + 4. [links]
Proof idea: K2 crosses K1 under (inside→outside) ≥ n times and over (outside→inside) ≥ n times; each stick contributes at most 1/2 to linking number, so ≥ 2n xy-sticks plus a z-stick between consecutive xy-sticks (p. 13).

**Corollary 6.3 (p. 13).** Let n be the linking number of a 2-braid link. Then the two-braid links, excluding 4^2_1 and 6^2_1, can be realized with 4n + 4 sticks. [links; upper bound by construction, Hopf link with 8 sticks, Figure 10]

**Lemma 6.4 (p. 13).** Let L be a two-component cubic lattice link conformation with linking number n = 2 or 3 and suppose that one of the components lies entirely in a plane. Then the number of sticks in the conformation is at least 4n + 5. [links]

**Theorem 6.5 (p. 14).** The lattice stick index of 4^2_1 is 13. [proved here; link]
Proof idea: linking number 2; with ≤ 12 sticks neither component may be planar (Lemma 6.4), so both are 6-stick unknots of the two types in Figure 11; each of the four xy-sticks of K2 must contribute 1/2, forcing all four inner endpoints to project to the same xy point, impossible; Figure 12 gives 13.

## Key equations and quantitative claims outside numbered statements
- Previously known (p. 2, quoted): s_CL[3_1] = 12 (Diao 1993 [3]); s_CL[9_47] = 18 (Promislow–van Rensburg 1999 [10]) ⚠ as printed; s_CL[4_1] = 14 (Huh–Oh 2005 [8]); Huh–Oh 2010 [7]: trefoil and figure eight are the only knots with lattice stick index less than 15.
- b[K1#K2] = b[K1] + b[K2] − 1 (Schubert [11], p. 4); b[T_{p,p+1}] = p ([11], p. 3); b[K] ≥ nb[J] for these satellites ([11], p. 6).
- c ≤ |P_x||P_y| (p. 9); c ≤ s_CL²/9 − 2 (eq. 5.1, p. 10).
- α ≤ c + 2 (from Bae–Park [1], p. 11).
- Figure 6 example (p. 8): "A 2-string satellite of (a 5-string satellite of 3_1 composed with the (4,5)-torus knot composed with a 2-string satellite of 9_46) with cubic lattice stick index 216."
- Remark p. 13: Hopf link realizable with 8 sticks; exceptions 4^2_1 and 6^2_1 have linking numbers 2 and 3.
- Six-stick lattice unknots: "the two constructions shown in Figure 11 are the only possible 6-stick lattice conformations up to rotation and changing the lengths of sticks" (p. 15).

## Methods / algorithms
Pure math; constructions:
1. Lower bounds from bridge index (Lemma 2.1), crossing number via projection (Thm 5.1), sum over components for links (Thm 6.1 proof), linking number counting for planar component (Prop 6.2, Lemma 6.4).
2. Upper bounds by explicit conformations (Figs. 1, 2, 9, 10, 12).
3. Composition (p. 4–5): Step 1 expand K2 in half-space z ≥ 0 by n0 (no x/y-sticks in 0 < z ≤ n0); Step 2 expand in half-spaces S1..S4 bounded by planes P1..P4 through edges of R2; Step 3 place K1 in z ≥ 0 with R1 at z = 0, scale so R1, R2 equal squares; Step 4 remove R1, R2, merge remaining four sticks into two z-sticks (−6 sticks).
4. Satellites (p. 6–7): J_n via translates by (1,1,−1); at a torsion stick a, re-route b_i to c_j by length change j−i and a vertical stick.
5. Arc presentation → lattice (p. 10–11): binding axis = z-axis; pages ordered by angle; first three pages at π/2, π, 3π/2; each subsequent arc uses x, y, z, y, x sticks plus a short z-stick; total 6α − 16.

## Tables
**Table 1 (p. 12).** "Lattice stick index of certain links." (verified against page image)

| Links | s_CL |
|---|---|
| 0^2_1 | 8 |
| 2^2_1 | 8 |
| 7^2_7 | 16 |
| 8^2_15 | 18 |
| 8^2_16 | 18 |
| 6^3_2 | 12 |
| 6^3_3 | 12 |

Additional link value outside table: 4^2_1 → 13 (Theorem 6.5).

## Figures
- **Fig. 1 (p. 3)** — "Minimal lattice conformations of 8_20, 8_21, and 9_46." *What it shows:* three 18-stick lattice knot drawings in perspective. Image: ../figures/Adams12/p03.png
- **Fig. 2 (p. 4)** — "Minimal lattice conformations of T_{2,3}, T_{3,4}, and T_{4,5}." *What it shows:* nested staircase-like lattice conformations of growing size showing the 6p pattern. Image: ../figures/Adams12/p04.png
- **Fig. 3 (p. 5)** — "Gluing L1 and L2 by eliminating 6 sticks." *What it shows:* two annular (shaded) regions each containing an L of sticks, illustrating gluing. Image: ../figures/Adams12/p05.png
- **Fig. 4 (p. 7)** — "Projection to the plane perpendicular to a." *What it shows:* parallel sticks b1…bn and c1…cn meeting in a rounded box. Image: ../figures/Adams12/p07.png
- **Fig. 5 (p. 7)** — "Permutation given ω(b1) = c_i and ω(b_i) = c1." *What it shows:* same box with rerouted sticks realising a permutation. Image: ../figures/Adams12/p07.png
- **Fig. 6 (p. 8)** — "A 2-string satellite of (a 5-string satellite of 3_1 composed with the (4,5)-torus knot composed with a 2-string satellite of 9_46) with cubic lattice stick index 216." *What it shows:* large lattice drawing with multi-strand bundles. Image: ../figures/Adams12/p08.png
- **Fig. 7 (p. 9)** — "Perturbing a primary projection." *What it shows:* overlapping projected sticks before/after small translation. (page not rendered)
- **Fig. 8 (p. 11)** — "Constructing a cubic lattice conformation from an arc presentation." *What it shows:* half-plane pages P1–P4 around the z-axis with lattice arcs. Image: ../figures/Adams12/p11.png
- **Fig. 9 (p. 13)** — "Minimal lattice conformations of links 0^2_1, 2^2_1, 7^2_7, 8^2_15, 8^2_16, 6^3_2, 6^3_3." *What it shows:* seven lattice link drawings (3 + 2 + 2 rows). Image: ../figures/Adams12/p13.png
- **Fig. 10 (p. 14)** — "Two-braid link with linking number 6." *What it shows:* a planar rectangle component with a second component weaving through it. Image: ../figures/Adams12/p14.png
- **Fig. 11 (p. 15)** — "Six stick trivial components." *What it shows:* the two non-planar 6-stick lattice unknots. Image: ../figures/Adams12/p15.png
- **Fig. 12 (p. 15)** — "Minimal lattice conformation of link 4^2_1." *What it shows:* 13-stick two-component link. Image: ../figures/Adams12/p15.png

## Stated limitations, open problems, future work
- Lemma 2.1 bound "holds only for nontrivial knots, which cannot lie entirely in a plane. As a consequence, this bound does *not* necessarily hold for arbitrary links, since one or more of the components may be contained in planes." (p. 12)
- Lemma 5.2 needs at least seven pages; fewer pages only give trefoil and figure-eight (p. 11).
- Corollary 6.3 excludes 4^2_1 and 6^2_1 (p. 13); 6^2_1's index is not determined in the paper.
- No explicit open-problems section.

## References worth following
- [1] Y. Bae, C. Y. Park, An upper bound of arc index of links, Math. Proc. Cambridge Philos. Soc. 129 (2000) 491–500.
- [3] Y. Diao, Minimal knotted polygons on the cubic lattice, J. Knot Theory Ramifications 2 (1993) 413–425.
- [7] Y. Huh, S. Oh, Knots with small lattice stick number, J. Phys. A 43 (2010) 265002.
- [8] Y. Huh, S. Oh, The lattice stick numbers of small knots, J. Knot Theory Ramifications 14 (2005) 859–868.
- [10] E. J. Janse van Rensburg, S. D. Promislow, The curvature of lattice knots, J. Knot Theory Ramifications 8 (1999) 463–490.
- [11] H. Schubert, Über eine numerische Knoteninvariante, Math. Z. 61 (1954) 245–288.

## Extraction notes
- All 16 pages read as images. Table 1 checked cell by cell against p. 12 image.
- ⚠ p. 2 states "Promislow and Rensburg proved that s_CL[9_47] = 18 ([10])" — transcribed as printed.
- ⚠ Theorem 5.1 and Theorem 6.5 numbering: there is both "Remark 5.1" and "Theorem 5.1" in Section 5 (as printed).
- Status of Theorem 6.1 values: proved here (lower bound = sum of component indices; upper bound = Fig. 9). Fig. 7 page (p. 9) not rendered (minor diagram).
