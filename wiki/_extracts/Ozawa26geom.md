# Ozawa26geom — Geometric densities and compression radii of knot types
- **Authors:** Makoto Ozawa (Dept. of Natural Sciences, Komazawa University, Tokyo)
- **Venue / year / identifiers:** arXiv:2604.27912v2 [math.GT], 12 Jul 2026 (MSC 57K10, 57K14, 53A04, 52C25). Acknowledgments state ChatGPT was used as an interactive aid; author takes responsibility.
- **File:** papers/2_algorithms/Ozawa_2026_Geometric_densities_compression_radii_2604.27912.pdf   **Pages:** 23
- **Text layer:** ok (formulas in the text layer are readable; no numerical tables)

## Abstract
We introduce scale-free compression radii and packing ratios of knot types and clarify their relation to geometric densities. Given a Euclidean-invariant, scale-covariant size functional D on embedded curves, we define the D-density by Len(γ)/D(γ) and the D-compression radius by D(γ)/Thi(γ). At the level of a single representative these quantities give the elementary factorization Len(γ)/Thi(γ) = (Len(γ)/D(γ))·(D(γ)/Thi(γ)). The point of the paper is not this cancellation itself, but the separation it suggests after optimization: density, compression, and ropelength generally have different minimizing sequences. We give a criterion for equality after optimization, record the basic optimized inequality, and compute the unknot case for diameter and minimal enclosing radius. We then prove polygonal approximation theorems for compression radii for D = diam and D = R_min, using standard convergence of polygonal thickness, and formulate the corresponding hypotheses for other L^p size functionals. Finally, we discuss how the resulting quantities interact with distortion, trunk, and supertrunk. The framework is intended as a structural companion to density-type invariants rather than as an immediate improvement of the strongest known ropelength lower bounds. In particular, the formal decomposition alone does not produce new ropelength lower bounds; such bounds would require independent estimates for the density and compression factors.

## Notation and conventions
- **Ropelength convention: LENGTH / RADIUS.** "With our convention Thi is the tube radius; if one writes the tube diameter as τ, then Thi = τ/2 and Rop = Len/Thi = Len/(τ/2)" (p. 3). Rop(γ) = Len(γ)/Thi(γ) (p. 1). Unknot: round circle radius r has Thi = r, Rop = 2π (Example 3.9, p. 7). The quoted 15.66 of Denne–Diao–Sullivan (p. 3, 10) is stated without conversion: ⚠ DDS04 is a length/DIAMETER number (15.66 ≈ 31.32 in radius convention); Ozawa26geom writes "Rop(K) ≥ 15.66" under the radius convention — this is an inconsistent use of the convention for that quoted bound.
- H(K) = admissible representatives of K: C^{1,1} embedded closed curves with positive thickness (smooth theory) (p. 4). Convergence = C¹ plus arclength parametrization and thickness semicontinuity (p. 4).
- D = geometric size functional (Def. 2.1); examples: diam, R_min, convex-hull size D_conv = Vol(Conv)^{1/3} (regularized D_{conv,η}), radius of gyration R_g, L^p-radial R_p, pairwise D_p.
- D-density ρ_D(γ) = Len/D, ρ_D(K) = inf; D-compression radius CRad_D(γ) = D/Thi, CRad_D(K) = inf; D-packing ratio Pack_D(γ) = Thi/D, Pack_D(K) = sup (p. 6). Polygonal analogues use Thi_poly (min of local curvature radius at vertices and half the doubly critical self-distance, p. 14).
- Cr(K) crossing number; distortion distort(γ) = sup d_γ(p,q)/|p−q|; trunk_v, trunk, supertrunk strunk(γ) = max_v trunk_v(γ), strunk(K) = inf (p. 18–19).

