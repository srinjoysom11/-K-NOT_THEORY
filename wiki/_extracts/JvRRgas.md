# JvRRgas — Generalised Atmospheric Sampling of Knotted Polygons
- **Authors:** E.J. Janse van Rensburg (York University, Toronto) and A. Rechnitzer (University of British Columbia, Vancouver)
- **Venue / year / identifiers:** Journal of Knot Theory and Its Ramifications (World Scientific) — preprint/instruction-file version, header "February 16, 2010 16:13 WSPC/INSTRUCTION FILE GASknot˙f". No volume/page numbers printed. AMS MSC 2000: 57M25, 82B41, 26D15, 92B99; PACS 02.10.Kn, 36.20.Ey, 05.70.Jk, 87.15.Aa.
- **File:** papers/2_algorithms/JvR-Rechnitzer_GAS_knotted_polygons_GASknot.pdf   **Pages:** 29
- **Text layer:** ok (formulas, sub/superscripts and chirality marks garbled; all checked against page images)

## Abstract
Self-avoiding polygons in the cubic lattice are models of ring polymers in dilute solution. The conformational entropy of a ring polymer is a dominant factor in its physical and chemical properties, and this is modeled by the large number of conformations of lattice polygons. Since cubic lattice polygons are embeddings of the circle in three space, they can be knotted is a model of knotting in ring polymers. In this paper we study the effects of knotting on the conformational entropy of lattice polygons and so determine the relative fraction of polygons of different knot types at large lengths.

More precisely, we consider the number of cubic lattice polygons of n edges and knot type K, p_n(K). Numerical evidence strongly suggests that
  p_n(K) ≃ C_K n^{α−3+N_K} μ_0^n
as n → ∞, where μ_0 is the growth constant of unknotted lattice polygons, α is the entropic exponent of lattice polygons, and N_K is the number of prime knot components in the knot type K [35]. Determining the exact value of p_n(K) is far beyond current techniques for all but very small values of n. Instead we use the GAS algorithm [23] to enumerate p_n(K) approximately. We then extrapolate ratios [p_n(K)/p_n(L)] to larger values of n for a number of given knot types.

We give evidence that for the unknot 0_1 and the trefoil knot 3_1, there exists a number M_{0_1,3_1} ≈ 170000 such that p_n(0_1) > p_n(3_1) if n < M_{0_1,3_1} and p_n(0_1) ≤ p_n(3_1) if n ≥ M_{0_1,3_1}. In addition, the asymptotic relative frequencies for a variety of knot types are determined. For example, we find that [p_n(3_1)/p_n(4_1)] → 27.0 ± 2.2, so that there are approximately 27 polygons of knot type the trefoil for every polygon of knot of type 4_1 (the figure eight knot), in the asymptotic limit.

Finally, we examine the dominant knot types at moderate values of n and conjecture that the most frequent knot types in polygons of any given length n, are of the form K_+(N) = (3_1^+)^{⌈N/2⌉} # (3_1^−)^{⌊N/2⌋} (or its chiral partner), where 3_1^+, 3_1^− are right- and left-handed trefoils, and N increases with n.

Keywords: Knotted Polygons, Monte Carlo, Lattice Knot Statistics.

