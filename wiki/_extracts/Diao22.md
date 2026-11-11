# Diao22 — The Ropelength Conjecture of Alternating Knots
- **Authors:** Yuanan Diao (Department of Mathematics and Statistics, University of North Carolina Charlotte)
- **Venue / year / identifiers:** arXiv:2208.00123v1 [math.GT], 30 Jul 2022. 2020 MSC: Primary 57K10, 57K31, 57K99.
- **File:** papers/3_analytic_bounds/Diao_2022_Ropelength_conjecture_alternating_knots_2208.00123.pdf   **Pages:** 4
- **Text layer:** ok

## Abstract
A long standing conjecture states that the ropelength of any alternating knot is at least proportional to its crossing number. In this paper we prove that this conjecture is true. That is, there exists a constant b₀ > 0 such that R(K) ≥ b₀Cr(K) for any alternating knot K, where R(K) is the ropelength of K and Cr(K) is the crossing number of K. In this paper, we prove that this conjecture is true.

## Notation and conventions
- **Ropelength R(K)** (p. 1): "The ropelength of a knot K is defined as the minimum length among all knots in the ambient class of K with unit thickness [3, 10, 13]." ⚠ The paper does not say whether "unit thickness" means unit radius or unit diameter; it cites Cantarella–Kusner–Sullivan [3], Diao–Ernst–Janse van Rensburg [10] and Litherland–Simon–Durumeric–Rawdon [13]. The proof transfers through [9, Lemma 1] (R(K) > ℓ(K_c)/14), so the convention is whatever [9] uses.
- **Cr(K)**: crossing number of K (p. 1).
- **Reverse parallel link** (p. 1): "The regular neighborhood of K on any orientable surface M embedded in S³ on which K lies is an annulus. The link formed by the boundaries K′, K″ of such an annulus is called a *reverse parallel link* of K if K′, K″ are assigned opposite orientations." Reverse parallel links of K are classified up to ambient isotopy by the linking number between K′ and K″.
- **P_L(v,z)**: HOMFLY-PT polynomial [12]; **F_K(v,z)**: Kauffman polynomial; P̃_L, F̃_K: same polynomials with coefficients reduced mod 2 (p. 2). breadth_v = (highest − lowest) power of v.
- **K_c**: a knot on the cubic lattice ambient isotopic to K of minimum length among lattice knots in its class; ℓ(K_c) its length (p. 2). An *edge* is a segment between adjacent lattice points (p. 3).
- **b(L)**: braid index (p. 3).

## Numbered statements
**Lemma 2.1 (p. 1).** For any alternating knot K, there exist two ambient isotopic classes 𝓛₁, 𝓛₂ of reverse parallel links of K such that if L is a reverse parallel link of K and L ∉ 𝓛₁, 𝓛₂, then
  breadth_v(P_L(v,z)) ≥ 2Cr(K) + 2,
where P_L(v,z) is the HOMFLY-PT polynomial of L and Cr(K) is the crossing number of K. (Proved here.)
Proof idea: By Rudolph's congruence theorem [15], (v⁻¹−v)/z · P̃_L(v,z) − 1 = v^{−2f}(1 + (v^{−2}+v²)/z²)F̃_K(v^{−2},z²) (eq. 2.1), f = linking number of L; by Cromwell [4, Proposition, line 15, p. 62] breadth_v(F̃_K) ≥ Cr(K) for alternating K, so breadth_v of the right side ≥ 2Cr(K)+4; 𝓛₁, 𝓛₂ are the classes with f = α, f = β where 2α, 2β are the lowest/highest v-powers of (1 + (v^{−2}+v²)/z²)F̃_K(v^{−2},z²).

**Remark 2.2 (p. 2).** Since Cr(K) ≥ 3 for any non-trivial knot K, β − α ≥ Cr(K) + 2 ≥ 5. It follows that the linking numbers of any two links L₁ ∈ 𝓛₁ and L₂ ∈ 𝓛₂ differ by at least 5.

**Theorem 3.1 (p. 2).** There exists a constant b₀ > 1/59.5 such that for any alternating knot K, R(K) ≥ b₀Cr(K). (Proved here.)

**Remark 3.2 (p. 3).** The construction in the proof of [9, Lemma 1] can in fact be improved to yield a better bound R(K) > (1/12)ℓ(K_c). This would allow us to improve the estimation of the constant b₀ to be at least 1/51.

**Remark 3.3 (p. 3).** The application of the Congruence Theorem in [15], unfortunately, fails in the case of an alternating link. Thus the ropelength conjecture remains open in general for alternating links.

## Key equations and quantitative claims outside numbered statements
- p. 1 (Intro): "there exists a constant b₀ > 0 such that R(K) > b₀Cr(K) for any alternating knot K. In fact, b₀ > 1/59.5." (strict inequality here; ≥ in abstract and Theorem 3.1 — see notes).
- p. 2, eq. (2.1)/(2.2): (v⁻¹−v)/z · P̃_L(v,z) = v^{−2f}(1 + (v^{−2}+v²)/z²)F̃_K(v^{−2},z²) + 1.
- p. 2: breadth_v(v^{−2f}(1 + (v^{−2}+v²)/z²)F̃_K(v^{−2},z²)) ≥ 2Cr(K) + 4.
- p. 2: R(K) > (1/14) ℓ(K_c), "as a consequence from the proof of [9, Lemma 1]" (rigorous, quoted).
- p. 3: ℓ(𝕃_c) = 4ℓ(K_c) (𝕂_c, 𝕂′_c = K_c, K′_c scaled by 2); ℓ(𝕃′_c) = ℓ(𝕃_c) + 8 in the worse case.
- p. 3: MFW inequality [11, 14]: b(𝕃′_c) ≥ breadth_v(P_{𝕃′_c})/2 + 1 ≥ Cr(K) + 2.
- p. 3: by [6, Theorem 3.1] (Diao19), ℓ(𝕃′_c) = 4ℓ(K_c) + 8 ≥ b(𝕃′_c). Hence 4ℓ(K_c) + 6 ≥ Cr(K).
- p. 3: ℓ(K_c) ≥ 24 for any non-trivial lattice knot [7]; so 4ℓ(K_c) + 6 ≤ 4.25 ℓ(K_c), so ℓ(K_c) ≥ Cr(K)/4.25 and R(K) > ℓ(K_c)/14 ≥ Cr(K)/59.5.

