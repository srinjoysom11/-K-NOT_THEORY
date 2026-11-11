# JvRR11univ — On the universality of knot probability ratios
- **Authors:** E.J. Janse van Rensburg (York University); A. Rechnitzer (University of British Columbia)
- **Venue / year / identifiers:** arXiv:1101.4047v3 [cond-mat.stat-mech] 10 Mar 2011; "Submitted to: J. Phys. A: Math. Gen."; PACS 02.10.Kn, 36.20.Ey, 05.70.Jk, 87.15.Aa
- **File:** papers/2_algorithms/JvR-Rechnitzer_2011_Universality_of_knot_probability_ratios_1101.4047.pdf   **Pages:** 8
- **Text layer:** ok (formulas garbled in text layer; transcribed from page images)

## Abstract
Let p_n denote the number of self-avoiding polygons of length n on a regular three-dimensional lattice, and let p_n(K) be the number which have knot type K. The probability that a random polygon of length n has knot type K is p_n(K)/p_n and is known to decay exponentially with length [1, 2]. Little is known rigorously about the asymptotics of p_n(K), but there is substantial numerical evidence [3, 4, 5, 6] that p_n(K) grows as

p_n(K) ≃ C_K μ_∅^n n^{α−3+N_K},  as n → ∞,

where N_K is the number of prime components of the knot type K. It is believed that the entropic exponent, α, is universal, while the exponential growth rate, μ_∅, is independent of the knot type but varies with the lattice. The amplitude, C_K, depends on both the lattice and the knot type.

The above asymptotic form implies that the relative probability of a random polygon of length n having prime knot type K over prime knot type L is

(p_n(K)/p_n) / (p_n(L)/p_n) = p_n(K)/p_n(L) ≃ [C_K / C_L].

In the thermodynamic limit this probability ratio becomes an amplitude ratio; it should be universal and depend only on the knot types K and L. In this letter we examine the universality of these probability ratios for polygons in the simple cubic, face-centered cubic, and body-centered cubic lattices. Our results support the hypothesis that these are universal quantities. For example, we estimate that a long random polygon is approximately 28 times more likely to be a trefoil than be a figure-eight, independent of the underlying lattice, giving an estimate of the intrinsic entropy associated with knot types in closed curves.

## Notation and conventions
- **SAP / p_n** (p. 2): "A self-avoiding polygon (SAP) on a regular lattice 𝕃 is the piecewise linear embedding of a simple closed curve as a sequence of distinct edges joining vertices in 𝕃. The number of distinct unrooted polygons modulo translations is denoted p_n." lim_{n→∞} p_n^{1/n} = μ exists, μ = self-avoiding walk growth constant.
- **p_n(K)** (p. 2): "the number of unrooted polygons of length n and knot type K, modulo translations." Length n = number of edges.
- **Lattices** (p. 2): SC = simple cubic, FCC = face-centred cubic, BCC = body-centred cubic.
- **N_K** (p. 2): number of prime components of K. **α**: entropic exponent (believed universal). **μ_∅**: growth rate of unknotted polygons (lattice-dependent, knot-type independent). **C_K**: amplitude (depends on lattice and knot type).
- **a_+(φ), a_0(φ), a_−(φ)** (p. 3): "the total numbers [of] positive, neutral and negative atmospheric moves of a SC lattice polygon φ" (generalised to FCC/BCC plaquettes).
- **⟨W⟩_n** (p. 4): mean GAS weight of polygons of length n.
- Knot notation 0_1, 3_1, 4_1, 5_1, 5_2 (Rolfsen-style).

