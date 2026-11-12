# ACPR10 — Knot Tightening by Constrained Gradient Descent
- **Authors:** Ted Ashton, Jason Cantarella, Michael Piatek, Eric Rawdon
- **Venue / year / identifiers:** arXiv:1002.1723v1 [math.DG], 8 Feb 2010; printed "Date: June 12, 2004; Revised: November 18, 2018" (published Experimental Mathematics 20(1) (2011) 57–90, as cited in CRSS25 ref [4]; not printed on this file). Software: `ridgerunner` (minimiser), `octrope` (strut finder), `tsnnls`, `roundout_rl` (smooth upper bounds).
- **File:** papers/2_algorithms/Ashton-Cantarella-Piatek-Rawdon_2010_Knot_tightening_gradient_descent_1002.1723.pdf   **Pages:** 45
- **Text layer:** ok for prose; formulas partly garbled (checked on images pp. 6, 7, 17, 18, 24, 38, 43); tables: names lose super/subscript order (see notes), numbers fine and cross-checked.

## Abstract
We present new computations of approximately length-minimizing polygons with fixed thickness. These curves model the centerlines of "tight" knotted tubes with minimal length and fixed circular cross-section. Our curves approximately minimize the ropelength (or quotient of length and thickness) for polygons in their knot types. While previous authors have minimized ropelength for polygons using simulated annealing, the new idea in our code is to minimize length over the set of polygons of thickness at least one using a version of constrained gradient descent.
We rewrite the problem in terms of minimizing the length of the polygon subject to an infinite family of differentiable constraint functions. We prove that the polyhedral cone of variations of a polygon of thickness one which do not decrease thickness to first order is finitely generated, and give an explicit set of generators. Using this cone we give a first-order minimization procedure and a Karush-Kuhn-Tucker criterion for polygonal ropelength criticality.
Our main numerical contribution is a set of 379 almost-critical knots and links, including all prime knots with ten and fewer crossings and all prime links with nine and fewer crossings. For links, these are the first published ropelength figures, and for knots they improve on existing figures. We give new maps of the self-contacts of these knots and links, and discover some highly symmetric tight knots with particularly simple looking self-contact maps.