## Methods / algorithms
Proof of Theorem 3.1 (pp. 2–3):
1. Take a minimum-length cubic-lattice representative K_c of K; R(K) > ℓ(K_c)/14 via [9, Lemma 1].
2. Push-off: {x + t(½,½,½) : x ∈ K_c, 0 ≤ t ≤ 1} is an embedded annulus with boundaries K_c and K′_c = (½,½,½) + K_c; with opposite orientations it is a reverse parallel link L_c. Scale both by 2 to get lattice knots 𝕂_c, 𝕂′_c, link 𝕃_c, ℓ(𝕃_c) = 4ℓ(K_c).
3. Choose edge e of K_c: (i) perpendicular to z-axis with maximal z-coordinate among such edges; (ii) if parallel to the x-axis (y-axis) then maximal x- (y-) coordinate among those satisfying (i). e corresponds to segments l₁ ⊂ 𝕂_c, l₂ ⊂ 𝕂′_c each of two edges.
4. Replace the edge on l₁ by the lattice path of Fig. 1 (no self-intersections by choice of e) → reverse parallel link 𝕃′_c with linking number differing by one from 𝕃_c.
5. By Lemma 2.1 and Remark 2.2, at least one of 𝕃_c, 𝕃′_c has breadth_v(P) ≥ 2Cr(K)+2; assume worse case 𝕃′_c (length +8).
6. MFW inequality ⇒ braid index ≥ Cr(K)+2; Diao19 (length ≥ braid index for lattice links) ⇒ 4ℓ(K_c)+8 ≥ Cr(K)+2; use ℓ(K_c) ≥ 24 to finish.

## Tables
None.

## Figures
- **Fig. 1 (p. 3)** — "Left: the line segments l₁ ∈ 𝕂_c and l₂ ∈ 𝕂′_c corresponding to e. The two edges marked by thin lines are used to indicate the grid lines, they are not part of the link; Right: An edge on l₁ is replaced by the path showing." *What it shows:* two parallel diagonal-drawn two-edge segments l₁, l₂ (perspective view), and on the right the same with one edge of l₁ replaced by a detour lattice path looping around l₂ (a square-ish detour) to change the linking number by one. Image: ../figures/Diao22/p03.png

## Stated limitations, open problems, future work
- p. 3 (Remark 3.3): the Congruence Theorem argument fails for alternating links; "the ropelength conjecture remains open in general for alternating links."
- p. 3 (Remark 3.2): constant improvable to 1/51 via an improved version of [9, Lemma 1] (R(K) > ℓ(K_c)/12) — stated, not proved here.

## References worth following
- [4] P. R. Cromwell, Arc presentations of knots and links, Knot Theory (Warsaw 1995), Banach Center Publ. 42 (1998), 57–64.
- [6] Y. Diao, Braid Index Bounds Ropelength from Below, JKTR 29 (4) (2020), 2050019.
- [7] Y. Diao, Minimal Knotted Polygons on the Cubic Lattice, JKTR 2 (4) (1993), 413–425.
- [9] Y. Diao, C. Ernst, E. J. Janse van Rensburg, Upper Bounds on Linking Number of Thick Links, JKTR 11(2) (2002), 199–210.
- [11] J. Franks, R. Williams, Braids and the Jones Polynomial, Trans. AMS 303 (1987), 97–108.
- [14] H. Morton, Seifert Circles and Knot Polynomials, Math. Proc. Camb. Phil. Soc. 99 (1986), 107–109.
- [15] L. Rudolph, A congruence between link polynomials, Math. Proc. Camb. Phil. Soc. 107 (1990), 319–327.
- [3] Cantarella, Kusner, Sullivan, On the minimum ropelength of knots and links, Invent. Math. 150 (2002), 257–286.

## Extraction notes
- All 4 pages read as images.
- ⚠ Inequality strictness inconsistent: abstract and Theorem 3.1 state R(K) ≥ b₀Cr(K) with b₀ > 1/59.5; Intro and the final line of the proof give strict R(K) > Cr(K)/59.5.
- ⚠ Thickness convention (radius vs diameter) not stated in this paper.
- ⚠ Abstract repeats "In this paper, we prove that this conjecture is true" twice (as printed).
- ⚠ In the proof, the worse case is said to be 𝕃′_c "since ℓ(𝕃′_c) = ℓ(𝕃_c) + 8"; then "ℓ(𝕃′_c) = 4ℓ(K_c) + 8 ≥ b(𝕃′_c)" leads to "4ℓ(K_c) + 6 ≥ Cr(K)" (consistent with b ≥ Cr+2).
- The reference to Diao19 ([6]) gives JKTR 29(4) 2020 for the published version.