## Numbered statements
The paper has no numbered theorems. Its numbered displayed claims:
- **Eq. (1) (p. 2), assumed scaling form (numerical evidence [3,4,6,5,10], not proved):** p_n(K) ≃ C_K μ_∅^n n^{α−3+N_K}, as n → ∞. "Unfortunately very little of this form can be proven rigorously — the exponential growth rate is only known to exist when K is the unknot." Pattern theorem [1,2]: μ_∅ < μ strictly, and p_n(K)/p_n decays exponentially (quoted from [1,2]).
- **Eq. (2) (p. 2):** for prime K, L (N_K = N_L = 1): (p_n(K)/p_n)/(p_n(L)/p_n) = p_n(K)/p_n(L) ≃ [C_K/C_L], as n → ∞ — expected universal ("amplitude ratio").
- **Eq. (6) (p. 7), numerical summary of limiting amplitude ratios (claimed lattice-independent):**
  - C_{3_1}/C_{4_1} = 28(1); C_{3_1}/C_{5_1} = 400(20); C_{3_1}/C_{5_2} = 280(20)
  - C_{4_1}/C_{5_1} = 15(1); C_{4_1}/C_{5_2} = 9(1)
  - C_{5_1}/C_{5_2} = 0.67(3).
  "These numbers are self-consistent within the stated error bars."

## Key equations and quantitative claims outside numbered statements
- (p. 2) Shortest unknots: 3 of length 4 in SC; 8 of length 3 in FCC; 12 of length 4 in BCC.
- (p. 2) Trefoil SC: p_n(3_1) = 0 if n < 24 and p_24(3_1) = 3328 (rigorous, [9]; also [21]). GAS data: "p_15(3_1) = 128 in the FCC and p_18(3_1) = 3168 in the BCC (see Table 1); no shorter trefoils were observed." ⚠ Table 1 gives 64 (FCC) and 1584 (BCC) — exactly half the values in the text.
- (p. 4) Eq. (5): ⟨W⟩_n / ⟨W⟩_m = p_n(K)/p_m(K) (from [12]); used with exact minimal-length counts (Table 1) to obtain approximate p_n(K).
- (p. 4) Executing a move and updating the polygon takes O(1) time.
- (p. 4) Minimal knots: algorithm "quickly found all realisations of minimal knots (within hours) and then failed to find new conformations after another few days of CPU time" (numerical; SC trefoil count proved [21,9]).
- (p. 4–5) Runs: each simulation 1 week on one node of WestGrid's Glacier cluster; ≈400 chains of 2^27 polygons (FCC), 1400 chains of 2^23 polygons (SC), 500 chains of 2^23 polygons (BCC). Maximum polygon length 512 edges.
- (p. 5) log(p_n(K)/p_n(L)) observed approximately linear in n^{−1} (from earlier SC work [10]); extrapolated linearly to 1/n → 0.
- (p. 5) 3_1/4_1: linear-fit y-intercepts 3.34(3) SC, 3.35(3) FCC, 3.29(3) BCC; mutually within 95% confidence intervals; limiting ratio 27 ± 2; excluding BCC (less converged at large n): 28 ± 1. Fig. 4 caption: e^{3.32} ≈ 28.
- (p. 6) 4_1/5_2: limiting ratio 9 ± 1 (e^{2.2} ≈ 9); data less well converged. 5_1/5_2: 0.67(3) (e^{−0.4} ≈ 0.67).
- (p. 7) In each case FCC and BCC curves lie close together while SC stands apart — unexplained.
- (p. 7) Comparison: from [11] (SC polygons) C_{3_1}/C_{4_1} ≈ 22, "close to our estimate, but not within mutual error bars". Off-lattice [22], [23] give "quite different results"; universality class may differ; also affected by differing entropic exponent estimates. Caution: unless estimated exponents are equal, ratio of estimated probabilities tends to 0 or ∞.

## Methods / algorithms
GAS (Generalized Atmospheric Sampling) algorithm [12], a generalisation of the Rosenbluth algorithm; approximate enumeration (pp. 3–4).
1. **Moves, SC (p. 3):** BFACF elementary moves. Type I (neutral): exchanges two adjacent orthogonal edges over a unit lattice square (neutral atmospheric plaquette). Type II: negative move replaces three edges in a ⊓ conformation by a single edge (negative plaquette); positive move replaces a single edge by three edges in a ⊓ arrangement (positive plaquette). Irreducibility classes of BFACF on SC polygons = fixed knot types [19].
2. **Moves, FCC/BCC (pp. 3–4):** FCC: 4 elementary triangular plaquettes incident to each edge → positive and negative moves only. BCC: each edge incident to 12 plaquettes (6 planar, 6 non-planar), quadrilaterals → positive, negative and neutral moves. Irreducibility classes = fixed knot types on each lattice [20].
3. **Sequence (p. 4):** start at φ_0; φ_{j+1} obtained from φ_j by an atmospheric move, each chosen uniformly from the possible moves so that, if φ_j has length ℓ_j,
   Pr(+) ∝ β_{ℓ_j} a_+(φ_j), Pr(0) ∝ a_0(φ_j), Pr(−) ∝ a_−(φ_j).   (3)
   β_ℓ "is a parameter that is chosen to be approximately ⟨a_+⟩_ℓ/⟨a_−⟩_ℓ. This parameter can be chosen so that on average the probability of making a positive move is roughly the same as that of making a negative move." ⚠ As printed, β ≈ ⟨a_+⟩/⟨a_−⟩ would amplify rather than balance positive moves; transcribed as printed.
