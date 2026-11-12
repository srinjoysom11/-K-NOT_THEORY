# Ozawa26density — Density and compression on lattice-knot merge trees
- **Authors:** Makoto Ozawa (Dept. of Natural Sciences, Komazawa University, Tokyo)
- **Venue / year / identifiers:** arXiv:2605.29160v3 [math.GT], 26 Aug 2026 (MSC 57K10; 49Q10, 49Q20, 53A04, 52C25). Keywords: lattice knot, BFACF move, merge tree, p-density, compression radius, ropelength, thickness, filtered move graph, raw lattice profile. Acknowledgments (p. 24): ChatGPT used as interactive aid; author takes responsibility. Zenodo data: doi 10.5281/zenodo.21319883 (trefoil pilot, p. 23) and 10.5281/zenodo.21304711 (merge certificates).
- **File:** papers/2_algorithms/Ozawa_2026_Density_compression_lattice_knot_merge_trees_2605.29160.pdf   **Pages:** 25
- **Text layer:** ok (table columns scrambled in text; all main tables re-read from page images)

## Abstract
We introduce a finite-state framework for discrete p-density and compression-radius profiles of lattice knots. At a lattice length level N, one considers lattice-polygon representatives of a fixed knot type, modulo proper lattice isometries, and optionally restricts to the subgraph generated from specified seeds by a local move system such as BFACF moves. Raw density and compression functionals are attached directly to the lattice polygons. To reduce lattice artefacts, the framework also permits controlled perturbation, corner smoothing, thickness certification, and thickness normalization.

The unconditional results are finite-state statements: computability for a fixed explored graph and finite smoothing scheme, monotonicity under increasing length caps, and componentwise inequalities under graph mergers. We further organize the construction as a two-parameter filtration by lattice length and by a density or compression threshold, giving a computable discrete counterpart of continuous density- and compression-filtered knot spaces. The analytic lattice-to-continuous approximation problem is left open.

As preliminary numerical checks, we report raw-lattice computations for the square unknot and a 24-edge cubic-lattice trefoil, together with a restricted length-filtration profile for the trefoil at N = 24, 26, 28, 30, 32. We then compute raw geometric profiles on the complete minimal-layer merge trees of the amphichiral knots 4_1 and 6_3 determined in the companion paper. For every birth component we evaluate the full distribution of ρ_2, ρ_∞, CRad_2, and CRad_∞ on its minimal support. We also evaluate the entire bounded component at the first merge level: all 19618 states of the 4_1 component at N = 32, and both 12337-state mirror components of 6_3 at N = 42. Reflection gives identical geometric distributions on paired branches. The merge levels nevertheless enlarge the attainable geometric ranges: for 4_1 both density minima improve at N = 32, while the two compression minima remain unchanged; for 6_3 all four displayed minima improve at N = 42. The final 6_3 merger at N = 44 is represented by a verified explicit certificate but its full bounded component is not claimed to have been exhaustively enumerated. Along the selected maximal-barrier certificates, density and compression behave as competing rather than redundant objectives. All displayed values are explicitly raw-lattice quantities, not exhaustive smoothed knot-type invariants.

## Notation and conventions
- **Lattice:** "in computations SC = Z³" simple cubic, unit edges (p. 3, 5). Lattice polygon = embedded closed polygonal curve with lattice edges; lattice length ℓ(P) = number of edges (Def. 3.1, p. 5).
- **Counting convention:** P_N^L(K) = {lattice polygons of type K, ℓ(P) ≤ N}/Isom⁺(L), "the orientation-preserving lattice isometry group. If mirrors are to be identified, one may instead divide by the full lattice isometry group. In this paper mirrors are not identified unless explicitly stated." (p. 5). Prop. 8.2 uses the "mirror-sensitive quotient". Canonicalization = modulo orientation-preserving lattice isometries (p. 20).
- n_L(K) = minimal lattice length (Def. 3.2, p. 5). BFACF moves change length by 0 or ±2, so seed-generated searches only visit levels N_0, N_0+2, … (Remark 3.5, p. 5; Def. 3.6).
- **p-spread** D_p(γ) = ((1/L²)∬|x−y|^p ds_x ds_y)^{1/p}, −1<p<∞, p≠0; D_0 via logarithmic mean; D_∞ = diam (Def. 2.1, p. 3–4). D_2² = 2R_g² (p. 10).
- **p-density** ρ_p(γ) = Len(γ)/D_p(γ) (Def. 2.3); lattice: ρ_p^L(P) = ℓ(P)/D_p(P), D_p(P) computed with arclength measure on the polygon (Def. 4.1, p. 6). ρ_∞ = ℓ/diam.
- **Compression radius** CRad_D(γ) = D(γ)/Thi(γ) (Def. 2.4); Thi = min{MinRad, ½ d_csd} (p. 10), i.e. tube RADIUS convention (ropelength = Len/Thi, length/radius). Lattice: CRad_D^L(P) = D(P)/Thi_poly(P) (Def. 4.2).
- **Raw SC thickness convention (labelled, not a theorem):** "Thi_poly(P) = 1/2, CRad^SC_D(P) = 2D(P)" (Remark 4.6, p. 6; p. 11). So in raw tables CRad^SC_2 = 2 D_2, CRad^SC_∞ = 2 diam, and ρ_D(P)·CRad^SC_D(P) = 2ℓ(P) ("raw ropelength proxy", p. 17). Paper notes true polygonal thickness with a right-angle corner is ≤ 1/2, equality only if no non-adjacent features force smaller.
- Minimal support M(C) = C ∩ P^SC_{n_SC(K)}(K) (p. 13): minimal-length states of a merge-tree node C.
- Merge-tree nodes: 4_1: birth components C1, C2 (58 states each) and C3, C4 (18 each) at N=30; all merge at N=32. 6_3: twelve birth components A39,A10,A9,A7,A6,A3 and mirrors B39,…,B3 (sizes 39,10,9,7,6,3; reflection exchanges A_r and B_r) at N=40; six A_r merge into branch A and six B_r into branch B at N=42 (74 minimal classes, 12337 bounded states each, disjoint); A, B merge at N=44 (p. 13). Hierarchies 4→1 (4_1), 12→2→1 (6_3).
- Filtration: sublevel graph G_{N,Λ}^F(K;S) = G_N^{L,M}(K;S) restricted to {P: F(P) ≤ Λ}; F-admissible components (p. 22). Seed-generated graph G_N^{L,M}(K;S) = induced subgraph on vertices reachable from seed set S by M-paths staying at length ≤ N (Def. 3.4, p. 5). Level-N profile = min over the finite vertex set.
- Ropelength-windowed continuous profiles ρ_p^{rop,λ}(K), CRad_D^{rop,λ}(K) (Def. 2.6, p. 4).
- Reference numbering in THIS paper: [16] = Ozawa "Merge trees of lattice knots" arXiv:2605.25322 (= Ozawa26merge); [17] Zenodo 21304711; [18] Ozawa "Unconstrained and ropelength-windowed p-densities of knot types" arXiv:2604.23621; [19] Ozawa26geom (arXiv:2604.27912); [20] Zenodo 21319883. Differs from Ozawa26geom (there the merge paper is [17], this paper [18], Ozawa26rope [16]).
- **Differences from Ozawa26geom:** that paper is an abstract framework (single size functional D, Rop = ρ_D·CRad_D, polygonal approximation theorem 7.6) with the pairwise family D_p (Def. 6.4, p∈(0,∞)); this paper is the computational/finite-state companion on lattice polygons with explicit raw convention Thi_poly=1/2, p-spread range −1<p<∞, D_2² = 2R_g² (geom Prop. 6.5: D_2 = √2 R_g, same). Both use tube-radius thickness (Rop = Len/Thi).

