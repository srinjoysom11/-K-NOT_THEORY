# JvROT25 — Relative knot probabilities in confined lattice polygons
- **Authors:** EJ Janse van Rensburg (York Univ.), E Orlandini (Padova), MC Tesi (Bologna)
- **Venue / year / identifiers:** arXiv:2501.08835v3 [cond-mat.soft], 13 Mar 2025; header "Version 2.1 as of March 17, 2025"; PACS 82.35.Lr, 82.35.Gh, 61.25.Hq. (No journal ref printed.)
- **File:** papers/2_algorithms/JvR-Orlandini-Tesi_2025_Relative_knot_probabilities_confined_2501.08835.pdf   **Pages:** 27 (pp. 1–22 content, pp. 22–27 refs)
- **Text layer:** partly garbled (formulas/fractions in Eq. 1–2, 9–10 scrambled; Tables I–IV text layer correct but checked against page images pp. 7, 20, 21)

## Abstract
In this paper we examine the relative knotting probabilities in a lattice model of ring polymers confined in a cavity. The model is of a lattice knot of size n in the cubic lattice, confined to a cube of side-length L and with volume V = (L+1)^3 sites. We use Monte Carlo algorithms to approximately enumerate the number of conformations of lattice knots in the confining cube. If p_{n,L}(K) is the number of conformations of a lattice polygon of length n and knot type K in a cube of volume L^3, then the relative knotting probability of a lattice polygon to have knot type K, relative to the probability that the polygon is the unknot (the trivial knot, denoted by 0_1), is ρ_{n,L}(K/0_1) = p_{n,L}(K)/p_{n,L}(0_1). We determine ρ_{n,L}(K/0_1) for various knot types K up to six crossing knots. Our data show that these relative knotting probabilities are small so that the model is dominated by lattice polygons of knot type the unknot. Moreover, if the concentration of the monomers of the lattice knot is φ = n/V, then the relative knot probability increases with φ along a curve that flattens off as the Hamiltonian state is approached.
(⚠ abstract says "volume L^3" but also "V = (L+1)^3"; see notation.)

## Notation and conventions
- **Lattice / counting (p. 4):** "The number of cubic lattice polygons of length n is denoted p_n (these are unrooted and closed self-avoiding walks of length n steps in the cubic lattice counted up to equivalence under translations in the lattice)." p_n(K) = number of lattice knots of length n (edges) and knot type K. Cubic lattice is bipartite so p_n(K)=0 for odd n (p. 5).
- **Confined counts (p. 4, 6):** L-cube = cube of side length L in lattice steps, containing (L+1)^3 lattice sites; V = (L+1)^3 (Fig. 1 caption p. 3; p. 4; p. 6, Eq. 7). p_{n,L}(K) = number of lattice knots of length n and type K confined to the L-cube; "both conformational and translational degrees of freedom contribute" (p. 6) — i.e. placements counted as distinct, rotations inside the cube included (p. 4: "distinct conformations (also due to translations and rotations inside the cube)"). p_{n,L} = number of placements of lattice polygons (all knot types) of length n in an L-cube.
- ⚠ Inconsistency of cube convention: Abstract says "cube of volume L^3"; Fig. 2 caption (p. 4) says "side length of the cube is L − 1 (so that it contains V = L^3 sites)"; Eq. 6 (p. 6) writes "n > L^3"; Fig. 1 caption (p. 3) writes "V = (L+1)^d". Main text (pp. 4, 6) and all computations use V = (L+1)^3 (e.g. "12-cube with 2197 sites" = 13^3, p. 12; "lengths up to 13^3−1 = 2196"; 14-cube up to 15^3−1 = 3374).
- Concentration φ = n/V (p. 7). Free energy F_V(φ) = −(1/V) log p_{n,L}(K) (Eq. 7); per unit length f_K(φ) = −(1/n) log p_{n,L}(K) (Eq. 8) (p. 7).
- Knot probability P_{n,L}(K) = p_{n,L}(K)/p_{n,L} (Eq. 11, p. 10). Relative probability ρ_{n,L}(K1/K2) = p_{n,L}(K1)/p_{n,L}(K2) = P_{n,L}(K1)/P_{n,L}(K2) (Eq. 15, p. 11). R_L(K1/K2) = lim_{n↗V} ρ_{n,L}(K1/K2) (Eq. 16, p. 11): ratio as polygon approaches a Hamiltonian cycle. Tables III–IV report **natural logarithms** log R_L (the text says "logarithms"; Table values like −1.538 are log R_L, consistent with "log R_8(3_1^+/0_1) = −0.832±0.023", p. 22).
- n_K = minimal length of lattice knot of type K: n_{0_1}=4, n_{3_1}=24 [Diao], n_{4_1}=30, n_{5_1}=34 (p. 4); Table I bottom row gives n_K = 4, 24, 30, 34, 36, 40, 40, 40, 40, 40 for 0_1, 3_1^+, 4_1, 5_1^+, 5_2^+, 6_1^+, 6_2^+, 6_3, 3_1^+#3_1^+, 3_1^+#3_1^−. (Text on p. 4 gives n_51 = 34 and 5_1 = "51"; table lists the 5_1^+ chirality.)
- Notation 3_1^+ = (right-handed) trefoil; 3_1^+#3_1^+ and 3_1^+#3_1^− compound (connected-sum) knots. (Text p. 16 writes "3_1^−#3_1^+" for the second compound.)
- μ = growth constant of cubic lattice polygons (SAWs); μ_K = lim sup p_n(K)^{1/n}; μ_{01} for unknots (Eq. 1–2, p. 5). α = 0.237(2) entropic exponent (p. 5); N_K = number of prime knot components of K.
- φ_c = critical concentration in the Flory–Huggins approximation (p. 8–9); φ* = location of free-energy minimum measured in simulation.
- Algorithms: GAS (generalised atmospheric sampling) and GARM, implemented with BFACF moves, parallel (p. 5, 11–12).

