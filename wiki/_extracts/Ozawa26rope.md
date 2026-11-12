# Ozawa26rope — Ropelength-filtered knot spaces
- **Authors:** Makoto Ozawa (Dept. of Natural Sciences, Komazawa University, Tokyo)
- **Venue / year / identifiers:** arXiv:2604.17905v7 [math.GT], 29 Sep 2026 ("Date: September 2026"); MSC 57K10; 53A04, 55P15, 57R40. Keywords: ropelength, thickness, space of knots, thick isotopy, physical knot theory, Gordian knots, persistent homotopy, merge ultrametric, swept-area metric. Declaration: ChatGPT and Claude used for drafting/restructuring/checks; author takes responsibility (p. 48). Pure-math paper: no numerical experiments of its own.
- **File:** papers/2_algorithms/Ozawa_2026_Ropelength_filtered_knot_spaces_2604.17905.pdf   **Pages:** 50
- **Text layer:** ok (formulas partly garbled in the layer, tables re-read from page images; proofs of Lemma 6.16 and Lemma 9.2 only skimmed)

## Abstract
Ropelength is usually studied as a minimisation problem for one knot at a time. Here we instead use ropelength to filter the space of all realisations of a knot type. For a knot type K and budget Λ, let Y_Λ(K) be the space of unit-thickness C^{1,1} configurations of length at most Λ, modulo rigid motions and constant-speed reparametrisation.

We prove compact capture for smooth knot families, yielding homotopical and homological exhaustion of the ordinary knot space by finite ropelength levels. In the normalised Euclidean model, every Y_Λ(K) is compact; connected components are right-continuous and their merge levels are attained, giving an ultrametric on the components of the ideal stratum. We also prove that Y_L(K) strongly deformation retracts onto its exact-length shell, so path connectivity at a fixed level is fixed-length physical isotopy. The connected merge scale and the path merge scale, the min–max quantity for constrained deformation paths, take the same values, although only the former is known to be attained. Moreover, all configurations in any fixed finite sublevel become path connected to one another at some common finite higher level, even if the original sublevel has infinitely many components.

For higher homotopy we introduce ropelength widths and relate them to known models of spaces of knots. We record mirror symmetry and prove finite factorization across every positive filtration gap in a marked weak model, yielding all-degree homological q-tameness. Finally, we relate the path filtration to the companion swept-area construction: the infimal budget for admissible endpoint connections agrees with the path merge threshold. The resulting framework separates geometric, topological, and physical-isotopy questions and provides a quantitative foundation for the study of ropelength-filtered knot spaces.

## Notation and conventions
- **Ropelength convention: LENGTH / RADIUS.** "Rop(γ) = Len(γ)/Thi(γ) is the ropelength: the dimensionless ratio of core length to tube radius" (p. 3). Convention 2.6 (p. 10): "We take Thi to be the radius of the largest embedded tube, as in [12]. With this convention the round circle of radius 1 has Thi = 1, Len = 2π and Rop = 2π. Part of the literature, for instance [14], uses the tube diameter instead, which halves all ropelength values. Numerical values quoted below have been converted to the radius convention." (So 31.32 of [14] is radius-convention; compare Ozawa26geom, which quotes the same bound as 15.66 under a radius label: that ⚠ is Ozawa26geom's, not this paper's.)
- Thickness Thi(γ) = sup{r : T_r(γ) embedded solid torus} = reach (Def. 2.1, p. 9); dcsd = doubly critical self-distance; Thi = min{inf ρ, ½ dcsd} (Thm 2.2); equivalently Thi = inf R(x,y,z) circumradius (2.1, p. 9); Federer form Thi = inf_{p≠q} |q−p|²/(2 dist(q−p, T_p)) (6.1, p. 30).
- m_K = Rop(K) = inf{Rop(γ): [γ]=K} (Def. 2.5, p. 10).
- **Filtration:** Y_Λ(K) = {[γ] : [γ]=K, Thi(γ) ≥ 1, Len(γ) ≤ Λ}/∼ with ∼ = rigid motion (orientation-preserving Euclidean isometry) and (constant-speed) reparametrisation incl. rotation or reflection of source circle (1.1, p. 4–5; Def. 6.1, p. 25, γ: R/2πZ→R³ constant speed, topologised as quotient of constant-speed C¹ topology). Y_∞(K)=∪_Λ Y_Λ(K). Smallest level with Y_Λ≠∅ is m_K; ideal stratum I(K) = Y_{m_K}(K) (p. 5). Smooth parallel model E_{K,Λ}(M) = {γ ∈ E_K(M): Rop ≤ Λ} (Def. 4.1, p. 15–16; E^{<Λ} strict; C^{1,1} version with norm ‖u‖_{C^{1,1}}).
- Exact-length shell P_L(K) = {[γ]∈Y_L(K): Len=L} (p. 25). Conn(X) = connected components, π_0(X) = path components (Convention 6.4, p. 26: not assumed equal).
- **Merge level (Def. 6.9, p. 27):** μ_K(x,y) = inf{Λ : x and y connected in Y_Λ(K)}; for connected sets A,B, μ_K(A,B) = inf of Λ at which A∪B lies in one connected component. **Path merge** μ_K^path(x,y) = inf{Λ : path from x to y in Y_Λ(K)} (Remark 6.14, p. 28). **Ultrametric** d_K(A,B) = μ_K(A,B) − m_K on Conn(I(K)) (Thm 6.12).
- Untying thresholds (Def. 6.29, p. 34): u_c(x)=μ_K(x,A_0), u_p(x)=μ_K^path(x,A_0), excesses e_c=u_c−L, e_p=u_p−L (L=Len(x)); x is Gordian relative to A_0 at its own length if no path from x to A_0 in Y_L(K).
- Width (Def. 5.1, p. 20): w_i^K(α;γ_*) = inf sup_z Rop(F(z)) over based representatives; excess width ℓ_i = w_i − Λ_* ≥ 0 (Λ_*=Rop(γ_*)); stabilisation level σ_i(K;γ_*) = sup_α w_i(α) (Def. 5.3, p. 21); death level d(a) (Def. 5.13, p. 23). Mirror merge scale μ_K^mir(A)=μ_K(A,τA), d_K^mir(A)=μ_K^mir(A)−m_K (Def. 6.33, p. 36).
- Marked weak model X_a (p. 40): {γ: S¹=R/Z→R³, C^{1,1}, |γ′|=1, γ̄=0 (centroid), Thi(γ) ≥ a^{-1}, [γ]=K}, C¹ topology, phase/orientation/rotation marked (so Rop ≤ a with length one).
- Pole-marked space P(K) = {(J,p): J∈K_K(S³), p∈S³∖J}, R(J,p) = Rop_{R³}(σ_p(J)), P_Λ(K)={R≤Λ} (§7.3, p. 38). Long knots: Rop_c(f)=Rop_{S³}(c(f)) after one-point compactification (§7.2).
- **Relation to Ozawa26geom / Ozawa26density:** same radius convention Rop=Len/Thi; this paper's Y_Λ(K) filtration is the "ropelength filtration of [16]" that Ozawa26geom Remark 3.13 refers to (geom [16] = this paper), and the "ideal stratum" I(K) is the initial layer I_Rop(K). Reference numbering here: [33] = Ozawa26merge (arXiv:2605.25322), [34] = Ropelength-Filtered Reidemeister Graphs (arXiv:2605.03350), [35] = Ropelength-Filtered Swept-Area Geometry (arXiv:2605.05557). No density/compression radius quantities appear in this paper; Ozawa26geom and Ozawa26density are not cited.
- Conventions quoted from literature in the numerics (p. 12): benchmark numbers 2π (unknot), 4π (Fáry–Milnor), 21.45 [12], 31.32 [14], 32.74 (3_1), 42.09 (4_1) all in the radius convention.