## Numbered statements
- **Definition 2.1 (p. 3–4) — p-spread.** For −1<p<∞, p≠0: D_p(γ) = ((1/L²)∬_{γ×γ} |x−y|^p ds_x ds_y)^{1/p}; for p=0, log D_0(γ) = (1/L²)∬ log|x−y| ds_x ds_y (when finite); D_∞ = diam.
- **Remark 2.2 (p. 4).** p>−1 is the local integrability threshold (|γ(s)−γ(t)| ∼ |s−t| gives ∫|s−t|^p, finite iff p>−1); p=0 log singularity integrable; polygons handled edgewise.
- **Definition 2.3 (p. 4).** ρ_p(γ) = Len(γ)/D_p(γ). D = Euclidean-invariant size functional homogeneous of degree one (examples: diam, minimal enclosing radius, radius of gyration, D_p).
- **Definition 2.4 (p. 4).** CRad_D(γ) = D(γ)/Thi(γ); CRad_p = D_p/Thi.
- **Lemma 2.5 (p. 4) — Scale invariance.** ρ_p(aγ)=ρ_p(γ), CRad_D(aγ)=CRad_D(γ), a>0. Proof idea: both Len and D_p (resp. D and Thi) scale by a.
- **Definition 2.6 (p. 4) — Ropelength-windowed profiles.** ρ_p^{rop,λ}(K) = inf{Len/D_p : γ∈K, Thi(γ)≥1, Len(γ)≤λRop(K)}; CRad_D^{rop,λ}(K) = inf{D/Thi : γ∈K, Thi(γ)>0, Len/Thi ≤ λRop(K)}, λ≥1.
- **Remark 2.7 (p. 4).** The two normalizations are equivalent (scale invariance); without the length window density quantities collapse under local knotting constructions.
- **Definitions 3.1–3.4, 3.6 (p. 5).** Lattice polygon; P_N^L(K); n_L(K); filtered move graph G_N^{L,M}(K) (vertices P_N^L(K), edges = one allowed move); seed-generated graph G_N^{L,M}(K;S); admissible length levels N_M(N_0) = {N≥N_0 reachable under M} (= {N_0, N_0+2, …} for SC BFACF).
- **Remark 3.5 (p. 5).** "For the standard simple-cubic BFACF moves, the irreducibility classes on unrooted polygons are exactly the knot types [4]" (quoted: Janse van Rensburg–Whittington 1991). A bounded search is not exhaustive: a path to a polygon of length ≤ N may pass through longer intermediates. BFACF moves change length by 0 or ±2.
- **Definition 4.1 (p. 6).** ρ_p^L(P)=ℓ(P)/D_p(P); ρ_{p,N}^L(K)=min over P_N^L(K); seed version ρ_{p,N}^{L,M,seed}(K;S).
- **Definition 4.2 (p. 6).** CRad_D^L(P)=D(P)/Thi_poly(P); CRad_{D,N}^L(K) = min; seed version.
- **Proposition 4.3 (p. 6) — Finite-state computability.** For fixed L, K, N and finite move-generated vertex set, ρ_{p,N}^{L,M,seed}(K;S) and CRad_{D,N}^{L,M,seed}(K;S) are finite computable reals (up to numerical precision); global level-N quantities computable if P_N^L(K) is enumerated. Proved (finite minimum).
- **Proposition 4.4 (p. 6) — Monotonicity in the length level.** For N ≤ N′: ρ_{p,N′}^L(K) ≤ ρ_{p,N}^L(K) and CRad_{D,N′}^L(K) ≤ CRad_{D,N}^L(K) (when defined); same for seed-generated profiles if the vertex sets are nested. Proof idea: feasible set at N contained in that at N′.
- **Remark 4.5 (p. 6).** Distinguishes: finite value on explored graph / exhaustive value from complete enumeration / unproved statement about all lattice representatives.
- **Remark 4.6 (p. 6) — Simple cubic thickness.** Orthogonal corner gives local scale 1/2, so Thi_poly ≤ 1/2 for a polygon with a right-angle corner; equality only when no non-adjacent features force smaller half-distance. Raw tables use Thi_poly = 1/2, CRad^SC(P) = 2D(P), labelled convention.
- **Definition 5.1 (p. 7) — Smoothing-perturbation scheme S=(ε,r,A).** Each P gets a nonempty finite set S(P)={γ_1..γ_m} of embedded C^{1,1} curves: (i) ambient isotopic to P; (ii) in ε-tubular neighbourhood of P; (iii) corners replaced by arcs/splines of radius ≥ r; (iv) reproducible from finite data A.
- **§5.1 corner-rounding scheme (p. 7).** At right-angle vertex v_i (a_i=v_i−v_{i−1}, b_i=v_{i+1}−v_i, a_i⊥b_i), choose 0<r<1/2; replace trimmed subsegments ending at q_i^−=v_i−r a_i, q_i^+=v_i+r b_i by the quarter-circle of radius r centred at c_i=v_i−r a_i+r b_i; straight vertices unchanged; result γ_r(P). Finite scheme S_round(P)={γ_{r_j}(P)} after discarding curves failing an embeddedness certificate; perturbed scheme first displaces vertices by rational displacements ≤ ε.
- **Proposition 5.2 (p. 7) — Elementary thickness certificate.** If γ is a rounded perturbation of unit SC polygon P in the δ-neighbourhood, non-adjacent local pieces have mutual distance ≥ 1−2δ and all smoothing arcs have radius ≥ r, then Thi(γ) ≥ min{r, (1−2δ)/2}. Proof idea: thickness = min(min curvature radius, ½ doubly critical self-distance).
- **Remark 5.3 (p. 8).** Conservative bound; non-adjacent-distance hypothesis is a genuine global condition and can fail for dense polygons; sharper experiments should use interval subdivision or exact segment-arc distances.
- **Certification pipeline (C1)–(C4) (p. 8):** (C1) decompose into segments and arcs with rational/interval endpoints; (C2) certify tangent matching and local curvature radius ≥ r (∞ on segments); (C3) certified lower bound for distance between non-adjacent pieces by interval arithmetic on f(s,t)=|γ_i(s)−γ_j(t)|², subdividing I×J until tolerance; (C4) τ_cert = min(local radius bound, ½ certified non-local distance) ⇒ Thi(γ) ≥ τ_cert>0.
- **Proposition 5.4 (p. 8) — Certified computability for line-and-arc smoothing.** For finite search graph, finite list of radii, fixed subdivision tolerance, positive certified separation margin for each accepted curve, thickness-normalized smoothed density/compression values are reproducibly computable with certified thickness lower bound. Proved (finiteness).
- **Definition 5.5 (p. 8).** Thickness normalization γ̂ = γ/Thi(γ), Thi(γ̂)=1; ρ_p, CRad_D unchanged.
- **Definitions 5.6, 5.7 (p. 9).** Smoothed profiles ρ_{p,N}^{L,S}(K)=min{ρ_p(γ̂): P∈P_N^L(K), γ∈S(P)}, seed version with G_N^{L,M}(K;S); similarly CRad.
- **Theorem 5.8 (p. 9) — Finite computability of smoothed profiles.** For fixed K, N, finite seed-generated graph, finite scheme S, the smoothed seed-generated profiles are finite computable (global ones too if P_N^L(K) is enumerated). Proved (finite minimum).
- **Remark 5.9 (p. 9).** Perturbation separates the approximated invariant from lattice symmetries/angular constraints (a 90° corner imposes a fixed curvature scale).
- **Definition 6.1 (p. 9) — Windowed smoothed lattice profiles.** ρ_{p,λ}^{L,S}(K) = min over integers N ≤ λ n_L(K) of ρ_{p,N}^{L,S}(K); similarly CRad; for seeds of length N_0 the min is over N∈N_M(N_0), N ≤ λN_0.
- **Problem 6.2 (p. 9–10) — Thickness-controlled lattice-smoothing approximation (OPEN).** For L_h = hZ³, h→0, caps N_h(λ) = λRop(K)/h (parity adjusted; rounding brackets illegible in text layer), find hypotheses on S_h, thickness certificates and lattice approximation under which ρ_{p,N_h(λ)}^{L_h,S_h}(K) → ρ_p^{rop,λ}(K), and similarly for CRad_D.
- **Remark 6.3 (p. 10).** Guiding problem, not a result; limit needs control of lattice approximation, smoothing, thickness certificates, optimization error.
- **Problem 6.4 (p. 10) — Effective error bounds (OPEN).** Find explicit E_ρ(h,N,ε,r), E_D(h,N,ε,r) bounding the difference between smoothed lattice and continuous ropelength-windowed profiles.
- **§7 formulas (p. 10):** D_2(γ)² = (1/L²)∬|x−y|² = 2R_g(γ)², R_g² = (1/L)∫|x−x̄|²ds; D_∞ = diam (attained at vertices for polygons); general p: sum over edge pairs, edgewise quadrature, care for −1<p<0 near e=f; smoothed thickness Thi = min{MinRad, ½ d_csd}.
- **Remark 8.1 (p. 12).** Density and compression need not improve simultaneously: Table 1 length-26 detour lowers ρ_2, ρ_∞ vs 24-step seed while Table 2 shows raw compression radii increase.
- **Proposition 8.2 (p. 14) — Exact raw profiles on the computed merge-tree nodes.** Under the mirror-sensitive quotient and raw convention Thi_poly=1/2, the following values are exact for the stated finite sets: (i) for 4_1, all 152 minimal states and the entire 19618-state bounded component at N=32 are evaluated; (ii) for 6_3, all 148 minimal states and both entire 12337-state bounded components A and B at N=42 are evaluated; (iii) reflection preserves all four functionals, so each pair A_r, B_r has the same complete distribution, and the level-42 branches A and B have the same complete distribution although A∩B=∅ at N=42; (iv) the minimal-support profile of the final 6_3 root is exact (support = union of all 148 minimal states); no exhaustive bounded-state profile is claimed for the full N=44 root. *Computed/proved here.* Proof idea (paper): state sets finite, enumerated with the same BFACF moves and canonicalization as the companion merge-tree computation; reflection preserves arclength measure and distances hence D_2 and diam.
- **Theorem 11.1 (p. 21) — Component monotonicity under merge.** If seed-generated graphs are nested in N and C_1,…,C_m are components of G_N^{L,M}(K;S) lying in a single component C′ of G_{N′}^{L,M}(K;S), N′≥N, then ρ_p(C′) ≤ min_j ρ_p(C_j) and CRad_D(C′) ≤ min_j CRad_D(C_j) (ρ_p(C)=min{ρ_p(γ): P∈C, γ∈S(P)}). Proof idea: feasible sets nested.
- **Remark 11.2 (p. 21).** A merge may lower but cannot raise the component minimum; record both merge scale and first level reaching a threshold.
- **Proposition 11.3 (p. 22) — Finite two-parameter filtration.** If N ≤ N′ and Λ ≤ Λ′ (nested seed graphs), G^F_{N,Λ}(K;S) ⊆ G^F_{N′,Λ′}(K;S); for finite sets of levels and thresholds all component births, mergers and first threshold-crossing levels are computable by finite graph search.
- **Remark 11.4 (p. 22).** Discrete counterpart of the density/compression-sublevel filtrations of [19]; the length-only merge scales of [16] and the global minimum profiles are one-parameter shadows.
- **Theorem 12.1 (p. 22) — Computable smoothed lattice profiles.** For fixed K, L, M, finite seed set S, cap N, finite smoothing scheme, the smoothed seed-generated profiles are well-defined finite computable quantities, nonincreasing in N along nested seed-generated searches. Proof: Thm 5.8 + feasible-set inclusion.
- **Question 12.2 (p. 22) — Stabilized lattice approximation with scaled windows (OPEN).** For L_h=hZ³ and smoothing schemes with radii/perturbations/tolerances →0 preserving embeddedness and isotopy, with cap N_h(λ)=λRop(K)/h (parity adjusted), under what additional thickness, approximation, optimization hypotheses do smoothed lattice profiles converge to the ropelength-windowed continuous profiles?
- **Problem 14.1 (p. 23) — Certified thickness for smoothed lattice curves (OPEN).**
- **Problem 14.2 (p. 24) — Further exhaustive minimal-layer profiles (OPEN).** Extend 4_1/6_3 to further small knots, certified smoothed representatives, compare across knot types and lattices.
- **Problem 14.3 (p. 24) — Bounded profile at the top 6_3 merge (OPEN).** Exhaustively enumerate the full N=44 bounded component of 6_3 and compute min/max/mean/median/distribution of raw and smoothed functionals; determine which new optima first appear at the top merge.
- **Problem 14.4 (p. 24) — Geometric cost of a merge path (OPEN).** Minimax cost of connecting two seed components under cap N (minimize the largest F-value along a path); compute for 4_1 and 6_3 mirror seed pairs, compare with length-only barrier; can density- and compression-minimizing paths coincide?

