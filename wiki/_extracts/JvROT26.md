# JvROT26 — Thermodynamics of Confined Knotted Lattice Polygons
- **Authors:** EJ Janse van Rensburg (York Univ.), E Orlandini (Padova), MC Tesi (Bologna)
- **Venue / year / identifiers:** arXiv:2603.07730v3 [cond-mat.soft], 23 Mar 2026; header "Version 1.0 as of March 24, 2026"; PACS 82.35.Lr, 82.35.Gh, 61.25.Hq. (No journal ref printed.)
- **File:** papers/2_algorithms/JvR-Orlandini-Tesi_2026_Thermodynamics_confined_knotted_polygons_2603.07730.pdf   **Pages:** 18 (pp. 1–15 content, pp. 16–18 refs)
- **Text layer:** partly garbled (equations, piecewise definitions, some captions); Tables I–VI text layer clean, Tables II–VI checked against page images (pp. 10, 12, 13), Table I from text layer only.

## Abstract
A ring polymer in a confining space may exhibit at least two phases, namely an expanded (or solvent-rich phase) if its concentration is small, or a collapsed (or polymer-rich phase) when it is concentrated and compressed. These phases are discussed in reference [1], and have been modelled, traditionally, in the mean field using Flory-Huggins theory [2, 3]. In three dimensions the ring polymer may also be knotted, or linked, and have its conformational degrees of freedom constrained by its topology. In a lattice model of confined knotted ring polymers there are indications that the thermodynamic properties of the ring polymer (for example, the osmotic pressure [4, 5]) is a function of its topology. In this paper we explore a lattice knot model of a confined ring polymer as a function of its chemical potential. We show that a well-defined phase transition occurs between solvent-rich and polymer-rich phases when the lattice knot exhibits either the unknot topology or any other fixed knot type. Furthermore, we observe small yet significant variations in the free energy near the critical point when comparing trefoil knots with other non-trivial knot types. These findings indicate that the thermodynamic properties of confined ring polymers depend on their topological entanglement characteristics (namely, their knot type).

## Notation and conventions
- **Cube convention (differs from JvROT25!)** (p. 2): "A lattice polygon is confined if it is placed within a cube of side-length L − 1 and volume V = L³ lattice sites." (p. 4): "An L-cube in the cubic lattice is a cubical sublattice of L³ lattice sites and side-length L (lattice sites)." So here L = number of lattice sites per side, V = L³, ϕ = n/L³ (Fig. 1 caption p. 2). In JvROT25 the L-cube had side L steps and (L+1)³ sites; thus L(JvROT26) = L(JvROT25)+1 (e.g. 7-cube here = 6-box there). Check: p. 6 gives p_{4,L}(∅) = 3L(L−1)² (=756 for L=7, equal to Table I (JvROT25) L=6 entry). ⚠ But p. 6 also says "in a 3-cube there are p_{24,3}(3_1^+) = 2084 placements of the minimal length right-handed lattice trefoil": under this paper's convention a 3-cube (3 sites/side) cannot hold a trefoil of length 24 (the value 2084 equals JvROT25 Table I at L=3 steps = 4 sites/side) — apparent leftover of the older convention.
- Counting (p. 3): p_n = "number of lattice polygons of length n (counted modulo translations)". p_{n,L}(K) = number of realisations (placements) of a lattice knot of fixed knot type K, length n in an L-cube, "conformational degrees of freedom, and then also translational and rotational degrees of freedom" (p. 4). p_4(∅) = 3 (p. 6) (∅ here denotes the unknot, i.e. 0_1; notation switches between 0_1 and ∅ on p. 6). Maximum polygon length in an L-cube is L³−1 for L odd (p. 6).
- Origin of the lattice placed at the bottom (lexicographically least) site of the L-cube (p. 4).
- Grand canonical: Z(x) = Σ_n p_n x^n = Σ p_n e^{−υ n/k_BT} (Eq. 3), υ = chemical potential (⚠ p. 4 Eq. 13 writes "x = e^{−υn/k_BT}" with a stray n; Eq. 3 implies x = e^{−υ/k_BT}). Φ(x) = log Z(x) (Eq. 4). Z_{K,L}(x) = Σ_{n≥0} p_{n,L}(K) x^n with p_{0,L}(K) = 1 (Eq. 13) (polynomial in x, n ≤ L³). Free energy density f_{K,L}(x) = (1/L³) log Z_{K,L}(x) (Eq. 14) ("free energy" is the log of partition function with sign such that f_{K,L}(0)=0, f ≥ 0). Canonical F_{n,L}(K) = −log p_{n,L}(K) (p. 4).
- χ_K(x) = limsup_{L→∞} f_{K,L}(x) (Eq. 15) — limiting free energy (⚠ χ is also used for the Flory interaction parameter in Eq. 42, and in JvROT25).
- Energy density E_K(x) = x d/dx χ_K(x) (Eq. 19) = limiting concentration of polymer; specific heat C_K(x) = x d/dx E_K(x) (Eq. 20). Finite-size: E_{K,L}(x) = x d/dx f_{K,L}(x) = (1/Z) Σ (n/L³) p_{n,L}(K) x^n (Eq. 21) = mean concentration ϕ_{K,L}(x). Finite-size C_{K,L}(x) = x d/dx E_{K,L}(x).
- x_K = critical point (fugacity) of knot type K; x_K(L) = finite-size estimate = location of max of specific heat C_{K,L}; error bar = half-width at half-height of the peak (p. 7). H_K(L) = peak height (max of C_{K,L}). x_01 = 1/μ is NOT the unknot critical point: "it is known that x_01 ≠ 1/μ" (p. 8); x_01 ≤ x_K (p. 5, ref 71).
- Exponents: α (polygon entropic exponent, p_n ~ C n^{α−3} μ^n), ν (metric exponent, R_g ~ n^ν), α_K (entropic exponent of knot K, Eq. 10–11, α_K = α_01 + N_K, N_K = number of prime components), α*_K = specific-heat exponent of the confined collapse transition (Eq. 17–20), q = finite-size exponent for concentration (Eq. 22–24).
- Knot notation: 3_1^+ right-handed trefoil; granny knot 3_1^+#3_1^+ (chiral); square knot 3_1^+#3_1^− (amphichiral); prime knots up to 6 crossings {4_1, 5_1^+, 5_2^+, 6_1^+, 6_2^+, 6_3}.
- μ = 4.684039931(27) (Clisby, pivot algorithm, p. 3), 1/μ = 0.213490921(13) (also 0.2134909212 ± 0.0000000013, p. 8). ν = 0.587597(7) [ref 66]; α = 0.237 ± 0.002 [63,65]; hyperscaling 2 − α = dν gives α = 0.237209(21); Flory ν = 3/5 gives α = 1/5 (p. 3–4).