## Notation and conventions
- **Ropelength convention: LENGTH / RADIUS.** Def. 1.2 (p. 2): "The ropelength of a curve γ is defined by Rop(γ) = Len(γ)/Thi(γ)." Thickness (p. 2): "the supremal ε for which any point in an ε-neighborhood of γ has a unique nearest neighbor on the curve" = (Prop. 1.1, [33]) the supremal radius of embedded tubes of uniform radius around γ. So thickness is a radius: trefoil value 32.74 ⇒ length/radius (matches CKS01's convention); the unit-thickness curve has tube radius 1. **However** (p. 28): "for technical reasons, our minimized configurations have thickness close to 1/2 (rather than 1, as in the discussion above), and hence their maximum curvature is 2" (also kink curvature range κ up to ≈2.0 in Atlas pages, p. 36–37, and Fig. 13). Reported Rop values are the scale-invariant ratio Len/Thi regardless.
- Thickness characterisation (Thm 1.3 [33], p. 2): Thi(γ) = min{ min_s 1/κ(s), min_{(s,t)∈dcsd(γ)} d(s,t)/2 } where d(s,t) = |γ(s) − γ(t)| and dcsd(γ) = doubly critical self-distances = critical points of d with s ≠ t, i.e. ⟨γ(s)−γ(t), γ'(s)⟩ = 0 = ⟨γ(s)−γ(t), γ'(t)⟩. (Federer's "reach", footnote p. 2.)
- Polygon V = (v_1,…,v_V) ∈ R^{3V}, edges e_i, indices mod V; turning angle θ_i at v_i.
- **Def. 2.1 (p. 6) MinRad(v_i)** = radius of the unique circle tangent to the two edges meeting at v_i that touches the midpoint of the shorter one. Eq. (1): min{|e_{i−1}|,|e_i|}/(2 tan(θ_i/2)) = min{ |e_{i−1}|/(2 tan(θ_i/2)), |e_i|/(2 tan(θ_i/2)) } = min{MinRad^−(v_i), MinRad^+(v_i)} (Rawdon [44]). MinRad^± are differentiable where defined.
- **Def. 2.2 dcsd(V)**: set of (p,q) on V with p ≠ q which are local minima of the self-distance function (cases: edge–edge, vertex–edge, vertex–vertex; Fig. 3).
- **Def. 2.3 polygonal thickness** Thi_p(V) := min{ min_i MinRad(v_i), min_{(p,q)∈dcsd(V)} d(p,q)/2 } (Rawdon).
- **Def. 2.4:** θ(τ,ℓ) = turning angle of a pair of edges of length ℓ with MinRad = τ; θ(τ,ℓ) = 2 arctan(ℓ/2τ). VB(τ,ℓ) = {(p,q) ∈ V×V : vb(p,q) ≥ π/θ(τ,ℓ)}, vb(p,q) = smaller number of vertices between p and q (counting p and/or q if vertices) on the same component, ∞ otherwise.
- **Def. 2.5 (τ,ℓ)-constraint thickness** CThi(τ,ℓ,V) = min{ min_i MinRad(v_i)/τ, min_{(p,q)∈VB(τ,ℓ)} d(p,q)/2 }; τ = "stiffness"; only τ = 1 used, CThi(ℓ,V) := CThi(1,ℓ,V). V need not be equilateral to define CThi.
- **Def. 2.9 Strut set** Strut(V) = pairs (p,q) in VB(1,ℓ) with d(p,q)/2 = 1 and either an isolated local minimum of d, or an endpoint of a family of local minima (then a vertex–edge pair joining two parallel edges). **Def. 2.10 Kink set** Kink(V) = {(v_i, ±) : MinRad^±(v_i) = 1}. Both empty if CThi > 1.
- Variation W ∈ R^{3V}; V_t = V + tW (Eq. 7). **Def. 2.12:** if CThi(ℓ,V) = 1, W is an infinitesimal motion if D_W CThi(ℓ,V) ≥ 0 (Eq. 10); if CThi > 1, every W is. I(V) = cone of infinitesimal motions. **Def. 2.14:** R(V) = cone of resolvable motions generated by −∇(d(p,q)/2) for (p,q) ∈ Strut(V) and −∇MinRad^±(v_j) for (v_j,±) ∈ Kink(V) (Eq. 11, with nonnegative coefficients λ_i², λ_j²). **Def. 2.15:** constrained gradient (−∇f)_I = closest vector in I(V) to −∇f.
- **Def. 2.17 thickness-critical for minimising f:** either D_W f = 0 (for all W), or CThi(ℓ,V) = 1 and every W with D_W f < 0 has D_W CThi < 0. **Def. 2.19:** V is constraint-qualified (Mangasarian–Fromovitz) if there is W with D_W CThi > 0.
- **Def. 3.1 rigidity matrix** A (CThi = 1): columns are −∇(d(p,q)/2) for (p,q) ∈ Strut(V) and −∇MinRad^±(v_i) for (v_i,±) ∈ Kink(V).
- Link names (p. 35): "the link X^z_y being the z-th example of a prime X-crossing link of y components in the table" — ⚠ printed text says "Xzy" in the layer but the table images show X^c_i with **c = number of components (superscript) and i = index (subscript)**, e.g. 6^3_2 = Borromean rings (3 components). Rolfsen numbering; Perko pair 10_161 and 10_162 identified, later knots renumbered, so only **165** ten-crossing knots (p. 35). Knots have c=1 (written X_i).
- Resolution: "vertices per unit of ropelength" (p. 18); Rop_p = polygonal ropelength Len(V)/Thi_p(V) (measured by octrope), Rop = upper bound for the smooth ropelength obtained by splicing circle arcs of radius MinRad into the corners (roundout_rl) (p. 25–26).
- Residual = ‖(−∇f)_I‖ / ‖−∇f‖ (relative constrained gradient) (p. 26).

## Numbered statements
- **Proposition 1.1 (p. 2), quoted from [33].** If γ is a C¹ curve, then the thickness Thi(γ) is given by the supremal radius of all embedded tubes formed by taking the union of disks of uniform radius centered on γ(s) in the planes normal to γ'(s).
- **Definition 1.2 (p. 2).** Rop(γ) = Len(γ)/Thi(γ); Rop(L) = minimal ropelength over curves in knot/link type L.
- **Theorem 1.3 (p. 2), quoted from [33].** Thi(γ) = min{ min_s 1/κ(s), min_{(s,t)∈dcsd(γ)} d(s,t)/2 }. (Also "any curve with nonzero thickness is C^{1,1}" [22, 11], p. 2.)
- **Theorem 2.6 (p. 8), proved here.** If V is an equilateral polygon of edgelength ℓ, then Thi_p(V) ≥ 1 ⇔ CThi(ℓ,V) ≥ 1.
  Proof idea: via Lemma 2.7 dcsd ⊂ VB; the boundary case uses Schur's theorem to compare with a planar arc with turning angles θ(1,ℓ) and n = ⌈π/θ(1,ℓ)⌉ edges, which has an inscribed unit circle so d(p,q) ≥ 2 (Fig. 4).
- **Lemma 2.7 (p. 8), proved here (cf. Lemma 13 of [46]).** If V is an equilateral polygon of edgelength ℓ and MinRad ≥ τ, then dcsd(V) ⊂ VB(τ,ℓ). Proof idea: any (p,q) ∈ dcsd has total curvature ≥ π on each arc, otherwise by Fenchel the angle at p or q exceeds π/2 and d(p,q) could be reduced to first order.
- **Corollary 2.8 (p. 10), proved here.** If dcsd(V) ⊂ VB(τ,ℓ) and the distance between any two vertices on the boundary of VB is strictly greater than Thi_p(V), then CThi = Thi_p for polygons in a neighborhood of V (regardless of whether V is equilateral with edgelength ℓ).
- **Proposition 2.11 (p. 11), proved here.** Suppose CThi(ℓ,V) = 1. Then (Eq. 8) D_W CThi(ℓ,V) = d/dt⁺ CThi(V_t)|_{t=0} = min{ min_{(v_i,±)∈Kink} d/dt⁺ MinRad^±(v_i)(t)|_{t=0}, min_{Strut(V)} d/dt⁺ [d(p(t),q(t))/2]|_{t=0} } (forward derivatives exist). Proof idea: Clarke's theorem for min-functions [16]; for parallel edges at distance 2 (Fig. 5) the minimum over the family η ∈ [0,1] of the derivative is attained at η = 0 or 1 because it is linear in η.
- **Corollary 2.13 (p. 12), proved here.** I(V) is the dual cone of the set {−∇(d(p,q)/2) : (p,q)∈Strut(V)} ∪ {−∇MinRad^±v_i : (v_i,±)∈Kink(V)}.
- **Proposition 2.16 (p. 13–14), quoted from [51] Thm 2.8.7.** Any vector W ∈ R^{3V} may be uniquely written W = W_R + W_I with ⟨W_R, W_I⟩ = 0, W_R ∈ R(V) the closest resolvable motion and W_I ∈ I(V) the closest infinitesimal motion (R(V) = I(V)^+, dual cones; Fig. 6).
- **Theorem 2.18 (p. 14), proved here (Kuhn–Tucker form [10]).** V is thickness-critical for minimising f ⇔ −∇f ∈ R(V) ⇔ the constrained gradient (−∇f)_I vanishes. Interpretation (Eq. 13): −∇f + Σ_{Strut} λ_i² ∇(d(p,q)/2) + Σ_{Kink} λ_j² ∇MinRad v_j = 0 — λ² are Lagrange multipliers: compression forces transmitted by tube contacts (struts) and bending resistance (kinks). Proof via Farkas' theorem [40].
- **Proposition 2.20 (p. 15), quoted from [10].** Any constraint-qualified local minimum of f is a thickness-critical point for minimising f. (Counter-example to the general claim without constraint qualification: minimise f = −x subject to min{x³−y, y} ≥ 0 at (0,0).)
- **Corollary 2.21 (p. 15), proved here.** If V is a local minimum for f then it is thickness-critical (scaling V provides the needed motion D_W CThi > 0).
- **Proposition 3.2 (p. 16).** (∇Len(V))_k = (v_{k−1} − v_k)/|v_{k−1} − v_k| + (v_{k+1} − v_k)/|v_{k+1} − v_k| (as printed; the text layer reads without the absolute-value signs).
- **Proposition 3.3 (p. 16).** If (p,q) ∈ Strut(V), p = α v_i + (1−α) v_{i+1}, q = β v_j + (1−β) v_{j+1}, then ∇(d(p,q)/2) = (1/(2 d(p,q))) {α(p−q), (1−α)(p−q), β(q−p), (1−β)(q−p)} applied to v_i, v_{i+1}, v_j, v_{j+1} (as printed in the text layer; ⚠ the printed prefactor "1/2d(p,q)" is what the text shows; sign/normalisation not independently re-derived).
- **Proposition 3.4 (p. 17).** For a vertex v_i with finite MinRad^±, n = oriented normal of the plane v_{i−1},v_i,v_{i+1}; K = ‖v_{i+1}−v_i‖/(2 cos θ − 2); V = (v_{i+1}−v_i)/(2 tan(θ/2)‖v_{i+1}−v_i‖); W = K (v_{i−1}−v_i)×n / ‖v_{i−1}−v_i‖²; X = K n×(v_{i+1}−v_i)/‖v_{i+1}−v_i‖². Then ∇MinRad^+(v_i) = {W, −W − X − V, X + V} located at v_{i−1}, v_i, v_{i+1}. ∇MinRad^− is similar.
- **Corollary 3.5 (p. 17), proved here.** If V is equilateral with edgelength ℓ and MinRad v_i = 1 then ‖∇MinRad^± v_i‖ ≥ 2/ℓ². (⚠ The proof on p. 18 states ‖W‖ = |2+2cos θ|/ℓ²; the algebra is not expanded.) Purpose: sensitivity estimate — gradient norms grow like 1/ℓ² so MinRad is a numerically sensitive second-derivative quantity.
- **Proposition 5.1 (p. 25), proved here.** Suppose c(s), d(t) are unit-speed piecewise C² arcs with curvature bounded above by K, and ‖c(0) − d(0)‖ > 1/2 is the minimum distance between c and d. Then for any 0 ≤ s_0, t_0 ≤ ℓ: ‖c(s_0) − d(t_0)‖ ≤ ‖c(0) − d(0)‖ + (1+K) ℓ². Used by roundout_rl to eliminate subsquares of the (s,t) square.
- **Conjectures (unnumbered, p. 29), this paper:** if a family of polygonal ropelength-critical configurations V_n converge to a C^{1,1} curve V then V is ropelength critical in the sense of [9], the strut sets of V_n converge in Hausdorff distance to the self-contact set of V, and the kink sets of V_n converge to the portion of V at maximum curvature. **Quoted conjecture (Gonzalez, p. 30):** every composite knot formed by joining a knot to its mirror image has a critical configuration with a pair of straight segments.
- Quoted facts (p. 30): an interval of a tight knot with curvature less than the maximum and no struts must be a straight segment [27, 50, 9, 21]; a pair of arcs coparametrised by a single family of struts with curvature below the maximum form a standard double helix [9, 34].

## Key equations and quantitative claims outside numbered statements
- p. 4: improve upper bound for ropelength of figure-eight 4_1 by 0.06 to **42.0887** (vs [14]); 9_20 improved by 8.12% to **80.2219** (vs [47]); Borromean rings (6^3_2) bound **58.0070**, within 0.0017% of ≈58.0060 suggested by [10]; "simple chain" link bound 41.7086588, "within 0.02% of the correct value of 6π + 2 [11]". ⚠ Table 1 (p. 24) compares the same quantity to 12π + 4 ≈ 41.6991 [11]; 6π+2 ≈ 20.85 is not 41.7 (and CKS01 gives (4π+4)k−8 = 12π+4 for k = 3 rings). All are numerical upper bounds on smooth ropelength.
- p. 4: results improve on all previously published computations except the trefoil. Against Gilbert's (unpublished, Knot Atlas) configurations: recomputed by the authors' software, their knots tighter in all cases but 2^2_1 by an average of 3.619% (outlier 9^3_27, 71% shorter); against Gilbert's *claimed* ropelengths: tighter in 316 cases, less tight in 36, 1.075% tighter on average; 9^2_28 about 4% shorter. (Footnote 2: Gilbert's claimed numbers not reproduced by MinRad measurement; possibly a discretisation effect.)
- p. 18: typical run: start low resolution 2 vertices per unit ropelength (80–150 vertices), then 4, then 8 vertices per unit ropelength; final run 20–40 CPU hours (desktop); average edge length ≈0.061, 658 edges; average strut set 919 pairs, kink set 19 vertices; rigidity matrix on average 938 × 1974, 99.4% sparse (≤ 11199 of 1,851,612 entries nonzero); several hundred thousand steps. Each column of A has at most 12 nonzero entries (struts: ≤ 4 vertices = 12 variables; MinRad: 3 vertices = 9 variables) (p. 16).
- p. 19: equilateral penalty Eq(V): Len+Eq minimised; typical average edge-length error ≈0.385%. Final ropelengths computed with Thi_p. Strut finding with octrope (clustering code of Ashton–Cantarella [1]); ≈10% of runtime in a typical run (400-edge 5_1 with ≈600 struts, 30 s sample); naive search would involve ~10⁶ pairs.
- p. 19–20: tsnnls solves A^TA x = A^Tb by Cholesky (TAUCS); condition number of A^TA is square of that of A; LAPACK rcond on all final rigidity matrices: average condition number ≈10⁴, none worse than 8×10⁵ ⇒ expected error ≈10⁻⁸ average, 10⁻⁶ worst case in the constrained gradient (heuristic rule of thumb ε_mach × condition number).
- p. 20: stepsize: max 10⁻² when CThi > 1 (Euler); line search (Brent, low precision) once CThi = 1; "computationally acceptable" α: ≤10⁻², ≥10⁻⁶, and the Step 4 solver must still work at the new point.
- p. 21: MaxErr = 10⁻⁴; Newton correction target (1 − MaxErr/2); lsqr minimum-norm solve; 640-edge trefoil with 975 struts, 10 kinks: correction steps 3–25 s, normal steps < 1 s.
- p. 22: 379 knots/links at ≥ 8 vertices per unit ropelength; some at 16, 32, 74 vertices per unit; largest runs ≈2400 vertices. Initial residual goal < 0.01 achieved for **375 of 379**; residual 0.001 achieved for **202**. Computed on clusters at Univ. St Thomas, Univ. Georgia, Vanderbilt ACCRE. Resolution increased by a minrad-preserving spline interpolation (p. 22).
- p. 24–25: each knot started from ≥ 5 initial configurations (KnotPlot, TOROS annealer [47], Gilbert's Knot Atlas configurations, hand-drawn from Kawauchi, KnotPlot diagram command); lowest ropelength kept.
- p. 26: relative residual: average over knots in the tabulation ≈ 0.00299 (⚠ arithmetic mean of all 379 residuals in Tables 8–10 is 0.00578, dominated by 0.78 for 8^4_3; excluding that it is ≈0.0037; the paper's 0.00299 seems to refer to a subset, e.g. knots only); residuals as low as 2.54×10⁻⁵ "for knots and links of special interest such as 8_18, 10_123, the trefoil, and the Borromean rings" (⚠ Tables 8–10 list 8_18: 0.000900015, 3_1: 0.00621792, so these are separate high-resolution runs not tabulated). Four difficult cases: **10_61, 8^3_10, 8^4_3, 9^3_17** (residuals 0.0241, 0.0208, 0.780, 0.248 respectively, matching the table outliers).
- p. 27–28: all tight-configuration data (incl. coordinates) public; "Atlas of Tight Links" [2]; tightening animations online. Minimised configurations have thickness ≈1/2, max curvature 2 (p. 28).
- p. 28–29: minimising ropelength seems to break symmetry of the starting configuration: 3_1 minimiser appears threefold symmetric; 5_1 minimiser is NOT fivefold symmetric; but tight 8_18 and 10_123 are highly symmetric with a single repeated strut-set element (reminiscent of the Borromean rings, Atlas p. 29): upper bounds **74.9063** (8_18) and **92.3565** (10_123) (Fig. 12). These "may be better candidates for an explicit solution than seemingly simpler knots such as the trefoil."
- p. 30 (Fig. 13): 2400-edge trefoil, thickness ≈1/2, residual 0.0018, polygonal ropelength **32.743663**, smooth upper bound 32.74352; six kinked regions clearly resolved, 117 vertices involved. (⚠ Table 3 lists 3_1 Rop 32.7436 from the 8 vertices/unit run.)
- p. 30: active curvature constraints (kinks) found in **372 of 379** configurations; straight segments (no struts/kinks) in **338** cases (e.g. link 6^3_3 with segments of length 2.1, 1.14, 0.56 (Fig. 14)); double helices only a few times (6^3_3 [Atlas p. 28], 7^2_2 [p. 43], 8_19 [p. 66], possibly 8^3_3 [p. 91]). (Link labels as printed "633", "772", "819", "873" — decoded here as 6^3_3, 7^2_2, 8_19, 8^3_3 by the same rule as the tables.)
- p. 36–37, Atlas pages: 8_18: Rop_p 74.9114, Rop 74.9063, file kl_8_18_hrbanff.vect, 1199 vertices, 5591 struts, κ range [0.802748, 2.00005], 24 kinked regions, straight length 0; 10_123: Rop_p 92.3646, Rop 92.3565, file kl_10_123_handcrafted.vect, 1498 vertices, 7189 struts, κ range [0.84917, 2.00008], 30 kinks.
- p. 28 Fig. 11 (Atlas pages): 7_1: Rop_p 61.4234, Rop 61.4067, 512 vertices, 788 struts; 4^2_1: 40.0203, 40.0122, 400 vertices, 610 struts.

## Methods / algorithms
1. (p. 6–10) Discretise ropelength: polygon thickness Thi_p (Def. 2.3), and a differentiable-min "constraint thickness" CThi (Def. 2.5), equal to Thi_p for equilateral polygons (Thm 2.6); strut set Strut(V) and kink set Kink(V) (Def. 2.9–2.10) are the active constraints.
2. (p. 10–14) One-sided derivative of CThi (Prop 2.11); cones I(V) (infinitesimal motions) and R(V) (resolvable motions) are dual (Prop 2.16); constrained gradient = projection onto I(V); criticality ⇔ −∇Len ∈ R(V) (Thm 2.18, Eq. 13 Lagrange multipliers on struts and kinks).
3. (p. 15–16) Compute (−∇f)_I: build rigidity matrix A (Def. 3.1), solve NNLS min_{Λ≥0} ‖AΛ − (−∇f)‖ (Eq. 14); (−∇f)_R = AΛ, (−∇f)_I = −∇f − AΛ. Gradients: Props 3.2–3.4.
4. (p. 18–19) Algorithm 1 (ridgerunner): repeat { compute −∇f = −∇Len(V_k) − ∇Eq(V_k); find Strut/Kink, build A; compute (−∇f)_I; line-search α (Eq. 18: V_{k+1} = V_k + α(−∇f)_I); if CThi(ℓ,V_{k+1}) < 1 − MaxErr correct by Newton's method } until ‖(−∇f)_I‖/‖−∇f‖ small.
5. (p. 19) Equilateral penalty Eq(V) keeps edge lengths approximately equal; octrope clustering for struts/kinks; tsnnls (block-pivoting PJV algorithm + sparse Cholesky TAUCS) for the SNNLS problem.
6. (p. 20) Stepsize rules (see quantitative claims). (p. 21) Newton error correction with minimum-norm solve by lsqr, MaxErr = 10⁻⁴; alternative: rescale knot (SONO-style, destroys strut set).
7. (p. 21–22) Variants: open curves with fixed/plane-constrained endpoints (endpoint constraint gradients added to A); modified algorithm that scales up the length gradient on strut/kink-free portions to speed straightening.
8. (p. 22–25) Production: multi-resolution (2, 4, 8, … vertices per unit ropelength) from ≥ 5 different initial configurations per knot; keep best.
9. (p. 25–26) Smooth ropelength bound: splice circular arcs of radius MinRad(v_i) at corners (piecewise C¹ curve, Fig. 9); estimate self-distances by sampling with spacing ℓ and bound the error with Prop 5.1; roundout_rl nets the (s,t) square and eliminates subsquares; double precision. Output column Rop.

## Tables
Tables 3–10 each have 379 rows (> 150): written to **`wiki/data/ACPR10_table3.csv`** (one row per knot/link: name, kind, crossings, components, index, Rop_p, Rop, residual, rank by Rop). Columns Rop_p, Rop = Tables 3–5; residual = Tables 8–10; rank = position in Tables 6–7. Row/name assignment was done by sequence order and verified: every table token's digit multiset matches the assigned name X^c_i (the PDF text layer scrambles superscript/subscript digit order), the 379 rows reproduce Table 2's min/max per crossing number, and the sorted order of Tables 6–7 reproduces the rank order of the Rop column (checked all 379).

**Table 1 (p. 24)** — "Numerical results from ridgerunner compared to the minimum ropelength values from [11] and [10]. The relative errors in the computations are quite small." (verified on image)

| Link name | Clasp | Hopf link (2^2_1) | 2^2_1#2^2_1 | Borromean rings (6^3_2) |
|---|---|---|---|---|
| Vertices | 332 | 216 | 384 | 930 |
| Rop_p bound | 4.2841 | 25.1406 | 41.7131 | 58.0192 |
| Rop bound | 4.2837 | 25.1334 | 41.7086588 | 58.0070 |
| Smooth length | 4.2629 [10] | 8π [11] | 12π + 4 [11] | 58.0060 [10] |
| Relative error | 0.4% | 0.02% | 0.02% | 0.0017% |

(⚠ Table 3 gives for 2^2_1 Rop_p 25.1415 and for 6^3_2 Rop_p 58.0112 (Rop 58.0070 equal), i.e. different runs from Table 1's 25.1406 / 58.0192. Arithmetic: 8π = 25.1327, so Rop 25.1334 is 0.003% above, Rop_p 25.1406 is 0.03% above; 12π+4 = 41.6991: Rop 0.011%, Rop_p 0.034%; the printed "0.02%" values do not match either exactly. Clasp: (4.2837−4.2629)/4.2629 = 0.49% vs printed 0.4%.)

**Table 2 (p. 27)** — "This table shows the links of smallest and largest minimum ropelength for each crossing number (according to our data). Recall that we did not minimize ten-crossing links, so it is likely that some ten-crossing link has more or less ropelength than the 10_123 and 10_124 knots." (columns: Cr, Rop = [min, max], Links = (argmin, argmax); link labels decoded as X^c_i.)

| Cr | Rop | Links |
|---|---|---|
| 3 | 32.74 | 3_1 |
| 4 | [40.0122, 42.0887] | 4^2_1, 4_1 |
| 5 | [47.2016, 49.7716] | 5_1, 5^2_1 |
| 6 | [50.5539, 58.1013] | 6^3_3, 6^2_3 |
| 7 | [55.5095, 66.3147] | 7^2_7, 7^2_6 |
| 8 | [60.5754, 75.2592] | 8^3_7, 8^4_1 |
| 9 | [66.0311, 83.6092] | 9^2_49, 9^2_42 |
| 10 | [71.0739, 92.3565] | 10_124, 10_123 |

(Printed labels "9429, 9422", "837, 841", "772, 762", "633, 632", "521" are the scrambled forms of these; each value reproduced from the CSV: e.g. 9^2_49 = 66.0311, 9^2_42 = 83.6092, 10_124 = 71.0739, 10_123 = 92.3565, 8^3_7 = 60.5754, 8^4_1 = 75.2592, 7^2_7 = 55.5095, 7^2_6 = 66.3147.)

**Tables 3–5 (pp. 38–40)** — "Ropelengths of Tight Knots and Links by Knot Type" (Part 1: 2^2_1 … 9_38; Part 2: 9_38 … 10_37; Part 3: 10_37 … 10_123/10_124 …10_165), columns Link, Rop_p, Rop. In CSV. First 10 rows (CSV order = Rolfsen order; name, Rop_p, Rop, residual, rank):

| name | Rop_p | Rop | residual (Tables 8–10) | rank by Rop |
|---|---|---|---|---|
| 2^2_1 | 25.1415 | 25.1334 | 2.45124e-05 | 1 |
| 3_1 | 32.7437 | 32.7436 | 0.00621792 | 2 |
| 4_1 | 42.0971 | 42.0887 | 0.000996335 | 4 |
| 4^2_1 | 40.0203 | 40.0122 | 0.000999549 | 3 |
| 5_1 | 47.2149 | 47.2016 | 0.00981995 | 5 |
| 5_2 | 49.4820 | 49.4701 | 0.00994775 | 6 |
| 5^2_1 | 49.7864 | 49.7716 | 0.00998078 | 7 |
| 6_1 | 56.7178 | 56.7058 | 0.000999592 | 12 |
| 6_2 | 57.0381 | 57.0235 | 0.00897204 | 13 |
| 6_3 | 57.8531 | 57.8392 | 0.000979541 | 16 |

Facts checked from the data: ⚠ three rows have Rop > Rop_p (the smooth bound exceeds the polygonal value): 9_28 (81.0878 vs 81.1352), 9_30 (81.4811 vs 81.4883), 10_84 (89.6518 vs 89.6788); all other rows have Rop < Rop_p. Largest Rop: 9^2_42 is the largest 9-crossing; overall maximum 10_123 = 92.3565; overall minimum 2^2_1 = 25.1334 (Hopf link), then 3_1 = 32.7436, 4^2_1 = 40.0122, 4_1 = 42.0887.

**Tables 6–7 (pp. 41–42)** — "Knot and Link Types sorted by Ropelength" (read down each column, top-left to bottom-right; 379 entries, labels only, no numbers). Order is reproduced by column `rank_by_Rop` in the CSV (verified). First entries (rank 1–10): 2^2_1, 3_1, 4^2_1, 4_1, 5_1, 5_2, 5^2_1, 6^3_3, 6^2_1, 7^2_7. Statement p. 35: "the 2-component link 7^2_7 occurring before any 6 or 7 crossing knot and the 10_124 knot occurring before many 8 and 9 crossing links" (printed labels 727 and 10124).

**Tables 8–10 (pp. 43–45)** — "Residuals of Tight Knots and Links by Knot Type" (Parts 1–3), residual = ‖(−∇f)_I‖/‖−∇f‖ per configuration. In CSV column `residual`. Summary from CSV: 375 of 379 < 0.01; 202 < 0.001; four largest: 8^4_3 0.780186, 9^3_17 0.247874, 10_61 0.0241498, 8^3_10 0.0208108; smallest 2^2_1 2.45124e-05, then 9_4 8.64059e-05.

## Figures
- **Fig. 1 (p. 3)** — "The thickness of a smooth curve γ is controlled by curvature (as in the left picture), and the length of chords in dcsd(γ) (as in the right picture)." *What it shows:* a curve with a tight bend and a curve with a chord of length 2·Thi.
- **Fig. 2 (p. 5)** — "These two images of the 9_20 knot show the tightest configurations obtained by our algorithm (left) and by the TOROS algorithm described in [47] (right)… ropelength of the left-hand configuration is bounded by 80.2219, while the configuration on the right has ropelength bounded by 87.31." *What it shows:* many self-contacts resolved by the new method. Image: ../figures/ACPR10/p05.png
- **Fig. 3 (p. 6)** — three types of local minima of self-distance: edge–edge, vertex–edge, vertex–vertex pairs (polygons with chord drawn).
- **Fig. 4 (p. 9)** — proof of Thm 2.6: arc P with equal edge lengths ℓ, turning angle θ(1,ℓ) = 2 arctan(ℓ/2), n = ⌈π/θ⌉ edges, inscribed unit circle; marked point q above the top of the circle. Image: ../figures/ACPR10/p09.png
- **Fig. 5 (p. 11)** — parallel edges e_i, e_j with a family of minimal chords; endpoints p, q on e_i and r, s on e_j. Image: ../figures/ACPR10/p11.png
- **Fig. 6 (p. 13)** — dual cones I(V) and R(V) and decomposition W = W_I + W_R.
- **Fig. 7 (p. 23)** — strut set of the Borromean rings (6^3_2): arclength-labelled diagonals (values 0, 2.90 … 29.01 along the 3 components), dark green squares at (s,t) for each strut; no self-contact within a component; each component contacts the other two in "lantern-shaped" structures; bottom plot compares one lantern to the theoretical self-contact set of [10] (black line). Image: ../figures/ACPR10/p23.png
- **Fig. 8 (p. 24)** — simple clasp: loose configuration (left), strut positions in arclength coordinates (centre, right enlarged) for a 332-edge polygonal clasp compared with the theory of [10]. Image: ../figures/ACPR10/p24.png
- **Fig. 9 (p. 25)** — left: circle arc of radius MinRad(v_i) spliced into corner v_{i−1}v_iv_{i+1} (curve C¹ not C²); right: setup for Prop. 5.1 (arcs c, d, minimum distance x at c(0),d(0), bound x + (1+K)ℓ²). (not rendered; description from caption)
- **Fig. 10 (p. 27)** — "graph shows the relationship between ropelength (y-axis) and crossing number (x-axis) for knots and links in our data set. The bottom lines show the bound of Denne et al. [17] for ropelength of a nontrivial knot (horizontal line) and Diao's bound [18] for ropelength in terms of crossing number (curve)." *What it shows:* y-axis ≈ 30–90 (ticks 30, 50, 70, 90), x-axis crossing number 2–10; scatter with substantial overlap between crossing numbers. Image: ../figures/ACPR10/p27.png
- **Fig. 11 (p. 28)** — two Atlas pages (7_1 and 4^2_1): three views, strut triangle plot in arclength coordinates, curvature plot below. Image: ../figures/ACPR10/p28.png
- **Fig. 12 (p. 29)** — tight 8_18 and 10_123 (ropelength upper bounds 74.9063, 92.3565), highly symmetric. Image: ../figures/ACPR10/p29.png
- **Fig. 13 (p. 30)** — computed 1/MinRad vs arclength for a 2400-edge trefoil (arclength to ≈16.37, 1/MinRad axis 0.5–2.0); six kinked regions at the maximal 1/MinRad ≈ 2. Image: ../figures/ACPR10/p30.png
- **Fig. 14 (p. 31)** — two views of tight 6^3_3 (Rop 50.5539) with straight segments highlighted. Image: ../figures/ACPR10/p31.png
- **Atlas reproductions pp. 36–37** — 8_18 and 10_123 strut maps (triangle plot, curvature, kinks in red). Images: ../figures/ACPR10/p36.png, p37.png. Table pages: ../figures/ACPR10/p38.png (Table 3), p43.png (Table 8).

## Stated limitations, open problems, future work
- p. 4: composite knots and links not treated ("We intend to address the ropelength of composite knots and links in a future publication"); p. 30 same.
- p. 29: no theorem proved that polygonal strut sets converge to those of a critical smooth configuration — conjectured (above).
- p. 29–30: curvature constraints appear active in 372/379 cases (suggestive numerical evidence that kinks are common; "better evidence for this conjecture in an upcoming publication"); straight segments 338 times.
- p. 21: Newton error correction (lsqr) is the speed bottleneck; occasional Newton solver failures observed; possible cycling (Fletcher).
- p. 20: tsnnls (TAUCS) fails when the rigidity matrix is singular (multiple ways to balance gradient force; "seems to be rare"); a minimum-norm solver would be needed.
- p. 31: projected-gradient methods suffer from wobbling and zigzagging; adding conjugate-gradient gave only slight improvement; SQP would require reduced constraint sets (O(n) of the O(n²) self-distance constraints), for which these data could be used.
- p. 31–32: explicit solution of the structure of smooth tight knots "is likely to require even better data"; the clasp critical shape has tiny straight segments (a few thousandths of total length) so converged runs with tens of thousands of vertices would be needed.
- p. 26: four configurations (10_61, 8^3_10, 8^4_3, 9^3_17) particularly difficult for ridgerunner (large residuals).
- p. 22: runs with long strut-free segments converge slowly (step size controlled by tightly curved regions).

## References worth following
- [33] Litherland, Simon, Durumeric, Rawdon, Thickness of knots, Topology Appl. 91 (1999) (Prop 1.1, Thm 1.3).
- [10] Cantarella, Fu, Kusner, Sullivan, Wrinkle, Criticality for the Gehring link problem, Geom. Topol. 10 (2006) (Borromean rings and clasp strut sets; KKT criticality).
- [11] Cantarella, Kusner, Sullivan, On the minimum ropelength of knots and links, Invent. Math. 150 (2002) (8π Hopf link, 12π+4 chain, etc.).
- [44], [45], [46], [47] Rawdon: The thickness of polygonal knots (thesis 1997); Approximating the thickness of a knot (1998); Approximating smooth thickness, JKTR 9 (2000); Can computers discover ideal knots?, Exp. Math. 12 (2003) (TOROS annealer).
- [14] Carlen, Laurie, Maddocks, Smutny, Biarcs, global radius of curvature, and the computation of ideal knot shapes (2005) (previous bound for 4_1; curvature constraints nearly active).
- [24] Gilbert, Ideal knot and link data (Knot Atlas wiki); [41] Pieranski, In search of ideal knots (SONO); [52] Sullivan, Approximating ropelength by energy functions.
- [12], [43] Cantarella–Piatek–Rawdon TSNNLS (arXiv cs.MS/0408029); Portugal–Júdice–Vicente block pivoting; [1] Ashton–Cantarella, octree ropelength algorithm.
- [16] Clarke, Generalized gradients (min-function derivative); [51] Stoer–Witzgall (dual cone decomposition).
- [17] Denne, Diao, Sullivan, Quadrisecants give new lower bounds for the ropelength of a knot, Geom. Topol. 10 (2006); [18] Diao, The lower bounds of the lengths of thick knots, JKTR 12 (2003).
- [2] Ashton, Cantarella, Piatek, Rawdon, Atlas of tight links (online).

## Extraction notes
- Pages rendered: 3, 5, 9, 11, 23, 24, 27, 28, 29, 30, 31, 36, 37, 38, 43. Fig. 9 (p. 25) and several small figures only described from captions; Fig. 10 axes read from the text layer (tick labels) only.
- Pages 38–45 tables: numbers extracted from the PDF text layer (`pdftotext -layout`) and assembled by script; names assigned by Rolfsen sequence order (families: 2^2_1; 3_1; 4_1,4^2_1; 5_1,5_2,5^2_1; 6_1–6_3, 6^2_1–3, 6^3_1–3; 7_1–7_7, 7^2_1–8, 7^3_1; 8_1–8_21, 8^2_1–16, 8^3_1–10, 8^4_1–3; 9_1–9_49, 9^2_1–61, 9^3_1–21, 9^4_1; 10_1–10_165 = 379 entries). Verified: digit multiset of every printed token matches its assigned name (no mismatches in Tables 3–5, 8–10); numeric spot-checks against images p. 38 (all 3 columns) and p. 43 (all 4 columns); Table 2 extremes reproduced; Table 6–7 order reproduced from Rop values. Column-break duplicates in the PDF (rows repeated at the top of the next column: e.g. 8_2, 8^3_8, 9_38, 9^2_33 ...) were removed.
- ⚠ list: "6π+2" in intro vs "12π+4" in Table 1; Table 1 vs Table 3 Rop_p for Hopf link and Borromean rings; Table 1 relative errors not matching the printed values; average residual 0.00299 vs 0.00578 (mean of Tables 8–10); lowest residuals (2.54×10⁻⁵ for 8_18, 10_123, 3_1, Borromean) not in Tables 8–10 (these tables give 8_18 = 9.0×10⁻⁴, 3_1 = 6.2×10⁻³, 10_123 = 1.65×10⁻³); Rop > Rop_p for 9_28, 9_30, 10_84; document date line "June 12, 2004; Revised: November 18, 2018" vs arXiv 2010; link naming given as "X^z_y" in prose but tables use X^c_i (components superscript).
- p. 36–37 Atlas columns (arclength coordinates of struts) not transcribed.