## Key equations and quantitative claims outside numbered statements
- p. 2 (quoted from companion [16], not re-derived here): 152 minimal 4_1 classes split at length 30 into four type-0 components of sizes 58, 58, 18, 18, all merging at N=32; 148 minimal 6_3 classes split at length 40 into twelve components of sizes 39,39,10,10,9,9,7,7,6,6,3,3, merging into two mirror-related components at N=42 and one at N=44. Barrier spectra on birth-level components {0,2} (4_1) and {0,2,4} (6_3).
- p. 11: trefoil seed = 24-step KnotPlot cubic coordinate model; Diao: no nontrivial SC knot has <24 steps, 24-step ones are trefoils [6,7]. Length-26 row: replace edge (0,2,1)→(−1,2,1) by detour (0,2,1)→(0,3,1)→(−1,3,1)→(−1,2,1); "not an exhaustive level-26 computation".
- p. 12 (computation): rounded square r=1/4: L = 4(1−2r)+2πr = 2+π/2 ≈ 3.5708; Thi ≥ r = 1/4, certificate sharp; line-and-arc quadrature.
- p. 12 (numerical, restricted search): candidates from the 24-step seed by positive +2 plaquette detours only, embedded polygons kept; neither an exhaustive BFACF cap search nor enumeration of all trefoil polygons. Filtered ρ_2: 11.3576 (N=24) → 9.7147 (N=32); ρ_∞: 5.8209 → 4.2385. Exact-level counts 1, 47, 1286, 27018, 485184. Best CRad_2 already reached at N=26; best CRad_∞ stays the seed value 8.2462 through N=32; best exact-level CRad_2 rises mildly after N=26.
- p. 14 (4_1): "58-state components have smaller density minima, while the 18-state components have smaller compression minima. After the four components merge at N=32, new length-32 states improve both density minima, but neither compression minimum improves."
- p. 15 (6_3): A7/B7 smallest birth-level ρ_2 (14.9132), A9/B9 smallest birth-level ρ_∞ (7.3030), A6/B6 smallest birth-level CRad_2^SC (4.8597). Level-42 bounded branch improves (ρ_2, ρ_∞, CRad_2^SC, CRad_∞^SC) from (14.9132, 7.3030, 4.8597, 10.0000) to (14.1660, 6.5593, 4.8464, 9.7980). A and B indistinguishable by these reflection-invariant distributions.
- p. 15–16 (figure-eight certificate, verified path from [16], data in [17]): joins 30-edge SC figure-eight seed ω to mirror ω̄ under N=32; 21 states, 20 BFACF moves, via 32-edge connecting state η (=s5); ω→η 5 moves, mirror→η 15. Edge numbers along path: 30, 32×9, 30, 32×6, 30×4 (as printed: 30,32,32,32,32,32,32,32,32,32,30,32,32,32,32,32,32,30,30,30,30). At s10: CRad_2^SC=4.4969, CRad_∞^SC=8.2462, ρ_2=13.3425, ρ_∞=7.2761. At η density worsens (ρ_2 12.8545→13.5982, ρ_∞ 6.5465→6.9830), CRad_2^SC 4.6676→4.7065, CRad_∞^SC unchanged 9.1652.
- p. 17: raw ropelength proxy ρ_D·CRad^SC_D = 2ℓ: 60 at the 30-edge seeds, 64 at 32-edge states, back to 60. 21-state table in supplementary figure8_merge_path_32_density_compression.csv.
- p. 17 (6_3 certificate): σ = supplied 40-edge SC minimal seed in A7, σ̄ in B7; verified path 153 states, 152 BFACF moves, reaches but never exceeds length 44, meets at 42-edge state η=s116; seed branch 116 moves, mirror 36; realizes global maximal excess barrier 4. At η: ρ_2 15.2841→16.5461, ρ_∞ 7.8446→8.2369, CRad_2^SC 5.2342→5.0767, CRad_∞^SC unchanged 10.1980. Min ρ_2 along path 15.0260 at s3; min ρ_∞ 6.8716 at s52 (with CRad_∞^SC=12.8062, largest diameter-based compression on path); min CRad_2^SC 5.0767 at s116. Raw proxy 80, 84, 88 at ℓ=40, 42, 44. Table in six3_merge_path_44_density_compression.csv.
- p. 18–19 (heuristic, not proved): ρ_∞(P) ≥ 2 (closed curve of length L has diameter ≤ L/2); unrestricted raw ρ_{∞,N}(K) expected → 2 along flexible families (knot localized + long thin unknotted stadium, diam ~ ℓ/2); trefoil values 5.8209, 5.3072, 4.8742, 4.5227, 4.2385 "consistent with the initial stage of this degeneration". p=2: doubled interval of total length L in fixed cubic lattice: D_2² ∼ L²/24, ρ_2 ∼ √24 = 2√6 ≈ 4.8990; round circle of length L: ρ_2 = √2·π ≈ 4.4429 (printed "√2π ≈ 4.4429"; D_2 formula garbled in text, not image-checked). Summary table (p. 19): ρ_∞ decreases / degenerates toward 2; ρ_2 decreases / toward long-loop benchmarks √24 or √2π; CRad_∞ currently stable / finite compactness optimum; CRad_2 improves early then stable / finite compactness optimum. "Not proposed as new knot invariants; benchmark degeneracies for unwindowed density."
- p. 19: positive-detour candidate counts 27018 (ℓ=30) → 485184 (ℓ=32); N>32 should be labelled larger cap, pruned, beam-search or BFACF-sampling.
- p. 20: planned target set 0_1, 3_1, 4_1, 5_1, 5_2, 6_1, 6_2, 6_3, 7_1, 7_2, 3_1#3_1 (granny), 3_1#(mirror 3_1) (square); N_max=⌊λN_0⌋ parity adjusted.
- p. 21: output labels: exhaustive at level N; seed-generated; capped search; stochastic perturbation search. Distance functionals cannot detect chirality.
- p. 23: pseudocode (for each K, seeds, N in admissible levels: explore_BFACF with cap N; for each vertex P and smoothing γ: thickness, scale, evaluate, update best); reproducibility record fields (i)–(vii). Source package: tree_geometric_profile_summary.csv, figure8_tree_state_metrics.csv (19618 states), six3_tree_state_metrics_up_to_N42.csv, C++17 tree_profiles.cpp. Trefoil archive: seed coordinates, +2 plaquette-detour generator, evaluation scripts, summary tables N=24..32.
- p. 24 Appendix A: D_2² = 643/144, D_2 ≈ 2.1131 verified for the 24-step seed.

