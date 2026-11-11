# Klotz26tqq — Tight Bounds for Tight Links: Ropelength of T(Q,Q) torus links
- **Authors:** Alexander R. Klotz (Dept. of Physics and Astronomy, California State University, Long Beach)
- **Venue / year / identifiers:** arXiv:2603.02416v2 [math.GT], 13 Mar 2026
- **File:** papers/4_links/Klotz_2026_Ropelength_TQQ_torus_links_2603.02416.pdf   **Pages:** 15
- **Text layer:** partly garbled (formulas in Eqs. 1–36 scrambled; Eqs. 5–8, 14–18, 19–23 and Table I checked on page images; Appendix Eqs. 26–36 read from text layer only)

## Abstract
Ropelength, L, is a parameter characterizing the minimum contour length of a knot or link. There exist upper and lower bounds on ropelength with respect to crossing number, C, including a universal lower bound constraining L ≥ α_0 C^{3/4} for some constant α_0. There is currently an order-of-magnitude range for the value of α_0 between 1.105 and 10.76. In this work, we show that T(Q,Q) torus links can be constructed such that the upper bound is within a factor of 1.77 of the lower bound. We derive a stronger lower bound based on the convex hull around close-packed disks of approximately α_TQQ > √(8π√3) + (2π + √(2π(7√3 − 12))) Q^{−1/2} ≈ 6.60 + 7.61 Q^{−1/2}, significantly higher than the best universal lower bound of 1.105. We show that a link can be constructed without any free parameters or geometric optimization that, when Q is large, has a coefficient α_TQQ < 1.005 · 4π(5√5 − 8)/3 ≈ 13.39, and can be improved to 11.68 by solving a helical no-overlap constraint equation that requires a conjectural approximation. For Q up to 20 we construct links from smooth planar curves or toroidal helices minimized with respect to a small number of geometric parameters, that are between 6 and 60% greater in ropelength than the lower bound. Many such links can be annealed to within 10% of the lower bound using gradient descent. This represents significant progress towards developing sharp bounds on the ropelengths of specific classes of knots and links.
(⚠ The abstract's printed expression "8π√3 + (2π + √(2π + 7√3 − 12))Q^{−1/2}" is garbled in the text layer; the form above is as typeset in Eq. (8), p. 3. See ⚠ on 7.61 below.)

## Notation and conventions
- (p. 1) "Ropelength is a property characterizing the tightest possible embedding of a knot or link, typically expressed as the minimum contour length of a knot surrounded by a non-overlapping unit-thickness tube [1]." Unit-thickness tube = tube of radius 1 (so ropelength = length / radius; minimum centre-line distance between distinct strands ≥ 2, see Eq. 10 "minimum distance … greater than or equal to 2").
- L = ropelength (length of the specific construction used; p. 1: "we may use the term ropelength to refer to the smallest length achieved by a specific construction, rather than the ultimate tightest value which in most cases is unknown"); C = crossing number; α = L/C^{3/4} (p. 2: "We are interested in the ratio α = L/C^{3/4}"); α_0 = universal lower-bound constant; other subscripts for specific cases (α_iso, α_w, α_4, α_4D, α_5, α_5D, α_opt, α_TQQ).
- (p. 1) T(pQ,Q): p small natural number, P = pQ and C = pQ(Q−1). "each component wraps around the central hole of the torus once before closing with itself." T(Q,Q) is the p = 1 case; Q components each linked once with the other N = Q−1.
- N = number of other components a given component is linked with (hull of N unit disks); W(N) = Wegner lower bound for convex-hull perimeter of N unit disks; σ = π/√12 ≈ 0.91 hexagonal area fraction (p. 2).
- (p. 4) Toroidal helices: N helices evenly spaced on a cylinder of radius r and height H, repeated p times, wrapped to a torus of major radius R_0 = pH/2π; h = R_0 − r_o inner radius of the donut hole; effective constraining height H_c = 2π(R_0 − r_o) < H.
- "Radially constrained"/"vertically constrained" helix shells (p. 4). "Reverse Jenga" (p. 7): moving helices from outer shells to inner shells.
- Q = number of components = number of helices; T = number of shells in a concentric construction (Q ≈ T²·const).

## Numbered statements
None (no numbered theorems). Equations (1)–(36) listed below. Cited external theorems used: Cantarella–Kusner–Sullivan Theorem 10 and Theorem 11 [1] (quoted; see (1),(2)); Wegner inequality [17] (quoted).

## Key equations and quantitative claims outside numbered statements
Lower bound (p. 2–3).
- (1) (p. 2) L_{TQQ} > Q(4π + 2(Q−1)), 3 ≤ Q ≤ 6 — from CKS Theorem 10: a component linked with N others has length greater than 2π plus the minimum convex hull around N unit disks; "For N = 2, 3, 4, 5 the pushed minimal hulls have lengths of 4π + 2N". "This minimum length cannot be achieved without violating the no-overlap constraint, and beyond N = 5 the minimal hull cannot link with N copies of itself (e.g. Fig. 1b for N = 6)."
- (2) (p. 2) CKS Theorem 11: L_J > 2π + 2π√Lk.
- (3) (p. 2) L_{T_{pQ,Q}} > 2πQ(1 + √(p(Q−1))) ≈ 2π√p Q^{3/2}.
- (4) α_iso = 2πQ(1+√(p(Q−1)))/(pQ(Q−1))^{3/4} ≈ 2π/p^{1/4} + 2π/(p^{3/4}√Q) (garbled; as read). Greatest for p=1, small Q. For p=1 and large Q limiting value 2π ≈ 6.28, "a factor of 5.7 above the lower bound on α_0".
- (p. 2) hexagonal packing area fraction σ = π/√12 ≈ 0.91 increases limiting α by σ^{−1/2} ≈ 1.05. Wegner/Groemer packing [19].
- (5) Wegner inequality: W(N) ≥ √( 4π ( √12 (N−1) + (2−√3) ⌈√(12N−3) − 3⌉ + π ) ) (p. 3).
- (6) Lower bound: L_{T_{pQQ}} ≥ Q( 2π + √( 4π( √12 (p(Q−1)−1) + (2−√3) ⌈√(12p(Q−1)−3) − 3⌉ + π ) ) ).
- (7) α_w = [that expression]/(pQ(Q−1))^{3/4}.
- (8) ignoring the ceiling and expanding at large Q: α_w > √(8π)·(3/p)^{1/4} + (2π + √(2π(7√3−12))) / (√Q p^{3/4}) ≈ 6.60/p^{1/4} + 7.61/(√Q p^{3/4}). ⚠ With the printed closed form the second coefficient evaluates to 2π + √(2π(7√3−12)) ≈ 7.17, not 7.61 (not reproduced by me; transcribed as printed).
- (p. 3) Limit falls below universal 1.105 for p > 1271, below the author's conjectured 2 and 3.22 when p > 118 and p > 17. For p=1: limit √(8π√3)·… "√(8π√3) ≈ 6.60, six times the lower bound of α_0" (value given as 6.60). "The bound falls below 10 for Q > 6 and below 8 for Q > 28. No investigation has produced a knot or link with α < 10, so the tightest known links must be made 40% tighter to show this bound is sharp, which it likely is not."
- (p. 3) Caveat: the lower bound "may not apply when p > 1 as the formal derivation … involves a certain number of punctures of the surface of a cone by the link [1], a constraint which is not guaranteed to be satisfied. The isoperimetric bound should be treated as more rigorous in these cases."
- (p. 3) "The Wegner formula likely underestimates the minimal hull perimeter for finite N, and indeed it cannot be achieved for one in twenty-four numbers, beginning with 121 [19]. Numerical estimates of the minimal convex hulls around unit disks [20] suggest values … on the order of 5% greater than the Wegner formula" — not used for rigorous bound.
- (p. 1) Literature values quoted: universal lower bound α_0 ≥ (11/4π)^{−3/4} ≈ 1.105 [12] (author conjectured ≥ 3.22 [13]); alternating knots L > C/56 [10]; T(P,2) torus knots/links L < 7.31C [11]; general upper bound C log^5(C) [5]; non-alternating T(P,Q) have upper bounds ∝ C^{3/4} [14,15]. Abstract: α_0 range "between 1.105 and 10.76".
- (p. 2) Previous work [16] (Klotz–Thompson): L ≈ 12C^{3/4} up to Q = 39 for p=3; large links with α_{T_{3Q,Q}} < 19.11; asymptotic lower bound for such a construction ≈ 5 (factor 4 gap).

Upper-bound constructions (pp. 4–8).
- (9) helix i: x = (R_0 + r cos(pθ)) cos(θ + 2πi/N), y = (R_0 + r cos(pθ)) sin(θ + 2πi/N), z = r sin(pθ) (p. 4).
- Helix length L = √(H² + (2πr)²); toroidal helix slightly longer.
- (10) non-overlap on same cylinder: d = √( 2r²(1 − cos(2π(θ_Δ + 1/N)... )) + (H θ_Δ/2π)² ) ≥ 2 (garbled in text; see formula as printed in page image of p. 4, not re-verified), −π ≤ θ_Δ ≤ π, "transcendental constraint equation [21]". Single N-helix ideal solution (large N): r = 2N/π (⚠ text shows r = 2N/π; and later "ideal radius ≈ 0.45N such that r_ideal ≈ 2.22N" — as printed these two statements disagree: 2N/π ≈ 0.64N vs 0.45N vs 2.22N) and H = 2πr = √(8N)? (text-layer reads "H = 2πr = √(8N)"; later p. 5 says "ideal height of an N-helix, √(8N)"). ⚠ p. 4–5 ideal-helix values garbled and not reproducible from text layer; do not rely.
- (p. 4) Doubling construction: two copies of T(Q,Q), one rotated/translated and Hopf-linked through the donut hole of the other gives a link with ≥ 2L and 4C crossings (potentially reducing α by factor √2). "These links are not torus links for p>1." For p=1 with a torus link and its mirror image result differs: two Hopf links → T(4,4) = L12n2206; Hopf link with its reflection → L12n2209. Donut linking requires R_o ≥ 2r_o + 2.
- 4-increment construction (p. 5): concentric shells of N = 4, 8, 12, 16,… helices at radii r = 2, 4, 6, 8,…; shell has 0.9 of ideal number so radially underconstrained; T shells, outer radius r_o = 2T, N_o = 4T; only outer shell constrained.
- (11) H_c/N_o · cos(arctan(H_c/(πN_o))) ≥ 2 ⇒ H_c ≥ 2π N_o/√(π² − 4) ≈ 2.59 N_o. "approximately 92% the ideal height of an N-helix, √(8N)". Full transcendental solution gives 2.628 N_o.
- (12) R_0 = H_c/2π + r_o = (1/√(π²−4) + 1/2) N_o ≈ 0.913 N_o.
- Q = Σ multiples of 4 up to 4T ⇒ T ≈ √(Q/2), N_o ≈ √(8Q) (text).
- (13) H_0 = 2πR_0 = 2π(1/√(π²−4) + 1/2)√(8Q) ≈ 16.22√Q ≡ κ√Q.
- (14) L_4 = Σ_{i=1}^T 4i √(H_0² + (2π r_i)²) = Σ_{i=1}^{√(Q/2)} 4i √(κ²Q + (4πi)²).
- (15) L_4 ≈ (Q^{3/2}/(12π²)) ( (κ² + 8π²)^{3/2} − (κ² + 16π²/Q)^{3/2} ).
- (16) α_4 = (1/12π²)((κ² + 8π²)^{3/2} − κ³) ≈ 17.36 — "a factor of 2.63 above the lower bound".
- (p. 6) Doubling a T(pQ,Q) link: crossing number becomes 2pQ(Q−1) + 2Q² (each component of each torus has Lk = 1 with each of the other torus); for p=1 crossing number quadrupled; α can decrease only if major radius does not increase by more than a factor √2; will not reduce α if p > 3. For p>1 result subject to lower bound of T((p+1)Q,Q).
- (17) (p. 6) With major radius 4T = √(8Q)... (factor ≈ 1.095) so height term 2π√8: α_4D = (4π/3)(5√5 − 8) ≈ 13.32, "at most a factor of 2.019 above the lower bound".
- (p. 6) Toroidal lengthening: major radius ≈ 1.81 × minor radius of outermost helices gives 1.5% excess in first construction; in double torus major = 2 × minor, increase of largest helix 1.11%. (18) numerical limit of ratio (toroidal/straight helix lengths) ≈ 1.0042 ⇒ ratio converges to 13.38. "If a firm upper bound is desired, the correction falls below 1.005 when T ≥ 10." Single 4-incremented helix correction 0.58%.
- (p. 6–7) 5-increment: single torus asymptotic α_5 = 19.2; linked tori (fit through own hole when T > 4) coefficient 13.59, correction 0.4% ⇒ α_5D = 13.64. Without correction for partially filled outer shells, efficiency worse; with it 5-increment more efficient than 4-increment until Q ≈ 23800 (566 million crossings); below twice the lower bound until Q ≈ 15000 (225 million crossings), or Q ≈ 2380 if only isoperimetric bound assumed.
- (p. 7) "Reverse Jenga": 4-incremented torus needs only about 8.7% of shells or 16.7% of helices moved inward to fit through its own donut hole without increasing length; limiting ratio below 12.27; "the lower 91% of shells can accommodate an additional 21% more helices."
- (19) N_a = hπr/√(h² + r²) (approximate max helices in a shell; h = donut-hole radius = 2T) (p. 7).
- (20) N_max = ⌊N_a − ε⌋, with π(r − (arcsin(1/r))^{−1}) ≤ ε ≤ 2π − 6 (p. 7). "The correction is largest for an asymptotically tall helix of radius 2, where N_a = 2π but the maximum is 6." (Appendix proves only partially, see below.)
- (21) L_opt ≈ ∫ 8π² i T √((4T²+i²)/(T²+i²)) di = 2π²[√40 − log(27) + 6 tanh^{−1}(√(2/5)) − 4] T³ ("cubic coefficient approximately 69") — as read from page image.
- (22) Q = Σ 2πiT/√(i²+T²) ≈ 2πT(√2 T − √(1+T²))… ≈ 2π(√2 − 1)T² ≈ 2.6T² (text); compared with 2.5 for the 5-increment system.
- (23) α_opt = L_opt/C^{3/4} = √((7+5√2)π) · (√10 − 2 + 3( tanh^{−1}√(2/5) − tanh^{−1}(1/…)) ) ≈ 11.64 (the argument of the second tanh^{−1} is in small print, not unambiguously read). Toroidal correction 1.00385 ⇒ upper bound for large links 11.68; outer shell has R_0 = 2r_o so 1.011 "may be used as a universal overestimate". "The upper bound is 1.77 times the Wegner bound and 1.86 times the isoperimetric bound." Requires assumption that the cubic approximation to the transcendental constraint holds; "supported by numerical tests up to T = 100 (Q = 52203, C ≈ 2.7 × 10^9) tested with 1000 points per helix." Covers specific Q ≈ 5.2T²; outer helices can be removed to reach desired Q.
- (p. 8) ⚠ Text refers to "Figure 2 shows the coefficients from the doubled 4-increment, 5-increment, and optimal constructions" but these are in Fig. 3 (caption p. 8).

Low-Q results (pp. 8–11).
- (p. 9) Tried Q = 3–20 (Q=2 trivial); tightened with Ridgerunner [7]. "links could be constructed quite close to the lower bounds for Q = 3 − 6. Beyond Q = 6, the lower bound does not appear to be particularly constraining, with constructed links having an α between 12 and 13 (which continues out to Q = 60), and tightened links with α between 11 and 12. The ratio with respect to the lower bound generally increases towards roughly 1.5." Author suspects "the true bound for this type of link is closer to 10, and has much weaker Q-dependence." If Kallrath et al. [20] hulls are optimal, links would move ≈ 5 percentage points towards the lower bound.
- Planar curves (p. 9–11): Möbius energy generally minimized by planar convex curves [23]; Q congruent linked circles: start with Q unit circles in the XZ plane, rotate i-th about Z by φ = 2πi/Q, translate by ρ along r̂_i = ⟨cos φ, sin φ, 0⟩ (0<ρ<1), tilt about r̂_i by ψ (0<ψ<π/2); ropelength 2π·Q/2·d_{i,i+1}? (text "2π Q/2 di,i+1"; garbled: = Q·(2π)·(d_{i,i+1}/2), d = minimum distance between sequential circles). Minimizing gives ρ ≈ 1/2, ψ ≈ 5π/18, L ≈ 6.6C, "comparable to that of a Q-helix". Both Q-helices and linked circles asymptotically linear L ≈ 6.6C.
- (24) gibbous curve: x(θ) = γ(cos θ + δ cos 2θ), y = sin θ; γ of order 1, δ of order 0.1; convex for δ < 1/4. Four parameters minimised: displacement, inclination angle, x-scale γ, Fourier coefficient δ; empirically L ≈ 5.53C for gibbous links (linear in C, inefficient for large links). Tight links for Q = 3, 4 (min radius of curvature ≥ 1 verified); T(5,5) from four gibbous curves around a central rounded square (two extra parameters). Best case T(3,3) from gibbous curves within 7% of the lower bound, others within 25%.
- Toroidal helices low Q (p. 11): shell radii 2,4,6,… with major radius free; configurations normalised by minimum distance between helices; "T(14,14) … formed from two copies of a link formed by a circle surrounded by six helices, achieving α_{T14,14} = 11.53"; for p = 2 and 3, α typically 11–12 up to Q = 60 "slightly lower than for T(Q,Q) knots as expected"; p = 3 values below those in [16].
- Ridgerunner (p. 11): "The tightest T(3,3) link (6^3_3/L6n1) found by Ashton et al. [7] is only 1.3% above the lower bound." First computations run on best constructed configurations with 200 vertices per component; T(9,9) outlier needed 300 vertices per component; for Q ≥ 6 some ideal configurations adopted (Q−2)-fold symmetry. Ridgerunner lengths ≈ 10% smaller than constructed; many within 10% of lower bound; ratio to lower bound increases to ≈ 1.4; "These results do not necessarily imply that these values are close to the true ropelength, as the computations are sensitive to both initial conditions and local minima."
- (p. 11) Lowest α found (beyond scope): 10.19 for a T(20,10) link; previously 10.02 for T(24,19) [24, a tweet]; "Several failed attempts were made to find a knot or link with α < 10." Preliminary: links made from linking a torus link with its mirror image have ≈ 15% greater ropelength than un-mirrored version.
- (p. 12) Conclusion: constructed knots within factor 1.5 of the lower bound below 180 crossings, annealed to within 10% of the lower bound up to 42 crossings, within a factor 1.77 for asymptotically large crossing number (requires the Eq. (20) approximation).

Appendix (pp. 13–15).
- (25) Toroidal correction ratio ∫_0^{2π}√(r² + p^{−2}(R − r cos θ)²)dθ / (2π√((2πR/p)² + (2πr)²)/2π) ... = ∫√(1 + p^{−2}(R/r − cos θ)²)dθ / (2π√((R/rp)² + 1)) as a function of R/r (garbled). Computed by generating toroidal helices with 10,000 vertices and measuring arc length discretely. "The excess decreases with the negative fourth power of the ratio." "with a ratio of 1 a toroidal helix is self-intersecting for p > 1."
- (26) d²(θ_Δ,N,r,h) = 2r²(1 − cos(2π(θ_Δ + 1/N)))… + h²θ_Δ² (garbled, as printed); (27) N_a = πhr/√(h²+r²); (28)–(33) cubic-approximation analysis. Tall-cylinder limit with ε=1: lim d²_c = 4r² sin²(π/(πr − 1)...) ≈ 4 + 8/(πr) (always > 4, → 4 as r → ∞, 5.2 at r = 2); isotropic case h=2 evaluates ≈ 6.38; lim_{h→∞} d²_c(R_0) ≈ 4 + 8√2/(πh) (as read).
- (34) π(r − (arcsin(1/r))^{−1}) ≤ ε ≤ 2π − 6; minimal value reached at r=2 when N_a = 2π and actual max is 6. With ε=0: tall limit d_c² ≈ 4 − 4/(3r²) < 4 (35); isotropic d_c² ≈ 4 − 68/(45h⁴) < 4 (36) — "This suggests that the constraint is not satisfied for ε = 0." "This is the extent of our proof, which is incomplete because we have not shown that the full constraint equation is satisfied, only the cubic approximation." Numerically, substituting N_a − (2π − 6) and r = 2 into the full constraint equation satisfies it for all tested h, with limiting squared distance ≈ 4 + 6.2/h².

## Methods / algorithms
1. (p. 2–3) Lower bound: model each component of T(pQ,Q) as the minimal convex hull around p(Q−1) unit disks (CKS Thm 10 / Thm 11), pushed out by 2π (Fig. 1b); use Wegner's inequality [17] for hull perimeter of N disks; multiply by Q components.
2. (p. 4–6) Zero-parameter construction: concentric shells of cylindrical helices (4 more helices per shell: 4, 8, 12,…; radii 2, 4, 6,…), height set by constraint (11) on the outer shell using the donut-hole circumference H_c, closed into a torus with major radius increased by outer radius (12); sum lengths of all helices (14)–(16). Then double: link two copies through each other's holes (requires major radius ≈ 1.095× larger) → T(2Q,2Q) with α_4D (17); toroidal-lengthening correction (18).
3. (p. 6–7) 5-increment variant; "reverse Jenga" reallocation.
4. (p. 7–8) Optimal solution: shell i at radius 2i, major radius = twice minor radius of the T-th shell (4T), as many helices per shell as fit, N_max = ⌊N_a − ε⌋ (19)–(23); numerical overlap tests up to T = 100 with 1000 points per helix.
5. (p. 9–11) Small Q: construct from gibbous planar curves (4 parameters) or toroidal helices (optimised with small number of parameters, normalised by minimum inter-helix distance rather than a hard constraint, "more akin to knot energy minimization"); estimate configuration for Q+1 by adding a helix to the outer layer or a new layer and reverse-Jenga; seconds per configuration.
6. (p. 11) Gradient descent: Ridgerunner [7] started from best constructed configuration (200 vertices/component; 300 for T(9,9)), also symmetric initial conditions.

## Tables
**Table I (p. 13).** "Table of toroidal corrections for the length of a helix as a function of the major to minor radius ratio." (Verified against page image for rows 1–2.3 and 3–9.5; remaining rows read from text layer, which matched the image in all rows seen.) Columns: Ratio R/r, then correction factor for p=1, 2, 3. (⚠ printed table has no rows between 2.5 and 3 or between 10 and 20.)

| Ratio | p = 1 | p = 2 | p = 3 |
|---|---|---|---|
| 1 | 1.06998 | 1.039895 | 1.022286 |
| 1.1 | 1.058092 | 1.036947 | 1.021417 |
| 1.2 | 1.04807 | 1.034065 | 1.020521 |
| 1.3 | 1.039731 | 1.031288 | 1.019608 |
| 1.4 | 1.032854 | 1.028642 | 1.018687 |
| 1.5 | 1.027218 | 1.026147 | 1.017768 |
| 1.6 | 1.022615 | 1.023815 | 1.016856 |
| 1.7 | 1.018859 | 1.021651 | 1.015959 |
| 1.8 | 1.015793 | 1.019657 | 1.015083 |
| 1.9 | 1.013286 | 1.017828 | 1.014232 |
| 2 | 1.011229 | 1.016158 | 1.013409 |
| 2.1 | 1.009536 | 1.014639 | 1.012617 |
| 2.2 | 1.008137 | 1.013262 | 1.011859 |
| 2.3 | 1.006976 | 1.012016 | 1.011136 |
| 2.4 | 1.006008 | 1.010891 | 1.010448 |
| 2.5 | 1.005197 | 1.009876 | 1.009795 |
| 3 | 1.0026752 | 1.006131 | 1.007052 |
| 3.5 | 1.001501 | 1.003911 | 1.005065 |
| 4 | 1.000902 | 1.002572 | 1.00366 |
| 4.5 | 1.0005727 | 1.001743 | 1.002672 |
| 5 | 1.0003803 | 1.001215 | 1.001975 |
| 5.5 | 1.000262 | 1.000869 | 1.001481 |
| 6 | 1.0001863 | 1.000635 | 1.001125 |
| 6.5 | 1.0001359 | 1.000474 | 1.000866 |
| 7 | 1.0001015 | 1.000361 | 1.000676 |
| 7.5 | 1.0000773 | 1.000279 | 1.000534 |
| 8 | 1.0000598 | 1.000218 | 1.000426 |
| 8.5 | 1.0000471 | 1.000174 | 1.000344 |
| 9 | 1.0000375 | 1.00014 | 1.00028 |
| 9.5 | 1.0000303 | 1.000113 | 1.00023 |
| 10 | 1.0000247 | 1.000093 | 1.000191 |
| 20 | 1.0000015 | 1.000006 | 1.000013 |

(Rows 2.4–2.5 and 10, 20 from the text layer only.)

## Figures
- **Fig. 1 (p. 3)** — "a. Diagram of a T(7,7) link. b. The shape of the shortest curve that can be part of a unit-thickness T(7,7) link, with its bold centerline pushed a distance of 1 from the minimal convex hull around 6 unit disks. The lower bound arises from assuming that each component of a T(Q,Q) link is the minimal convex hull of Q−1 unit disks. c. Diagram of a T(92,92) link. d. An estimate of the minimal hull around 91 disks. For large enough Q the minimal hull approximates a circular curve around a hexagonal packing." *What it shows:* (a) rosette-like projection of 7 interlaced curves; (b) a rounded pentagon-like curve around 6 touching disks (5 around 1); (c) dense disc of lines; (d) ~91 packed disks inside a near-circular curve. Image: ../figures/Klotz26tqq/p03.png
- **Fig. 2 (p. 5)** — "Construction of an efficient T(Q,Q) link from concentric helices. a. The arrangement of helices, incrementing 4 per shell. b. The vertical concentric helices. c. A torus formed from wrapping the helix, shown with thinner curves. d. Two copies of the torus are increased in major radius and linked through each other, shown with unit thickness curves. The visible extra space highlights the unconstrained nature of the helices." Image: ../figures/Klotz26tqq/p05.png
- **Fig. 3 (p. 8)** — "a. Three-quarter coefficients for the T(Q,Q) links formed by doubly-linked tori of concentric helices incremented by 4 and 5 per shell, as well as the optimal construction. The two curves in each color show the best- and worst-case scenarios … Kinks correspond to configurations below which the major radius must be increased to allow for double torus linking. Limiting values are shown as dashed lines without the helical correction and the lower bound is shown for comparison. b. Shows the same data as a ratio relative to the lower bound." *What it shows:* α (from ≈6 up) vs number of helices Q on log axis (10^0–10^8): curves converging to limits ≈ 13.3 (4-increment), ≈13.6 (5), ≈11.6 (optimal); lower bound curve falls toward 6.6; right panel ratio axis 1.5–… Image: ../figures/Klotz26tqq/p08.png
- **Fig. 4 (p. 9)** — "a. Three-quarter coefficients for the best constructed T(Q,Q) links for Q from 2 to 20, color-coded by their construction method. Values reached by gradient descent are shown in red and the lower bound is shown for comparison. The dashed line corresponds to the best large-Q upper bound of 11.68. The red datum at Q = 3 is from Ashton et al. [7]. b. The same data as a ratio relative to the lower bound. The solid black line below the data indicates the ratio for the gradient descent data assuming that numerically optimized convex hulls minimal, and the green line indicates the ratio for the constructed links assuming the isoperimetric inequality. The large-Q ratio of 1.77 sets the upper limit of this plot." Image: ../figures/Klotz26tqq/p09.png
- **Fig. 5 (p. 10)** — "a. Typical shape of a gibbous curve that can be used to construct links. b-d. Optimal links for Q = 3, 4, 5 constructed from gibbous curves, shown with reduced tube radius. d. includes a rounded square as the central curve. e-g. T(20,20) links formed by optimizing a 20-helix (e), congruent circles (f), and gibbous curves (g), shown with unit tube radius." Image: ../figures/Klotz26tqq/p10.png
(Figure data points in Figs. 3, 4 are not tabulated in the paper; no numeric values can be read beyond those quoted in the text.)

## Stated limitations, open problems, future work
- Lower-bound derivation may not apply for p > 1 (cone-puncture condition not guaranteed); isoperimetric bound more rigorous there (p. 3).
- Wegner bound likely underestimates minimal hull perimeter for finite N (p. 3); conjectural 5% higher values not used.
- 11.68 requires the conjectural cubic-approximation assumption on the transcendental no-overlap equation; Appendix proof "is incomplete" (pp. 7, 12, 15).
- Ridgerunner results sensitive to initial conditions and local minima; "not necessarily … close to the true ropelength" (p. 11).
- Future: "toroidal helices with more complex harmonic modes", "minimizing ropelength in the Fourier rather than Cartesian domain", winding a dense helical cylinder into a non-alternating torus knot; Hopf-link-of-smaller-links construction for other knots (p. 12).
- Author suspects true bound for T(Q,Q) is "closer to 10" (p. 9).

## References worth following
- [1] Cantarella, Kusner, Sullivan, On the minimum ropelength of knots and links, Invent. Math. 150 (2002) (Theorems 10, 11).
- [17] Wegner, Über endliche Kreispackungen in der Ebene, Studia Sci. Math. Hungar. 21 (1986).
- [19] Böröczky, Ruzsa, Note on an inequality of Wegner, Discrete Comput. Geom. 37 (2007).
- [20] Kallrath et al., Near optimal minimal convex hulls of disks, J. Global Optim. (2021).
- [7] Ashton, Cantarella, Piatek, Rawdon, Knot tightening by constrained gradient descent, Exp. Math. 20 (2011) (Ridgerunner).
- [16] Klotz, Thompson, Ropelength-minimizing concentric helices and non-alternating torus knots, Proc. R. Soc. A 481 (2025).
- [21] Huh, Hong, Kim, No, Oh, Best packing of identical helices, J. Phys. A 49 (2016).
- [12] Buck, Four-thirds power law for knots and links, Nature 392 (1998); [6] Diao, The lower bounds of the lengths of thick knots, JKTR (2003); [5] Diao–Ernst–Por–Ziegler, ropelengths almost linear in crossing number (2019); [15] Diao–Ernst, The complexity of lattice knots, Topology Appl. 90 (1998) (cited for T(P,Q) C^{3/4} upper bound); [13] Klotz, arXiv:2507.20903.

## Extraction notes
- Lattice relevance: only a side citation — [15] Diao–Ernst "The complexity of lattice knots" cited for C^{3/4}-type upper bounds on torus knots (p. 1). Otherwise continuous ropelength (not lattice).
- Search/optimisation relevance: construction + Ridgerunner gradient-descent tightening; "reverse Jenga" greedy helix reallocation; no learning methods.
- Acknowledgements (p. 12) state that after v1 the author was contacted by T. Tao with ChatGPT's analysis of the preprint; feedback incorporated in v2 (stated assumptions clarified, transcription errors corrected, helical-correction table updated).
- Eq. (10), (25), (26)–(33) in the text layer are garbled and were not all verified against images; they are paraphrased. Eq. (6)–(8), (14)–(18), (19)–(23) and Table I (first 2.3 rows, rows 3–9.5) verified on images.
- ⚠ 7.61 coefficient (see Eq. 8). ⚠ Fig. 2/Fig. 3 reference mismatch (p. 8). ⚠ ideal-helix radius/height statements p. 4–5 mutually inconsistent as read.