## Numbered statements
- **Definition 2.1 (p. 5) — Geometric size functional.** A map D: admissible closed curves → R with (1) D(gγ) = D(γ) for every isometry g; (2) D(aγ) = aD(γ) for a > 0; (3) D(γ) > 0. Continuous if continuous under the chosen topology.
- **Examples 2.2–2.5 (p. 5).** 2.2 diam(γ) = sup|x−y|; 2.3 R_min(γ) = inf_a sup_x |x−a| with ½diam ≤ R_min ≤ diam; 2.4 D_conv(γ) = Vol(Conv(γ))^{1/3} (not positive on planar curves; regularized D_{conv,η} = (Vol + η diam³)^{1/3} ≥ η^{1/3} diam); 2.5 radius of gyration R_g = ((1/Len)∫|x − x̄|² ds)^{1/2}.
- **Definition 3.1 (p. 6) — D-density.** ρ_D(γ) = Len(γ)/D(γ); ρ_D(K) = inf_{γ∈H(K)}.
- **Definition 3.2 (p. 6) — Scale-free compression radius.** CRad_D(γ) = D(γ)/Thi(γ); CRad_D(K) = inf.
- **Definition 3.3 (p. 6) — Packing ratio.** Pack_D(γ) = Thi(γ)/D(γ); Pack_D(K) = sup; if CRad_D(K) > 0, Pack_D(K) = 1/CRad_D(K).
- **Remark 3.4 (p. 6).** Smaller CRad_D = better compression; larger Pack_D = better packing.
- **Lemma 3.5 (p. 6) — Representative-level decomposition.** For every admissible γ of positive thickness, Rop(γ) = ρ_D(γ) CRad_D(γ), i.e. Len/Thi = (Len/D)(D/Thi). *Proof: cancellation.*
- **Lemma 3.6 (p. 6) — Optimized inequality.** For every knot type K and every size functional D, Rop(K) ≥ ρ_D(K) CRad_D(K). *Proof: take infimum.*
- **Proposition 3.7 (p. 7) — Equality criterion.** Assume ρ_D(K) > 0 and CRad_D(K) > 0. Then Rop(K) = ρ_D(K) CRad_D(K) iff there is a sequence γ_j ∈ H(K) with Rop(γ_j) → Rop(K), ρ_D(γ_j) → ρ_D(K), CRad_D(γ_j) → CRad_D(K). In particular if all three infima are attained, equality iff a common minimizer exists.
- **Remark 3.8 (p. 7).** Equality is equivalent (up to minimizing sequences) to simultaneous optimization of ropelength, density and compression radius.
- **Example 3.9 (p. 7) — The unknot.** Let γ be a round circle of radius r: Len = 2πr, Thi = r, R_min = r, diam = 2r. For D = R_min: ρ_R(U) = 2π, CRad_R(U) = 1, Rop(U) = 2π, so equality holds. For D = diam: ρ_diam(U) = π, CRad_diam(U) = 2, Rop(U) = 2π, again equality. "Thus the optimized product can be sharp." ⚠ These values are the values at the round circle; the paper presents them as the knot-type infima ρ(U), CRad(U). Remark 3.11 (p. 8) only asserts the universal bound ρ_diam(K) ≥ 2 (Len ≥ 2 diam), and the paper does not prove that the circle minimises Len/diam or Len/R_min over H(U) (a doubly covered segment limit has Len/diam → 2 and Len/R_min → 4); transcribed as printed.
- **Example 3.10 (p. 8) — Strictness for an artificial functional.** D*(γ) = Thi(γ)(1 + e^{−Rop(γ)}) is Euclidean-invariant, scale-covariant, positive. ρ_{D*}(γ) = Rop(γ)/(1+e^{−Rop(γ)}), CRad_{D*}(γ) = 1 + e^{−Rop(γ)}. Since x/(1+e^{−x}) is strictly increasing for x > 0 and every knot type has representatives of arbitrarily large ropelength (insert a Reidemeister-I kink of scale ε), ρ_{D*}(K) = Rop(K)/(1 + e^{−Rop(K)}), CRad_{D*}(K) = 1, so ρ_{D*}(K) CRad_{D*}(K) = Rop(K)/(1+e^{−Rop(K)}) < Rop(K).
- **Remark 3.11 (p. 8).** The inequality is useful only if both factors admit independent lower bounds. For D = diam every closed curve satisfies Len ≥ 2 diam, hence ρ_diam(K) ≥ 2 and Rop(K) ≥ 2 CRad_diam(K) (universal estimate, "not intended to improve the best known ropelength bounds").
- **Definition 3.12 (p. 8–9) — Optimal strata.** When infima are attained: I_{ρ_D}(K), I_{CRad_D}(K), I_Rop(K) (density, compression, ropelength ideal strata).
- **Remark 3.13 (p. 9).** The compression ideal stratum should not be identified with the usual ideal knot stratum; I_Rop(K) is the initial layer of the ropelength filtration of [16]; each of ρ_D and CRad_D defines its own sublevel filtration.
- §4.1 (p. 9, unnumbered): since ½diam ≤ R_min ≤ diam: Len/diam ≤ Len/R_min ≤ 2 Len/diam and ½ diam/Thi ≤ R_min/Thi ≤ diam/Thi (density and compression radii for diam and R_min are equivalent up to universal constants).
- **Definition 6.1 (p. 13) — L^p-radial size.** R_p(γ) = inf_a ((1/Len)∫_γ|x−a|^p ds)^{1/p}, 1 ≤ p < ∞; R_∞ = R_min; ρ_{prad}, CRad_{prad}.
- **Proposition 6.2 (p. 13) — L^p radial ropelength decomposition.** For every γ of positive thickness and every 1 ≤ p ≤ ∞, Rop(γ) = ρ_{prad}(γ) CRad_{prad}(γ); consequently Rop(K) ≥ ρ_{prad}(K) CRad_{prad}(K). *(Proof cites "Proposition 3.5", i.e. Lemma 3.5 — ⚠ misreference.)*
- **Proposition 6.3 (p. 13) — The case p = 2.** The minimizing centre in R_2 is the arclength barycenter x̄ and R_2(γ) = R_g(γ). (∫|x−a|² = ∫|x−x̄|² + Len|a−x̄|².)
- **Definition 6.4 (p. 13–14) — Pairwise L^p-spread.** D_p(γ) = ((1/Len²)∬|x−y|^p ds_x ds_y)^{1/p}, p ∈ (0,∞); D_∞ = diam; ρ_p = Len/D_p, CRad_p = D_p/Thi; Rop = ρ_p CRad_p.
- **Proposition 6.5 (p. 14) — Relation between R_2 and D_2.** For every admissible γ, D_2(γ) = √2 R_2(γ) = √2 R_g(γ).
- **Definition 7.1 (p. 14).** Polygonal invariants ρ_D(P) = Len(P)/D(P), CRad_D(P) = D(P)/Thi_poly(P), Pack_D(P); ρ_{D,n}(K) = inf over P_n(K), CRad_{D,n}(K) = inf, Pack_{D,n}(K) = sup (p. 15).
- **Proposition 7.2 (p. 15) — Polygonal representative-level decomposition.** Rop_poly(P) = ρ_D(P) CRad_D(P); Rop_{poly,n}(K) ≥ ρ_{D,n}(K) CRad_{D,n}(K).
- **Remark 7.3 (p. 15).** Equality Rop_{poly,n}(K) = ρ_{D,n}(K) CRad_{D,n}(K) need not hold.
- **Assumption 7.4 (p. 15) — Approximation and compactness hypotheses.** (1) For every C^{1,1} γ ∈ H(K) of positive thickness there are P_n ∈ P_n(K) with P_n → γ, D(P_n) → D(γ), Thi_poly(P_n) → Thi(γ). (2) If P_n ∈ P_n(K) with Thi_poly(P_n) = 1 and D(P_n) ≤ C, then after translations and a subsequence P_n converges to an admissible γ ∈ H(K) of the same knot type. (3) For every such subsequence D(γ)/Thi(γ) ≤ liminf D(P_n)/Thi_poly(P_n).
- **Lemma 7.5 (p. 15–16).** For D = diam and D = R_min, Assumption 7.4 holds in the standard polygonal ropelength setting. Proof idea (paper): inscribed polygons; polygonal thickness convergence is the main theorem of Rawdon–Simon [21]; diam and R_min continuous under Hausdorff convergence; compactness via unit-tube volume bound on length.
- **Theorem 7.6 (p. 16) — Polygonal approximation for compression radii.** If D satisfies Assumption 7.4, then lim_{n→∞} CRad_{D,n}(K) = CRad_D(K); if CRad_D(K) > 0 then lim Pack_{D,n}(K) = Pack_D(K). In particular for D = diam and D = R_min. *Proved (p. 16–17).*
- **Corollary 7.7 (p. 17).** The conclusion applies to any D for which Assumption 7.4 can be verified, e.g. R_p (1 ≤ p < ∞), D_p (1 ≤ p ≤ ∞), D_{conv,η}; verification is not automatic.
- **Remark 7.8 (p. 17).** The extra difficulty for compression radii is the presence of thickness (convergence/semicontinuity of polygonal thickness needed).
- **Proposition 8.1 (p. 18) — Density gives a distortion lower bound.** For every embedded closed curve γ, distort(γ) ≥ ½ Len(γ)/diam(γ); consequently distort(γ) ≥ ¼ Len(γ)/R_min(γ). Proof idea (paper): take p and q at arclength Len/2 apart, so d_γ(p,q) = Len/2 and |p−q| ≤ diam; then diam ≤ 2R_min. At the representative level distort(γ) ≥ ¼ ρ_R(γ) = ¼ Rop(γ)/CRad_R(γ); taking infima distort(K) ≥ ¼ ρ_R(K) (same class of representatives); no equality with Rop(K)/CRad_R(K) implied (p. 19).
- **Conjecture 8.2 (p. 20) — Compression lower bound from supertrunk.** There is a universal constant c > 0 such that for every knot type K, CRad_R(K) ≥ c strunk(K). (Heuristic motivation: N disjoint disks of radius ≈ r in a planar disk of radius ≈ R gives N ≲ C(R/r)², hence strunk(γ) ≲ C CRad_R(γ)² (p. 19–20); paper says "motivation, not a proof".) *Open conjecture.*
- **Question 8.3 (p. 20) — Density and trunk.** Is there a universal function f with ρ_R(K) ≥ f(trunk(K))? More generally bounds for ρ_D(K) or CRad_D(K) in terms of trunk, supertrunk, superbridge number, or representativity?
- **Question 9.1 (p. 20) — Simultaneous minimizers.** For which K and D does there exist γ ∈ I_Rop(K) ∩ I_{ρ_D}(K) ∩ I_{CRad_D}(K), i.e. Rop(K) = ρ_D(K) CRad_D(K)?
- **Question 9.2 (p. 21).** How different can the three ideal strata be? Examples where they are disjoint?
- **Question 9.3 (p. 21) — Natural strictness and the trefoil.** For the trefoil and D = diam or R_min, is Rop(K) ≥ ρ_D(K) CRad_D(K) strict (no common minimizing sequence)?
- **Question 9.4 (p. 21).** Behavior of ρ_D(K), CRad_D(K) under connected sum (subadditive/superadditive/nonmonotone)?
- **Question 9.5 (p. 21).** Do large representativity, trunk or superbridge number force lower bounds for compression radii or density?
- **Question 9.6 (p. 21).** Which size functional best separates density from compression (diam, R_min, R_g, pairwise L^p-spread, convex-hull size)?
- **Question 9.7 (p. 21).** Can ρ_{D,n}(K) and CRad_{D,n}(K) be effectively approximated by finite-dimensional optimization; usable as computable surrogates?
- **Remark 9.8 (p. 21).** Discrete surrogates: lattice-filtered move graphs [17] (seed-generated BFACF merge scales 32 for the figure-eight knot and 44 for 6_3; verified move-path certificate, second implementation, Zenodo archive [19]); discrete density/compression profiles [18] (lattice length normalised by chord-length spread functionals; raw lattice-thickness convention); relation to continuous invariants open.
- **Question 9.9 (p. 21–22) — Filtered densities and compression radii.** Filter H(K) by sublevel sets {CRad_D ≤ Λ} or {ρ_D ≤ Λ}; study admissible components and merge scales; dependence on D; do amphichiral knot types exhibit positive mirror merge barriers (as in BFACF experiments: 4_1 and 6_3 mirror seed pairs have barriers 2 and 4 [17])?