## Methods / algorithms
Raw-lattice pilot:
1. (p. 11) Raw functionals on unit-edge polygons: D_2² = (2/ℓ)∫|x−x̄|² via exact edgewise integrals (∫(a+td)dt = a+d/2; ∫|a+td|²dt = |a|²+a·d+1/3), D_∞ = max vertex distance, CRad^SC = 2D.
2. (p. 12, App. A p. 24) Trefoil search: SC lattice, type 3_1, seed = 24-step KnotPlot coordinates [vertices (1,−1,1), (1,0,1), (1,1,1), (1,2,1), (0,2,1), (−1,2,1), (−1,1,1), (−1,0,1), (−1,0,0), (0,0,0), (1,0,0), (2,0,0), (2,0,1), (2,0,2), (1,0,2), (0,0,2), (0,0,1), (0,1,1), (0,1,0), (0,1,−1), (1,1,−1), (1,0,−1), (1,−1,−1), (1,−1,0)]; only positive +2 plaquette detours; embedded polygons retained; N = 24, 26, 28, 30, 32; exact-level and cumulative bests (Tables 4, 5). Run times not reported.
3. (§8.3–8.4) Merge-tree profiles: SC lattice, BFACF, canonicalization mod orientation-preserving lattice isometries (mirrors distinguished); 4_1 at N=32 (19618 states) and 6_3 at N=42 (2×12337) enumerated exhaustively with the companion paper's enumerator (C++17); four functionals on every state; min/max/mean/median in supplementary CSV, only minima displayed. Sample sizes 152 (4_1) and 148 (6_3) minimal states.
4. Path certificates: verified BFACF paths from [16]/[17] (4_1: 21 states; 6_3: 153 states), functionals evaluated per state.
Planned smoothed protocol (§5, §9.3 p. 20): per level N: (1) generate BFACF graph from seeds with cap N; (2) canonicalize; (3) finite family S(P) of smoothed perturbations; (4) compute Thi, normalize, evaluate ρ_2, ρ_∞, CRad_2, CRad_∞; (5) record best value and realizer. NOT carried out here beyond the rounded-square example (Table 3).