## Numbered statements
The paper has **no numbered Theorem/Proposition/Lemma/Conjecture/Question**. Numbered equations and the facts cited (with status) are listed in the next section. Statements the paper quotes from references (all *quoted, not proved here*):
- p. 5: limits μ_{01} = lim p_n(0_1)^{1/n} and μ exist (through even n) by concatenation + Fekete's lemma; μ_{01} < μ [Sumners–Whittington 1988, ref 44] (quoted).
- p. 5: μ_{01} ≤ μ_K < μ (quoted, refs 44, 45); "it is believed that μ_K = μ_{01} for all knot types K" (refs 23, 46) — belief/conjecture, not proved.
- p. 6: P_n → 1 as n→∞ (Sumners–Whittington result, ref 44; quoted).
- p. 10 (Eq. 12–14): lim_{L→∞} P_{n,L}(K) = p_n(K)/p_n; lim_{n→∞} lim_{L→∞} P_{n,L}(K) = 0 for every K including 0_1 (derived from μ_K<μ; "it follows by equations (3) and (4)"); lim_{L→∞} lim_{n→N} P_{n,L}(K) = π_K with N = 2⌊L^3/2⌋ (definition of limiting knotting probability of Hamiltonian cycles when L runs through even numbers; existence not asserted).

## Key equations and quantitative claims outside numbered statements
Equations (all p. as indicated):
- Eq. 1 (p. 5): lim p_n(0_1)^{1/n} = μ_{01} < μ = lim p_n^{1/n} (even n).
- Eq. 2 (p. 5): limsup p_n(K)^{1/n} = μ_K.
- Eq. 3 (p. 5): p_n = C n^{α−3} μ^n (1+o(1)); Eq. 4: p_n(K) = C_K n^{α+N_K−3} μ_K^n (1+o(1)). "strong numerical evidences" (numerical/heuristic); α = 0.237(2) [47,48].
- Eq. 5 (p. 5): p_{n−ℓ}(0_1) ≃ n^{−1} p_n(K) as n→∞ for prime K; plotting log[n p_{n−ℓ}(0_1)/p_n(K)] vs 1/n gives ℓ ≈ 8 for the trefoil (numerical; refs 4, 24): tying a trefoil costs about 8 steps of length.
- p. 6: p_n(0_1) ≈ p_n(3_1) at n ≈ 169600 ± 5600, p_n(0_1) < p_n(3_1) beyond (numerical, ref 24).
- p. 6: P_n = 1 − p_n(0_1)/p_n = 1 − (C_{01}/C)(μ_{01}/μ)^n (1+o(1)); log(μ/μ_{01}) = (4.15 ± 0.32)×10^{−6} (numerical, ref 54).
- p. 4: Flory interaction parameter of the model χ = 0.18(3) [ref 39] (numerical); p_4(0_1) = 3, p_n(0_1) = 0 for n<4, minimal length of unknot is 4. (⚠ p. 4 says p_4(0_1)=3 [unrooted, up to translation, i.e. 3 orientations of the unit square]; p. 6 says p_{4,1}(0_1) = 6 [placements in a 1-cube, = Table I L=1].)
- Eq. 6 (p. 6): p_{n,L}(K) = 0 if n < n_K or n > L^3 (⚠ n > L^3 as printed; with V=(L+1)^3 sites the natural bound would be V; the paper elsewhere samples up to n = (L+1)^3 − 1).
- p. 6: Table I counts for minimal-length knots in L-boxes are obtained by exhaustive enumeration; "strictly speaking lower bounds, but should be exact in most cases, as they were checked exhaustively by repeated computer searches".
- Eq. 7–8 (p. 7): F_V(φ) = −(1/V) log p_{n,L}(K); f_K(φ) = −(1/n) log p_{n,L}(K).
- Eq. 9 (p. 8): Flory–Huggins free energy f_fh(φ) = (1−φ) log(1−φ) + (φ/n) log φ − χ φ^2 + A φ. Text: "Taking first n→∞, and then φ→0+, show that f_fh(φ)/φ → A−1. Thus A = 1 − log μ" (as printed; ⚠ the limit and relation A = 1 − log μ are stated as printed, and "A−1" would then equal −log μ).
- p. 8–9: critical concentration from ∂²f_fh/∂φ² = ∂³f_fh/∂φ³ = 0 at fixed n gives φ_c = 1/(1+√n_c) (text layer shows "1/(1+ √n_c)"); self-consistent with φ_c = n_c/(L+1)^3. Eq. 10: φ_c ≈ 1/(L+1), equivalently n_c ≈ (L+1)^2 (heuristic Flory–Huggins mean-field). ⚠ The printed intermediate steps (p. 9: "φ_c ≈ 1/(1+φ_c(L+1)^3) … φ_c^{3/2} ≈ 1/(L+1)^3 … squaring, cube root") are garbled in the text; the end result φ_c ≈ 1/(L+1) is as printed.
- Comparison with simulation minima of unknot free energy curves (Fig. 3; numerical): L=6: φ_c ≈ 1/7 = 0.1428 vs φ* ≈ 0.169; L=12: 1/13 = 0.0769 vs φ* ≈ 0.0792; L=14: 1/15 = 0.0667 vs φ* ≈ 0.067 (p. 9). Minima φ* decrease with L (p. 8).
- p. 9: for φ<φ_c solvent-rich regime (SAW exponents); φ>φ_c polymer-rich (collapsed) regime.
- Eq. 12–14 (p. 10): see above.
- Eq. 15–16 (p. 11): definitions of ρ and R_L.
- p. 12: Simulation sizes: GAS run in B blocks, T parallel threads per block (4, sometimes 6), S BFACF iterations per thread call. Example L=12 (2197 sites): lengths n ≤ 2196, B = 120, T = 4, S = 20,000,000, total BST = 9,600,000,000 BFACF moves. B increased from 60 (L=6) to 150 (L=14); S from 20,000,000 (L=6) to 30,000,000 (L=14). Short additional GARM simulations used to verify.
- p. 12: error bars from block independence; examples (L=12 unknot): p_{10,12}(0_1) = (8.55 ± 0.28)×10^5; p_{1000,12}(0_1) = (3.04 ± 1.54)×10^{563}; log p_{1000,12}(0_1) = 1297.5 ± 1.2.
- p. 12: data for L ∈ {6,8,10,12}; L=14 only for unknot and trefoil. Convergence good only for φ ≲ 0.93 (L=12), φ ≲ 0.90 (L=14); for φ ⪆ 0.93 ratios noisy, "no conclusions could be drawn".
- p. 13 (numerical): L=8, ρ(3_1^+/0_1) ≈ 0.10 at φ ≈ 0.5 (trefoils ≈ 10% of unknots); monotone increase, levels off. L=12: ρ < 0.10 for φ < 0.3, approaching 1.0 for φ > 0.8; wider uncertainty for φ > 0.5. ⚠ Table III gives log R_12(3_1^+/0_1) = −0.391(34), i.e. R ≈ 0.68 at φ=1, not 1; "approach 1.0" is an approximate statement from Fig. 6.
- p. 14: for fixed φ, ρ(3_1^+/0_1) increases systematically with L, levelling off; curves appear to approach a limiting curve; "the data appear to show that the curves accumulate, with increasing L, on the horizontal axis, so that ρ_{n,L}(3_1^+/0_1) → 1 as L→∞ for Hamiltonian polygons" (hedged, numerical suggestion). If lim sup_{L→∞} ρ < 1 at constant concentration, trefoils remain suppressed in the continuum limit.
- p. 15: ratios rise sharply as φ crosses φ_c ≈ 1/(L+1); curves flatten for φ > 0.7.
- Eq. 17 (p. 15): R(3_1^+/0_1) = lim_{L→∞} lim_{φ→1^−} ρ_{n,L}(3_1^+/0_1) ≤ 1. Questions raised: is R < 1, and is its value universal (model-independent)? (p. 15–16) — unresolved.
- p. 16–17: ρ(4_1/0_1) lower than ρ(3_1^+/0_1) except L=12 at high φ (noisy); 4_1 rises more sharply across φ_c. ρ(4_1/3_1^+) < 1 generally (except L=12 at high φ, noisy); appears to approach 1 as L increases at high φ; low-φ behaviour unclear.
- p. 18–19: five-crossing knots suppressed compared to trefoil and figure-eight; 5_2 more likely than 5_1; among 6-crossing prime knots 6_3 most likely, then 6_2, then 6_1; compound 3_1^+#3_1^− more likely than 3_1^+#3_1^+.
- p. 19 (Table II discussion): ranking by log p_{n,L}(K) at n=500 (L=12): 0_1, 3_1^+, 4_1, 5_2^+, 5_1^+, 6_3, 6_2^+, 6_1^+, 3_1^+#3_1^−, 3_1^+#3_1^+ (strictly descending). n=1000, 2000 "generally consistent… except in a few cases", e.g. at n=2000 4_1 appears to outrank 0_1 and 3_1^+ (within large error bars; attributed to uncertainty).
- Eq. 18 (p. 22): extrapolation model log ρ_L(K1/K2) = log R_L(K1/K2) + b(1/φ − 1) + c(1/φ² − 1) (text layer: "+b(1/φ−1)+c 1/φ2−1"; the grouping of the c-term is read as c(1/φ² − 1)), fitted by weighted least squares with φ > 0.1 data (numerical). Example: log R_8(3_1^+/0_1) = −0.832 ± 0.023.
- p. 22 (Table III discussion): log R_L decreases (in magnitude) down columns: non-trivial knots become more competitive with unknot as L increases; dominance of unknot remains substantial for small L; log R_L(4_1/3_1^+) approaches 0 with L. 5_2 more likely than 5_1 as φ→1. Six-crossing: except L=6, 6_3 most likely; compounds suppressed vs prime 6-crossing knots; 3_1^+#3_1^− more likely than 3_1^+#3_1^+ (or 3_1^−#3_1^−).
- p. 20–21 (Conclusions, hedged expectations): unknot most popular knot type for L ≤ 14, esp. low to moderately high φ; expect for large L (uniform sampling from a confining cube) non-trivial knot types to be far more likely than unknots, yet unknot may remain the single most likely knot type. ⚠ Conclusion text says the ratio flattens "to a limiting value less than zero" — meaning log-ratio < 0 (ratio < 1); also says curves "may reach a limiting curve at zero" (i.e. log ρ → 0).
- Table III shows log R_12(4_1/0_1) = +0.291(42) > 0 and Table IV log R_12(6_3/0_1) = +0.009(63) ≈ 0, i.e. at φ→1 for L=12 the figure-eight outnumbers the unknot (extrapolated, numerical); this is not commented upon in the text (⚠ conclusion p. 20 states unknot is most popular for L up to 14; Table II at n=500 is consistent, Table III extrapolation at φ=1 is not).