## Key equations and quantitative claims outside numbered statements
- p. 1, 8: ropelength = geometric density × scale-free compression radius (formal identity; rigorous trivial).
- p. 3 (quoted literature): universal lower bounds of order Cr^{3/4}; DEPZ09: Rop(K) ≤ a Cr(K) log⁵ Cr(K); DDS04: Rop(K) ≥ 15.66 for nontrivial K (⚠ convention, see above); Diao: alternating knots Rop(K) > b_0 Cr(K) with b_0 > 1/56 (rigorous, quoted); non-alternating torus knots 3/4-power constructions [13] KT25.
- p. 3–4 (numerical, from companion papers [17]): BFACF merge scales for mirror seed pairs of 4_1 and 6_3: values 32 and 44, from birth levels 30 and 40, so mirror barriers 2 and 4 (lattice, numerical/verified computation, not proved here).
- p. 8: Rop(K) ≥ 2 CRad_diam(K) (using ρ_diam ≥ 2).
- p. 11: any lower bound CRad_diam(K) ≥ c Cr(K)^{3/4} would give Rop(K) ≥ 2c Cr(K)^{3/4}; alternating knots would need ρ_D CRad_D ≳ Cr (paper's targets, hypothetical).
- No new ropelength bounds are claimed ("the formal decomposition alone does not produce new ropelength lower bounds").

## Methods / algorithms
Pure-math framework paper.
1. (§2–3) Define size functionals, densities, compression radii and packing ratios; prove the representative-level identity and the optimized inequality; characterize equality (Prop. 3.7); unknot examples; artificial strictness example.
2. (§6) L^p-radial and pairwise L^p families (R_g, D_2 relation).
3. (§7) Polygonal approximation: Assumption 7.4 (approximation, compactness, ratio lower semicontinuity) ⇒ Theorem 7.6 by an upper/lower limit argument; verification for diam and R_min via Hausdorff continuity and unit-tube volume compactness.
4. (§8) Distortion bound from density (antipodal-in-arclength points); heuristic link between compression and supertrunk via disjoint tube disks on level planes.

## Tables
None.

## Figures
- **Fig. 1 (p. 2)** — "The representative-level decomposition of ropelength into a density factor and a compression factor. After optimization over a knot type, the minimizing representatives for the three quantities may differ." *Shows:* diagram Rop(γ) = Len/Thi = ρ_D(γ) · CRad_D(γ) with choices of D (diam, R_min, R_p, D_p, D_{conv,η}). Image: ../figures/Ozawa26geom/p02.png
- **Fig. 2 (p. 9)** — "Two basic size functionals. The dashed circle represents a minimal enclosing ball of radius R_min(γ) centered at a, while the segment indicates the diameter scale diam(γ)." Image: ../figures/Ozawa26geom/p09.png
- **Fig. 3 (p. 14)** — Schematic of polygonal approximation: smooth γ approximated by inscribed polygons P_n; CRad_{D,n}(K) → CRad_D(K), Pack_{D,n}(K) → Pack_D(K). Image: ../figures/Ozawa26geom/p14.png
- **Fig. 4 (p. 18)** — Left: nearby points with long arclength separation contribute to distortion; right: intersections with level planes measure trunk; worst direction gives supertrunk. Image: ../figures/Ozawa26geom/p18.png

## Stated limitations, open problems, future work
- p. 1 (abstract), 8, 11: the framework does not improve ropelength lower bounds without independent estimates for density and compression factors.
- p. 7: equality after optimization requires a common minimizing sequence; "not expected in general".
- p. 15–17: other size functionals require verification of Assumption 7.4; p. 20: supertrunk/compression relation is heuristic; rigorous version needs transversality or coarea-type estimate.
- Questions 8.3, 9.1–9.9 and Conjecture 8.2 (open).

## References worth following
- [16] Ozawa, The ideal stratum and deformation persistence of knot types, arXiv:2604.17905 (= Ozawa26rope); [17] Ozawa, Discrete knot theory via lattice-filtered move graphs, arXiv:2605.25322 (= Ozawa26merge); [18] Ozawa, Discrete p-density and compression radii of lattice knots, arXiv:2605.29160 (= Ozawa26density); [19] Zenodo DOI 10.5281/zenodo.20412976.
- [21] Rawdon, Simon, Polygonal approximation and energy of smooth knots, JKTR 15 (2006) (polygonal thickness convergence).
- [5] Denne–Diao–Sullivan, Quadrisecants..., Geom. Topol. 10 (2006); [9] DEPZ09; [8] Diao, The ropelength conjecture of alternating knots (2024); [13] KT25; [14] Klotz, Tight bounds for tight links, arXiv:2603.02416.
- [6] Denne–Sullivan, The distortion of a knotted curve, PAMS 132 (2004); [20] Pardon, On the distortion of knots on embedded surfaces, Ann. Math. 174 (2011).
- [2] Blair–Ozawa, Height, trunk and representativity of knots (2019); [15] Kuiper, A new knot invariant.

## Extraction notes
- Pages rendered: 2, 9, 14, 18. No tables. All statements (definitions, lemmas, propositions, theorem, corollary, conjecture, questions) transcribed in full from the text layer; no formulas needed image verification (formulas simple and consistent).
- ⚠ Convention inconsistency for the quoted DDS04 bound 15.66 (diameter convention) in a paper that declares the radius convention (p. 3, 10).
- ⚠ Example 3.9: ρ_R(U) = 2π and ρ_diam(U) = π are evaluated at the round circle but stated as infima (see statement).
- ⚠ Proof of Prop. 6.2 cites "Proposition 3.5" (it is Lemma 3.5).
- Intro mentions "Section 5" and "Section 4 ... concrete choices of D" while "Section 6 gives L^p versions" — consistent; Section 5 is a literature benchmarks section (p. 10–12) with no new results.