## Tables
**Table 1 (p. 11)** — Pilot raw-lattice density values. These entries are candidate values, not exhaustive minima. The length-26 row gives an upper bound for the level-26 raw-lattice profile and shows that the length filtration can lower the observed ρ_2 and ρ_∞ values.

| K | representative | ℓ | D_2² | D_2 | D_∞ | ρ_2 | ρ_∞ |
|---|---|---|---|---|---|---|---|
| 0_1 | unit square | 4 | 2/3 | 0.8165 | 1.4142 | 4.8990 | 2.8284 |
| 0_1 | 1×2 rectangle | 6 | 3/2 | 1.2247 | 2.2361 | 4.8990 | 2.6833 |
| 3_1 | 24-step seed | 24 | 643/144 | 2.1131 | 4.1231 | 11.3576 | 5.8209 |
| 3_1 | one +2 plaquette detour | 26 | 5359/1014 | 2.2989 | 4.8990 | 11.3097 | 5.3072 |

**Table 2 (p. 11)** — Pilot raw-lattice compression-radius values under the standard Thi_poly = 1/2 convention. The one-detour row worsens the raw compression values even though it improves the displayed density values in Table 1; this illustrates that density and compactness are competing objectives. Smoothed profiles will replace these raw values by certified thickness-normalized C^{1,1} values.