4. **Weight (p. 4):**
   W(φ_n) = [a_−(φ_0) + a_0(φ_0) + β_{ℓ_0} a_+(φ_0)] / [a_−(φ_n) + a_0(φ_n) + β_{ℓ_n} a_+(φ_n)] × ∏_{j=0}^{n} β_{ℓ_j}^{(ℓ_j − ℓ_{j+1})}.   (4)
5. **Estimation (p. 4):** compute mean weight ⟨W⟩_n at length n; use Eq. (5) with exactly known minimal-length counts (Table 1) as normalisation m.
6. **Minimal counts (p. 4):** collected minimal-length polygons during simulation or independent runs (idea from [9], [10]).
7. **Analysis (p. 5):** plot log(p_n(K)/p_n(L)) vs 1/n; linear fits; exponentiate intercept.

## Tables
**Table 1 (p. 5).** "The number of minimal length polygons of fixed knot types in the SC, FCC and BCC lattices."

| Knot | SC length | SC number | FCC length | FCC number | BCC length | BCC number |
|---|---|---|---|---|---|---|
| 0_1 | 4 | 3 | 3 | 8 | 4 | 12 |
| 3_1 | 24 | 3328 | 15 | 64 | 18 | 1584 |
| 4_1 | 30 | 3648 | 20 | 2796 | 20 | 12 |
| 5_1 | 34 | 6672 | 22 | 96 | 26 | 14832 |
| 5_2 | 36 | 114912 | 23 | 768 | 26 | 4872 |

## Figures
- **Fig. 1 (p. 2)** — "Minimal trefoils on the SC (left — 24 edges), FCC (middle — 15 edges) and BCC (right — 18 edges)." *What it shows:* 3D ball-and-stick renderings of one minimal trefoil on each lattice. Image: ../figures/JvRR11univ/p02.png
- **Fig. 2 (p. 3)** — "Elementary moves of the BFACF algorithm on the SC lattice." *What it shows:* Type I (corner flip across a unit square) and Type II (insert/remove a ⊓ of three edges replacing one edge), drawn with arrows. Image: ../figures/JvRR11univ/p03.png
- **Fig. 3 (p. 3)** — "(Left) There are 4 elementary triangular plaquettes incident to each edge in the FCC lattice. (Middle and right) Each edge in the BCC lattice is incident to 12 plaquettes; 6 planar and 6 non-planar (the remaining 3 are reflections of the 3 displayed)." *What it shows:* shaded triangular FCC plaquettes around an edge (green) and BCC quadrilateral plaquettes (red). Image: ../figures/JvRR11univ/p03.png
- **Fig. 4 (p. 5)** — "Plots of the logarithm of the ratio of the number of 3_1 to 4_1 knots. The dotted lines indicate the extrapolations. Note that the FCC and BCC data are nearly the same. The intercept indicates that the limiting ratio is approximately e^{3.32} ≈ 28." *What it shows:* log(p_n(3_1)/p_n(4_1)) vs 1/n ∈ [0, 0.015], y ∈ [3, 6]; SC curve steeper (≈5.8 at 1/n = 0.015), FCC/BCC overlapping (≈5.0 at 0.015); all extrapolate to ≈3.3–3.35 at 0. Image: ../figures/JvRR11univ/p05.png
- **Fig. 5 (p. 6)** — "Plots of the logarithm of the ratio of the number of 4_1 to 5_2 knots. The linear extrapolations are indicated by dotted lines. The intercept indicates that the limiting ratio is approximately e^{2.2} ≈ 9." *What it shows:* y from ≈2.2–2.3 at 1/n=0 to ≈4.9 (SC) and ≈4.0 (FCC/BCC) at 0.015. Image: ../figures/JvRR11univ/p06.png
- **Fig. 6 (p. 6)** — "Plots of the logarithm of the ratio of the number of 5_1 to 5_2 knots. The linear extrapolations are indicated by dotted lines. The intercept indicates that the limiting ratio is approximately e^{−0.4} ≈ 0.67." *What it shows:* y from ≈ −0.4 at 0 to ≈0.42 (SC) and ≈0.05–0.1 (FCC/BCC) at 0.015. Image: ../figures/JvRR11univ/p06.png