## Methods / algorithms
1. (p. 3–4) Model: self-avoiding polygon on Z³ of fixed length n and fixed knot type K confined to an L-cube (V = (L+1)³ sites); entropy/free energy from counts p_{n,L}(K).
2. (p. 5, 11) Sample with GAS (Janse van Rensburg–Rechnitzer) and GARM using BFACF elementary moves, producing estimates of ratios p_n(K)/p_m(K); normalise using exact exhaustive minimal-length counts p_{n_K,L}(K) (Table I) so that absolute counts for n_K ≤ n ≤ (L+1)³−1 are obtained.
3. (p. 11–12) Parallel implementation (4–6 threads, similar to parallel PERM). GAS simulation = B blocks × T threads × S iterations; blocks independent, giving error bars (std from blocks, combined through the ratio, Fig. 5 caption). GARM only for verification.
4. (p. 12) Data used only where converged: φ ≲ 0.93 (L=12), ≲ 0.90 (L=14).
5. (p. 21–22) R_L extrapolated to φ=1 by weighted least squares, Eq. 18, using φ > 0.1.
6. Exhaustive search for minimal-length knot placements in L-boxes (Table I) (p. 6).

## Tables
**TABLE I (p. 7)** — "Number of lattice knots p_{n,L}(K) of minimal length n_K in an L-box". (Verified cell-by-cell against page image.)