| K | representative | ℓ | CRad_2^SC = 2D_2 | CRad_∞^SC = 2D_∞ | status |
|---|---|---|---|---|---|
| 0_1 | unit square | 4 | 1.6330 | 2.8284 | exact raw value |
| 0_1 | 1×2 rectangle | 6 | 2.4495 | 4.4721 | exact raw value |
| 3_1 | 24-step seed | 24 | 4.2262 | 8.2462 | seed value |
| 3_1 | one +2 plaquette detour | 26 | 4.5978 | 9.7980 | non-exhaustive candidate |

**Table 3 (p. 12)** — A complete smoothing sanity check for the unknot. The compression value uses the certified lower bound τ_cert = 1/4. In general this gives the conservative certified upper value D_2/τ_cert for the true compression radius; in this convex rounded-square example the certificate is sharp, since the actual thickness is r = 1/4.

| example | L | τ_cert | D_2 | D_∞ | ρ_2 | CRad_2 |
|---|---|---|---|---|---|---|
| rounded square, r = 1/4 | 3.5708 | 0.2500 | 0.7800 | 1.2071 | 4.5780 | 3.1199 |

**Table 4 (p. 13)** — Exact-level raw-lattice pilot profile for the trefoil. Candidates are obtained from a fixed 24-step seed by positive +2 plaquette detours only. The values are therefore non-exhaustive candidate values.

| exact length N | generated candidates | best ρ_2 | best ρ_∞ | min CRad_2 | min CRad_∞ |
|---|---|---|---|---|---|
| 24 | 1 | 11.3576 | 5.8209 | 4.2262 | 8.2462 |
| 26 | 47 | 11.3097 | 5.3072 | 4.1827 | 8.2462 |
| 28 | 1286 | 10.8903 | 4.8742 | 4.1886 | 8.2462 |
| 30 | 27018 | 10.3115 | 4.5227 | 4.2153 | 8.2462 |
| 32 | 485184 | 9.7147 | 4.2385 | 4.2420 | 8.2462 |

**Table 5 (p. 13)** — Filtered raw-lattice pilot profile for the trefoil. The entries are minima over the generated candidates with length at most N. The column "cumulative" gives the number of generated candidates with ℓ ≤ N. The monotone behavior follows from the nested feasible sets, while the numerical improvement measures the effect of increasing the length cap within this restricted search.

| cap N | cumulative | best ρ_2 | best ρ_∞ | best CRad_2 | best CRad_∞ |
|---|---|---|---|---|---|
| 24 | 1 | 11.3576 | 5.8209 | 4.2262 | 8.2462 |
| 26 | 48 | 11.3097 | 5.3072 | 4.1827 | 8.2462 |
| 28 | 1334 | 10.8903 | 4.8742 | 4.1827 | 8.2462 |
| 30 | 28352 | 10.3115 | 4.5227 | 4.1827 | 8.2462 |
| 32 | 513536 | 9.7147 | 4.2385 | 4.1827 | 8.2462 |