## Numbered statements
(Definitions 2.1, 2.5, 4.1, 5.1, 5.3, 5.7, 5.13, 6.1, 6.9, 6.29, 6.33 are given in Notation. "Quoted" = from the literature; "proved here" per the paper's Table 1 on p. 8.)
- **Question 1.1 (p. 3) — The rope-budget question.** Given two configurations of the same knot type made from the same rope, can one be deformed into the other without cutting the rope, letting it pass through itself, or using more rope than we started with?
- **Theorem 2.2 (p. 9) — Thickness formula.** For embedded C^{1,1} γ: Thi(γ) = min{inf_s ρ(s), ½ dcsd(γ)}, ρ=1/|κ|; equivalently (2.1) Thi(γ) = inf{R(x,y,z): x,y,z distinct points of γ}. *Quoted:* Litherland–Simon–Durumeric–Rawdon [30], Gonzalez–Maddocks [23], [12, Lemma 1.1].
- **Remark 2.3 (p. 9).** Thi ≥ 1 is closed under uniform convergence (three-point form).
- **Proposition 2.7 (p. 10–11) — The round circle is the tight unknot.** If γ is closed C^{1,1} with Thi ≥ 1 then Len(γ) ≥ 2π with equality iff γ is a round circle of radius 1; Rop(U)=2π and I(U) is a single point. Proof idea: Thi ≥ 1 ⇒ |κ| ≤ 1 a.e.; Len ≥ ∫|κ| ≥ 2π by Fenchel; equality case plane convex curve of constant curvature 1. *Proved here (elementary).*
- **Proposition 2.8 (p. 11) — A knotted rope needs 4π.** If Thi(γ) ≥ 1 and the knot type is nontrivial then Len(γ) > 4π ≈ 12.566; hence m_K > 4π for every nontrivial K. Proof idea: |κ| ≤ 1/Thi plus Fáry–Milnor (total curvature > 4π).
- **Remark 2.10 (p. 12).** Values 32.74 and 42.09 are outputs of constrained gradient descent [2]; not proofs; no nontrivial knot has a closed-form minimiser.
- **Theorem 2.11 (p. 12) — Cantarella–Kusner–Sullivan [12, Thm 2.9].** In every knot or link type there is a ropelength minimiser, and every minimiser is C^{1,1}; minimisers need not be C². *Quoted.*
- **Remark 2.12 (p. 12–13).** Several non-congruent critical configurations exist ([10]); whether distinct critical points can lie in different components of a sublevel is the Gordian-type question of §6.
- **Theorem 3.1 (p. 13) — Gramain [24].** For a nontrivial long knot f the class [G_f]∈π_1(K_f,f) of the rotation loop is nontrivial and remains nonzero in H_1(K_f). *Quoted.*
- **Theorem 3.2 (p. 14) — Hatcher [25].** The space of unknotted smooth circles in S³ deformation retracts onto the great circles, Gr_2(R⁴). *Quoted.*
- **Theorem 3.3 (p. 14) — Hatcher [26,27].** K⊂S³ knot, K_K(S³) its component: (i) nontrivial torus knot: homotopy type of SO(4)/G_K, G_K ⊇ a circle (stabiliser of standard placement on a Clifford torus); (ii) hyperbolic: SO(4)/Γ_K, Γ_K finite group of orientation-preserving isometries of S³∖K; (iii) satellite: (SO(4)×X_K)/Γ_K, X_K records non-rigid satellite parameters (torus factors in nested cases, configuration-space factors in general). *Quoted.*
- **Remark 3.4 (p. 15).** Hyperbolic/satellite cases needed a linearisation hypothesis, now a theorem by Dinkelbach–Leeb [16].
- **Theorem 3.5 (p. 15) — Hatcher, Budney [26,8].** Every component of the long-knot space K is aspherical and K_f ≃ * (f unknotted), S¹ (torus knot), S¹×S¹ (hyperbolic); general f via JSJ fibre bundles; K is a free little 2-cubes object on long prime knots [7]. *Quoted.*
- **Lemma 4.3 (p. 16) — Local tubular stability.** For γ∈Emb^∞(S¹,M) there exist a neighbourhood V_γ and constants r_γ>0, L_γ<∞ with Thi(η) ≥ r_γ and Len(η) ≤ L_γ for all η∈V_γ; Rop locally bounded. Proof idea: tubular neighbourhood theorem; C² nearby curves are normal graphs; curvature close; no doubly critical chord < 2r by a limiting argument.
- **Proposition 4.4 (p. 17) — Positive-reach version.** Conclusion of Lemma 4.3 holds for E_K(M) with the strong C^{1,1} topology.
- **Theorem 4.5 (p. 17) — Compact capture.** P compact, F: P→E_K(M) continuous ⇒ sup_p Rop(F(p)) < ∞, i.e. F(P)⊂E_{K,Λ}(M) for some finite Λ (also for the C^{1,1} space). Proof idea: finite subcover by neighbourhoods V_γ, r=min r_γ, L=max L_γ, Rop ≤ L/r. *Proved here (standard).*
- **Lemma 4.6 (p. 17) — Descent to open quotients.** G acts on X with open orbit map q, h: X→[0,∞) G-invariant and locally bounded ⇒ induced h̄ on X/G is locally bounded; every compact subset of X/G lies in one sublevel.
- **Theorem 4.8 (p. 18) — Homotopical exhaustion.** For every i ≥ 0, colim_{Λ→∞} Π_i^K(Λ) → π_i(E_K(M),γ_*) is an isomorphism (Π_i^K(Λ)=π_i(E_{K,Λ},γ_*), Λ ≥ Λ_*=Rop(γ_*)); holds for closed and strict sublevels and in the C^{1,1} model. Proof: surjectivity and injectivity by compact image in a single finite sublevel.
- **Corollary 4.9 (p. 18) — Homological exhaustion.** For every ring R and j ≥ 0, colim_Λ H_j(E_{K,Λ};R) ≅ H_j(E_K;R).
- **Corollary 4.10 (p. 18) — Telescope.** For cofinal Λ_* ≤ Λ_1<Λ_2<…→∞, Tel(E_{K,Λ_1}→E_{K,Λ_2}→…)→E_K(M) is a weak homotopy equivalence.
- **Corollary 4.11 (p. 18) — Quotient and Borel versions.** Thm 4.8, Cor. 4.9, 4.10 hold for U_K(M), K_K(M) and Borel constructions EG×_G E_{K,Λ} for compact Lie G acting by isometries.
- **Remark 4.12 (p. 19).** The exhaustion theorem is soft: holds for any locally bounded function.
- **Remark 4.13 (p. 19).** Inclusion of the smooth into the C^{1,1} sublevel at a fixed closed level is not known to be a weak equivalence (small smoothing may push ropelength across Λ); statements are for a fixed model or after right-relaxation (limit over Λ+ε); relative smoothing after positive budget relaxation for Euclidean strong parameterised families is proved in [34].
- **Proposition 5.2 (p. 20) — Width is a non-Archimedean seminorm.** For every i ≥ 1: (i) Λ_* ≤ w_i^K(α;γ_*) < ∞; (ii) w_i(1)=Λ_*; (iii) w_i(α^{-1})=w_i(α); (iv) w_i(αβ) ≤ max{w_i(α),w_i(β)}. Hence ℓ_i is a non-Archimedean group seminorm. Proof idea: constant map; concatenate/pinch; finiteness from Thm 4.8.
- **Theorem 5.4 (p. 21) — Isometry orbits have zero excess width.** G acts by isometries preserving E_K(M), γ_*∈E_K(M), orbit map o: g↦g∘γ_*, O=G·γ_*. Then Rop≡Λ_* on O and: (i) every class in im[o_*: π_i(G,e)→π_i(E_K,γ_*)] has excess width 0; (ii) if O→E_K(M) is surjective on π_i for some i ≥ 1 then w_i(α;γ_*)=Λ_* for every α, i.e. ℓ_i≡0 and σ_i(K;γ_*)=Λ_*. Proof idea: isometries preserve length and thickness.
- **Corollary 5.5 (p. 21) — The Gramain class costs no rope.** For a long knot f, w_1([G_f];f) = Rop_c(f), i.e. ℓ_1([G_f];f)=0; for nontrivial f the seminorm ℓ_1 on π_1(K_f,f) is not a norm. Proof: Gramain loop = orbit of the circle subgroup of SO(3)⊂SO(4) fixing the poles.
- **Remark 5.6 (p. 21).** Excess width could a priori have been a norm; it is not.
- **Theorem 5.8 (p. 22) — Vanishing of excess width.** If K⊂S³ is orbit realised by J_0 (Def. 5.7: SO(4)·J_0→K_K(S³) is π_i-surjective for all i ≥ 0), then for every i ≥ 1 and α∈π_i(K_K(S³),J_0): w_i(α;J_0)=Rop_{S³}(J_0), ℓ_i(α;J_0)=0, σ_i(K;J_0)=Rop_{S³}(J_0); so the persistent homotopy of the spherical filtration surjects onto its stable value at the single finite level Rop_{S³}(J_0), in every degree. Proof: Thm 5.4(ii) with G=SO(4).
- **Corollary 5.9 (p. 22).** Every nontrivial torus knot and hyperbolic knot in round S³ is orbit realised by a maximally symmetric placement; every stable positive-degree class has zero excess width at that basepoint.
- **Remark 5.10 (p. 22–23).** Stable excess widths vanish only for the round-sphere model at the orbit basepoint; transient classes and degree zero untouched.
- **Problem 5.11 (p. 23) — Satellite widths (OPEN).** For a satellite K and α from a non-isometric direction of Hatcher's X_K, compute/estimate its excess width in the round-sphere filtration; is it positive for some satellite?
- **Problem 5.12 (p. 23) — The first positive-degree phenomenon (OPEN).** Exhibit K, i ≥ 1 and α∈π_i(E_K(M)) with ℓ_i(α)>0, or prove excess widths vanish identically. "As of this writing, no example of a positive excess width is known in any degree i ≥ 1."
- **Corollary 5.14 (p. 23) — Finite death criterion.** A finite-level class a maps to the identity in π_i(E_K) iff d(a)<∞; if E_K is aspherical every finite-level class of degree i ≥ 2 has finite death level.
- **Corollary 5.15 (p. 23) — Transient higher homotopy of long knots.** For any long knot f and i ≥ 2 every class in π_i(K_{f,Λ},f) dies at a finite level. Proof: K_f is K(π,1) (Thm 3.5); Cor. 5.14, Thm 7.2.
- **Remark 5.16 (p. 24).** Homotopy persistence nonabelian in degree one; Thm 9.3 gives finite-rank homology maps across every gap but not pointwise finite-dimensionality or CW description at a closed level.
- **Proposition 6.2 (p. 25) — Exact-length retraction.** For every L ≥ m_K, P_L(K)→Y_L(K) is a strong deformation retract; two points of P_L(K) are joined by a path in Y_L(K) iff joined by a fixed-length thick isotopy in P_L(K). Proof idea: scale about the arclength centroid by s_t(γ)=(1−t)+tL/ℓ ≥ 1. *Proved here.*
- **Remark 6.3 (p. 25).** Justifies "physical isotopy" language only at the level of path components.
- **Theorem 6.5 (p. 26) — Compactness of normalised sublevels.** For every knot type K and finite Λ ≥ m_K, Y_Λ(K) is compact Hausdorff. Proof idea: centre at arclength centroid; diameter ≤ Λ/2; speed v=Len/2π with 1 ≤ v ≤ Λ/2π (Prop. 2.7); |κ|≤1 gives Lip(γ′) ≤ v² ≤ (Λ/2π)²; Arzelà–Ascoli in C¹; Thi ≥ 1 closed (Rem. 2.3); close thick curves are ambient isotopic [12, §2]; quotient by compact SO(3)×O(2). (Standard compactness mechanism, quotient statement isolated here.)
- **Remark 6.6 (p. 26).** Knot (not link) hypothesis essential: for a split link a sublink can drift to infinity, quotient not compact, merge levels need not be attained (Coward–Hass Gordian split link).
- **Lemma 6.7 (p. 26).** In a compact Hausdorff space components = quasicomponents; nested intersection of compact connected sets is compact connected.
- **Corollary 6.8 (p. 27) — Right continuity of connected components.** x,y∈Y_Λ(K) in the same connected component of Y_{Λ+ε}(K) for every ε>0 ⇒ same component of Y_Λ(K); equivalently Conn(Y_Λ)→lim_{ε>0} Conn(Y_{Λ+ε}) is injective.
- **Lemma 6.10 (p. 27) — Smoothing one positive-thickness knot.** A C^{1,1} embedding of positive thickness can be joined to a smooth embedding of the same type by a path along which length is bounded and thickness bounded away from zero (mollification).
- **Lemma 6.11 (p. 27–28) — Finiteness.** μ_K(x,y)<∞ for all x,y∈Y_∞(K).
- **Theorem 6.12 (p. 28) — The merge function.** For x,y,z∈Y_∞(K): (i) μ_K(x,x)=Len(x), μ_K(x,y)=μ_K(y,x)<∞; (ii) μ_K(x,z) ≤ max{μ_K(x,y),μ_K(y,z)}; (iii) (attainment) x and y lie in one connected component of Y_Λ(K) already for Λ=μ_K(x,y). Consequently on the ideal stratum d_K(A,B)=μ_K(A,B)−m_K is a finite-valued ultrametric on Conn(I(K)); d_K(A,B)=0 iff A=B. Proof idea: (i),(ii) formal; (iii) is Cor. 6.8 at Λ=μ_K(x,y). *Proved here (consequence of compactness).*
- **Corollary 6.13 (p. 28) — Positive attained barrier.** For distinct components A≠B of I(K), every path in Y_∞(K) from A to B attains length at least m_K+d_K(A,B)>m_K somewhere; at level m_K+d_K(A,B) the two lie in one connected component.
- **Remark 6.14 (p. 28–29).** Path merge: μ_K ≤ μ_K^path < ∞, strong triangle inequality by concatenation; μ_K^path is only a pseudo-ultrametric a priori; both issues vanish if sublevels locally path connected, which holds after small right relaxation (§6.6); attainment of the path infimum open (Rem. 6.27). Equivalent physical meaning via Prop. 6.2: x,y∈P_L(K) physically isotopic iff path connected in Y_L(K).
- **Remark 6.15 (p. 29).** Compactness supplies (iii) only; no path is manufactured.
- **Lemma 6.16 (p. 30) — Uniform interpolation.** There are δ_0>0 and C<∞ depending only on Λ such that if x,y∈Ȳ_Λ(K) satisfy ‖x−y‖_{C¹}<δ<δ_0 and z_τ=(1−τ)x+τy then for every τ∈[0,1]: Len(z_τ) ≤ max{Len(x),Len(y)} ≤ Λ and Thi(z_τ) ≥ 1−C√δ; z_τ is a C^{1,1} embedding of type K depending continuously on τ in C¹. Proof idea: three ranges of parameter distance ℓ ≤ √δ, √δ ≤ ℓ ≤ ρ, ℓ ≥ ρ, using the Federer form (6.1) and estimate (6.2).
- **Remark 6.17 (p. 31).** The three ranges are forced; exponent ½ not optimal; only Thi(z_τ) ≥ 1−η(δ), η→0 is used.
- **Theorem 6.18 (p. 31) — Local path connectivity after right relaxation.** For every finite Λ ≥ m_K and ε>0 there is δ>0 such that any two points of Y_Λ(K) at C¹-distance <δ are joined by a path in Y_{Λ+ε}(K). Proof idea: homothety path x→λx, scaled interpolation λz_τ, reverse homothety, λ=(1−C√δ)^{-1}.
- **Corollary 6.19 (p. 32).** x,y in one connected component of Y_Λ(K) ⇒ for every ε>0 in one path component of Y_{Λ+ε}(K).
- **Theorem 6.20 (p. 32) — Equality of the merge functions.** μ_K(x,y)=μ_K^path(x,y) for all x,y∈Y_∞(K). Proof: attained connected merge + Cor. 6.19; reverse inequality formal.
- **Corollary 6.21 (p. 32).** On Conn(I(K)), μ_K^path−m_K is a finite-valued ultrametric; path merge separates distinct connected components of the ideal stratum.
- **Corollary 6.22 (p. 32) — Finiteness, right-relaxed form.** For Λ′<Λ the images of Conn(Y_{Λ′})→Conn(Y_Λ) and π_0(Y_{Λ′})→π_0(Y_Λ) are finite.
- **Corollary 6.23 (p. 32) — Uniform finite-level merging of a fixed sublevel.** For every K and finite Λ ≥ m_K there is a finite L ≥ Λ with Y_Λ(K) contained in a single path component of Y_L(K); equivalently # im(π_0(Y_Λ)→π_0(Y_L)) = 1; in particular all of I(K) can be joined at a common finite level without assuming finitely many components. (Does not give an effective bound nor attainment, nor path connectedness of all of Y_L.)
- **Corollary 6.24 (p. 33).** The threshold at which two configurations become joinable by an admissible isotopy in the regularity class of [35] equals μ_K=μ_K^path.
- **Proposition 6.25 (p. 33) — Local path connectivity off the shell.** If x∈Y_Λ(K) with Len(x)<Λ then some C¹-neighbourhood of x in Y_Λ(K) consists of points joined to x by a path inside Y_Λ(K). Proof idea: path length of Thm 6.18 ≤ Λ once 2πδ+C√δΛ ≤ η (η=Λ−Len(x)).
- **Corollary 6.26 (p. 33).** The obstruction to local path connectivity of Y_Λ(K) is confined to the exact-length shell {Len=Λ}; if that shell is locally path connected then π_0(Y_Λ(K))=Conn(Y_Λ(K)) is finite and the path-merge infimum is attained.
- **Remark 6.27 (p. 33).** Thickness is an infimum of circumradii, upper semicontinuous and genuinely discontinuous (a circle of radius 2 is a C¹-limit of curves with small high-frequency wiggles of curvature 1 and Thi≡1), so Rop is only lower semicontinuous; closing Cor. 6.26 needs structure of critical configurations ([19], [40]).
- **Question 6.28 (p. 33–34) — Finiteness of connected components (OPEN).** Is Conn(Y_Λ(K)) finite for every K and finite Λ? (Compact spaces can have Cantor-set many components; Cor. 6.22 gives only the right-relaxed answer, so Λ→π_0(Y_Λ) is q-tame.)
- **Theorem 6.30 (p. 34) — The untying threshold.** (i) L ≤ u_c(x)=u_p(x)<∞, 0 ≤ e_c(x)=e_p(x)<∞. (ii) x and A_0 lie in one connected component of Y_{u_c(x)}(K). (iii) Every path from x to A_0 has peak length ≥ u_p(x), and for every ε>0 there is such a path in Y_{u_p(x)+ε}(K). (iv) If e_c(x)>0 then x is Gordian at length L and every sublevel path from x to A_0 reaches length ≥ L+e_c(x). (v) If e_c(x)=0 then x and A_0 lie in one component of Y_L(K) and are joined by a path in Y_{L+ε}(K) for every ε>0; whether x is Gordian at length L is exactly whether the path threshold is attained. *Proved here (consequence of Thm 6.12, 6.20).*
- **Remark 6.31 (p. 35) — State of the art, model by model.** Gordian results: Coward–Hass [13] Gordian split link (fixed-length thick link isotopy); Kusner–Kusner [29] Gordian pair under total-length constraint; Ayala–Hass [4] infinite families of Gordian unlinks; Bauermeister [5] Gehring ropelength (length trading allowed); Ayala [3] Gordian unknots in the thinner model U_1 (standard thick model here = U_2; saturated case τ=2 qualitatively different). A rigorous x path-separated from the round target in Y_{Len(x)}(U) would settle Problem 10.11. (Quoted.)
- **Proposition 6.32 (p. 36) — Mirror involution.** For a reflection r of R³, τ_Λ([γ])=[r∘γ] is a well-defined homeomorphism of Y_Λ(K), compatible with sublevel inclusions; for amphichiral K it is an involution of the whole filtration and of I(K), so {Y_Λ(K)} is a filtered Z/2-space.
- **Corollary 6.34 (p. 36) — Mirror barrier criterion.** If A≠τA then 0<d_K^mir(A)<∞ and the barrier is attained. "What nobody can currently do is exhibit an amphichiral knot type with a mirror-nonfixed ideal component."
- **Problem 6.35 (p. 37) — Figure-eight mirror separation (OPEN).** Is there a connected component A⊂I(4_1) with A≠τA? (A positive answer would give the first continuum ropelength barrier for a knot; stronger than non-congruence of one numerical tight configuration to its mirror.)
- **Theorem 7.1 (p. 38) — Persistent recovery of Hatcher's knot space.** For every i ≥ 0, colim_Λ π_i(K_{K,Λ}(S³)) ≅ π_i(K_K(S³)), and for cofinal levels hocolim K_{K,Λ}→K_K(S³) is a weak homotopy equivalence (Cor. 4.10, 4.11). For torus/hyperbolic K: colim_Λ π_i ≅ π_i(SO(4)/H_K), H_K stabiliser; stable groups hit already at the finite level Rop_{S³}(J_0).
- **Theorem 7.2 (p. 38) — Long-knot exhaustion.** For every long knot f and i ≥ 0: colim_Λ π_i(K_{f,Λ},f) ≅ π_i(K_f,f). No uniform bound on birth/death levels of transient classes asserted.
- **Theorem 7.3 (p. 39) — Pole bundle.** π: P(K)→K_K(S³), (J,p)↦J is a locally trivial fibre bundle with fibre the knot complement S³∖K, hence a Serre fibration. Proof: isotopy extension on a small normal-graph neighbourhood.
- **Theorem 7.4 (p. 39) — Pole-space exhaustion.** Every compact subset of P(K) lies in P_Λ(K) for some finite Λ; colim_Λ π_i(P_Λ(K))≅π_i(P(K)), likewise homology and telescopes.
- **Remark 7.5 (p. 39).** P(K) makes the complement topology visible; natural place to look for the satellite phenomena of Problem 5.11.
- **Lemma 9.1 (p. 40) — Compactness and short chords.** X_a is compact; for γ∈X_a, circular parameter distance h ≤ 1/a: |γ(s+h)−γ(s)| ≥ h−ah²/2 ≥ h/2; for 0<h_0 ≤ min(1/4,1/a) chords with parameter separation ≥ h_0 have length ≥ h_0/2.
- **Lemma 9.2 (p. 40) — Uniform finite convex interpolation.** Given a<b there is δ>0 such that for any finite family γ_0,…,γ_m∈X_a with ‖γ_i−γ_0‖_{C¹}<δ every convex combination z=Σt_iγ_i is a regular embedding of type K and N(z)∈X_b; δ independent of m.
- **Theorem 9.3 (p. 41) — Finite factorization across a positive gap.** For a<b the inclusion X_a→X_b factors up to homotopy through a finite simplicial complex; hence over every field the persistence module H_q(X_a) is q-tame in every degree q ≥ 0: every map across a strictly positive parameter gap has finite rank. Proof idea: finite cover by C¹ balls radius ρ=δ/2, nerve P, f(x)=Σφ_i(x)e_i, g(Σt_ie_i)=N(Σt_ix_i); homotopy (x,t)↦N((1−t)x+tΣφ_i(x)x_i). *Proved here (marked C¹ model only).*
- **Remark 9.4 (p. 41).** Nerve factorization is a standard device; ropelength-specific input is Lemma 9.2.
- **Corollary 9.5 (p. 41) — Additional continuous resources.** On the marked model with finitely many C¹-continuous resource inequalities Φ_j ≤ c_j, inclusion across a positive ropelength gap and positive gaps in each bound factors through a finite complex; strict sublevels have finite-rank maps across such gaps. (Also: the marked thickness-≥1, length-≤a, constant-speed, zero-centroid model has the same homology persistence as X_a; not an isometry for swept-area costs; no equivariant/Borel tameness claimed, p. 41–42.)
- **Remark 9.6 (p. 42).** Planar polar curves radius 1+n^{-3}cos(n²θ) converge in C¹ to the unit circle but curvature unbounded and ropelengths diverge, so a weakly compact family need not lie in one sublevel.
- **§9.1–9.4 unnumbered results (p. 42–44):** (§9.1) diagonal coalgebra on H_0 recovers the set of path components and transition maps (not connected components); barcodes forget incidence: two 4-leaf trees (leaves a,b,c,d births 0,1,2,3; merges (a,b)@4,(c,d)@5,(pairs)@6 versus (a,b)@4,(ab,d)@5,(+c)@6) have identical bars [0,∞),[1,4),[3,5),[2,6) but different final splits 2+2 vs 3+1. (§9.2) finite terminal core: if exhausted Z has compact capture and finite CW homotopy type, a single finite level surjects onto all terminal homology (and homotopy); not an equivalence. (§9.3) fixed non-split link type: normalised weak sublevel compact; split link: factors can be translated apart, noncompact; entry length of a split union = sum of factor entry lengths; any proved factor excess barrier transfers to the split union (conditional, no new explicit example). (§9.4) pole-gauge invariance R(J,p) under Möbius transport; if orbit inclusion SO(4)/G_K→K_K(S³) is a homotopy equivalence, SO(4)×_{G_K}E_K→P(K) is a homotopy equivalence with image at finite level max_{p∈E_K}R(K,p) (placement-dependent, no uniform bound); essential homology persistence of a finite-CW terminal space with compact capture is finitely many right-infinite intervals.
- **Problems (p. 44–46), all OPEN:**
  - **Problem 10.1 (p. 44) — The unknot just above the minimum.** Describe Y_Λ(U) for Λ slightly >2π: contractible? connected for all Λ? finite Conn/π_0? A complete answer for Λ ≤ 2π+ε would be the first computation of a non-minimal ropelength sublevel.
  - **Problem 10.2 (p. 44).** Compute numerically the path min–max profile (Figure 14) for explicit unknotted thick configurations (doubled loop, coiled configuration, configurations of [36]); estimate u_p(x); seek rigorous lower bounds for u_c(x)=u_p(x); numerical evidence that e_p(x)>0 with rigorous error analysis would be substantial.
  - **Problem 10.3 (p. 44).** Compile a table of best current ropelength bounds and numerical values for small crossing number knots in one normalisation with sources/error estimates ("literature currently mixes the radius and diameter conventions").
  - **Problem 10.4 (p. 44).** For amphichiral K determine the induced Z/2-action on π_0(Y_Λ(K)) and H_*(Y_Λ(K);Z/2); level at which it becomes trivial.
  - **Problem 10.5 (p. 44–45) — Attainment in positive degree.** Is the infimum defining w_i^K(α;γ_*) attained? Equivalently a compactness statement for spaces of thick families analogous to Thm 6.5?
  - **Problem 10.6 (p. 45) — Tameness.** Are Y_Λ(K) locally path connected (connected = path components)? CW homotopy type of Y_Λ or E_{K,Λ}? pointwise finite-dimensional persistent homology? (Semialgebraic polygonal approximation suggested.)
  - **Remark 10.7 (p. 45).** Paths in Thm 6.18 are finite concatenations of scaling/interpolation; Lipschitz endpoint connections after right relaxation; no claim about preserving swept-area cost.
  - **Problem 10.8 (p. 45) — Produce a transient class.** Exhibit a nonzero class in π_i(K_{f,Λ}), i ≥ 2 (a sphere of thick long knots that cannot be filled within its own budget).
  - **Problem 10.9 (p. 45).** = Problem 5.11 (satellite widths); first place where Thm 5.8 does not apply.
  - **Problem 10.10 (p. 45).** Compare round S³, Euclidean normalised and pole-marked filtrations; explicit interleavings or conformal gauges.
  - **Problem 10.11 (p. 45) — A standard thick Gordian knot.** Find K (possibly U) and x of length L not path connected in Y_L(K) to a chosen tight target A_0; stronger: prove u_c(x)=u_p(x)>L.
  - **Problem 10.12 (p. 45) — Disconnected ideal strata.** Prove Conn(I(K)) has more than one element for some K, or that I(K) is always connected.
  - **Remark 10.13 (p. 45).** Continuum mirror separation is Problem 6.35; discrete comparisons in [33].
  - **Problem 10.14 (p. 46).** = Problem 5.12.

## Key equations and quantitative claims outside numbered statements
- p. 11 (elementary, rigorous): Rop(U)=2π; Rop(K)>4π≈12.566 for nontrivial K.
- p. 12 / Fig. 5 (benchmarks, radius convention): 21.45 [12] (CKS 2002 lower bound, dashed, valid for all nontrivial knots); 31.32 [14] (DDS 2006 lower bound, dashed); 32.74 for 3_1 and 42.09 for 4_1 (numerical, from [2]; tabulation reproduced in [39]). "The gap between 31.32 and 32.74 is about 4.5%: the general lower bound is already very close to the trefoil's value." Only 2π is an exact knot-type value. The nontrivial-knot lower-bound marks are rigorous; trefoil and figure-eight marks numerical.
- p. 6 (intro (D), quoted from companion [33], discrete, move-system specific, certified): complete simple-cubic BFACF minimal-layer merge trees 4→1 for 4_1 at levels 30, 32 and 12→2→1 for 6_3 at levels 40, 42, 44; the two level-42 branches are mirror images and disjoint until N=44. "We use these only as finite benchmarks: no lattice-to-continuum implication is claimed." (also p. 8 Table 1, p. 37.) No lattice sizes/run times in this paper.
- p. 37: lattice edge number and Euclidean ropelength "are different resources"; no continuum barrier follows without controlled comparison maps.
- p. 6 (E, quoted from [35]): swept-area cost on admissible paths is an extended metric (not only pseudometric), finite on each admissible component, monotone in budget, bounded below by a Euclidean-orbit flat-current distance; projected-area-vector calibration gives a quotient-safe lower bound; the level at which the cost first becomes finite equals the path merge threshold (§6.7); no convergence of minimal costs asserted.
- p. 30 (Lemma 6.16 constants): Thi(z_τ) ≥ 1−C√δ, C depending only on Λ (non-sharp exponent).
- p. 25 (Prop. 6.2 proof): s_t(γ)=(1−t)+t(L/ℓ).
- p. 20: classes of width via min–max; Fig. 10.

## Methods / algorithms
Pure-math paper; proof strategy (terse):
1. (§2–3) Fix thickness/ropelength conventions (radius), thickness formula, elementary bounds 2π and 4π, existence/regularity of minimisers, and the Hatcher–Budney terminal homotopy types.
2. (§4) Local tubular stability (Lemma 4.3) ⇒ compact capture (Thm 4.5) ⇒ homotopical/homological exhaustion and telescope (Thm 4.8, Cor. 4.9–4.11).
3. (§5) Define widths/death levels; symmetry argument (isometry orbits at constant ropelength) ⇒ vanishing of stable excess width for orbit-realised knots (Thm 5.4, 5.8).
4. (§6) Normalised model Y_Λ(K): compactness via Arzelà–Ascoli (Thm 6.5) ⇒ right continuity (Cor. 6.8) ⇒ attained connected merge, ultrametric (Thm 6.12); exact-length retraction by scaling (Prop. 6.2); uniform straight-line interpolation + homothety (Lemma 6.16, Thm 6.18) ⇒ path merge = connected merge (Thm 6.20) and finite merging of a fixed sublevel (Cor. 6.23); untying threshold (Thm 6.30); mirror involution (Prop. 6.32).
5. (§7) Bridges: round S³ (Thm 7.1), long knots by compactification (Thm 7.2), pole-marked complement bundle (Thm 7.3–7.4).
6. (§9) Marked weak model X_a: compactness (Lemma 9.1), convex interpolation (Lemma 9.2), nerve factorization ⇒ q-tameness (Thm 9.3).

## Tables
**Table 1 (p. 8)** — Scope and provenance. The distinction between connected and path components is deliberately visible: it is mathematically essential in degree zero.

| Statement | Status |
|---|---|
| Existence and C^{1,1} regularity of ropelength minimisers | Standard; Cantarella–Kusner–Sullivan [12], with related formulations in [23, 40]. |
| Compactness of {Thi ≥ 1, Len ≤ Λ}/∼ (theorem 6.5) | The analytic compactness mechanism is standard in ropelength theory; we isolate the quotient statement needed for the filtration. |
| Compact capture and exhaustion (theorems 4.5 and 4.8) | Elementary consequence of local tubular stability and compactness of the parameter space; included because it is the bridge to knot-space topology. |
| Exact-length retraction (proposition 6.2) | Proposition proved here. It identifies path connectivity of Y_L(K) with fixed-length physical isotopy. |
| Right continuity of connected components and attained connected merge (corollary 6.8 and theorem 6.12) | Consequences of compactness, isolated here in the form needed for ropelength filtrations. |
| Path merge and physical Gordian behaviour (remark 6.14 and theorem 6.30) | Path merge is the min–max budget for actual paths. At a fixed level, path connectivity agrees with fixed-length physical isotopy. Equality with connected merge is proved in theorem 6.20; attainment of the path infimum remains open. |
| Swept-area metric on admissible components | Companion result [35]: the infimal swept area of regularity-restricted admissible isotopies defines a genuine extended metric, finite on each admissible component, with current-theoretic and projected-area lower bounds. Right-relaxed endpoint thresholds agree by theorems 6.18 and 6.20; convergence of costs is a separate question. |
| Gordian phenomena | Rigorous for several link models [13, 29, 4, 5]. Ayala [3] proves Gordian unknots in a thinner model U_1; this does not by itself settle the standard thick model used here. |
| Width and isometry-orbit vanishing (proposition 5.2 and theorem 5.4) | Formal once compact capture is known. |
| Stable width for torus and hyperbolic knot spaces (theorem 5.8) | Consequence of Hatcher's orbit models [27, 26]; scoped to the round S³ model and an orbit basepoint. |
| Discrete minimal-layer BFACF merge trees for 4_1 and 6_3 | Certified companion computation [33]: 4→1 at 30, 32 and 12→2→1 at 40, 42, 44; discrete and move-system specific. |
| Marked weak model: finite factorization, q-tameness (theorem 9.3) | Proved here; standard nerve device, new input lemma 9.2; marked C¹ model only. |
| Continuum figure-eight mirror separation | Open (problem 6.35). |
| Higher Reidemeister–Cerf comparison | Programmatic. Classical one-parameter transversality is supported by Queffelec [37]; the filtered higher comparison remains a separate relative-genericity problem in [34]. |

**Table 2 (p. 15)** — The terminal homotopy types, from theorems 3.2, 3.3 and 3.5. These are the Λ → ∞ limits of everything computed in this paper.

| knot type | K_K(S³) | K_f (long) |
|---|---|---|
| unknot | ≃ Gr_2(R⁴) | ≃ * |
| torus knot | ≃ SO(4)/G_K, dim = 5 | ≃ S¹ |
| hyperbolic knot | ≃ SO(4)/Γ_K, Γ_K finite | ≃ S¹×S¹ |
| satellite knot | ≃ (SO(4)×X_K)/Γ_K, X_K from JSJ data | bundle-theoretic |

**Table 3 (p. 24)** — The dictionary used throughout the paper.

| geometric side | topological side |
|---|---|
| rope budget Λ | sublevel E_{K,Λ} or Y_Λ(K) |
| tight (ideal) configurations | the minimum level set I(K)=Y_{m_K}(K) |
| two configurations cannot be connected within budget | they lie in different components of Y_Λ(K) |
| level at which connected components merge | connected merge height μ_K |
| min–max budget for an actual connecting path | path merge μ_K^path |
| extra rope needed to perform a cyclic motion | excess width ℓ_1 |
| a family of motions that only exists with slack | a class born at a finite level |
| slack that becomes unnecessary | a class with finite death level |
| budget above which nothing new appears | stabilisation level σ_i(K) |

**Table 4 (p. 29)** — Two degree-zero merge notions. They agree as numbers (theorem 6.20); keeping them separate is still useful, because the left column has the better compactness theorem and only its infimum is known to be attained.

| | connected merge μ_K | path merge μ_K^path |
|---|---|---|
| Meaning | topology of compact sublevels | deformation paths / min–max budget |
| Finite? | yes | yes |
| Strong triangle inequality? | yes | yes |
| Infimum attained? | yes | not known in general |
| Separates components at zero excess? | yes, for connected ideal components | yes (corollary 6.21) |
| Relation | μ_K = μ_K^path (theorem 6.20); only the left infimum is known to be attained. | |

(Appendix A p. 47 is a notation list, not a data table; the numerical benchmark values are given in Fig. 5.)

## Figures
- **Fig. 1 (p. 4)** — "Left: thickness is the radius of the largest embedded tube. Right: the standard thick-unknot question; the middle picture is a three-crossing diagram of the unknot. Can every unknotted unit-thickness configuration be carried to the round configuration by a fixed-length physical isotopy?…" *Shows:* core curve in a tube with radius Thi; a tangled unknotted rope and the round circle.
- **Fig. 2 (p. 5)** — "Ropelength persistence in one picture…" *Shows:* sketch of the space of thick configurations (horizontal) against length (vertical), levels Λ_1<Λ_2<Λ_3, local minima A,B,C, sublevel Y_{Λ_2}(K) with two components. Image: ../figures/Ozawa26rope/p05.png
- **Fig. 3 (p. 10)** — Two obstructions to thickness: (a) too sharp a bend (ρ<r), (b) two strands too close (dcsd<2r).
- **Fig. 4 (p. 11)** — Ropelength scale invariance: circle with Len=2π, Thi=1 and with Len=4π, Thi=2, both Rop=2π.
- **Fig. 5 (p. 12)** — "The ropelength number line, in the radius convention of convention 2.6. Dashed marks are proved lower bounds valid for every nontrivial knot; solid marks are values of specific knot types. The gap between 31.32 and 32.74 is about 4.5%… Numerical values are from [2]; the tabulation used here is the one reproduced in [39]." *Shows:* axis 0–45 with marks 2π (unknot, solid), 4π (Fáry–Milnor, dashed), 21.45 [12], 31.32 [14] (dashed), 32.74 (3_1), 42.09 (4_1). Image: ../figures/Ozawa26rope/p12.png
- **Fig. 6–7 (p. 14)** — Space of knots schematic (components E_U, E_{3_1}, E_{4_1}); Gramain loop (rotations t=0°,60°,120°,180°), lies in one ropelength level set.
- **Fig. 7 (p. 14)** — "The Gramain loop: spin a long knot once about its axis." (per-figure entry added 2026-11-12 from the caption text layer, PDF p. 14.)
- **Fig. 8 (p. 18)** — Compact capture: finitely many neighbourhoods V_{γ_j} cover compact F(P). **Fig. 9 (p. 19)** — mapping telescope E_{K,Λ_1}→E_{K,Λ_2}→… ≃_w E_K. **Fig. 10 (p. 20)** — width as min–max peak ropelength; excess width ℓ_i=w_i−Λ_*. **Fig. 11 (p. 22)** — orbit SO(4)·J_0 is one level set of Rop_{S³}.
- **Fig. 12 (p. 24)** — "The picture the invariants are trying to draw: classes that survive to the limit have a birth level (their width) and no death; transient classes have both. The stabilisation level σ_i(K) is the largest birth level of a stable class…" *Shows:* bars against Λ: two stable bars reaching Λ→∞, two transient bars; marks m_K, σ_i(K). Heuristic. Image: ../figures/Ozawa26rope/p24.png
- **Fig. 13 (p. 30)** — Merge dendrogram: leaves A,B,C,D of I(K) merging as budget rises; ultrametric triangle (isosceles, two equal sides longest). Image: ../figures/Ozawa26rope/p30.png
- **Fig. 14 (p. 35)** — Untying threshold: length vs deformation parameter, x at length L, target A_0, common value u_c=u_p; illustrative profiles (peak not known attained). Image: ../figures/Ozawa26rope/p35.png
- **Fig. 15 (p. 36)** — Schematic mechanism of Gordian phenomena (strand threaded through a tight ring; caricature of [13]). **Fig. 16 (p. 37)** — Mirror involution τ on Y_Λ(K), components A and τA with barrier d^mir_K(A)>0. **Fig. 17 (p. 39)** — pole-marked space P(K)→K_K(S³) with fibre S³∖K. **Fig. 18 (p. 46)** — organising diagram: finite thick-knot geometry → ropelength-filtered persistent homotopy → Λ→∞ Hatcher–Budney homotopy type (right arrow theorem 4.8; left arrow is where open problems live).

## Stated limitations, open problems, future work
- p. 7: Table 1 and §1.4 delineate standard / proved / open; "compact knot sublevels the quantity with the cleanest attainment theorem is the connected merge, not the path merge".
- p. 19: smooth vs C^{1,1} sublevel equivalence at a fixed closed level not resolved (Remark 4.13).
- p. 29, 33: attainment of the path-merge infimum open; obstruction confined to exact-length shell (Cor. 6.26, Remark 6.27).
- p. 24, 45: tameness only across positive gaps in marked weak model; pointwise finite-dimensionality, CW description, coarse/Borel quotient models not proved (Remark 5.16, Problem 10.6).
- p. 37: continuum figure-eight mirror separation open (Problem 6.35); lattice benchmarks give no continuum implication.
- p. 23: no positive excess width known in any degree i ≥ 1 (Problem 5.12); stable vanishing only for orbit-realised (torus, hyperbolic) knots in the round S³ model; transient classes possible (Remark 5.10).
- p. 35: Ayala's Gordian unknots are in the thinner model U_1, not the standard thick model; standard thick Gordian knot open (Problem 10.11).
- p. 43, 42: conditional statements (split-link barrier transfer; no uniform or computable bound on finite level max R(K,p)).
- Open: Question 6.28, Problems 5.11, 5.12, 6.35, 10.1–10.6, 10.8, 10.10–10.12 (and 10.9, 10.14 as repeats).

## References worth following
- [12] Cantarella, Kusner, Sullivan, On the minimum ropelength of knots and links, Invent. Math. 150 (2002) (existence/regularity, 21.45 bound, thickness formula).
- [14] Denne, Diao, Sullivan, Quadrisecants give new lower bounds for the ropelength of a knot, Geom. Topol. 10 (2006) (31.32 bound).
- [2] Ashton, Cantarella, Piatek, Rawdon, Knot tightening by constrained gradient descent, Experiment. Math. 20 (2011); [39] Klotz, Anderson, Ropelength and writhe quantization of 12-crossing knots, arXiv:2305.17204 (numerical 32.74, 42.09).
- [33] Ozawa, Merge Trees of Length-Filtered Lattice Knot Spaces, arXiv:2605.25322 (= Ozawa26merge); [34] Ozawa, Ropelength-Filtered Reidemeister Graphs, arXiv:2605.03350; [35] Ozawa, Ropelength-Filtered Swept-Area Geometry, arXiv:2605.05557.
- [26] Hatcher, Spaces of knots, arXiv:math/9909095; [27] Hatcher, Topological moduli spaces of knots (unpublished 2002); [25] Hatcher, A proof of the Smale conjecture (1983); [8] Budney, Topology of knot spaces in dimension 3 (2010); [24] Gramain (1977).
- [13] Coward, Hass, Topological and physical link theory are distinct (2015); [3] Ayala, Geometric constraints in link isotopy, arXiv:2506.04442; [4] Ayala–Hass, Gordian unlinks, arXiv:2502.08499; [29] Kusner–Kusner (2023); [36] Pieranski–Przybył–Stasiak, Gordian unknots.
- [10] Cantarella, Ellis, Fu, Mastin, Symmetric criticality for tight knots (2014); [30] Litherland–Simon–Durumeric–Rawdon, Thickness of knots (1999); [23] Gonzalez–Maddocks (1999).

## Extraction notes
- Pages rendered: 5, 8, 12, 15, 24, 29, 30, 35. Tables 1–4 verified against page images (p. 8, 15, 24, 29). Fig. 5 values read from image.
- Text layer garbles some formulas (Lemma 6.16, Thm 6.5 proof, Lemma 9.2 proof); statement-level content cross-checked, internal estimate constants not independently verified.
- ⚠ Three different titles for arXiv:2605.25322 across the series: here [33] "Merge Trees of Length-Filtered Lattice Knot Spaces"; Ozawa26density [16] "Merge trees of lattice knots"; Ozawa26geom [17] "Discrete knot theory via lattice-filtered move graphs". Likewise the ropelength paper itself appears in Ozawa26geom [16] as "The ideal stratum and deformation persistence of knot types" (arXiv:2604.17905), while its own title is "Ropelength-filtered knot spaces".
- The paper makes no claims about densities, compression radii or lattice computations beyond quoting [33]; the quoted merge levels (30/32; 40/42/44) agree with Ozawa26density and Ozawa26geom.
- Page 7 (intro (F) ending, §1.4 intro) says "The table also suggests a hierarchy"; the table is Table 1 on p. 8 (placed after the text). Sections 1.1–1.2 rationale paragraphs not transcribed beyond the statements above.
- Beginner's notes (Remarks 2.3, 2.4, 2.9) summarised; no further numerical content.