## Notation and conventions
- **Lattice polygon, p_n (p. 2):** "A lattice polygon is an unrooted embedding of the unlabeled cycle graph in the hypercubic lattice Z^d. The length of the polygon is the number of unit length edges it contains and p_n is defined as the number of polygons of length n counted up to equivalence under translation in the lattice." The paper works in the simple cubic lattice Z^3.
- **μ (p. 2):** μ = lim_{n→∞} p_n^{1/n} (1.1), the lattice growth constant (= that of SAWs). Believed p_n = A n^{α−3} μ^n (1 + o(1)) (1.2), α = polygon entropic (specific-heat) exponent. Kesten: lim p_{n+2}/p_n = μ^2 (1.3).
- **p_n(K) (p. 2, p. 4):** number of polygons of length n and knot type K (counted up to translation). μ_0 = growth constant of unknotted polygons, μ_0 < μ (p. 3). α_K = entropic exponent of knot type K; the paper writes α_K = α + N_K (p. 6).
- **N_K (p. 6):** "the number of prime components in the knot type K".
- **Chirality (p. 4):** for chiral K, K^+ and K^− denote right/left-handed types, p_n(K^+) = p_n(K^−) (2.1), p_n(K) = p_n(K^+) + p_n(K^−) = 2p_n(K^+) (2.2).
- **p_n^±(K) (pp. 4–5, eq. 2.3/2.6):** p_n^±(K) = p_n(K) if K achiral; p_n(K^+) + p_n(K^−) if K chiral. E.g. p_n^±(3_1^+#3_1^+) = p_n(3_1^+#3_1^+) + p_n(3_1^−#3_1^−) = 2 p_n(3_1^+#3_1^+) (2.4); this does not count the achiral square knot 3_1^+#3_1^−. p_n^±(4_1) = p_n(4_1), p_n^±(3_1) = p_n(3_1^+) + p_n(3_1^−).
- **n_min(K) (p. 5):** "For each knot type K there is a number n_min(K) such that p_n(K) = 0 if n < n_min(K) and otherwise p_n(K) > 0 for even n. The number n_min(K) is the minimal length of the knot type K in the cubic lattice."
- **Symmetry class (p. 5, p. 12):** equivalence class of polygons under the 24 elements of the octahedral group ("rotations and reflections"); "normally each equivalence class will contain 24 elements".
- **Amplitude ratio [C_K/C_L], M_{K,L} (p. 7, eq. 2.14):** M_{K,L} ≈ [C_K/C_L]^{1/(N_L−N_K)} if N_L > N_K; M_{K,L} ≈ [C_K/C_L] if N_L = N_K. When N_K > N_L, M_{L,K} = 1/M_{K,L}. If N_K = N_L, M_{K,L} is the relative asymptotic frequency (p_n^±(K) ≃ [M_{K,L}] p_n^±(L), 2.15); if N_L > N_K, M_{K,L} approximates the length at which p_n^±(L) starts to dominate p_n^±(K) (2.16). "it is trivially the case that M_{K,K} = n_min(K)" (p. 14, as printed).
- **M_{0_1,3_1} (p. 6, eq. 2.8):** least integer such that p_n(0_1) ≤ p_n^±(3_1) for all even n ≥ M_{0_1,3_1}. M_{0_1,3_1^+} = 2 M_{0_1,3_1} (2.13).
- **Atmospheres (p. 7–8):** a_−(ω) = number of negative atmospheric plaquettes (three successive edges in a ⊔-conformation; BFACF type II length-reducing); a_+(ω) = positive (an edge replaceable by three edges in ⊔-conformation giving length n+2); a_0(ω) = neutral (two adjacent edges at right angle bounding a unit square containing exactly two edges and three vertices of the polygon; BFACF type I). They count the possible length-increasing, length-decreasing and fixed-length BFACF moves.
- **Error-bar format (p. 16):** "estimate ± 67%-confidence interval ± systematic error". Final M values: statistical and systematic errors combined and then the interval doubled. Notation like 3.39(23) × 10^5 in Table 5 means 3.39 ± 0.23.

## Numbered statements
**Theorem 3.1 (p. 8) (quoted from reference [24], Janse van Rensburg & Whittington 1991).** The irreducibility classes of the BFACF moves for unrooted polygons in the cubic lattice coincide with the knot types of the polygons as closed simple curves in three dimensions.

**Conjecture (pp. 25–26) (conjecture, numerical support).** Consider the knot types
  K_+(N) = (3_1^+)^{⌈N/2⌉} # (3_1^−)^{⌊N/2⌋} and K_−(N) = (3_1^−)^{⌈N/2⌉} # (3_1^+)^{⌊N/2⌋}
where K_+(0) = K_−(0) = 0_1, K_+(1) = 3_1^+ and K_−(1) = 3_1^−. Then amongst polygons of a given even length n ≥ 4 there is an N such that the most populous knot types are both K_+(N) and K_−(N). Moreover, N increases to infinity proportionally with n, so that the complexity of the most populous knot type increases with the length of the polygons.
— "This conjecture in particular is also consistent with p_n(3_1^+#3_1^−) > p_n(3_1^+#3_1^+) for each value of n. It is also supported by the estimates in equations (5.7), (5.8), and (5.9)." (p. 26)

**Ansatz (2.7) (p. 6) (numerical evidence, from [35], [38], [32]).** p_n^±(K) ≃ C_K n^{α−3+N_K} μ_{0_1}^n.

## Key equations and quantitative claims outside numbered statements
- (1.4)–(1.5), p. 2 (quoted, square lattice Z^2 [25,26]): μ = 2.63815853034(10), α = 0.5000005(10); exact α = 1/2 in 2D from CFT/Coulomb gas [33,34].
- (1.6)–(1.7), p. 2 (quoted, Z^3, lace-expansion enumeration [4]): μ = 4.684044(11), α ≈ 0.24; ε-expansion [11,29]: α = 0.237 ± 0.002.
- p. 5: p_4(0_1) = 3. n_min(3_1) = 24 (proved [6]); p_24^±(3_1) = 3328 [7,42], so p_24(3_1^+) = 1664. 3328 is not a multiple of 24 ⇒ some minimal trefoils are lattice-symmetric. Simulations: 142 symmetry classes of minimal trefoils (length 24).
- p. 5: n_min(4_1) = 30, p_30(4_1) = 3648 [42]. ⚠ The text says "there are 278 distinct equivalence classes for this knot. Observe that 278 × 24 = 3648", but Table 1 lists 152 classes for 4_1 (152 × 24 = 3648; 278 is the 5_1 entry and 278 × 24 = 6672).
- p. 12: Fig. 3 minimal trefoil (n = 24) has only 8 distinct images; Fig. 4 minimal 6_1 (n = 40) invariant under a 180° rotation, class of 12. Among prime knots in Table 1 only 3_1, 6_1 and 8_19 produced such symmetric examples (p. 12; p. 26 says 0_1, 3_1, 6_1, 8_19); among compound knots 3_1^+#3_1^−, 3_1^+#3_1^+, 4_1#4_1 and (3_1^+)^4. ⚠ p. 26 lists "3_1^+#3_1^+, 3_1^+#3_1^−, 4_1#4_1 and 3_1^+#3_1^+#3_1^+#3_1^+" — same set.
- p. 12: Table 1 values exact for 0_1, 3_1, 4_1; all others are lower bounds. 3_1^+#3_1^+#3_1^−#3_1^− "proved too much for our available hardware"; sieving (3_1^+)^2#(3_1^−)^2 produced "tens of millions of polygons" (p. 25).
- p. 13 (exact comparison values from series [4]): p_18(0_1) = 108088232, p_22(0_1) = 29764630632 (vs GAS estimates in Table 2). Series for all polygons known to n = 32 [4].
- p. 10: flatGAS runs over even n ∈ [n_min(K), n_max(K)], n_max usually 2500 (500 for cases marked * — see Extraction notes); each sequence 10^7 states; e.g. 2500 sequences for the unknot, 2000 for trefoils.
- (4.2), p. 13: log[n p_n(0_1)/p_n^±(3_1)] ≈ log[C_{0_1}/C_{3_1}] + c_1/n + c_2/n^2 + …; three-parameter regression on c_0 + c_1/n + c_2/n^2 gives c_0 = log[C_{0_1}/C_{3_1}] = log M_{0_1,3_1}.
- (4.3), p. 14: log[n^{−N_K} p_n^±(K) / (n^{−N_L} p_n^±(L))] ≈ log[C_K/C_L] + c_1/n + c_2/n^2 + … (as printed).
- **Unknot/trefoil (p. 16, numerical):** fit n_min = 34, n_max = 1500: χ² ≈ 757 on 732 d.o.f. (acceptable at 75% level), log[C_{0_1}/C_{3_1}] = 12.0410 ± 0.0074; n_min = 36: 12.0159 ± 0.0075. Best: log M_{0_1,3_1} = 12.0410 ± 0.0074 ± 0.0251. **M_{0_1,3_1} = 170000 ± 12000 (4.4)**; **M_{0_1,3_1^+} = 340000 ± 24000 (4.5)**. Fig. 5 caption: X-intercept log n ≈ 12.041 ± 0.038.
- **Unknot/figure-eight (p. 17):** no consistent estimate with n > 700 included; with n ≤ 700, n_min 30→58 explored. log[C_{0_1}/C_{4_1}] = 15.4030 ± 0.0135 at n_min = 48 (χ² ≈ 343 on 325 d.o.f., 76.1% level); n_min = 50: 15.3708 ± 0.0140 (χ² ≈ 303 on 324 d.o.f., 20% level). log M_{0_1,4_1} = 15.4030 ± 0.0135 ± 0.0328. **M_{0_1,4_1} = (4.89 ± 0.46) × 10^6 (4.6)**, crossover near n ≈ 4890000. Fig. 7 caption: log n = 15.403 ± 0.047.
- **Trefoil/figure-eight (p. 18):** n_max = 1000, n_min = 40: log[C_{3_1}/C_{4_1}] = 3.2967 ± 0.0098, χ² ≈ 435 on 479 d.o.f. (73.1%); n_min = 42: 3.2665 ± 0.0101. Combined 3.2967 ± 0.0098 ± 0.0302. **M_{3_1,4_1} = 27.0 ± 2.2 (4.7)**. Consistency (p. 19): M_{0_1,3_1} × M_{3_1,4_1} ≈ 4.59 × 10^6 vs M_{0_1,4_1} = (4.89 ± 0.46) × 10^6. **M_{3_1^+,4_1} ≈ 13.5 ± 1.1.**
- **5_1 (p. 19):** n_max = 1800; n_min = 36: log[C_{0_1}/C_{5_1}] = 17.8362 ± 0.0314, χ² ≈ 42 "acceptable at the 0% level" on 331 d.o.f.; n_min = 38: 17.8057 ± 0.0325 (χ² ≈ 34, 330 d.o.f.). Best 17.8362 ± 0.0314 ± 0.0305. **M_{0_1,5_1} = (5.58 ± 0.70) × 10^7 (4.8).**
- **5_2 (p. 20):** n_min = 64: log[C_{0_1}/C_{5_2}] = 17.1412 ± 0.0187, χ² ≈ 328 on 317 d.o.f. (68%); n_min = 66: 17.1044 ± 0.0191 (χ² ≈ 291, 316 d.o.f., 16%). Best 17.1412 ± 0.0187 ± 0.0368. **M_{0_1,5_2} = (2.78 ± 0.32) × 10^7 (4.9)** — 5_2 crosses over the unknot before 5_1. ⚠ The n_min = 66 value and the "best estimate" are printed as log[C_{0_1}/C_{5_1}] (typo for 5_2).
- p. 21: Table 4 internal consistency: M_{3_1,4_1} × M_{4_1,5_1} = 438 ± 76 while M_{3_1,5_1} = 399 ± 44; n_max = 1000 used because data noisy for n > 1000.
- p. 21–22: chiral conversion "M_{K^+,L^+} = M_{K,L} = 2 M_{K^+,L} = 0.5 M_{K,L^+}"; e.g. M_{4_1,5_1^+} = 32.4 ± 3.0 and M_{5_1^+,6_1} = 5.4 ± 0.9.
- **(3_1^+)^2 (p. 22):** N = 2; n_max = 700, n_min = 50: log[C_{0_1}/C_{3_1^+#3_1^+}] = 26.199 ± 0.016 ± 0.050, χ² ≤ 316 on 323 d.o.f. (40%). **M_{0_1,(3_1^+#3_1^+)} = 977000 ± 66000 (5.1).**
- **3_1^+#3_1^− (p. 23):** n_max = 700, n_min = 50, χ² ≤ 286 on 324 d.o.f. (6.4%): log[C_{0_1}/C_{3_1^+#3_1^+}] = 26.228 ± 0.015 ± 0.045 (⚠ subscript printed as 3_1^+#3_1^+, context is 3_1^+#3_1^−). **M_{0_1,(3_1^+#3_1^−)} = 496000 ± 30000 (5.2).**
- **(5.3), p. 23:** n_max = 700, n_min = 42: **M_{(3_1^+#3_1^+),(3_1^+#3_1^−)} = 0.535 ± 0.066** — chiral 3_1^+#3_1^+ roughly half as numerous as achiral 3_1^+#3_1^−.
- **(5.4), p. 23:** ratio n p_n^±(3_1^+)/p_n^±(3_1^+#3_1^+), n_min = 48, n_max = 700, "acceptable at the 0% level on 325 degrees of freedom": log[C_{3_1^+}/C_{3_1^+#3_1^+}] = 14.203 ± 0.016 ± 0.048; **M_{3_1^+,(3_1^+#3_1^+)} = 1473000 ± 190000** (compound trefoil overtakes prime trefoil at ≈ 1.5 million edges).
- **(5.5), p. 24:** (3_1^+)^3, N_K = 3, n_min = 60, n_max = 700, 53% on 314 d.o.f.: log[C_{0_1}/C_{(3_1^+)^3}] = 41.712 ± 0.021 ± 0.032; **M_{0_1,(3_1^+)^3} = (2.18 ± 0.80) × 10^6.** ⚠ Table 5 prints this entry as 2.18(80) × 10^5.
- **(5.6), p. 24:** (3_1^+)^4, N_K = 4, n_min = 80, n_max = 700, 37% on 307 d.o.f.: log[C_{0_1}/C_{(3_1^+)^4}] = 61.032 ± 0.026 ± 0.077; **M_{0_1,(3_1^+)^4} = (8.40 ± 0.40) × 10^6.**
- **(5.7), p. 24:** M_{(3_1^+#3_1^+),(3_1^+#4_1)} = 9.4 ± 1.2.
- **(5.8), p. 25:** M_{(3_1^+#3_1^+),(4_1#4_1)} = 250 ± 40.
- **(5.9), p. 25:** M_{(3_1^+#3_1^+#3_1^−),(3_1^+#3_1^+#3_1^+)} = 9.0 ± 1.4.
- **(5.10), p. 25:** n ≤ 700, n_min = 68, N_K = 3: "[C_{0_1}/C_{3_1^+#3_1^+#3_1^−}] = 39.595 ± 0.066" (⚠ printed without "log"); **M_{0_1,(3_1^+#3_1^+#3_1^−)} = (1.08 ± 0.11) × 10^6**, less than (5.5), "implying that this compound knot is more numerous". Results "very sensitive to the maximum length".
- p. 27: "if K and L are both prime knot types, or have the same number of prime components, then M_{K,L} is dimensionless, and may in fact be universal (independent of the lattice)" (speculation).

## Methods / algorithms
GAS (Generalised Atmospheric Sampling) with BFACF moves as atmospheric moves (pp. 7–10):
1. State: a cubic-lattice polygon φ_j of fixed knot type K; start φ_0 of type K. Moves: positive (a_+, length +2), neutral (a_0, length-preserving, BFACF type I), negative (a_−, length −2) BFACF moves. By Theorem 3.1 the chain is irreducible on polygons of a fixed knot type (p. 8).
2. Move selection at length ℓ (3.1–3.3): P_+ = β_ℓ a_+(φ_j)/[a_−(φ_j) + a_0(φ_j) + β_ℓ a_+(φ_j)], P_0 = a_0(φ_j)/[same], P_− = a_−(φ_j)/[same].
3. flatGAS (p. 9, eq. 3.4): β_ℓ = ⟨a_−(φ)⟩_ℓ / ⟨a_+(φ)⟩_ℓ, with β_{n_max} = 0; gives roughly equal samples at all lengths ℓ < n_max.
4. Weights (pp. 9–10): σ(φ_j, φ_{j+1}) = −1 for a positive move, +1 for a negative move. W_0 = 1; W'_{j+1} = (a_−^g(φ_j) + a_0^g(φ_j) + β_{ℓ_j} a_+^g(φ_j)) W_j; W_{j+1} = W'_{j+1} β_{ℓ_{j+1}}^{σ(φ_j,φ_{j+1})} / (a_−^g(φ_{j+1}) + a_0^g(φ_{j+1}) + β_{ℓ_{j+1}} a_+^g(φ_{j+1})). Sequence weight (3.5): W(φ) = [ (a_−^g(φ_0) + a_0^g(φ_0) + β_{ℓ_0} a_+^g(φ_0)) / (a_−^g(φ_L) + a_0^g(φ_L) + β_{ℓ_L} a_+^g(φ_L)) ] ∏_{j=0}^{|φ|−1} β_{ℓ_j}^{σ(φ_j,φ_{j+1})}. (The superscript g is printed but not defined in this paper.)
5. Estimator (3.6): Σ_{|τ|=n} ⟨W(φ)⟩_τ / Σ_{|σ|=m} ⟨W(φ)⟩_σ = p_n(K)/p_m(K). Justification: backward chain is irreducible recurrent on a finite state space, so ⟨P(φ_0|τ)⟩_n becomes independent of n.
6. Normalisation (pp. 10–12): p_{n_min}^±(K) obtained by sieving minimal-length polygons encountered during simulation: each put in a lexicographic least string, rotated/reflected by the octahedral group to find its class, hashed and listed.
7. Runs (p. 10): sequences of 10^7 states on even n ∈ [n_min(K), n_max(K)], n_max(K) usually 2500 (500 in some cases); number of sequences = "Iterations" column of Table 1.
8. Analysis (pp. 13–16): weighted least-squares three-parameter fits of log ratio vs 1/n (model 4.3); drop n > n_max (1500, 1000, 1800 or 700 depending on case), increase n_min in steps of 2 until fit acceptable at 95% level; systematic error = |change| when n_min increased by 2 more; combine errors, exponentiate, double the interval.

## Tables
**Table 1 (p. 11).** "Knotted Polygons of Minimal Length." (verified against image)

| K | n_min(K) | p^±_{n_min}(K) | Symmetry classes | Iterations (×10^7) |
|---|---|---|---|---|
| 0_1 | 4 | 3 | 1 | 2500* |
| 3_1^+ | 24 | 3328 | 142 | 2000* |
| 4_1 | 30 | 3648 | 152 | 1500* |
| 5_1^+ | 34 | 6672 | 278 | 1000* |
| 5_2^+ | 36 | 114912 | 4788 | 500 |
| 6_1^+ | 40 | 6144 | 258 | 500 |
| 6_2^+ | 40 | 32832 | 1368 | 500 |
| 6_3 | 40 | 3552 | 148 | 500 |
| 8_19^+ | 42 | 13992 | 592 | 500 |
| 3_1^+#3_1^− | 40 | 143904 | 6056 | 500 |
| 3_1^+#3_1^+ | 40 | 30576 | 1275 | 500 |
| 3_1^+#4_1 | 46 | 359712 | 14988 | 500 |
| 4_1#4_1 | 52 | 334824 | 13987 | 500 |
| 3_1^+#3_1^+#3_1^+ | 56 | 288816 | 12034 | 500 |
| 3_1^+#3_1^+#3_1^− | 56 | 8874648 | 369777 | 500 |
| 3_1^+#3_1^+#3_1^+#3_1^+ | 72 | 2752304 | 114680 | 500 |

(Exact for 0_1, 3_1, 4_1; lower bounds otherwise, p. 12.)

**Table 2 (p. 13).** "Approximate Enumeration of Trefoil Polygons with GAS." (verified against image; p_m(3_1) here is the p^± count 3328 at n = 24)

| n | p_m(0_1) | p_m(3_1) | p_m(4_1) |
|---|---|---|---|
| 4 | 3 | | |
| 6 | 22 | | |
| 8 | (2.0699 ± 0.0024) × 10^2 | | |
| 10 | (2.4143 ± 0.0047) × 10^3 | | |
| 12 | (3.1863 ± 0.0081) × 10^4 | | |
| 14 | (4.541 ± 0.014) × 10^5 | | |
| 16 | (6.856 ± 0.023) × 10^6 | | |
| 18 | (1.084 ± 0.0041) × 10^8 | | |
| 20 | (1.774 ± 0.0032) × 10^9 | | |
| 22 | (2.987 ± 0.015) × 10^10 | | |
| 24 | (5.156 ± 0.027) × 10^11 | 3328 | |
| 26 | (9.053 ± 0.051) × 10^12 | 281050 ± 630 | |
| 28 | (1.618 ± 0.010) × 10^14 | (1.4339 ± 0.0053) × 10^7 | |
| 30 | (2.931 ± 0.020) × 10^15 | (5.769 ± 0.028) × 10^8 | 3648 |
| 32 | (5.380 ± 0.039) × 10^16 | (2.005 ± 0.011) × 10^10 | (5.414 ± 0.017) × 10^5 |
| 34 | (9.980 ± 0.076) × 10^17 | (6.342 ± 0.039) × 10^11 | (4.341 ± 0.025) × 10^7 |
| 36 | (1.871 ± 0.015) × 10^19 | (1.862 ± 0.012) × 10^13 | (2.495 ± 0.018) × 10^9 |
| 38 | (3.537 ± 0.030) × 10^20 | (5.204 ± 0.038) × 10^14 | (1.164 ± 0.010) × 10^11 |

**Table 3 (p. 20).** "M_{0_1,K} for prime knots." (verified)

| 0_1/K | M_{0_1,K} | 0_1/K | M_{0_1,K} |
|---|---|---|---|
| 3_1 | (1.70 ± 0.12) × 10^5 | 6_1 | (6.42 ± 0.64) × 10^8 |
| 4_1 | (4.89 ± 0.46) × 10^6 | 6_2 | (7.28 ± 0.74) × 10^8 |
| 5_1 | (5.58 ± 0.70) × 10^7 | 6_3 | (1.54 ± 0.22) × 10^9 |
| 5_2 | (2.78 ± 0.32) × 10^7 | 8_19 | (2.78 ± 0.28) × 10^10 |

**Table 4 (p. 21).** "M_{K,L} for prime knots (M_{L,K} = 1/M_{K,L})." (verified against image; text layer is misaligned by one row)

| K/L | M_{K,L} | K/L | M_{K,L} |
|---|---|---|---|
| 3_1/4_1 | 27.0 ± 2.2 | 5_1/6_1 | 10.8 ± 1.8 |
| 3_1/5_1 | 399 ± 44 | 5_1/6_2 | 11.8 ± 1.2 |
| 3_1/5_2 | 216 ± 24 | 5_1/6_3 | 22.2 ± 2.7 |
| 3_1/6_1 | 5160 ± 560 | 5_1/8_19 | 447 ± 56 |
| 3_1/6_2 | 6240 ± 600 | 5_2/6_1 | 31.0 ± 5.0 |
| 3_1/6_3 | 11900 ± 1800 | 5_2/6_2 | 34.6 ± 4.6 |
| 3_1/8_19 | 225100 ± 28000 | 5_2/6_3 | 71 ± 18 |
| 4_1/5_1 | 16.2 ± 1.5 | 5_2/8_19 | 1280 ± 170 |
| 4_1/5_2 | 9.0 ± 1.2 | 6_1/6_2 | 1.05 ± 0.13 |
| 4_1/6_1 | 218 ± 30 | 6_1/6_3 | 1.83 ± 0.30 |
| 4_1/6_2 | 258 ± 28 | 6_1/8_19 | 47.0 ± 5.2 |
| 4_1/6_3 | 475 ± 72 | 6_2/6_3 | 2.06 ± 0.32 |
| 4_1/8_19 | 9000 ± 1100 | 6_2/8_19 | 40.3 ± 4.6 |
| 5_1/5_2 | 0.417 ± 0.040 | 6_3/8_19 | 25.5 ± 6.4 |

⚠ Text p. 21 says "M_{3_1,4_1} × M_{4_1,5_1} = 438 ± 76" — consistent with 27.0 × 16.2 ≈ 437. 5_1/5_2 = 0.417 < 1 consistent with 5_2 being more common (4.9 vs 4.8). p. 22 "M_{4_1,5_1^+} = 32.4 ± 3.0" = 2 × 16.2.

**Table 5 (p. 25).** "M_{K,L} for compounded trefoils." (verified with 250-dpi zoom)

| K\L | 3_1^+ | (3_1^+)^2 | (3_1^+)^3 | (3_1^+)^4 |
|---|---|---|---|---|
| 0_1 | 3.39(23) × 10^5 | 9.77(66) × 10^5 | 2.18(80) × 10^5 | 8.40(40) × 10^6 |
| 3_1^+ | 1 | 1.47(19) × 10^6 | 2.56(12) × 10^6 | 1.245(60) × 10^7 |
| (3_1^+)^2 | — | 1 | 5.08(56) × 10^6 | 3.90(28) × 10^7 |
| (3_1^+)^3 | — | — | 1 | 3.80(52) × 10^8 |

⚠ 0_1/(3_1^+)^3 cell printed "× 10^5" but eq. (5.5) gives (2.18 ± 0.80) × 10^6. ⚠ 0_1/3_1^+ = 3.39(23) × 10^5 vs eq. (4.5) 340000 ± 24000 (rounding). ⚠ Diagonal "1" entries conflict with the paper's own statement M_{K,K} = n_min(K) (p. 14).

## Figures
- **Fig. 1 (p. 3)** — "The two elementary moves in the BFACF algorithm. Moves of type I are length preserving, while moves of type II changes the length of the polygon by two steps or edges." *What it shows:* schematic of the BFACF type I (corner flip) and type II (plaquette insertion/deletion) moves. Image: ../figures/JvRRgas/p03.png
- **Fig. 2 (p. 8)** — "Plaquette atmospheres induced by the BFACF elementary moves. This polygon has positive atmosphere a_+ = 11, neutral atmosphere a_0 = 6 and negative atmosphere a_− = 4." *What it shows:* a square-lattice polygon with plaquettes marked ⊕ (blue), ⊙ (green), ⊖ (red). Image: ../figures/JvRRgas/p08.png
- **Fig. 3 (p. 11)** — "A minimal length lattice trefoil knot of length 24 and with only 8 distinct conformations under rotations and reflections in the cubic lattice." *What it shows:* 3D drawing of the lattice trefoil with vertices marked, XYZ axes. Image: ../figures/JvRRgas/p11.png
- **Fig. 4 (p. 12)** — "A minimal length lattice knot of type 6_1 and length 40 edges and with only 12 distinct conformations under symmetry operations of the octahedral group. This particular polygon is invariant under a 180° rotation and belongs to an equivalence class with only 12 distinct members under reflections and rotation of the cubic lattice onto itself." *What it shows:* 3D lattice drawing of the 6_1 conformation. Image: ../figures/JvRRgas/p12.png
- **Fig. 5 (p. 14)** — "The ratio [p_n(0_1)/p_n^±(3_1)] as a function of length n on logarithmic scales. For small values of n, p_n(0_1) > p_n^±(3_1), but since this relation changes to p_n(0_1) < p_n^±(3_1) for large values of n ≥ M_{0_1,3_1}, it must cut through the X-axis if it is extrapolated. Extrapolation of the data shows that this occurs near log n ≈ 12.041±0.038 (see the text for details about the extrapolation)." *What it shows:* log ratio (y 0–20) vs log n (x 0–15); red curve from ≈19 at log n ≈ 3.2 decreasing to ≈5 at log n ≈ 7.8; bullet at (12, 0).
- **Fig. 6 (p. 15)** — "Testing the hypothesis that N_{3_1} = 1 for the trefoil knot in equation (2.7). The data approaches a non-zero constant as n → ∞, and the value of this Y-intercept is an estimate of the amplitude ratio [C_{0_1}/C_{3_1}]. These data also give the estimate M_{0_1,3_1} = 170000 ± 12000 so that p_n(0_1) ≈ p_n^±(3_1) when n ≈ M_{0_1,3_1} and p_n(0_1) < p_n(3_1) for n > M_{0_1,3_1}. In other words, polygons of knot type trefoil start to dominate unknotted polygons at lengths of about 170000 edges." *What it shows:* log(n p_n(0_1)/p_n^±(3_1)) vs 1/n (0–0.05); curve rises from ≈12 at 1/n=0 to ≈22 at 1/n≈0.042. Image: ../figures/JvRRgas/p15.png
- **Fig. 7 (p. 17)** — "The ratio [p_n(0_1)/p_n(4_1)] against n on logarithmic axes. The proportion of polygons of knot type 4_1 increases relative to the number of unknotted polygons with n, and extrapolation of the curve shows that it approaches the X-axis when log n = 15.403 ± 0.047." *What it shows:* log ratio decreasing from ≈27 at log n ≈ 3.4 to ≈8 at log n ≈ 7.8; bullet at log n ≈ 15.4 on the x-axis.
- **Fig. 8 (p. 18)** — "Extrapolation of the data in figure 7. The curve approaches a non-zero constant as n → ∞ on the Y-axis, providing strong numerical evidence that N_{4_1} = 1 in equation (2.7) for the figure eight knot. The amplitude ratio [C_{0_1}/C_{4_1}] is estimated by the Y-intercept, and is an estimate also of M_{0_1,4_1} = (4.89 ± 0.46) × 10^6. Thus, the unknot and the figure eight knot turn over at his length." *What it shows:* log(n p_n(0_1)/p_n(4_1)) vs 1/n, from ≈15 at 0 to ≈31 at 1/n ≈ 0.033.
- **Fig. 9 (p. 19)** — "Plotting log[p_n^±(3_1)/p_n(4_1)] against n to determine the asymptotic relative frequency of trefoils and figure eights in polygons. Extrapolation to the Y-axis shows that M_{3_1,4_1} = 27.0 ± 2.2; in other words, for every 27 trefoils, we should observe one figure eight knot in the limit of large n." *What it shows:* curve labelled 3_1/4_1 from ≈3.3 at 1/n=0 rising to ≈12 at 1/n≈0.033. Image: ../figures/JvRRgas/p19.png
- **Fig. 10 (p. 20)** — "log[n p_n(0_1)/p_n^±(K)] plotted against 1/n for K = 3_1, 4_1, 5_1 and 5_2. In each case the curves approach a non-zero finite value as n increases, providing numerical evidence that N_K = 1 in equation (2.7) for these knot types. Extrapolation of the data to the Y-axis gives the points indicated by bullets. These points provide estimates of M_{0_1,K} of each of the knot types." *What it shows:* four curves; intercepts ≈12 (3_1), ≈15.4 (4_1), ≈17–18 (5_1, 5_2). Image: ../figures/JvRRgas/p20.png
- **Fig. 11 (p. 21)** — "Plotting log[p_n^±(K)/p_n^±(L)] against n to determine the asymptotic relative frequency of knots of types K and L in polygons." *What it shows:* curves 3_1/5_2, 3_1/5_1 (intercepts ≈5.4–6), 3_1/4_1 (≈3.3), 4_1/5_2, 4_1/5_1 (≈2.2–2.8), 5_1/5_2 (slightly below 0) vs 1/n. Image: ../figures/JvRRgas/p21.png
- **Fig. 12 (p. 22)** — "Extrapolating data for knots of type 3_1^+#3_1^+ and 3_1^+#3_1^− to estimate M_{0_1,(3_1^+#3_1^+)} and M_{0_1,(3_1^+#3_1^+)}. Also plotted are data for K = 3_1 for comparison." (⚠ second subscript printed as 3_1^+#3_1^+.) *What it shows:* log(n^{N_K} p_n(0_1)/p_n^±(K)) vs 1/n; the two N=2 curves nearly coincide with intercept ≈26; 3_1 curve intercept ≈12. Image: ../figures/JvRRgas/p22.png
- **Fig. 13 (p. 23)** — "Extrapolating data for compounded knots of type (3_1^+)^N for N = 1, 2, 3, 4." *What it shows:* four curves with intercepts ≈12, 26, 42, 61. Image: ../figures/JvRRgas/p23.png
- **Fig. 14 (p. 24)** — "Extrapolating ratios [n p_n^±((3_1^+)^{N−1})/p_n^±((3_1^+)^N)] for N = 1, 2, 3, 4. In each case the curve approaches a non-zero finite constant. This is evidence that N_{(3_1^+)^M} = M in equation (2.7)." *What it shows:* curves 0_1/3_1^+ (intercept ≈12), 3_1^+/3_1^+#3_1^+ (≈14–15), (3_1^+)^2/(3_1^+)^3 (≈15), (3_1^+)^3/(3_1^+)^4 (≈20). Image: ../figures/JvRRgas/p24.png
- Rendered table pages: ../figures/JvRRgas/p13.png (Table 2), ../figures/JvRRgas/p25.png (Table 5).

## Stated limitations, open problems, future work
- p. 12: "While we are confident that the estimates higher up in the table are the correct values, our confidence declines as one descends the table (or as p^±_{n_min}(K) increases in size)." 3_1^+#3_1^+#3_1^−#3_1^− "proved too much for our available hardware."
- p. 17: for 4_1, "we could not find a consistent estimate for M_{0_1,4_1} when data with n > 700 is included in the regressions."
- p. 21: "data are quite noisy for n > 1000".
- p. 25: estimating M_{0_1,(3_1^+#3_1^+#3_1^−)} "produces results which were very sensitive to the maximum length of polygons in our data"; (3_1^+)^2#(3_1^−)^2 "proved beyond the capacity of our available computers".
- p. 26: "Overall it appears that symmetric embeddings were the exception, rather than the rule, and we expect this pattern to persist."
- p. 27: "We are continuing our investigations of this conjecture and in particular of our results on the relative frequencies of knot types as defined by M_{K,L}. … M_{K,L} is dimensionless, and may in fact be universal (independent of the lattice). Currently we are examining this by computing M_{K,L} for other three dimensional lattices."

## References worth following
- [4] Clisby N, Liang R, Slade G 2007, Self-Avoiding Walk Enumeration via the Lace Expansion, J. Phys. A 40 10973 (μ, α in Z^3; exact p_n).
- [6] Diao Y 1993, Minimal knotted polygons on the cubic lattice, JKTR 2 413–425 (n_min(3_1) = 24).
- [7] Diao Y 1994, The Number of Smallest Knots on the Cubic Lattice, J Stat Phys 74 1247–1254 (3328).
- [16] Janse van Rensburg E J 1992, Ergodicity of the BFACF Algorithm in Three Dimensions, J Phys A 25 1031–1042.
- [17] Janse van Rensburg E J 2002, The Probability of Knotting in Lattice Polygons, Contemp. Math. 304 125–135 (earlier 3_1/4_1 relative frequencies).
- [19] Janse van Rensburg E J 2009, Monte Carlo Methods for the Self-Avoiding Walk, J Phys A 42 323001 (GAS implementation).
- [21] Janse van Rensburg E J, Promislow S D 1995, Minimal Knots in the Cubic Lattice, JKTR 4 115–130.
- [23] Janse van Rensburg E J, Rechnitzer A 2009, Generalised Atmospheric Sampling of Self-Avoiding Walks, J Phys A 42 335001 (GAS, flatGAS).
- [24] Janse van Rensburg E J, Whittington S G 1991, The BFACF Algorithm and Knotted Polygons, J Phys A 24 5553–5567 (Theorem 3.1).
- [32] Marcone, Orlandini, Stella, Zonta 2007, Size of Knots in Ring Polymers, Phys Rev E 75 041105 (evidence for ansatz 2.7).
- [35] Orlandini E, Tesi M C, Janse van Rensburg E J, Whittington S G 1998, Asymptotics of Knotted Lattice Polygons, J Phys A 31 5953–5967 (ansatz 2.7).
- [40] Rechnitzer A, Janse van Rensburg E J 2008, Generalised Atmospheric Rosenbluth Methods (GARM), J Phys A 41 442002.
- [42] Scharein R, Ishihara K, Arsuaga J, Diao Y, Shimokawa K, Vazquez M 2009, Bounds for minimal step number of knots in the simple cubic lattice, J Phys A 42 475006 (n_min, p_{n_min} comparison).
- [44] Sumners D W, Whittington S G 1988, Knots in Self-Avoiding Walks, J Phys A 21 1689–1694 (pattern theorem).

## Extraction notes
- All pages read from text; pages 6–25 additionally checked as images. Tables 1–5 verified cell by cell against images (Table 5 at 250 dpi). Table 4's text layer is shifted by one row (first row's K/L lost); the image ordering above is authoritative.
- ⚠ Iterations column: header says "(×10^7)" while p. 10 says each sequence has 10^7 states and the column counts sequences; also p. 10 says "500 sequences in the cases marked by a (*), were n_max(K) = 500" — the * marks appear on 0_1, 3_1^+, 4_1, 5_1^+ only. Exact meaning ambiguous; transcribed as printed.
- ⚠ 4_1 symmetry classes: 152 (Table 1) vs 278 (text p. 5).
- ⚠ Table 5 0_1/(3_1^+)^3 = 2.18(80)×10^5 vs eq. (5.5) ×10^6.
- ⚠ p. 20 typos C_{5_1} for C_{5_2}; p. 23 C_{3_1^+#3_1^+} for 3_1^+#3_1^−; eq. (5.10) missing "log"; several χ² fits are described as "acceptable at the 0% level".
- ⚠ Abstract and p. 4 state the crossover direction slightly differently (strict vs non-strict inequalities), transcribed as printed.
- Fig. 1 (p. 3) caption taken from text layer; page rendered.