(Cumulative counts check: 1+47=48, +1286=1334, +27018=28352, +485184=513536.)

**Table 6 (p. 14)** — Complete minimal-layer BFACF component hierarchies from the companion paper. Reflections are retained in the quotient.

| knot | minimal length | birth-level partition and intermediate merge | final merge |
|---|---|---|---|
| 4_1 | 30 | 58+58+18+18; all four components persist to the next admissible level | N = 32 |
| 6_3 | 40 | 39+39+10+10+9+9+7+7+6+6+3+3; 12 → 2 at N = 42 | N = 44 |

**Table 7 (p. 14)** — Exact raw minima on the complete 4_1 merge tree. The mirror pairs C1, C2 and C3, C4 have identical complete distributions. Full min/max/mean/median summaries are supplied in tree_geometric_profile_summary.csv.

| 4_1 node/set | states | min ρ_2 | min ρ_∞ | min CRad_2^SC | min CRad_∞^SC |
|---|---|---|---|---|---|
| C1 or C2 minimal support | 58 | 12.4259 | 6.3960 | 4.4930 | 8.9443 |
| C3 or C4 minimal support | 18 | 13.3191 | 7.2761 | 4.3604 | 7.4833 |
| root minimal support | 152 | 12.4259 | 6.3960 | 4.3604 | 7.4833 |
| root bounded component, N = 32 | 19618 | 11.8473 | 5.8424 | 4.3604 | 7.4833 |

**Table 8 (p. 15)** — Exact raw minima on the computed nodes of the complete 6_3 merge tree. Mirror-related rows have identical full distributions. The bounded N = 44 root has not been exhaustively enumerated, so only its exact minimal support is listed.

| 6_3 node/set | states | min ρ_2 | min ρ_∞ | min CRad_2^SC | min CRad_∞^SC |
|---|---|---|---|---|---|
| A39 or B39 | 39 | 15.6243 | 7.8446 | 4.9048 | 10.0000 |
| A10 or B10 | 10 | 15.7694 | 7.8446 | 4.9363 | 10.1980 |
| A9 or B9 | 9 | 15.2841 | 7.3030 | 5.0186 | 10.3923 |
| A7 or B7 | 7 | 14.9132 | 7.4278 | 5.1494 | 10.1980 |
| A6 or B6 | 6 | 16.0590 | 7.8446 | 4.8597 | 10.0000 |
| A3 or B3 | 3 | 15.5651 | 7.8446 | 5.0790 | 10.1980 |
| A or B: minimal support, N = 42 | 74 | 14.9132 | 7.3030 | 4.8597 | 10.0000 |
| A or B: bounded component, N = 42 | 12337 | 14.1660 | 6.5593 | 4.8464 | 9.7980 |
| root minimal support, N = 44 | 148 | 14.9132 | 7.3030 | 4.8597 | 10.0000 |

**Table 9 (p. 15)** — Raw density and compression-radius values at the endpoints and the connecting state of the extracted N = 32 BFACF merge certificate for the supplied figure-eight seed and its reflected mirror seed. These are raw lattice values, not smoothed thickness-normalized values.

| state | role | ℓ | D_2 | D_∞ | ρ_2 | ρ_∞ | CRad_2^SC | CRad_∞^SC |
|---|---|---|---|---|---|---|---|---|
| s0 | seed ω | 30 | 2.3338 | 4.5826 | 12.8545 | 6.5465 | 4.6676 | 9.1652 |
| s5 | connecting state η | 32 | 2.3532 | 4.5826 | 13.5982 | 6.9830 | 4.7065 | 9.1652 |
| s20 | mirror seed ω̄ | 30 | 2.3338 | 4.5826 | 12.8545 | 6.5465 | 4.6676 | 9.1652 |

**Table 10 (p. 17)** — Raw density and compression-radius values at the endpoints and meeting state of the extracted N = 44 BFACF merge certificate for the supplied 6_3 seed and its reflected mirror. The values use the labelled convention Thi_poly = 1/2 and are not smoothed thickness-normalized values.

| state | role | ℓ | D_2 | D_∞ | ρ_2 | ρ_∞ | CRad_2^SC | CRad_∞^SC |
|---|---|---|---|---|---|---|---|---|
| s0 | seed σ | 40 | 2.6171 | 5.0990 | 15.2841 | 7.8446 | 5.2342 | 10.1980 |
| s116 | meeting state η | 42 | 2.5384 | 5.0990 | 16.5461 | 8.2369 | 5.0767 | 10.1980 |
| s152 | mirror seed σ̄ | 40 | 2.6171 | 5.0990 | 15.2841 | 7.8446 | 5.2342 | 10.1980 |

**Table 11 (p. 18)** — Comparison of the two verified BFACF mirror certificates used for the raw density and compression analysis. In each knot these paths realize the maximal excess barrier in the complete minimal-layer BFACF hierarchy; the geometric values themselves remain path-specific.

| knot | seed length | merge cap | mirror barrier | certificate | meeting length |
|---|---|---|---|---|---|
| 4_1 | 30 | 32 | 2 | 21 states, 20 moves | 32 |
| 6_3 | 40 | 44 | 4 | 153 states, 152 moves | 42 |

**Table 12 (p. 20)** — Initial target list for length-filtered smoothed density and compression computations. The values for 0_1 and 3_1 are classical simple-cubic minimal lengths, with the trefoil minimum due to Diao [6, 7]; for the remaining small prime knots and the listed connected sums we use the standard simple-cubic minimum-length table of Janse van Rensburg and Rechnitzer [12] as the intended birth levels. In an actual data release, each seed file should still be independently checked for length, embeddedness, and knot type. If a supplied seed is not certified minimal, the corresponding N_0 should be interpreted as a supplied-seed birth level rather than a proven lattice minimum.

