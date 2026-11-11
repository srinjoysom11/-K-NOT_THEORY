# CKS01 — On the Minimum Ropelength of Knots and Links
- **Authors:** Jason Cantarella, Robert B. Kusner, John M. Sullivan
- **Venue / year / identifiers:** arXiv:math/0103224v3 [math.GT], 1 Mar 2002; received April 2, 2001, revised February 22, 2002 (published Invent. Math. 150 (2002) 257–286, as cited in other papers; not printed on this file)
- **File:** papers/3_analytic_bounds/Cantarella-Kusner-Sullivan_2001_Minimum_ropelength_knots_links_math0103224.pdf   **Pages:** 29
- **Text layer:** ok except square roots, fractions and some inequalities; all square-root statements checked on page images (pp. 9, 13, 17, 22, 24, 25)

## Abstract
The ropelength of a knot is the quotient of its length by its thickness, the radius of the largest embedded normal tube around the knot. We prove existence and regularity for ropelength minimizers in any knot or link type; these are C^{1,1} curves, but need not be smoother. We improve the lower bound for the ropelength of a nontrivial knot, and establish new ropelength bounds for small knots and links, including some which are sharp.

## Notation and conventions
- **Ropelength convention: LENGTH / RADIUS.** "We measure the ropelength of a knot as the quotient of its length and its thickness, the radius of the largest embedded normal tube around the knot" (p. 1). "We define the ropelength of a link L to be Len(L)/τ(L), the (scale-invariant) quotient of length over thickness" (p. 4). Unit thickness = unit-radius tube; for a unit-thickness C^{1,1} curve curvature ≤ 1 and ropelength ≤ its length (p. 4). The trefoil's "one foot of one-inch (diameter) rope" remark (p. 2) is the length/diameter reading of "ropelength under 24".
- Thickness (p. 3): τ(L) := inf_{x∈L} τ_x(L), τ_x(L) := inf_{y,z∈L, x≠y≠z≠x} r(x,y,z), r(x,y,z) = radius of the circle through x,y,z (∞ if collinear). Lemma 1 (p. 3): for C¹ L, τ = inf_{x≠y} r(T_xL, y) = min(infimal radius of curvature, half the infimal doubly critical self-distance). Lemma 2 (p. 4): thickness = reach (Federer) = normal injectivity radius. Closest distance between two components ≥ 2τ (p. 3).
- Tight = ropelength-minimizing configuration (p. 1).
- P_n (p. 9): shortest length of a plane curve enclosing n disjoint unit-radius disks; P_n = 2π + 2Q_n, Q_n = length of shortest curve enclosing n points separated by unit distance.
- Cone angle at p of curve K = length of the projection of K to the unit sphere around p (p. 8). Cone surface = union of segments from p to K.
- Lk(J,K) total linking number (p. 12). Ov(A,B) = unsigned number of crossings of A over B minimized over projections of isotopic links (p. 14). Parallel overcrossing number PC(L) = min Ov(L,L') over parallel copies L' (p. 14). Asymptotic crossing number AC(L) (Freedman–He) = inf Ov(pL,qL)/|pq| over degree-p and degree-q satellites; AC(L) ≤ PC(L) ≤ Cr(L) (p. 14). Cr = crossing number. Br(L) = reduced bridge number (min number of local maxima of a height function over isotopic links minus number of unknotted split components) (p. 15). Relative AC(K_i, L) (p. 19). χ_−(K_i,L) = min Thurston norm of surfaces representing α_i = l_i + Σ Lk(K_i,K_j) m_j (p. 20).
- Lattice number k(L) = minimal number of unit edges to embed L in Z³ (p. 23).

## Numbered statements
- **Lemma 1 (p. 3).** Suppose L is C¹ and T_xL its tangent line at x. Then τ(L) = inf_{x≠y∈L} r(T_xL, y). This equals the infimal radius of curvature of L or half the infimal doubly critical self-distance, whichever is less.
- **Lemma 2 (p. 4).** For any C¹ link L, the thickness of L equals the reach of L; this is also the normal injectivity radius of L.
- **Lemma 3 (p. 5).** Thickness is upper semicontinuous with respect to the C⁰ topology on the space of C^{0,1} curves.
- **Lemma 4 (p. 6).** If L has thickness τ > 0, then its secant map S has Lipschitz constant 1/2τ. Thus L is C^{1,1}.
- **Lemma 5 (p. 6).** If L is a link of thickness τ > 0, then any points x, y ∈ L with |x − y| < 2τ are connected by an arc of L of length at most 2τ arcsin(|x−y|/2τ) ≤ (π/2)|x−y|. Proof idea: Schur's lemma (Chern's version applies to C^{1,1}).
- **Lemma 6 (p. 7).** Suppose L_i is a sequence of links of thickness at least τ > 0, converging in C⁰ to a limit link L. Then the convergence is actually C¹, and L is isotopic to (all but finitely many of) the L_i.
- **Theorem 7 (p. 7).** There is a ropelength minimizer in any (tame) link type; any minimizer is C^{1,1}, with bounded curvature. *Proved here (direct method).*
- **Lemma 8 (p. 8).** Let S be an infinite cone surface with cone angle θ ≥ 2π (so S has nonpositive curvature and is intrinsically Euclidean away from the cone point). Let R be a subset of S which includes the cone point, and let ℓ be a lower bound for the length of any curve in S surrounding R. Consider a C^{1,1} curve K in S with geodesic curvature bounded above by 1. If K surrounds R while remaining at least unit distance from R, then K has length at least ℓ + θ. Proof idea: parallel curves K_t at distance t; d/dt Len(K_t) = −∫κ_g ds = −θ by Gauss–Bonnet, so Len(K) = Len(K_t) + tθ ≥ ℓ + θ.
- **Lemma 9 (p. 9).** For any closed curve K, there is a point p such that the cone over K from p has cone angle 2π. When K has positive thickness, we can choose p to lie outside the thick tube around K. Proof idea: cone angle ≥ 2π at points on a chord, → 0 far away; intermediate value theorem.
- **Theorem 10 (p. 10).** Suppose K is one component of a link of unit thickness, and the other components can be partitioned into n sublinks, each of which is topologically linked to K. Then the length of K is at least 2π + P_n, where P_n is the minimum length of any curve surrounding n disjoint unit disks in the plane. *Sharp for n ≤ 5 (p. 11).*
- **Theorem 11 (p. 12).** Suppose L is a link of unit thickness. If K is one component of the link, and J is the union of any collection of other components, let Lk(J,K) denote the total linking number of J and K, for some choice of orientations. Then Len(K) ≥ 2π + 2π √(Lk(J,K)). (Printed form on p. 12: "Len(K) ≥ 2π + 2π√Lk(J,K)"; text layer lost the root, restored from p. 2, p. 13 and the proof: Area(R) ≥ π Lk ⇒ perimeter ≥ 2π√Lk.) Proof idea: flux of divergence-free unit field V through the cone portion outside the tube equals π Lk(J,K); isoperimetric inequality in the flat cone; then Lemma 8.
- **Lemma 12 (p. 14).** For any link partitioned into two parts A and B, Lk(A,B) and Ov(A,B) are symmetric in A and B, and |Lk(A,B)| ≤ Ov(A,B); Lk(A,B) ≡ Ov(A,B) (mod 2).
- **Conjecture 13 (p. 14).** If L is any knot or link, PC(L) = Cr(L).
- **Proposition 14 (p. 15).** For any link L, PC(L) ≥ Br(L). In particular, if L is nontrivial, PC(L) ≥ 2.
- **Lemma 15 (p. 15) (Gromov; Ekholm–White–Wienholtz).** Suppose L is a link and M a (possibly disconnected) minimal surface spanning L. Then for any point p ∈ R³ through which n sheets of M pass, the cone angle of L at p is at least 2πn. Proof idea: monotonicity formula (White) for M ∪ exterior cone.
- **Corollary 16 (p. 16).** If L is a nontrivial link, then there is some point p from which L has cone angle at least 4π. (Gives a new proof of the Fáry–Milnor theorem, total curvature ≥ 4π; bound cannot be improved since knots with total curvature 4π + ε exist; every two-bridge knot can be built with total curvature 4π + ε, p. 16.)
- **Proposition 17 (p. 16).** Let K be a nontrivial knot, and let T be any embedded (closed) solid torus with core curve K. Any smooth disk D spanning K must have self-intersections outside T.
- **Theorem 18 (p. 17).** If K is a nontrivial knot then there is a point p, outside the thick tube around K, from which K has cone angle at least 4π.
- **Theorem 19 (p. 17).** For any nontrivial knot K of unit thickness, Len(K) ≥ 4π + 2π √PC(K) ≥ 2π(2 + √2). (≈ 6.83π ≈ 21.45, p. 2.) Proof: 4π cone from Thm 18; area of S' ≥ π PC(K) via distance-decreasing map to the unit disk with unsigned degree ≥ PC(K); isoperimetric ℓ ≥ 2π√PC(K); Lemma 8 gives 4π + 2π√PC(K); Prop. 14 gives PC ≥ 2.
- **Proposition 20 (p. 20) (Freedman–He [FH, Thm 4.1]).** If K is a component of a link L, AC(K,L) ≥ χ_−(K,L). In particular, AC(K,L) ≥ 2 genus(K) − 1.
- **Theorem 21 (p. 20).** Suppose K is one component of a link L of unit thickness. Then Len(K) ≥ 2π + 2π √(AC(K,L)). If K is nontrivially knotted, this can be improved to Len(K) ≥ 4π + 2π √(AC(K,L)).
- **Corollary 22 (p. 21).** For any nontrivial knot K of unit thickness, Len(K) ≥ 2π(2 + √(2 genus(K) − 1)). More generally (printed unnumbered, p. 22): for any component K of a link L of unit thickness, Len(K) ≥ 2π(1 + √χ_−(K,L)).
- **Theorem 23 (p. 24).** Let L be a link type with minimum crossing number n, lattice number k, and minimum ropelength ℓ. Then ((4π/11) n)^{3/4} ≤ ℓ ≤ 2k ≤ 24 n². (Lower bound constant from Buck–Simon [BS]; upper bound by Schnyder grid embedding: lattice number < 12n².)
- **Conjecture 24 (p. 24).** Ropelength minimizers are piecewise analytic.
- **Conjecture 25 (p. 24).** If L is any knot or link, AC(L) = PC(L) = Cr(L). (Would give for a nontrivial knot 4π + 2π√3 ≈ 23.45 instead of 4π + 2π√2 ≈ 21.45.)
- **Conjecture 26 (p. 25).** The intersection of the tube around a knot of unit thickness with some 4π cone on the knot contains PC(K) disjoint unit disks avoiding the cone point. (Would improve the nontrivial-knot estimate to about 30.51, 93% of Pieranski's numerical 32.66 for the trefoil.)
- **Proposition 27 (p. 26).** For any space curve K: S¹ → R³, parametrized by arclength, there is a plane curve K' of the same length, also parametrized by arclength, so that for every θ, φ: |K(θ) − K(φ)| ≤ |K'(θ) − K'(φ)|. (Reshetnyak/Sallee; proof via Lemma 9, unrolling the cone.)

## Key equations and quantitative claims outside numbered statements
- p. 2 (Fig. 1 caption): simple chain of k ≥ 2 rings (connect sum of k−1 Hopf links) built from stadium curves has ropelength (4π + 4)k − 8, tight by Thm 10 (rigorous). Shows minimizers need not be C².
- p. 2: the Hopf link built from two round circles is the Gehring-link solution (previously known tight link).
- p. 2: best previously known lower bound for a nontrivial knot [LSDR]: 5π ≈ 15.71. Computer experiments [SDKP] (Pieranski SONO): tight trefoil ropelength ≈ 32.66 (numerical). Open "old question" whether any knot has ropelength under 24 (one foot of one-inch-diameter rope).
- p. 9–10: P_1 = 2π; P_n = 2π + 2n for 2 ≤ n ≤ 5 (Q_n = n); Q_6 = 4 + √3 (unique minimizer); minimizers unique for n < 4, one-parameter family for n = 4, two-parameter family for n = 5; Q_n grows like √n. Footnote: Schürmann conjectures minimum perimeter achieved by a subset of the hexagonal packing for n < 54 and proves not for n > 370 (p. 9–10).
- p. 11: tight links built for n ≤ 5 (each component planar of length 2π + P_n); one-parameter family of tight five-component links (P_4); minimizers not unique and (except Hopf link) not C². Composite-link deficit: observed in [SKB+] to seem at least 4π − 4, confirmed by the provably tight connected sums (p. 12).
- p. 13: Fig. 7 (2,4)-torus link: linking number 2, each component ≥ 2π + 2π√2 (> 4π); total ≥ 4π(1+√2) printed "≈ 33.34". ⚠ 4π(1+√2) ≈ 30.34 numerically; the printed "33.34" appears to be a typo. Laurie et al. [LKS+] numerical configuration ≈ 41.2.
- p. 13: writhe bound Len(K) ≥ 2π√|Wr(K)| (this paper's argument; flux argument, Lemma 8 not applicable) is weaker than Buck–Simon Len(K) ≥ 4π√|Wr(K)| [BS].
- p. 14: AC(L) ≤ PC(L) ≤ Cr(L); crossing number of K ∪ K' ≥ 4k for alternating K of crossing number k (Thistlethwaite, Lickorish–Thistlethwaite); Freedman–He: AC(K) ≥ 2 genus(K) − 1 (so ≥ 1 if K nontrivial) (p. 14–15).
- p. 19: AC(K_i, L) ≥ Σ_{j≠i} |Lk(K_i, K_j)|.
- p. 22 (Fig. 11): (2,6)-torus link with one component replaced by its Whitehead double: other component has Alexander (= Thurston) norm 5 (2n − 1 with n = 3; Alexander polynomial (1+x+x²)²(1−x)(1−y)); Cor. 22 gives total ropelength at least 2π(3 + √5). Three-fold bangle-sum link: expect Thurston norm 3 (would give 4π(1+√3)) but not proved. For the Whitehead link and Borromean rings χ_− = 1, no improvement over Thm 10.
- p. 23: ropelength lower bound ((4π/11)n)^{3/4} from [BS]; the (k,k−1) torus knots and k-component Hopf links have ropelength growing exactly as n^{3/4} [CKS = Nature 392]. Thm 10 shows simple chains have ropelength linear in n. Lattice: round corners with quarter circles of radius 1/2 → C^{1,1} curve of length < k and thickness 1/2, so ℓ ≤ 2k; k ≤ 94ℓ (omitted argument) improved by Diao et al. [DEJvR] to k ≤ 12ℓ. Embedding in a (2n−2)×(2n−2)×(2n+2) piece of the cubic lattice, each edge length < 6n, total lattice number < 12n² (via Schnyder, grid (n−1)×(n−1) doubled) (p. 23–24). Johnston: independent O(n²) with worse constant, two layers (p. 24). Authors expect lattice number ≥ n log n for tree-of-meshes-type links, and suspect superlinear ropelength might exist; VLSI methods might give O(n (log n)²) (p. 23, conjectural).
- p. 25 (quoted, announced): Diao [Dia]: 16π Cr(K) ≤ Len(K)(Len(K) − 17.334) for unit-thickness K, and trefoil ropelength > 24.
- p. 25: Borromean rings best bound 12π ≈ 37.70 (Thm 10); if AC = Cr then 6π(1+√2) ≈ 45.51 (≥ 78% of optimal) vs configuration with ropelength about 58.05 (three congruent planar curves from arcs of four radius-2 circles centered at vertices of a rhombus of side 4, major diagonal 4 longer than minor diagonal, p. 26); not even ropelength-critical (work with Fu).
- p. 25: Conj. 26 estimate for the nontrivial knot ≈ 30.51.

## Methods / algorithms
Pure-math (no computation).
1. (p. 3–7) Thickness as inf of three-point radius; equivalence with reach; Lipschitz secant map → C^{1,1}; compactness → minimizers (Thm 7).
2. (p. 8–11) Cone surfaces: from Lemma 9 cone point p outside the tube with cone angle 2π; surface is intrinsically flat; components linked to K puncture the cone at points ≥ 2 apart (intrinsic disks of radius 1); Lemma 8 gives Len(K) ≥ 2π + P_n.
3. (p. 12) Linking-number bound via flux of unit divergence-free tube field V: flux over R = π Lk; isoperimetric inequality.
4. (p. 14–15) Overcrossing numbers; PC ≥ Br via lifting parallel copy above a slab.
5. (p. 15–17) 4π cone: minimal disks, Lemma 15 (monotonicity), self-intersection outside tube (Prop. 17).
6. (p. 17–19) Thm 19: truncated cone S'; flow along V gives distance-decreasing map S'∩T → unit disk of degree ≥ PC.
7. (p. 19–21) Thm 21: perturb K so rotation angles θ_J are rational; degree-q satellites; area(S') ≥ π AC.
8. (p. 23–24) Upper bound: Schnyder planar grid embedding doubled for crossing gadgets.

## Tables
None.

## Figures
- **Fig. 1 (p. 2)** — "A simple chain of k ≥ 2 rings, the connect sum of k−1 Hopf links, can be built from stadium curves (with circles at the ends). This configuration has ropelength (4π + 4)k − 8 and is tight by Theorem 10; it shows that ropelength minimizers need not be C²." Image: ../figures/CKS01/p02.png
- **Fig. 2 (p. 5)** — elbow curves (straight segments joined by a unit-radius circular arc; thickness stays 1 as the arc angle → 0).
- **Fig. 3 (p. 6)** — secant map of a thick knot is Lipschitz (Lemma 4).
- **Fig. 4 (p. 10)** — "Two views of the same cone, whose cone angle is precisely 2π, on a symmetric trefoil knot." **Fig. 5 (p. 10)** — shortest curves enclosing n unit disks (P_1 = 2π, P_2 = 2π+4, P_3 = 2π+6, P_4 = 2π+8; unique for n<4, one-parameter family for n=4). Image: ../figures/CKS01/p10.png
- **Fig. 6 (p. 11)** — tight link whose components use the perimeter-minimizing shapes. Image: ../figures/CKS01/p11.png
- **Fig. 7 (p. 13)** — (2,4)-torus link, total ropelength ≥ 4π(1+√2) printed ≈ 33.34 (⚠ see above); numerical 41.2. Image: ../figures/CKS01/p13.png
- **Fig. 8 (p. 15)** — three stages of the proof of Prop. 14 (clasps as bridges). Image: ../figures/CKS01/p15.png
- **Fig. 9 (p. 18)** — cone of angle 4π on the symmetric trefoil. **Fig. 10 (p. 18)** — trefoil with thick tube T coned to p; integral curves of V. Image: ../figures/CKS01/p18.png
- **Fig. 11 (p. 22)** — Whitehead double of a (2,6)-torus link component; three-fold bangle-sum link. Image: ../figures/CKS01/p22.png
- **Fig. 12 (p. 25)** — development of a fundamental sector (4π/3 wedge) of the cone on Pieranski's tight trefoil; shaded = intersection with the thick tube, strip of width ≥ 1 plus unit disk around q. Image: ../figures/CKS01/p25.png
- **Fig. 13 (p. 26)** — Borromean rings configuration with ropelength about 58.05. Image: ../figures/CKS01/p26.png
- **Fig. 14 (p. 27)** — trefoil and its cone-surface unfolding (chord longer on the unfolding). Image: ../figures/CKS01/p27.png

## Stated limitations, open problems, future work
- p. 2: Whether any knot has ropelength under 24 ("Can a knot be tied in one foot of one-inch (diameter) rope?") remains open.
- p. 3/13: Conjecture 13, 24, 25, 26 (above). The authors believe the √ linking-number bound is never sharp for n > 1 (p. 2). P_n-version for linking number "seems difficult" (p. 13).
- p. 11: "we could still hope that every tight link is piecewise smooth, or even piecewise analytic."
- p. 23: no known family with superlinear ropelength growth in crossing number; suspected (n log n lattice number) but "hard to prove". Possible O(n(log n)²) upper bound via VLSI methods.
- p. 24: "an O(n²) bound on ropelength could be deduced from the Dowker code ... a claim appeared in [Buc]. But we do not see any way to make such an argument work."
- p. 22: Thurston norm of the three-fold link hard to compute.

## References worth following
- [BS] Buck, Simon, Thickness and crossing number of knots, Topol. Appl. 91 (1999) 245–257 (n^{3/4} lower bound, writhe bound).
- [CKS] Cantarella, Kusner, Sullivan, Tight knot values deviate from linear relation, Nature 392 (1998) 237.
- [FH] Freedman, He, Divergence free fields: energy and asymptotic crossing number, Ann. Math. 134 (1991) 189–229.
- [Dia] Diao, The lower bounds of the lengths of thick knots (preprint) (16π Cr ≤ Len(Len − 17.334)).
- [DEJvR] Diao, Ernst, Janse van Rensburg, Upper bounds on linking number of thick links, JKTR (2002) (k ≤ 12ℓ).
- [Sch1] Schnyder, Embedding planar graphs on the grid (1990); [dFPP] de Fraysseix–Pach–Pollack.
- [Joh] Johnston, An upper bound on the minimal edge number of an n-crossing lattice knot.
- [LSDR] Litherland, Simon, Durumeric, Rawdon, Thickness of knots, Topol. Appl. 91 (1999) 233–244.
- [GM] Gonzalez, Maddocks, Global curvature, thickness, and the ideal shapes of knots, PNAS 96 (1999).
- [Gro], [EWW] Gromov, Filling Riemannian manifolds; Ekholm–White–Wienholtz, Ann. Math. 155 (2002).
- [SDKP]/[Pie] Stasiak et al.; Pieranski (trefoil 32.66).

## Extraction notes
- Pages rendered: 2, 10, 11, 13, 15, 18, 22, 25, 26, 27. Text of Lemma 1–7 proofs abbreviated to idea lines; statements transcribed in full.
- All square roots restored by reading images of pp. 9, 13, 17, 22, 24, 25 (Thm 11, 19, 21 and Cor. 22 roots restored from consistent context; Thm 21 p. 20 and Cor. 22 p. 21 not imaged but equal to the visible Cor. 22 form on p. 22).
- ⚠ Fig. 7 caption: 4π(1+√2) printed as ≈ 33.34; arithmetic gives ≈ 30.34.
- ⚠ Theorem 19 is stated for PC(K); the p. 2 intro calls the numerical bound "4π + 2π√2 ≈ 6.83π ≈ 21.45" (consistent: 4π + 2π·1.4142 = 21.45).
- Cor. 22 is printed on p. 21 and the general χ_− form on p. 22 without its own number.
