# HNOR15 — Link lengths and their growth powers
- **Authors:** Youngsik Huh, Sungjong No, Seungsang Oh, Eric J Rawdon
- **Venue / year / identifiers:** J. Phys. A: Math. Theor. 48 (2015) 035202 (10pp), doi:10.1088/1751-8113/48/3/035202; received 11 August 2014, revised 4 November 2014, accepted 18 November 2014, published 19 December 2014
- **File:** papers/huh2014.pdf   **Pages:** 11 (p. 1 IOPscience cover sheet; printed page k = PDF page k+1)
- **Text layer:** ok; formulas with roots/fractions garbled — pp. 4–5 checked against images

## Abstract
For a certain infinite family 𝓕 of knots or links, we study the growth power ratios of their stick number, lattice stick number, minimum lattice length and minimum ropelength compared with their minimum crossing number c(K) for every K ∈ 𝓕. It is known that the stick number and lattice stick number grow between the 1/2 and linear power of the crossing number, and minimum lattice length and minimum ropelength grow with at least the 3/4 power of crossing number (which is called the four-thirds power law). Furthermore, the minimal lattice length and minimum ropelength grow at most as O(c(K)[ln(c(K))]^5), but it is unknown whether any family exhibits superlinear growth. For any real number r between 1/2 and 1, we give an infinite family of non-splittable prime links in which the stick number and lattice stick number grow exactly as the rth power of crossing number. Furthermore for any real number r between 3/4 and 1, we give another infinite family of non-splittable prime links in which the minimum lattice length and minimum ropelength grow exactly as the rth power of crossing number.

## Notation and conventions
- Lattice = cubic lattice (R×Z×Z) ∪ (Z×R×Z) ∪ (Z×Z×R) (p. 3–4).
- s(K) stick number in R³; s_L(K) lattice stick number; Len(K) minimum number of unit edges in the cubic lattice; Rop(K) = min over smooth curves of arc length / **radius** of the cross-sectional disk of the tube (p. 4). Lattice polygons carry a tube of radius 1/2 ⇒ Rop(K) ≤ 2 Len(K) (p. 4).
- H_{p,q} = (p, q)-Hopf link: p parallel copies of one Hopf component in its tubular neighbourhood and q of the other (p. 5). c(H_{p,q}) = 2pq; prime for p, q ≥ 2.
- "order O(c(K)^r)" is used in the sense of Θ (both upper and lower bound of that order are proved).

## Numbered statements
- **Theorem 1 (p. 4, proof p. 5–6).** For any real number r between 1/2 and 1, there is an infinite family 𝓕_r of non-splittable prime links such that s(K) and s_L(K) have the order O(c(K)^r) for every K ∈ 𝓕_r. *Proved.* Proof: H_k = H_{k^m, k^n}, 0 ≤ m ≤ n, realised by k^m + k^n triangles / lattice rectangles, so s(H_k) = 3(k^m + k^n), s_L(H_k) = 4(k^m + k^n); c(H_k) = 2k^{m+n} ⇒ order c^{n/(m+n)}; r = n_0/(m_0 + n_0) rational, real r by a sequence of rationals; use H_{2,k^{n_0}} when m_0 = 0 to stay prime.
- **Theorem 2 (p. 5, proof p. 6–7).** For any real number r between 3/4 and 1, there is an infinite family 𝓕_r of non-splittable prime links such that Len(K) and Rop(K) have the order O(c(K)^r) for every K ∈ 𝓕_r. *Proved.* Key inequalities (p. 7): 2πqp² + 2πpq² ≤ Rop(H_{p²,q²}) ≤ 2 Len(H_{p²,q²}) ≤ 20p²⌈q²/p⌉ + 12p³ (1 ≤ p ≤ q). With p = k^m, q = k^n: both sides O(k^{m+2n}), c(H_k) = 2k^{2m+2n} ⇒ order c^{(m+2n)/(2m+2n)}, which ranges over [3/4, 1].
  - Proof idea, lower bound (p. 5–6): if a component of L_1 had length < 2πq, it would bound an immersed disk of area < πq² (Beckenbach–Rado), but each of the q² linked components of L_2 meets the disk in area ≥ π; so each L_1 component has length ≥ 2πq, each L_2 component ≥ 2πp (thickness radius 1).
  - Upper bound construction (p. 6–7, Figs 4–5): stack p nested rectangles of size (⌈q²/p⌉ + 1) × (p + 1), then (⌈q²/p⌉ + 3) × (p + 3), …, giving p² components of total length Σ_{n=1}^{p} 2p(⌈q²/p⌉ + p + 4n − 2) = 2p²⌈q²/p⌉ + 6p³ (checked against the p. 7 image; the sum evaluates correctly); then p⌈q²/p⌉ square rectangles (p+1)², (p+3)², … threaded along x adding 4⌈q²/p⌉ Σ_{n=1}^{p}(p + 2n − 1); total 10p²⌈q²/p⌉ + 6p³; contains H_{p²,q²} as a sublink since q² ≤ p⌈q²/p⌉.