| K | initial length N_0 | first levels | role in experiment |
|---|---|---|---|
| 0_1 | 4 | 4, 6, 8, … | calibration |
| 3_1 | 24 | 24, 26, 28, … | first nontrivial prime |
| 4_1 | 30 | 30, 32, 34, … | four-crossing prime |
| 5_1 | 34 | 34, 36, 38, … | torus knot test |
| 5_2 | 36 | 36, 38, 40, … | twist knot test |
| 6_1 | 40 | 40, 42, 44, … | six-crossing prime |
| 6_2 | 40 | 40, 42, 44, … | six-crossing prime |
| 6_3 | 40 | 40, 42, 44, … | six-crossing prime |
| 7_1 | 44 | 44, 46, 48, … | torus knot test |
| 7_2 | 46 | 46, 48, 50, … | seven-crossing prime |
| 3_1#3_1 | 40 | 40, 42, 44, … | granny knot |
| 3_1#(mirror 3_1) | 40 | 40, 42, 44, … | square knot |

(§9.4 p. 21 gives an empty output-table template, entries ∗; not data. The p. 19 "observed vs expected behaviour" table is transcribed under Key quantitative claims.)

## Figures
- **Fig. 1 (p. 16)** — "Raw density and compression values along the extracted 21-state figure-eight BFACF merge path at length bound N = 32. The dashed vertical line marks the connecting state η = s5. The plotted data are raw lattice values under the labelled convention Thi_poly = 1/2." *What it shows:* two panels vs state index 0–20: raw density (ρ_2, ρ_∞) and raw compression radius (CRad_2^SC, CRad_∞^SC); density rises around the connecting state while compression moves in the opposite direction at intermediate states (values in text). Image: ../figures/Ozawa26density/p16.png
- **Fig. 2 (p. 18)** — "Raw density and compression values along the extracted 153-state 6_3 BFACF merge path at length bound N = 44. The dashed vertical line marks the meeting state η = s116. The plotted data are raw lattice values under the labelled convention Thi_poly = 1/2." *What it shows:* same two-panel type over states 0–152. Image: ../figures/Ozawa26density/p18.png
- Table pages also rendered: p11, p12, p13, p14, p15, p17, p20 (../figures/Ozawa26density/pNN.png).

## Stated limitations, open problems, future work
- p. 2–3: profiles "not claimed to be absolute invariants of the knot type unless the lattice, move system, smoothing class, and search region are specified"; a bounded seed-generated search does not enumerate the full bounded state graph; smoothed stage "is a certified protocol rather than a source of large numerical tables".
- p. 14, 23: no exhaustive bounded profile for the full 6_3 level-44 component; all values raw-lattice.
- p. 10: lattice-to-continuous convergence open (Problems 6.2, 6.4; Question 12.2).
- p. 12: trefoil search positive-detour restricted, non-exhaustive. p. 19: N>32 needs explicit labelling.
- p. 20–21: planned experiments for target knots and granny/square knots not yet done; functionals cannot detect chirality.
- Problems 14.1–14.4 (open).

## References worth following
- [16] Ozawa, Merge trees of lattice knots, arXiv:2605.25322 (= Ozawa26merge); [17] Zenodo 10.5281/zenodo.21304711; [20] Zenodo 10.5281/zenodo.21319883.
- [18] Ozawa, Unconstrained and ropelength-windowed p-densities of knot types, arXiv:2604.23621; [19] Ozawa, Geometric densities and compression radii of knot types, arXiv:2604.27912 (= Ozawa26geom).
- [4] Janse van Rensburg, Whittington, The BFACF algorithm and knotted polygons, J. Phys. A 24 (1991) 5553–5567.
- [6] Diao, Minimal knotted polygons on the cubic lattice, JKTR 2 (1993); [7] Diao, The number of smallest knots on the cubic lattice, J. Stat. Phys. 74 (1994).
- [12] Janse van Rensburg, Rechnitzer, Minimal knotted polygons in cubic lattices, J. Stat. Mech. (2011) P09008; [13] Scharein et al., J. Phys. A 42 (2009) 475006.
- [15] Scharein, KnotPlot cubic-lattice knot coordinates; [22] Rawdon, Simon, Polygonal approximation and energy of smooth knots, JKTR 15 (2006).

## Extraction notes
- Pages rendered: 11–18, 20. Tables 1–10 and 12 cell-checked against page images (11, 12, 13, 14, 15, 17, 20); Table 11 read from text layer only (p. 18 image rendered but not cell-inspected). Pages 10 and 19 not image-checked (the D_2 formula for a circle and rounding brackets in N_h(λ) are illegible in text).
- Internal checks: ρ·CRad^SC = 2ℓ holds (e.g. 12.8545·4.6676 ≈ 60); Table 5 cumulative counts sum correctly; Table 3: 3.5708/0.7800 = 4.578 ✓.
- ⚠ Trefoil Zenodo archive is cited as "[19]" on p. 23 but [19] is Ozawa26geom (the trefoil Zenodo is [20]).
- ⚠ Reference numbering and the title of the merge paper differ from Ozawa26geom (it calls arXiv:2605.25322 "Discrete knot theory via lattice-filtered move graphs"; here [16] "Merge trees of lattice knots").
- ⚠ p-range: p>−1 here (Def. 2.1) vs p>0 in Ozawa26geom Def. 6.4.
- Sections 9.4 and 10 contain no results; no numbered Corollaries. Run times/compute resources not reported anywhere.