| L-Box | 0_1 | 3_1^+ | 4_1 | 5_1^+ | 5_2^+ | 6_1^+ | 6_2^+ | 6_3 | 3_1^+#3_1^+ | 3_1^+#3_1^− |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 6 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 2 | 36 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 3 | 108 | 2084 | 864 | 0 | 0 | 0 | 0 | 0 | 0 | 108 |
| 4 | 240 | 15052 | 14048 | 9840 | 123312 | 6144 | 14568 | 4032 | 1332 | 33192 |
| 5 | 450 | 48876 | 73440 | 52416 | 740232 | 37512 | 134928 | 32496 | 61452 | 634752 |
| 6 | 756 | 113540 | 188928 | 147504 | 2186976 | 112329 | 459480 | 106272 | 222456 | 2201904 |
| 7 | 1176 | 219028 | 386400 | 315120 | 4808280 | 249000 | 1086720 | 246672 | 530280 | 5166360 |
| 8 | 1728 | 375324 | 687744 | 575280 | 8948880 | 465984 | 2115144 | 475008 | 1030860 | 9959832 |
| 9 | 2430 | 592412 | 1114848 | 948000 | 14953512 | 781704 | 3643248 | 812592 | 1770132 | 17014032 |
| 10 | 3300 | 880276 | 1689600 | 1453296 | 23166912 | 1214592 | 5769528 | 1280736 | 2794032 | 26760672 |
| 11 | 4356 | 1248900 | 2433888 | 2111184 | 33933816 | 1783080 | 8592480 | 1900752 | 4148496 | 39631464 |
| 12 | 5616 | 1708268 | 3369600 | 2941680 | 47598960 | 2505600 | 12210600 | 2693952 | 5879460 | 56058120 |
| 13 | 7098 | 2268364 | 4518624 | 3964800 | 64507080 | 3400584 | 16722384 | 3681648 | 8032868 | 76472352 |
| 14 | 8820 | 2939172 | 5902848 | 5200560 | 85002912 | 4486464 | 22226328 | 4885152 | 10654632 | 101305872 |
| 15 | 10800 | 3730676 | 7544160 | 6668976 | 109431192 | 5781672 | 28820928 | 6325776 | 13790712 | 130990392 |
| n_K | 4 | 24 | 30 | 34 | 36 | 40 | 40 | 40 | 40 | 40 |