## Numbered statements
**Theorem 1 (p. 5), proved here.** The limit χ_01(x) = lim_{L→∞} (1/L³) log Z_{01,L}(x) exists and defines the limiting free energy of confined lattice unknots. Moreover, since Z_{01,L}(x) ≥ 1, it follows that χ_01(x) ≥ 0.
Proof idea (as printed): concatenation inequality (Eq. 16, below) times x^n and summed gives Z_{01,L}(x) Z_{01,M}(x) ≤ 2(L+M)³ Z_{01,L+M}(x); "log Z_{01,L}(x) satisfies a generalised superadditive relation of the kind examined by Hammersley [74]". (⚠ the proof text says "Multiply equation (7) by x^n"; the relevant inequality is Eq. 16.)

**Equation (16) (p. 5), derived here.** Σ_{k=0}^{n} p_{k,L}(01) p_{n−k,M}(01) ≤ 2 (L+M)³ p_{n,L+M}(01). Derivation: concatenate α (length k, ≤ p_{k,L}(01) choices) and β (length n−k, ≤ p_{n−k,M}(01)/2 choices, factor 1/2 for rotation aligning top/bottom edges) by deleting two opposite edges of a unit square and adding the other two; the result is a length-n unknot placeable in an (L+M)-cube in at most (L+M)³ ways.

No other numbered Theorem/Lemma/Proposition/Conjecture/Question. Stated conjectures/claims (unnumbered, status as stated):
- p. 4: "For the purposes of this paper we conjecture that μ_K = μ_01." Known (quoted, refs 56, 70): μ > μ_K ≥ μ_01 > 0. Numerical data "cannot, so far, rule out either μ_K = μ_01 or μ_K > μ_01".
- p. 4: α_01 = α "numerical simulations suggest… However, this remains unproven." Eq. 11: α_K = α_01 + N_K (numerical evidence, refs 25, 26; see also 71, 72).
- p. 4 (Eq. 12 and after): ν_K = ν_01 = ν "Numerical simulations support the conjecture" [73].
- p. 5 questions: "(1) Is it the case that x_K = x_01? It can be shown that x_01 ≤ x_K [71]. (2) What is the relationship between the thermodynamic exponents α*_01 and α*_K?" (open).
- p. 2 open questions: (i) how does the thermodynamics of the solvent–polymer transition depend on knot type when knot type is fixed? (ii) is the transition accompanied by a delocalisation (melting) of the knotted segment? p. 3: "It is still an open question whether the knotted arc becomes statistically delocalized with increasing concentration."

