# Diao19 — Braid Index Bounds Ropelength from Below
- **Authors:** Yuanan Diao (Department of Mathematics and Statistics, University of North Carolina Charlotte)
- **Venue / year / identifiers:** arXiv:1901.10663v1 [math.GT], 30 Jan 2019. 2010 MSC: Primary 57M25; Secondary 57M27. (Cited in Diao22 as JKTR 29 (4) (2020), 2050019.)
- **File:** papers/3_analytic_bounds/Diao_2019_Braid_index_bounds_ropelength_below_1901.10663.pdf   **Pages:** 7
- **Text layer:** ok

## Abstract
For an un-oriented link 𝒦, let L(𝒦) be the ropelength of 𝒦. It is known that when 𝒦 has more than one component, different orientations of the components of 𝒦 may result in different braid index. We define the largest braid index among all braid indices corresponding to all possible orientation assignments of 𝒦 the *absolute braid index* of 𝒦 and denote it by **B**(𝒦). In this paper, we show that there exists a constant a > 0 such that L(𝒦) ≥ a**B**(𝒦) for any 𝒦, *i.e.*, the ropelength of any link is bounded below by its absolute braid index (up to a constant factor).

## Notation and conventions
- **Ropelength L(𝒦)** (p. 1): "defined (intuitively) as the minimum length of a unit thickness rope that can be used to tie the link." ⚠ Radius vs diameter not specified. The final constant comes from L_c(𝒦) < 14L(𝒦) quoted from [9] (Diao–Ernst–Janse van Rensburg 2002), so the convention is that of [9]. The intro quotes L(𝒦) ≥ 31.32 for nontrivial knots [4] and L(𝒦) ≥ 1.105(Cr(𝒦))^{3/4} [1,2] (these numbers correspond to the length/diameter convention of the cited works — the paper itself does not say so).
- **Cr(𝒦)**: minimum crossing number of the un-oriented link 𝒦 (p. 1).
- **Absolute braid index B(𝒦)** (p. 1): "the largest braid index among all braid indices corresponding to different orientation assignments of 𝒦." **b(𝒦)**: braid index of an oriented link; **b(𝒟)**, **s(𝒟)**: braid index / number of Seifert circles of diagram 𝒟.
- **Lattice** (p. 4): 𝒦_c a realization of 𝒦 on the cubic lattice; L(𝒦_c) its length; "the minimum of L(𝒦_c) over all lattice realization 𝒦_c of 𝒦 is called the *minimum step number* of 𝒦 and is denoted by L_c(𝒦)." A *step* is a segment between neighboring lattice points; x(𝒦_c), y(𝒦_c), z(𝒦_c) = numbers of x-, y-, z-steps.
- **Special cord diagram** (Def. 2.1, p. 2), **Seifert diagram** (Def. 2.2), **partial Seifert circles**, **companion**/**domain** of an oriented simple curve β with endpoints on C (p. 2), **coherent** (Def. 2.3, p. 3).
- **b₀(𝒦)** (p. 6): with HOMFLY-PT H(𝒟,z,a) defined by aH(𝒟₊) − a⁻¹H(𝒟₋) = zH(𝒟₀), H(trivial knot)=1; E(𝒟), e(𝒟) highest/lowest powers of a; b₀(𝒦) = (E(𝒟) − e(𝒟))/2 + 1. **B₀(𝒦)** = max{b₀(𝒦′) : 𝒦′ ∈ O(𝒦)}, O(𝒦) = set of oriented links from all orientations of components.

## Numbered statements
**Definition 2.1 (p. 2).** Let 𝒦 be an oriented link and 𝒟 a projection diagram of 𝒦 (projection plane z = 0). Let α₁,…,α_n be simple arcs of 𝒟. They form a *special cord diagram* R (associated with 𝒟) if: (i) the end points of α₁,…,α_n do not cross each other and are distributed on a topological circle C (in the plane z = 0); (ii) the interiors of α₁,…,α_n are completely within the disk C̄ bounded by C; (iii) 𝒟 \ ∪_{1≤j≤n} α_j does not intersect C̄; (iv) the arc γ_j on 𝒟 corresponding to α_j resides in a slab Z_j defined by z′_j ≤ z ≤ z″_j for some z′_j ≤ z″_j; (v) Z_k ∩ Z_j = ∅ if j ≠ k.
(Following text: replacing each α_j by any simple α′_j that is the projection of a curve γ′_j in slab Z_j with the same end points, bounded within C, gives an *equivalent* special cord diagram R′ of a projection 𝒟′ of 𝒦.)

**Definition 2.2 (p. 2).** A Seifert diagram of a special cord diagram is the diagram obtained from the special cord diagram by smoothing all crossings in the diagram.

**Definition 2.3 (p. 3).** A special cord diagram R is *coherent* if we can choose an orientation of C such that the Seifert diagram of R satisfies: (i) its Seifert circles (if any) are concentric to each other and all share the same orientation with C; (ii) the domain of any partial Seifert circle cannot contain any Seifert circles; (iii) if the domain of a partial Seifert circle contains another partial Seifert circle, it must contain the entire domain of that partial Seifert circle.

**Lemma 2.4 (p. 3).** Let R be a special cord diagram with n cords, then there exists a coherent special cord diagram R′ that is equivalent to R. Furthermore, the Seifert diagram of R′ contains exactly n partial Seifert circles and at most n − 1 Seifert circles. (Proved here.)
Proof idea: induction on n with C oriented clockwise; add the (n₀+1)-th cord α′_{n₀+1}; case 1 (companion of α_{n₀+1} meets other companions in empty or simply connected arcs) adds one partial Seifert circle and no Seifert circle (Fig. 3); case 2 (meets some companion in two disjoint arcs) adds one partial Seifert circle and one Seifert circle (Fig. 4).

**Theorem 3.1 (p. 5).** Let 𝒦 be an un-oriented link, then **B**(𝒦) < L_c(𝒦) < 14L(𝒦), that is, L(𝒦) > (1/14)**B**(𝒦). (Proved here; L_c < 14L quoted from [9].)

**Example 3.2 (p. 6).** Let 𝒦 be the (2,2n) torus link, a two component link with 2n crossings. One orientation yields braid index 2, the other n+1. Thus **B**(𝒦) = n + 1 = Cr(𝒦)/2 + 1, hence L_c(𝒦) > n + 1 and L(𝒦) > (n+1)/14 > Cr(𝒦)/28.

**Example 3.3 (p. 6).** Let 𝒦 be a twist knot with n ≥ 4 crossings. **B**(𝒦) = **b**(𝒦) = k + 1 = (Cr(𝒦)+1)/2 if n = 2k+1 is odd, and **B**(𝒦) = **b**(𝒦) = k + 2 = Cr(𝒦)/2 + 1 if n = 2k+2 is even. It follows that L(𝒦) > (Cr(𝒦)+1)/28 for any twist knot 𝒦.

**Example 3.4 (p. 6).** The (alternating) pretzel knot of Fig. 6 with columns of 2k+1, 2m+1, 2n+1 crossings: Cr(𝒦) = 2(k+m+n)+3; from formulas in [8], **B**(𝒦) = **b**(𝒦) = 2 + k + m + n > (1/2)Cr(𝒦). It follows that L(𝒦) > Cr(𝒦)/28 as well.

**Theorem 4.1 (p. 7).** Let 𝒦 be an un-oriented link, then **B**₀(𝒦) < L_c(𝒦) < 14L(𝒦) and L(𝒦) > (1/14)**B**₀(𝒦). (Proved here, from B₀ ≤ B and Theorem 3.1.)

## Key equations and quantitative claims outside numbered statements
- p. 1 (quoted background): L(𝒦) ≥ 31.32 for any nontrivial knot [4]; L(𝒦) ≥ 1.105(Cr(𝒦))^{3/4} in general [1,2], 3/4 power attained by infinitely many links [3,6]; families with ropelength growing linearly in crossing number exist [10], based on bridge number lower bound.
- p. 4: L_c = 24, 30, 34 for trefoil [5], figure-8 [12], 5₁ [12] — "the only known results for nontrivial knots".
- p. 4: WLOG z(𝒦_c) ≥ max{x, y} ⇒ z(𝒦_c) ≥ (1/3)L(𝒦_c), x + y ≤ (2/3)L(𝒦_c).
- p. 5: tilted xy-projection; at each of m lattice points with crossings, a special cord diagram with n_j cords; two different cords are separated by a slab of thickness near one. After Lemma 2.4: s(K′) ≤ ½Σn_j + Σ(n_j − 1) < (3/2)Σn_j; and Σn_j ≤ x + y ≤ (2/3)L(𝒦_c), so s(K′) < (3/2)Σ n_j ≤ (3/2)(2/3)L(𝒦_c) = L(𝒦_c).
- p. 5: b(𝒟) ≤ s(𝒟) (Yamada [13]); so **B**(𝒦) = b(𝒦_c) = b(K′) ≤ s(K′) < L(𝒦_c).
- p. 5: L_c(𝒦) < 14L(𝒦) [9].
- p. 6: MFW-type bound b₀(𝒦) ≤ b(𝒦) [11].
- p. 6: In Examples 3.2–3.4 bridge numbers are 2 or 3; links are algebraic, so ropelength grows at most linearly in crossing number [7]; hence these ropelengths grow linearly.

## Methods / algorithms
Proof of Theorem 3.1 (pp. 4–5):
1. Take a lattice realization 𝒦_c; WLOG z-steps are the majority so x+y steps ≤ (2/3)L(𝒦_c).
2. Project to the xy-plane, tilt slightly; crossings occur near lattice points; in the unit square around each such point the arcs form a special cord diagram (cords in disjoint z-slabs) (Fig. 5).
3. Orient 𝒦_c to realize **B**(𝒦); apply Lemma 2.4 to each cord diagram (ambient isotopy) giving projection K′ with n_j partial and ≤ n_j − 1 Seifert circles per site.
4. Count Seifert circles: s(K′) < (3/2)Σn_j; each cord has unit length in x/y steps so Σn_j ≤ (2/3)L(𝒦_c) ⇒ s(K′) < L(𝒦_c).
5. Yamada b ≤ s ⇒ **B**(𝒦) < L(𝒦_c); minimize ⇒ **B** < L_c; then L_c < 14L [9].

## Tables
None.

## Figures
- **Fig. 1 (p. 2)** — "Left: A special cord diagram; Right: The Seifert diagram of it." *What it shows:* a disk with several oriented chords crossing each other; after smoothing, three Seifert circles inside and several partial Seifert circles (small arcs at the boundary). Image: ../figures/Diao19/p02.png
- **Fig. 2 (p. 3)** — "Left: A special cord diagram equivalent to the special cord diagram shown in the left of Figure 1; Right: The corresponding Seifert diagram is coherent with the orientation C as shown in the figure." *What it shows:* rerouted curved cords; Seifert diagram has two concentric Seifert circles and partial circles near the boundary. Image: ../figures/Diao19/p03.png
- **Fig. 3 (p. 4)** — "Left: The companion of α_{n₀+1} is shown in thick line and its intersection with the companions of other partial Seifert circles are either empty or a simply connected arcs on C. The orientations of the Seifert circles and partial Seifert circles are parallel to that of C (not shown in the figure); Middle: The choice of α′_{n₀+1}; Right: The resulting Seifert diagram." *What it shows:* induction step case 1 (no new Seifert circle). Image: ../figures/Diao19/p04.png
- **Fig. 4 (p. 4)** — "Left: The companion of α_{n₀+1} is shown in thick line. Notice that its intersection with the companion of one partial Seifert circles consists of two disjoint arcs on C. The orientations of the Seifert circles and partial Seifert circles are parallel to that of C (not shown in the figure); Middle: The choice of α′_{n₀+1}; Right: The resulting Seifert diagram." *What it shows:* induction step case 2 (one new concentric Seifert circle). Image: ../figures/Diao19/p04.png
- **Fig. 5 (p. 5)** — "Left: the top view of a unit length square centered at a lattice point where the projected strands of K_c intersect; Right: A slightly tilted projection leads to a special cord diagram." *What it shows:* a dashed unit square with a cross of lattice strands; after tilting, several nearly parallel strands in each direction. Image: ../figures/Diao19/p05.png
- **Fig. 6 (p. 6)** — "An alternating pretzel knot with three columns containing 2k+1, 2m+1 and 2n+1 crossings respectively (k, m and n are non-negative integers and the case of k = m = n = 0 gives the trefoil knot)." Image: ../figures/Diao19/p06.png

## Stated limitations, open problems, future work
- p. 7: "It has been conjectured that the ropelength of an alternating link 𝒦 is bounded below by a constant multiple of its crossing number. Our result shows that this conjecture holds for many alternating links. A remaining challenge is about the alternating links whose absolute braid index is small, for example the (2,2n+1) torus knot whose braid index is 2. … it is quite plausible that its ropelength should behave linearly as its crossing number, we do not have a way to prove it! We end this paper with this problem as a challenge to our reader."
- p. 1: if a link has small bridge number, bridge-number methods give no good lower bound (motivation).

## References worth following
- [1] G. Buck, J. Simon, Thickness and Crossing Number of Knots, Topology Appl. 91(3) (1999), 245–257.
- [4] E. Denne, Y. Diao, J. Sullivan, Quadrisecants Give New Lower Bounds for the Ropelength of a Knot, Geom. Topol. 10 (2006), 1–26.
- [5] Y. Diao, Minimal Knotted Polygons on the Cubic Lattice, JKTR 2(4) (1993), 413–425.
- [7] Y. Diao, C. Ernst, Hamiltonian Cycles and Ropelengths of Conway Algebraic Knots, JKTR 15(1) (2006), 121–142.
- [8] Y. Diao, C. Ernst, G. Hetyei, P. Liu, A Diagrammatic Approach for Determining the Braid Index of Alternating Links, 2019 preprint, arXiv:1901.09778.
- [9] Y. Diao, C. Ernst, E. J. Janse van Rensburg, Upper Bounds on Linking Number of Thick Links, JKTR 11(2) (2002), 199–210.
- [10] Y. Diao, C. Ernst, M. Thistlethwaite, The Linear Growth in the Length of a Family of Thick Knots, JKTR 12(5) (2003), 709–715.
- [11] H. Morton, Seifert Circles and Knot Polynomials, Math. Proc. Camb. Phil. Soc. 99 (1986), 107–109.
- [12] R. Scharein, K. Ishihara, J. Arsuaga, K. Shimokawa, Y. Diao, M. Vazquez, Bounds for minimal step number of knots in the simple cubic lattice, J. Phys. A 42(47) (2009) 475006.
- [13] S. Yamada, The Minimal Number of Seifert Circles Equals The Braid Index of A Link, Invent. Math. 89 (1987), 347–356.

## Extraction notes
- All 7 pages read as images.
- ⚠ The thickness convention is not stated in the paper (only "unit thickness rope").
- ⚠ Example 3.3 says "twist knot with n ≥ 4 crossings" and then uses n = 2k+1 / n = 2k+2 for the crossing number; transcribed as printed.
- ⚠ Diao22 cites "[6, Theorem 3.1]" (this paper) for the inequality ℓ(𝕃) ≥ b(𝕃) for lattice links; the printed Theorem 3.1 here is stated as **B**(𝒦) < L_c(𝒦) < 14L(𝒦) (the length-vs-braid-index inequality for any lattice realization appears in the proof on p. 5: **B**(𝒦) ≤ s(K′) < L(𝒦_c)).