**TABLE II (p. 20)** — "Estimates of log p_{n,L}(K) in an L-cube with L = 12 in descending order" (parentheses = error in last digits as printed). Verified against image.

| Knot type | n = 500 | n = 1000 | n = 2000 |
|---|---|---|---|
| 0_1 | 699.69(45) | 1297.48(52) | 1816.77(93) |
| 3_1^+ | 697.22(41) | 1296.51(50) | 1816.71(99) |
| 4_1 | 696.23(43) | 1296.36(52) | 1817.98(160) |
| 5_2^+ | 694.64(45) | 1295.97(54) | 1816.83(76) |
| 5_1^+ | 694.19(37) | 1295.06(46) | 1816.59(81) |
| 6_3 | 693.02(49) | 1294.81(62) | 1816.75(99) |
| 6_2^+ | 692.86(47) | 1294.56(52) | 1816.36(81) |
| 6_1^+ | 692.74(57) | 1294.38(61) | 1816.13(79) |
| 3_1^+#3_1^− | 692.24(45) | 1291.56(55) | 1815.77(75) |
| 3_1^+#3_1^+ | 691.49(65) | 1293.15(72) | 1815.02(91) |

(Note: at n=1000, 3_1^+#3_1^− (1291.56) is below 3_1^+#3_1^+ (1293.15) although the table is "in descending order" at n=500 only.)

**TABLE III (p. 21)** — "Limiting probability ratio R_L(K1/K2) (equation (16))" (entries are log R_L, verified against image).

| L | 3_1^+/0_1 | 4_1/0_1 | 4_1/3_1^+ | 5_1^+/0_1 | 5_2^+/0_1 |
|---|---|---|---|---|---|
| 6 | −1.538(60) | −2.030(9) | −1.507(54) | −3.689(13) | −3.197(14) |
| 8 | −0.832(23) | −1.059(22) | −0.404(21) | −2.185(29) | −1.765(39) |
| 10 | −0.572(36) | −0.377(36) | −0.137(31) | −1.391(42) | −1.049(45) |
| 12 | −0.391(34) | 0.291(42) | −0.051(29) | −0.363(48) | −0.070(51) |
| 14 | −0.301(24) | | | | |

(⚠ internal arithmetic check: log R(4_1/0_1) − log R(3_1^+/0_1) should equal log R(4_1/3_1^+): L=6: −2.030+1.538 = −0.492 ≠ −1.507; L=8: −0.227 ≠ −0.404; L=10: +0.195 ≠ −0.137; L=12: +0.682 ≠ −0.051. The columns are therefore not mutually consistent as stated (each column apparently extrapolated separately by Eq. 18 fit); transcribed as printed.)

**TABLE IV (p. 21)** — "Limiting probability ratio R_L(K1/0_1) (equation (16)) for 6 crossing knots" (log R_L; verified against image).

| L | 6_1^+/0_1 | 6_2^+/0_1 | 6_3/0_1 | 3_1^+#3_1^+/0_1 | 3_1^+#3_1^−/0_1 |
|---|---|---|---|---|---|
| 6 | −4.424(27) | −4.416(19) | −4.152(23) | −5.736(18) | −5.200(22) |
| 8 | −2.602(47) | −2.460(47) | −2.216(52) | −3.796(50) | −3.190(46) |
| 10 | −1.655(54) | −1.481(55) | −1.113(57) | −2.727(63) | −2.100(54) |
| 12 | −0.431(59) | −0.330(58) | 0.009(63) | −1.670(66) | −0.983(59) |

## Figures
- **Fig. 1 (p. 3)** — "A schematic drawing of a knot in a confining cube or box. The side length of the cube is L, and the knot has rotational, translational and conformational degrees of freedom… Notice that the cube contains (L+1)^3 lattice sites so that its volume is V = (L+1)^d sites." *What it shows:* knot inside a cube (schematic). Image: ../figures/JvROT25/p03.png
- **Fig. 2 (p. 4)** — "A lattice knot in a cube in the cubic lattice. The side length of the cube is L − 1 (so that it contains V = L^3 sites)." *What it shows:* a lattice knot drawn in a cube. Image: ../figures/JvROT25/p04.png
- **Fig. 3 (p. 8)** — free energy curves f_K(φ) of lattice unknots for L ∈ {6, 8, 10, 12, 14}; convex curves with minima (bullets) at φ* that decrease with L; curves converge toward a limit with L. Image: ../figures/JvROT25/p08.png
- **Fig. 4 (p. 9)** — schematic Flory–Huggins free energy; convex, minimum at φ_c separating solvent-rich (φ<φ_c) from polymer-rich (φ>φ_c); θ-conditions near φ_c. Image: ../figures/JvROT25/p09.png.
- **Fig. 5 (p. 13)** — ρ_{n,L}(3_1^+/0_1) for L=8 vs φ, log scale with shaded 1-σ band; monotone increase, ≈0.10 at φ≈0.5. Image: ../figures/JvROT25/p13.png
- **Fig. 6 (p. 14)** — same for L=12; same axes; below 0.10 for φ<0.3, approaching 1 beyond φ≈0.8; wider band for φ>0.5.
- **Fig. 7 (p. 15)** — "The knot probability ratio ρ_{n,L}(3_1^+/0_1) of trefoils to unknots for L ∈ {6,8,10,12,14} plotted against the concentration φ…" *What it shows:* y-axis log[ρ(3_1/0_1)] from about −13 to 0, x-axis φ in [0,1]; five curves ordered L=6 (lowest, ending near −1.5 at φ≈0.9) to L=14 (highest, near −0.3), all rising steeply at small φ and flattening above φ≈0.7. Image: ../figures/JvROT25/p15.png
- **Fig. 8 (p. 16)** — ρ_{n,L}(4_1/0_1) for L ∈ {6,8,10,12}. Image: ../figures/JvROT25/p16.png
- **Fig. 9 (p. 17)** — ρ_{n,L}(4_1/3_1^+) for L ∈ {6,8,10,12}.
- **Fig. 10 (p. 18)** — ρ_{n,L}(5_x/0_1) (caption says "figure eight knots (5x)" — ⚠ caption copy-paste error; the curves are for 5_1, 5_2) for L ∈ {6,8,10,12}.
- **Fig. 11 (p. 18)** — ρ_{n,L}(6_x/0_1) (⚠ caption again says "figure eight knots (6x)") for 6_1, 6_2, 6_3.
- **Fig. 12 (p. 19)** — ρ_{n,L}(3_1#3_1/0_1) for 3_1^+#3_1^+ and 3_1^+#3_1^−, L ∈ {6,8,10,12}.
(Figs 6, 9–12 not imaged; descriptions from captions and text.)

## Stated limitations, open problems, future work
- p. 12: convergence/noise at φ ⪆ 0.93 (L=12), 0.90 (L=14); data collection took several months.
- p. 14: simulations at L ≥ 12 "pose significant challenges".
- p. 15–16: whether R(3_1^+/0_1) < 1 and whether its value is universal "(independent of the model, and so an intrinsic property of the knot types for dense curves)" are open; "Only simulations at larger values of L, and successful collection of data for φ close to 1, would settle these questions, but are also outside the realm of what is possible using our current algorithms and computer hardware."
- p. 11: pivot algorithm has very low acceptance at high concentration; other algorithms inefficient; direct P_{n,L}(K) not accessible, only ratios.
- p. 19–20: unclear whether unknot dominance persists with increasing L and φ.

## References worth following
- [24] Janse van Rensburg, Rechnitzer, Generalized atmospheric sampling of knotted polygons, JKTR 20 (2011) 1145–1171 (GAS; trefoil ℓ≈8; crossover n≈169600).
- [37] Janse van Rensburg, Rechnitzer, Generalized atmospheric sampling of self-avoiding walks, J Phys A 42 (2009) 335001; [38] Rechnitzer, Janse van Rensburg, GARM, J Phys A 41 (2008) 442002.
- [34] Janse van Rensburg, Osmotic pressure of compressed lattice knots, PRE 100 (2019) 012501; [39] The free energy of compressed lattice knots, J Phys A 53 (2019) 015002 (χ = 0.18(3)).
- [44] Sumners, Whittington, Knots in self-avoiding walks, J Phys A 21 (1988) 1689 (μ_01<μ).
- [54] Janse van Rensburg, Whittington, The knot probability in lattice polygons, J Phys A 23 (1990) 3573.
- [43] Scharein et al., Bounds for the minimum step number of knots in the simple cubic lattice, J Phys A 42 (2009) 475006 (n_{4_1}=30, n_{5_1}=34); [42] Diao, Minimal knotted polygons on the cubic lattice, JKTR 2 (1993) (n_{3_1}=24).
- [58] Anisimov, Longo, Sengers, Critical fluctuations in polymer solutions (2024) (Flory–Huggins critical concentration).
- [49] Orlandini, Tesi, Janse van Rensburg, Whittington, Entropic exponents of lattice polygons with specified knot type, J Phys A 29 (1996) L299.

## Extraction notes
- Pages rendered: 3, 4, 7, 8, 13, 15, 16, 20, 21 9. Tables I–IV checked against page images (pp. 7, 20, 21); cells match text layer.
- No numbered theorems/lemmas exist in this paper; it is a numerical study. All "results" are numerical/heuristic.
- ⚠ list: cube volume convention (L^3 vs (L+1)^3, Fig. 2 caption, Eq. 6); Fig. 10/11/12 captions copy "figure eight knots"; Table III column inconsistency; "limiting value less than zero" wording (log-scale); Fig 6 text says ratio →1 while Table III log R_12 = −0.391; Table III L=12 4_1/0_1 > 0 vs conclusion; garbled derivation of φ_c ≈ 1/(L+1) (p. 8–9).
- Figs 4, 6, 9–12 not viewed as images.