## Key equations and quantitative claims outside numbered statements (quoted background, p. 4–5)
- Negami [66]: (5 + √(8c(K) + 9))/2 ≤ s(K) for any link except the trivial knot; s(K) ≤ 2c(K) for links with no Hopf-link connected-sum factor and no splittable trivial component.
- Huh–Oh [45]: s(K) ≤ (3/2)(c(K) + 1) for nontrivial knots; s(K) ≤ (3/2)c(K) for non-alternating prime knots.
- Diao–Ernst [27]: 3√(c(K) + 1) + 3 ≤ s_L(K).
- Hong–No–Oh [39]: s_L(K) ≤ 3c(K) + 2 for nontrivial non-trefoil knots; s_L(K) ≤ 3c(K) − 4 for non-alternating prime knots.
- Hence s, s_L are between O(c^{1/2}) and O(c).
- Summarising [12, 13, 19]: ((4π/11) c(K))^{3/4} ≤ Rop(K) (as printed, the exponent 3/4 applies to the whole bracket), and the power 3/4 is optimal ("four-thirds power law"). Diao et al. [29]: Len(K) ≤ O(c(K)[ln c(K)]^5).
- p. 3: radius of gyration scaling n^{1/2} (phantom equilateral), n^{0.588} (excluded volume, cubic lattice), n^{1/3} (self-attracting) — background.

## Methods / algorithms
Explicit constructions only (see Theorem 1 and 2 above). Lattice realisation of H_{p,q}: nested rectangles (Figs 2, 4, 5).

## Tables
None.

## Figures
- **Fig. 1 (p. 5)** — The Hopf link H_{1,1} and the H_{4,8} link. Image: ../figures/HNOR15/p05.png
- **Fig. 2 (p. 6)** — Polygonal and lattice realizations of H_{2²,2³}. Image: ../figures/HNOR15/p06.png
- **Fig. 3 (p. 7)** — q² tubular pieces in a component of L_1. Image: ../figures/HNOR15/p07.png
- **Fig. 4 (p. 7)** — Placing p² parallel rectangles in the construction of H_{p², p⌈q²/p⌉}. Image: ../figures/HNOR15/p07.png
- **Fig. 5 (p. 8)** — Placing p⌈q²/p⌉ parallel rectangles in the construction of H_{p², p⌈q²/p⌉}. Image: ../figures/HNOR15/p08.png

## Stated limitations, open problems, future work
- p. 2, p. 5: "it is unknown whether any family exhibits superlinear growth" of Len or Rop.
- (Implicit) the families are links, not knots; whether knots realise every exponent in [3/4, 1] is not addressed.

## References worth following
- [10] Beckenbach, Rado 1933, Subharmonic functions and surfaces of negative curvature, Trans. AMS 35 662–82.
- [12] Buck 1998, Four-thirds power law for knots and links, Nature 392. [13] Buck, Simon 1999, Thickness and crossing number of knots, Topology Appl. 91.
- [19] Cantarella, Kusner, Sullivan 1998, Tight knot values deviate from linear relations, Nature 392.
- [27] Diao, Ernst 2007, Total curvature, ropelength and crossing number of thick knots, Math. Proc. Camb. Phil. Soc. 143.
- [29] Diao, Ernst, Por, Ziegler 2009, arXiv:0912.3282.
- [39] Hong, No, Oh 2013, Upper bound on lattice stick number of knots, Math. Proc. Camb. Phil. Soc. 155.
- [45] Huh, Oh 2011, An upper bound on stick number of knots, JKTR 20. [66] Negami 1991, Trans. AMS 324.

## Extraction notes
- Written by the wiki author. Background formulas on pp. 4–5 checked against 110-dpi crops. Theorem 2 inequality chain and construction sums from text layer; the final closed forms (2p²⌈q²/p⌉ + 6p³, 10p²⌈q²/p⌉ + 6p³, 20p²⌈q²/p⌉ + 12p³) are internally consistent (2·(10…+6…) = 20…+12…).
- The intermediate sum for the first stacking step is garbled in the text layer; transcribed from a 110-dpi crop of p. 7.
- Figure pages rendered: 5–8.