## Stated limitations, open problems, future work
- (p. 2) "very little of this form can be proven rigorously — the exponential growth rate is only known to exist when K is the unknot."
- (p. 5) BCC data "not as well converged at large n"; (p. 6) 4_1/5_2 "data are not as well converged and our estimates are not as good".
- (p. 7) FCC and BCC curves lie close while SC stands apart: "we would like to understand this better, but have no explanation at this time."
- (p. 7) Unclear whether lattice models and off-lattice models [22,23] are in the same universality class; comparisons sensitive to entropic exponent estimates.
- (p. 7) Future: "extending these results to composite knots and links, and also to perform similar analyses of data from off-lattice models."

## References worth following
- [1] D.W. Sumners, S.G. Whittington, Knots in self-avoiding walks, J. Phys. A 21:1689–1694, 1988.
- [2] N. Pippenger, Knots in random walks, Discrete Appl. Math. 25(3):273–278, 1989.
- [3] E. Orlandini, M.C. Tesi, E.J. Janse van Rensburg, S.G. Whittington, Asymptotics of knotted lattice polygons, J. Phys. A 31:5953–5967, 1998.
- [9] R. Scharein, K. Ishihara, J. Arsuaga, Y. Diao, K. Shimokawa, M. Vazquez, Bounds for the minimum step number of knots in the simple cubic lattice, J. Phys. A 42:475006, 2009.
- [10] E.J. Janse van Rensburg, A. Rechnitzer, Generalised atmospheric sampling of knotted polygons, J. Knot Theory Ramifications, 2010.
- [11] M. Baiesi, E. Orlandini, A.L. Stella, The entropic cost to tie a knot, J. Stat. Mech. 2010:P06012.
- [12] E.J. Janse van Rensburg, A. Rechnitzer, Generalized atmospheric sampling of self-avoiding walks, J. Phys. A 42:335001, 2009.
- [19] E.J. Janse van Rensburg, S.G. Whittington, The BFACF algorithm and knotted polygons, J. Phys. A 24:5553–5567, 1991.
- [20] E.J. Janse van Rensburg, A. Rechnitzer, BFACF-style algorithms for polygons in the body-centered and face-centered cubic lattices, J. Phys. A, 2010 (arXiv:1011.3847v1).
- [21] Y. Diao, The number of smallest knots on the cubic lattice, J. Stat. Phys. 74(5):1247–1254, 1994.
- [22] T. Deguchi, K. Tsurusaki, Universality of random knotting, Phys. Rev. E 55(5):6245–6248, 1997.
- [23] K.C. Millett, E.J. Rawdon, Universal characteristics of polygonal knot probabilities, Ser. Knots and Everything vol. 36, ch. 14, pp. 247–274, 2005.

## Extraction notes
- All 8 pages read as images; Table 1 verified cell-by-cell at 200 dpi.
- ⚠ p. 2 text: p_15(3_1) = 128 (FCC), p_18(3_1) = 3168 (BCC); Table 1 (p. 5): 64 and 1584. Factor 2 discrepancy (possibly counting orientations/chirality differently) — not explained in paper.
- ⚠ p. 4: β_ℓ ≈ ⟨a_+⟩_ℓ/⟨a_−⟩_ℓ as printed; the stated purpose (balancing + and − move probabilities) would suggest the reciprocal. Transcribed as printed.
- Figure curve values read approximately from plots.