## Key equations and quantitative claims outside numbered statements
- Eq. 1 (p. 3): lim (1/n) log p_n = log μ > 0 (growth constant; equals SAW growth constant [59]). Eq. 2: p_n ~ C n^{α−3} μ^n (theory and numerics). Eq. 4: Φ(x) = log Z(x). Eq. 5: Φ(x) ~ |x − x_c|^{2−α}, x_c = 1/μ (radius of convergence). Eq. 6: ξ ~ |x − x_c|^{−ν} (x<x_c). Eq. 7: R_g ~ n^ν.
- Eq. 8–9 (p. 4): lim (1/n) log p_n(01) = log μ_01 > 0 exists [56, 68, 69]; limsup (1/n) log p_n(K) = log μ_K. Eq. 10: p_n(K) ~ C_K n^{α_K−3} μ_K^n. Eq. 11: α_K = α_01 + N_K. Eq. 12: R_g(K) ~ n^{ν_K}. Numerical: |μ − μ_01| ≈ 4.15×10^{−6} [ref 45] (⚠ JvROT25 gives log(μ/μ_01) = (4.15 ± 0.32)×10^{−6}; here stated as |μ − μ_01|, different quantity).
- Eq. 17 (p. 5), unknot scaling assumption: χ_01(x) ~ 0 for x < x_01; ~ |x − x_01|^{2−α*_01} + […] for x > x_01. Eq. 18: same for knot type K with x_K, α*_K. Eq. 19: E_K(x) ~ 0 (x<x_K), |x−x_K|^{1−α*_K} (x>x_K). Eq. 20: C_K(x) ~ 0 (x<x_K), |x−x_K|^{−α*_K} (x>x_K) (standard scaling assumption; "theoretically less well understood" for K ≠ 01, p. 5). Authors stress α*_01 should not be confused with α_01 or α.
- p. 5 heuristic: for n ≪ L, p_{n,L}(01) = μ_01^{n+o(n)}; sum converges for x μ_01 < 1 ⇒ expected χ_01 = 0 there, >0 for xμ_01 > 1.
- p. 6 simulation: GAS with BFACF moves; L ∈ {7, 9, 11, 13, 15} (odd L only); data of ref [15] (= JvROT25) reused, GARM for consistency checks; parallel (omp), T parallel tours collected in M blocks, each block 10^7 BFACF iterations per tour. Example: trefoil in a 15-cube, M = 343 blocks × 4 tours × 10^7 = 2.576×10^10 iterations. L = 13 sampled up to n = 2196 (= 13³ − 1); "Sampling deteriorated as the maximum length was approached." Confidence intervals from block independence.
- p. 6: p_{4,L}(∅) = 3L(L−1)². Minimal trefoil length 24 [81]; 1664 placements of minimal-length right-handed trefoil in the cubic lattice up to translation [82]. Normalisation: GAS ratios p_{n,L}/p_{m,L} with m = 4 (unknot) or m = 24 (3_1^+, using exhaustive counts).
- p. 6 free-energy values (numerical): unknot f_{K,L}(1.0) = 0.7720(14) for L = 7; 0.85372(19) for L = 15.
- Eq. 22 (p. 6): E_{K,L}(x) ~ L^q h_0((x − x_K) L^{1/ν}); Eq. 23: E_{K,L}(x) ~ (x−x_K)^{−qν} h_1((x−x_K)L^{1/ν}), h_1(z) = z^{qν} h_0(z). For z<0 h_0→0 as L→∞; for small z>0 h_0(z) ~ z^{1−α*_K}, giving Eq. 24: q = (α*_K − 1)/ν (p. 7–8). (equivalently qν = α*_K − 1, p. 8.)
- p. 7: Fig. 5 unknot energy density E_{01,15}(x=2) ≈ 0.93 (approaches 1 with increasing x).
- Eq. 25 (p. 8): x_01(L) = x_01 + a/L^{1/ν}, linear fit with ν = 0.587597(7); error bars bootstrapped (adding/subtracting error bar per data point; 1000 estimates; mean and variance). **Eq. 26: x_01 = 0.2161 ± 0.0069** (numerical). 1/μ = 0.2134909… "not excluded by our result, although it is known that x_01 ≠ 1/μ".
- Eq. 27–28 (p. 8): C_{K,L}(x) ≃ L^{q+1/ν} h_K'((x−x_K) L^{1/ν}) (also form (x−x_K)^{1−qν} h_K''(…)); for the unknot C_{01,L} ≃ L^{q+1/ν} h'_{01}((x−x_01)L^{1/ν}) (Eq. 28). Peak heights ∝ L^{q+1/ν}.
- **Eq. 29 (p. 8): q = −0.765 ± 0.035 (unknot)** from the 10 pairwise ratios H_01(L1)/H_01(L2) = (L1/L2)^{q+1/ν}; minimum estimate −0.8089, maximum −0.7253, mean and variance reported (numerical).
- **Eq. 30 (p. 9): α*_01 = 0.551 ± 0.021** (from q = (α*−1)/ν; check: 1 + (−0.765)(0.587597) = 0.5505). Hence numerically α*_01 ≠ α_01 ≈ α ≈ 0.237 [26, 43]: the specific-heat exponent of the confined collapse transition differs from the free-space entropic exponent (numerical).
- Fig. 9 (p. 9): rescaled energy-density curves of the unknot coincide near the critical point, exposing h_0; (x_01(L) − x_01) L^{1/ν} ≈ a, "shown to good numerical accuracy".
- p. 9–10 trefoil 3_1^+: curves similar to unknot; peaks "narrower horizontally (and so more difficult to detect), and with significantly higher peaks". Critical-point extrapolation uses Eq. 31: x_{3_1}(L) = x_{3_1} + a/L^{1/ν} + b/L^{2/ν} (mild curvature). **Eq. 32: x_{3_1} = 0.2148 ± 0.0069**. Peak-height exponent for trefoil: **q = −1.422 ± 0.037** (same method), which rescales peak heights but "fails to rescale other features"; specific heat curves for x > x_{3_1} separate (Fig. 13). Using the unknot q = −0.765 instead rescales the curves above the critical point (Fig. 14) — "numerical evidence" that q is the same, hence α*_{3_1^+} = α*_01. Differences: higher trefoil peaks, a "shoulder" (inflection, concave rather than convex approach, p. 11) developing at the junction t between curve and spike. Junction point t scales with q = −0.765; peak p scales with q ≈ −1.422 (Fig. 15 schematic).
- p. 11: scaling function depends on knot type (h'_01 ≠ h'_{3_1}); critical points x_01, x_{3_1} may also differ "although this cannot be ruled out, or shown, using our data"; "even if the scaling exponent q turns out to be universal to all knot types." Fig. 16: energy-density rescaling for trefoil, somewhat larger corrections to scaling; curves coincide near critical point then split beyond the turning point.
- Granny (3_1^+#3_1^+) and square (3_1^+#3_1^−) knots (p. 11–12): analysed with q = −0.765; features similar to trefoil. **Eq. 33: x_{3_1^+#3_1^+} = 0.2152 ± 0.0052; Eq. 34: x_{3_1^+#3_1^−} = 0.2149 ± 0.0052.** For finite L, peaks for compounds are virtually identical to each other (Fig. 17–18) and lie outside confidence intervals of the 0_1 and 3_1^+ peaks (peak width used as uncertainty), yet extrapolated critical points agree within error bars. Fig. 18 ordering: peaks become higher and narrower going 0_1 → 3_1^+ → compound knots.
- **Eq. 35 (p. 13): x_{4_1} = 0.2148 ± 0.0061.** Eq. 36–38: H_K(L) = C_{K,L}(x_K) ≃ L^{q+1/ν} h'_K(0); h'_K(0) = lim H_K(L)/L^{q+1/ν} (Eq. 37); finite L: H_K(L)/L^{q+1/ν} = h'_K(0) + a/L^{q+1/ν} + … (Eq. 38) (as printed; linear fits, higher-order terms ignored) giving Table VI last column. Unknot h'_01(0) ≈ 0.259, larger than trefoil estimate (0.197). h'_K(0) generally increases with knot complexity (with variations); 5- and 6-crossing values close to each other.
- p. 13: all x_K (Table VI) very close; assuming common critical point, average = 0.2151 ± 0.0014. (Arithmetic check: mean of the ten Table VI values = 0.21508 ✓.) ⚠ The following sentences ("This estimate is slightly smaller that the average over the knot types in table VI. This is to be expected, since the connective constant for unknots are known to be strictly less than that of all polygons") are garbled/unclear as printed: the quoted average equals the Table VI mean, and 0.2151 lies above 1/μ = 0.2135 (consistent with x_01 ≥ 1/μ? the paper states x_01 ≠ 1/μ).
- Eq. 39 (p. 14): E_{K1,L}(x)/E_{K2,L}(x) ~ h_1((x−x_{K1})L^{1/ν}) / h_2((x−x_{K2})L^{1/ν}) (assuming q independent of knot type).
- Eq. 40 (p. 14), numerical finding: E_{3_1,L}(x)/E_{01,L}(x) ≈ 0 for x < min{x_01, x_{3_1}} (solvent), ≈ 1 for x > max{x_01, x_{3_1}} (polymer); near the critical point the ratio exceeds 1 (a "minor spike", Fig. 19, peak value ≈ 1.15–1.2 read from figure), interpreted as trefoils dominating there, consistent with localisation (Eq. 11). Interpretation: the knot goes from a tight ball-pair structure in the solvent phase to a loose topological constraint with no thermodynamic effect in the polymer phase. Similar for 4_1/0_1 (Fig. 20), 4_1/3_1 (Fig. 21: foot of step rounded, spike nearly absent), 3_1^+#3_1^+/0_1 (Fig. 22). Statement: "This indicates that the exponent α*_K may be independent of knot type." (hedged).
- Eq. 41 (p. 14): ψ_{K,L}(x) = f_{K,L}(x)/ϕ_{K,L}(x) (free energy per unit length of polymer). Eq. 42 (p. 14): Flory–Huggins excess free energy F(ϕ) = (1/V) log ϕ + (1−ϕ) log(1−ϕ) − χ ϕ² with V = L³ (χ = Flory interaction parameter). Excess free energy ψ_e(x) = ψ_{K,L}(x) − log μ (p. 15), plotted vs ϕ_{K,L}(x) (Fig. 23): curves collapse to a single curve for all L (unknot shown) except at small concentration (finite-size effects); "similar graphs can be made for the other knot types"; clear separation into solvent phase (small concentration) and polymer phase (large concentration).
- Conclusions of Discussion (p. 13–14): "sharp transitions at a critical point x_K for each of the knot types examined"; "knot type may affect the transition behavior… most apparent in the varying heights of specific heat spikes, and more subtly in the shape of the specific heat curves".

## Methods / algorithms
1. (p. 6) Model: self-avoiding polygon of variable length n, fixed knot type K, confined to an L-cube, L odd ∈ {7,9,11,13,15}; grand canonical ensemble with Z_{K,L}(x) = Σ p_{n,L}(K) x^n.
2. (p. 6) Estimate p_{n,L}(K) ratios with GAS (generalised atmospheric sampling, ref 75, 76) using BFACF elementary moves (refs 45, 77, 78) along Markov-chain "tours"; GARM (refs 76, 80) used for consistency checks; data from JvROT25 (ref 15) reused plus new data.
3. (p. 6) Normalisation by exact minimal-length counts (p_{4,L}(∅) = 3L(L−1)² for unknot; exhaustive computer counts for minimal-length knots, e.g. p_{24,3}(3_1^+) = 2084 — ⚠ see convention note).
4. (p. 6) Parallel: T tours (e.g. 4) per block, M blocks (e.g. 343), 10^7 BFACF iterations per tour per block; error bars from independent blocks.
5. (p. 6–7) Compute f_{K,L}(x), E_{K,L}(x), C_{K,L}(x) from p_{n,L}(K) via Eq. 14, 21, 20; locate peak of C_{K,L} to get x_K(L) and H_K(L); error bar = half width at half height.
6. (p. 8, 10) Extrapolate x_K(L) with Eq. 25 (unknot) or Eq. 31 (others), bootstrap errors (±1 error bar per point, 1000 resamples); estimate q from ratios of H_K(L) (10 pairs); α*_K = 1 + qν.
7. (p. 13) h'_K(0) from linear fits of H_K(L)/L^{q+1/ν}.
8. (p. 14) Compare E_{K1,L}/E_{K2,L} across knot types; (p. 15) Flory–Huggins collapse of ψ_e vs ϕ.

## Tables
Peak heights H and positions x are of the specific heat C_{K,L}(x) (Eq. 20).

**TABLE I (p. 8)** — "Estimates of x_01(L) and H_01(L) for unknots" (text layer; not imaged)

| L | x_01(L) | H_01(L) |
|---|---|---|
| 7 | 0.276 ± 0.015 | 1.5763 |
| 9 | 0.2553 ± 0.0079 | 2.0141 |
| 11 | 0.2441 ± 0.0050 | 2.4509 |
| 13 | 0.2371 ± 0.0034 | 2.8452 |
| 15 | 0.2325 ± 0.0026 | 3.2331 |

**TABLE II (p. 10)** — "Estimates of x_{3_1}(L) and H_{3_1}(L) for trefoils" (verified on image)

| L | x_{3_1}(L) | H_{3_1}(L) |
|---|---|---|
| 7 | 0.2926 ± 0.0055 | 4.9760 |
| 9 | 0.2631 ± 0.0035 | 5.4079 |
| 11 | 0.2482 ± 0.0025 | 5.7470 |
| 13 | 0.2394 ± 0.0018 | 5.9504 |
| 15 | 0.2338 ± 0.0015 | 6.2013 |

**TABLE III (p. 12)** — "Estimates of x_K and H_K for 3_1^+#3_1^+ and 3_1^+#3_1^−" (verified on image)

| L | x_{3_1^+#3_1^+}(L) | H_{3_1^+#3_1^+}(L) | x_{3_1^+#3_1^−}(L) | H_{3_1^+#3_1^−}(L) |
|---|---|---|---|---|
| 7 | 0.3189 ± 0.0043 | 9.0232 | 0.3176 ± 0.0043 | 8.9088 |
| 9 | 0.2774 ± 0.0026 | 9.9477 | 0.2765 ± 0.0026 | 9.7852 |
| 11 | 0.2574 ± 0.0018 | 10.5902 | 0.2567 ± 0.0018 | 10.3658 |
| 13 | 0.2460 ± 0.0014 | 11.0789 | 0.2455 ± 0.0014 | 10.8330 |
| 15 | 0.2387 ± 0.0011 | 11.4350 | 0.2382 ± 0.0011 | 11.1553 |

**TABLE IV (p. 13)** — "Estimates of x_{4_1}(L) and H_{4_1}(L)" (verified on image)

| L | x_{4_1}(L) | H_{4_1}(L) |
|---|---|---|
| 7 | 0.3000 ± 0.0049 | 6.2863 |
| 9 | 0.2671 ± 0.0031 | 6.8413 |
| 11 | 0.2507 ± 0.0022 | 7.2202 |
| 13 | 0.2415 ± 0.0016 | 7.6844 |
| 15 | 0.2351 ± 0.0013 | 7.7725 |

**TABLE V (p. 13)** — "Estimates of H_K(L)" (verified on image)

| K \ L | 7 | 9 | 11 | 13 | 15 |
|---|---|---|---|---|---|
| 0_1 | 1.5763 | 2.0141 | 2.4509 | 2.8452 | 3.2331 |
| 3_1^+ | 4.9760 | 5.4079 | 5.7470 | 5.9594 | 6.2013 |
| 4_1 | 6.2863 | 6.8413 | 7.2202 | 7.6844 | 7.7725 |
| 5_1^+ | 7.5451 | 8.2829 | 8.8108 | 9.1892 | 9.5177 |
| 5_2^+ | 7.6131 | 8.3224 | 8.8107 | 9.2183 | 9.5450 |
| 6_1^+ | 8.8670 | 9.7451 | 10.3373 | 10.8385 | 11.2580 |
| 6_2^+ | 8.9765 | 9.8726 | 10.4842 | 10.9422 | 11.3070 |
| 6_3 | 9.0197 | 9.9182 | 10.4933 | 10.9905 | 11.3676 |
| 3_1^+#3_1^+ | 9.0232 | 9.9477 | 10.5902 | 11.0789 | 11.4350 |
| 3_1^+#3_1^− | 8.9088 | 9.7852 | 10.3658 | 10.8330 | 11.1553 |

⚠ Table V trefoil, L=13: 5.9594, but Table II gives 5.9504 for the same quantity. Tables I, III, IV values agree with Table V (0_1, compounds, 4_1).

**TABLE VI (p. 13)** — "Extrapolated estimates of x_K" (verified on image)

| K | x_K | h'_K(0) |
|---|---|---|
| 0_1 | 0.2161 ± 0.0069 | 0.259 |
| 3_1^+ | 0.2148 ± 0.0069 | 0.197 |
| 4_1 | 0.2148 ± 0.0061 | 0.253 |
| 5_1^+ | 0.2146 ± 0.0056 | 0.322 |
| 5_2^+ | 0.2148 ± 0.0056 | 0.314 |
| 6_1^+ | 0.2154 ± 0.0052 | 0.387 |
| 6_2^+ | 0.2150 ± 0.0052 | 0.382 |
| 6_3 | 0.2152 ± 0.0052 | 0.383 |
| 3_1^+#3_1^+ | 0.2152 ± 0.0052 | 0.398 |
| 3_1^+#3_1^− | 0.2149 ± 0.0052 | 0.371 |

(⚠ the extrapolated critical points for 5_1^+, 5_2^+, 6_*, compounds have no separate equation numbers except Eq. 33–35; the text says Eq. 31 model used. Also note 3_1^+ has smaller h'(0) than the unknot though H_{3_1}(L) ≈ 2–3× larger, because the trefoil peak-height q differs from the unknot q used in the scaling.)

## Figures
- **Fig. 1 (p. 2)** — "A lattice knot ω of knot type 5_1^+ inside a cube in the cubic lattice of side-length L sites and volume L³ lattice sites. If ω has length n (steps or lattice sites), then the concentration of the vertices (monomers) in the lattice knot is ϕ = n/L³." *What it shows:* a lattice 5_1^+ knot ω in a cube C_ω of side L. Image: ../figures/JvROT26/p02.png
- **Fig. 2 (p. 3)** — schematic knotted ring polymer in a cubical cavity at low concentration; left: knot confined to a small volume (localized, knotted ball-pair); right: knot fills the cavity (delocalized). Not rendered (p. 3).
- **Fig. 3 (p. 3)** — schematic at intermediate and high concentration; left: tight tangle at the centre; right: relaxed to fill the cavity (knot melted into a sea of tangles).
- **Fig. 4 (p. 7)** — finite-size unknot free energies f_{01,L}(x), x ∈ [0,1], L = 7, 9, 11, 13, 15; curves ≈ 0 for small x, increasing beyond a critical x_01, accumulating toward a limiting curve. Image: ../figures/JvROT26/p07.png
- **Fig. 5 (p. 7)** — unknot energy density E_{01,L}(x): zero then sharp rise at critical point; → 1 as x grows (E_{01,15}(2) ≈ 0.93).
- **Fig. 6 (p. 7)** — unknot specific heat C_{01,L}(x): sharp peak near critical point, taller and narrower with L.
- **Fig. 7 (p. 8)** — rescaled specific heat C_{01,L}/L^{q+1/ν} vs (x−x_01)L^{1/ν} with q = −0.765; narrower spike with a "kink"/junction near (0, 0.1). Image: ../figures/JvROT26/p08.png
- **Fig. 8 (p. 9)** — schematic of the rescaled specific heat showing junction t and peak p (both scale with q).
- **Fig. 9 (p. 9)** — rescaled energy density curves of the unknot, coinciding near the critical point. Image: ../figures/JvROT26/p09.png
- **Fig. 10 (p. 9)** — finite-size free energies f_{3_1^+,L}(x), L = 7…15, similar to Fig. 4 but more widely spaced.
- **Fig. 11 (p. 10)** — trefoil energy density E_{3_1^+,L}(x): zero below ≈0.23, sharp rise; at x=1, E ranges ≈0.57 (L=7) to ≈0.70 (L=15) (read from image). Image: ../figures/JvROT26/p10.png
- **Fig. 12 (p. 10)** — trefoil specific heat C(3_1^+): peaks at x ≈ 0.29 (L=7) height ≈5 to x ≈ 0.23 (L=15) height ≈6.2.
- **Fig. 13 (p. 10)** — trefoil specific heat rescaled with q = −1.422: peaks collapse (height ≈ 3) but curves for x > x_{3_1} are systematically separated.
- **Fig. 14 (p. 11)** — trefoil rescaled with q = −0.765; collapse above critical point; a "shoulder" develops near the spike. Image: ../figures/JvROT26/p11.png
- **Fig. 15 (p. 11)** — schematic of rescaled trefoil specific heat (p, t, shoulder).
- **Fig. 16 (p. 12)** — trefoil energy density rescaled with q = −0.765; sharper turn than unknot; curves coincide near critical point, split after the turning point. Image: ../figures/JvROT26/p12.png
- **Fig. 17 (p. 12)** — rescaled specific heat for granny and square knots (nearly identical; blue curves lie over red), shoulder at spike more prominent than unknot/trefoil.
- **Fig. 18 (p. 12)** — rescaled specific heat for 0_1 (red), 3_1^+ (blue), 3_1^+#3_1^+ (orange), 3_1^+#3_1^− (cyan), horizontal axis (x−x_K)L^{1/ν} ∈ [0,10]; peak heights read ≈0.26 (0_1), ≈0.48 (3_1^+), ≈0.9 (both compounds), peaks narrower and more prominent in that order.
- **Fig. 19 (p. 14)** — "The energy density ratio of trefoils (3_1) to unknots (0_1) for confining boxes of sizes {7, 9, 11, 13, 15}…" *What it shows:* step from ≈0 to ≈1 near x ≈ 0.23–0.3, with a minor overshoot (≈1.15–1.2) at the step, then flat at 1; curves accumulate on a step function with spike as L grows. (Legend in image reads L=07, 09, 12, 13, 15 — ⚠ "12" where 11 is intended.) Image: ../figures/JvROT26/p14.png
- **Fig. 20–22 (p. 15)** — energy-density ratios 4_1/0_1 (Fig. 20), 4_1/3_1 (Fig. 21; rounded foot, spike nearly absent), 3_1^+#3_1^+/0_1 (Fig. 22); same step-and-plateau-at-1 behaviour as Fig. 19. Image: ../figures/JvROT26/p15.png
- **Fig. 23 (p. 15)** — excess free energy ψ_e(x) = ψ_{K,L}(x) − log μ vs mean concentration ϕ_{K,L}(x); curves collapse for all L except at small concentrations.

## Stated limitations, open problems, future work
- p. 2: questions (i) and (ii) (dependence of the transition on knot type; knot delocalisation) "partially" addressed.
- p. 3: open whether the knotted arc becomes statistically delocalised with increasing concentration.
- p. 4: μ_K = μ_01 versus μ_K > μ_01 not excluded by data; α_01 = α unproven.
- p. 5: relation between α*_01 and α*_K; whether x_K = x_01; α*_K theory "less well understood" for non-trivial K.
- p. 8: relationship of q-exponent α*_01 to α unclear (qν = α*_01 − 1 "but the relationship with the entropic exponent of lattice polygons α is unclear").
- p. 11: critical points x_01 and x_{3_1} "may additionally be different, although this cannot be ruled out, or shown, using our data".
- p. 6: sampling deteriorates near maximal length; only odd L ≤ 15.

## References worth following
- [15] JvR, Orlandini, Tesi, Relative knot probabilities in confined lattice polygons (= JvROT25), data reused here.
- [4] Gassoumov, JvR, Osmotic pressure of confined square lattice SAWs, J Phys A 52 (2018) 025004; [5] JvR, Osmotic pressure of compressed lattice knots, PRE 100 (2019) 012501.
- [45] JvR, Rechnitzer, Atmospheres of polygons and knotted polygons / (as cited for |μ−μ_01|) ; [56], [70] Sumners–Whittington type results (μ_K<μ).
- [60] Clisby, pivot algorithm (μ = 4.684039931(27)); [66] ν = 0.587597(7).
- [75], [76] GAS/GARM refs (Janse van Rensburg–Rechnitzer); [25], [26] knot entropic exponents α_K = α_01 + N_K.
- [71] x_01 ≤ x_K (see reference list p. 16–18 for exact citation, not transcribed).
- [74] Hammersley (generalised superadditivity).

## Extraction notes
- Pages rendered: 2, 7, 8, 9, 10, 11, 12, 13, 14, 15. Tables II–VI verified on images; Table I only from text layer (clean). Figures 2, 3, 4–6, 8, 10 etc. described from captions/text; Figs 11–13, 16–19 partially viewed.
- ⚠ list: cube convention differs from JvROT25 (L sites vs L steps), with leftover "p_{24,3}(3_1^+) = 2084" from the old convention; Eq. 13 stray n in x = e^{−υn/k_BT}; Theorem 1 proof cites "equation (7)" instead of (16); Table II vs Table V trefoil H(13) 5.9504 vs 5.9594; Fig. 19 legend L=12; unclear sentences about the average critical point (p. 13); χ symbol double use; ∅ vs 0_1 notation.
- Reference list (pp. 16–18) not transcribed except where used; [71] etc. not looked up.
