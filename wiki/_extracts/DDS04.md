# DDS04 — Quadrisecants give new lower bounds for the ropelength of a knot
- **Authors:** Elizabeth Denne, Yuanan Diao, John M Sullivan
- **Venue / year / identifiers:** Geometry & Topology 10 (2006) 1–26 (arXiv version, file name math0408026; "fonts, pagination and layout may vary from GT published version"); DOI 10.2140/gt.2006.10.1; published 25 February 2006; received 27 September 2005, revised 27 December 2005. MSC 57M25; 49Q10, 53A04.
- **File:** papers/3_analytic_bounds/Denne-Diao-Sullivan_2004_Quadrisecants_ropelength_lower_bounds_math0408026.pdf   **Pages:** 26
- **Text layer:** ok except square roots and some fractions (checked on p. 7 image; p. 20–22 constants re-derived arithmetically)

## Abstract
Using the existence of a special quadrisecant line, we show the ropelength of any nontrivial knot is at least 15.66. This improves the previously known lower bound of 12. Numerical experiments have found a trefoil with ropelength less than 16.372, so our new bounds are quite sharp.

## Notation and conventions
- **Ropelength convention: LENGTH / DIAMETER.** "the thickness τ(K) of a space curve K is defined by Gonzalez and Maddocks [11] to be twice the infimal radius r(a,b,c) of circles through any three distinct points of K ... When K is C¹ ... τ(K) is the supremal diameter of such a tube that remains embedded. We note that in the existing literature thickness is sometimes defined to be the radius rather than diameter of this thick tube. We define ropelength to be the (scale-invariant) quotient of length over thickness." (p. 1). So a unit-thickness knot has a tube of diameter 1 (radius 1/2), curvature ≤ 2 (p. 4), and its ropelength equals its length. ⚠ downstream: numbers here are HALF of the corresponding length/radius numbers in CKS01 (e.g. CKS01's 21.45 and conjecture 30.51 become 10.726 and 15.25 here, p. 2, 22). "No knot can be tied in one foot of one-inch rope" corresponds to ropelength > 12 here (p. 2).
- n-secant: oriented line meeting K in ≥ n components; quadrisecant abcd = ordered 4 points along a line; midsegment = bc; r := |a−b|, s := |b−c|, t := |c−d|; ℓ_{ab} = length of arc γ_{ab}; |a−b| = spatial distance (p. 3, 7). Orient K so b ∈ γ_{ad} (p. 4).
- Direct/reversed trisecant (p. 3). Quadrisecant types by dihedral order of the four points along K: simple (abcd), flipped (abdc), alternating (acbd) (p. 3–4).
- Unit thickness: B(a) = open unit ball centered at a (p. 4).
- f(r) := √(r²−1) + arcsin(1/r) for r ≥ 1; g(r) := 2π − 2 arcsin(r/2) for r ≤ 2, π for r ≥ 2 (p. 7, 20); minimum length function m(r,s,θ) (p. 7).
- Essential / strongly essential arc, secant, quadrisecant (Kuperberg), defined via knotted Θ-graphs and homotopy class h of a parallel δ (p. 9–13). Essential quadrisecant: for simple, all three secants ab, bc, cd essential; flipped: ab and cd essential; alternating: bc essential (p. 12).

## Numbered statements
- **Lemma 3.1 (p. 5).** Let K be a knot of unit thickness. If a ∈ K, then B(a) contains a single unknotted arc of K; this arc has length at most π and is transverse to the nested spheres centered at a. If ab is a secant of K with |a−b| < 1, then the ball of diameter ab intersects K in a single unknotted arc (either γ_{ab} or γ_{ba}) whose length is at most arcsin|a−b|. (Proof via Schur's lemma.) (Printed bound arcsin|a−b|, confirmed on p. 5 image.)
- **Corollary 3.2 (p. 5).** If K has unit thickness, a, b ∈ K and p ∈ γ_{ab} with a, b ∉ B(p) then the complementary arc γ_{ba} lies outside B(p). (∉ confirmed on p. 5 image; the text layer drops the slash.)
- **Lemma 3.3 (p. 5).** Let K be a knot of unit thickness. If a ∈ K, then the radial projection of K∖{a} to the unit sphere ∂B(a) is 1-Lipschitz. (Proof: local Lipschitz constant (sin θ)/d = 1/(2r) ≤ 1.)
- **Corollary 3.4 (p. 5).** Suppose K has unit thickness, and p, a, b ∈ K with p ∉ γ_{ab}. Let ∠apb be the angle between a−p and b−p. Then ℓ_{ab} ≥ ∠apb. In particular, if apb is a reversed trisecant in K, then ℓ_{ab} ≥ π.
- **Theorem 3.5 (p. 6).** The ropelength of a knot with a simple, flipped or alternating quadrisecant is at least π, 2π or 3π, respectively.
- **Lemma 4.1 (p. 7).** If abcd is a flipped quadrisecant for a knot of unit thickness, then the midsegment has length s ≥ 1. Furthermore if r ≥ 1 then the whole arc γ_{ca} lies outside B(b); similarly if t ≥ 1 then γ_{bd} lies outside B(c).
- **Lemma 4.2 (p. 7).** If abcd is an alternating quadrisecant for a knot of unit thickness, then r ≥ 1 and t ≥ 1. With the usual orientation, the entire arc γ_{da} thus lies outside B(b) ∪ B(c). If s ≥ 1 as well, then γ_{ac} lies outside B(b) and γ_{bd} lies outside B(c).
- **Lemma 4.3 (p. 8).** Any arc γ from a to b, staying outside B(p), has length at least m(|a−p|, |b−p|, ∠apb).
- **Corollary 4.4 (p. 8).** If a and b lie at distances r and s along opposite rays from p (so ∠apb = π) then the length of any arc from a to b avoiding B(p) is at least f(r) + f(s) = √(r²−1) + arcsin(1/r) + √(s²−1) + arcsin(1/s).
- **Lemma 4.5 (p. 9).** Let abcd be an alternating quadrisecant for a knot of unit thickness (usual orientation), r, s, t as above. Then ℓ_{da} ≥ f(r) + s + f(t). The same holds if abcd is a simple quadrisecant as long as r, t ≥ 1.
- **Lemma 5.1 (p. 10).** In a knotted Θ-graph α∪β∪γ, the triple (α,β,γ) is strongly essential iff (γ,β,α) is.
- **Remark 5.2 (p. 11).** ε-perturbation in the definition makes the set of essential secants closed.
- **Theorem 5.3 (p. 12).** If a, b ∈ K and both γ_{ab} and γ_{ba} are inessential, then K is unknotted. (Dehn's lemma.)
- **Theorem 5.4 (p. 13) (Kuperberg).** If K is a nontrivial knot parameterized by a generic polynomial, then K has an essential quadrisecant.
- **Lemma 6.1 (p. 13).** Let K be a knot of thickness τ > 0, and K' a C¹ knot close to K (corresponding points within ε < τ/4, tangent vectors within angle π/6). Then K and K' are ambient isotopic, each point moving by < ε.
- **Proposition 6.2 (p. 14).** If the C^{1,1} knots K_i have essential arcs γ_{a_i b_i}, and K_i → K in C¹ to a thick limit knot, a_i → a, b_i → b, then γ_{ab} is essential for K.
- **Corollary 6.3 (p. 14).** Every nontrivial C^{1,1} knot has an essential quadrisecant.
- **Theorem 7.1 (p. 15).** Suppose γ_{ac} is in the boundary of the set of essential arcs for a knot K. Then K must intersect the interior of segment ac, and in fact there is some essential trisecant abc.
- **Lemma 8.1 (p. 17).** If secant ab is essential in a knot of unit thickness then |a−b| ≥ 1, and if arc γ_{ab} is essential then ℓ_{ab} ≥ π.
- **Lemma 8.2 (p. 18).** If γ_{ab} is an essential arc in a unit-thickness knot and |a−b| < 2, then ℓ_{ab} ≥ 2π − 2 arcsin(|a−b|/2).
- **Corollary 8.3 (p. 19).** If γ_{ab} is an essential arc in a knot K of unit thickness, then ℓ_{ab} ≥ g(|a−b|).
- **Lemma 9.1 (p. 20).** For r ≥ 1: (1) the minimum of f(r) is π/2, at r = 1; (2) the minimum of f(r) + g(r) is 7π/6 + √3 > 5.397, at r = 2; (3) the minimum of g(r) + r is π + 2 > 5.141, at r = 2; (4) the minimum of 2f(r) + g(r) + r is just over 9.3774, at r ≈ 1.00305. (⚠ the text layer printed "7π/6 + 3"; with √3: 3.665 + 1.732 = 5.397 matches ">5.397"; also p. 19 gives π + f(2) = 7π/6 + √3.)
- **Theorem 9.2 (p. 20).** A knot with an essential simple quadrisecant has ropelength at least 10π/3 + 2√3 + 2 > 15.936. (Check: 10.472 + 3.464 + 2 = 15.936.)
- **Theorem 9.3 (p. 21).** A knot with an essential flipped quadrisecant has ropelength at least 10π/3 + 2√3 > 13.936. (Check: 10.472 + 3.464 = 13.936.)
- **Theorem 9.4 (p. 21).** A knot with an essential alternating quadrisecant has ropelength at least 15.66. (Proof: ≥ 2f(r)+2f(s)+g(s)+s+2f(t) ≥ 2π + 9.377 > 15.66.)
- **Theorem 9.5 (p. 22).** Any nontrivial knot has ropelength at least 13.936. (Worst of the three types.)
- **Theorem 9.6 (p. 22) (Denne's thesis [5]).** Any nontrivial C^{1,1} knot has an essential alternating quadrisecant. *Quoted.*
- **Corollary 9.7 (p. 22).** Any nontrivial knot has ropelength at least 15.66.
- **Lemma 10.1 (p. 23).** Suppose L is a link, and A is a component not split from the rest. Then for any a ∈ A, there is a trisecant aba' where b lies on another component. If L has unit thickness, then A has length at least 2π.
- **Corollary 10.2 (p. 23).** A nonsplit link with k components has ropelength at least 2πk. (Sharp for the tight Hopf link; length/diameter convention.)
- **Proposition 10.3 (p. 23) (Pannwitz).** If A and B are disjoint generic polygonal knots, linked (neither homotopically trivial in the complement of the other), then A ∪ B has a quadrisecant line intersecting them in the order ABAB. *Quoted.*
- **Proposition 10.4 (p. 23) (Kuperberg).** A generic nontrivial link has an essential quadrisecant. *Quoted.*
- **Theorem 10.5 (p. 24).** Every nontrivial C^{1,1} link has an essential quadrisecant.
- **Theorem 10.6 (p. 24).** Let L be a link of unit thickness with an essential quadrisecant Q. If Q has type AAAB, AABA, ABBA or ABCA, then the length of component A is at least 7π/3 + 2√3, 8π/3 + 1 + √3, 2π + 2 or 2π + 2, respectively. (Checked: AAAB = 2(7π/6+√3); AABA = (7π/6+√3) + (π/2+1) + π.) No link classes known to be guaranteed to have these types (p. 24).

## Key equations and quantitative claims outside numbered statements
- p. 1–2: Previously known lower bounds: 12 (Diao [8], "no knot can be tied in one foot of one-inch rope", rigorous); 10.726 [4] (CKS01 21.45 divided by 2); new: 15.66.
- p. 2 (numerical): Pieranski [17], Sullivan [19], Rawdon [18]: minimum ropelength for a trefoil slightly less than 16.372; another tight trefoil with different symmetry ≈ 18.7; tight figure-eight "just over 21".
- p. 2: worst of the three quadrisecant-type bounds is 13.936 (Thm 9.5); with alternating-type existence (Denne) the bound becomes 15.66.
- p. 22: 15.66 is better than the conjectured 15.25 from [4, Conjecture 26] (= 30.51/2); numerical trefoils are "no more than 5% greater than our bound" (16.372/15.66 ≈ 1.045). The bound cannot be sharp: a curve C¹ at b cannot achieve both bounds for ℓ_{cb} and ℓ_{bd} when s ≈ 1.003; a careful tangent analysis might give slightly better.
- p. 6: any closed curve has ropelength ≥ π (total curvature ≥ 2π); π bound for simple quadrisecants sharp (curves near a round circle).
- p. 21: Thm 9.2 minimisers r = s = t = 2; Thm 9.4 minimisers r = t → 1, s ≈ 1.00305.
- p. 23: tight Hopf link: each component length 2π in this convention (unit diameter).
- p. 8–9: formula f(r)+f(s) also appears in the geometric dilation papers [9, 10]; distortion of knotted curve > 4 [6].

## Methods / algorithms
1. (p. 4) Rescale K to unit thickness (diameter 1).
2. (p. 5–6) Local thickness lemmas (3.1–3.4): balls of radius 1 contain one arc; radial projection 1-Lipschitz; reversed trisecant ⇒ arc ≥ π.
3. (p. 7–9) Minimum arc outside a ball (Lemma 4.3, Cor. 4.4, Lemma 4.5): f, m functions.
4. (p. 9–14) Essential arcs/secants via knotted Θ-graphs; limits (Lemma 6.1, Prop. 6.2) → essential quadrisecant for any nontrivial C^{1,1} knot.
5. (p. 15–19) Shortest essential arc: Thm 7.1 (essential trisecant at boundary), Lemma 8.1, 8.2, Cor 8.3: ℓ_{ab} ≥ g(|a−b|).
6. (p. 20–22) For each quadrisecant type, write the length as a sum of functions of r, s, t, minimise each separately (Lemma 9.1).
7. (p. 22) Combine with Denne's alternating-quadrisecant theorem.

## Tables
None.

## Figures
- **Fig. 1 (p. 3)** — "These trisecants abc are reversed (left) and direct (right) because the cyclic order of the points along K is acb and abc, respectively." Image: ../figures/DDS04/p03.png
- **Fig. 2 (p. 4)** — "Here we see quadrisecants abcd on each of three knots. From left to right, these are simple, flipped and alternating, because the dihedral order of the points along K is abcd, abdc and acbd, respectively." Image: ../figures/DDS04/p04.png
- **Fig. 3 (p. 6)** — circle tangent to K at b through a, radius r = d/(2 sin θ).
- **Fig. 4 (p. 8)** — shortest curve from a to b avoiding B(p) is planar (segment, or segment + arc of ∂B(p) + segment). Image: ../figures/DDS04/p08.png
- **Fig. 5 (p. 10)** — essential knotted Θ-graph, parallel δ. Image: ../figures/DDS04/p10.png
- **Fig. 6 (p. 11)** — commutator [λ, h(α,β)] ≃ loop l_β. **Fig. 7 (p. 12)** — trefoil with an alternating essential quadrisecant abcd and a simple inessential ABCD. Image: ../figures/DDS04/p12.png
- **Fig. 8–10 (p. 15–17)** — proof diagrams for Thm 7.1.
- **Fig. 11 (p. 18)**, **Fig. 12 (p. 19)** — projection to the unit ball around p; the intricate case of Lemma 8.2. Image: ../figures/DDS04/p19.png
- **Fig. 13 (p. 20)** — left: plot of f(r) and g(r) for r ∈ [1,3]; right: plot of 2f(r)+g(r)+r for r ∈ [1,1.008] (minimum ≈ 9.3774). Image: ../figures/DDS04/p20.png

## Stated limitations, open problems, future work
- p. 22: bound not sharp; tangent-direction analysis at b and c could give a slightly better bound.
- p. 2/24: no improvement over known link bounds other than reinterpreting the Hopf link; "we know no way to apply" Theorem 10.6.

## References worth following
- [4] Cantarella, Kusner, Sullivan, On the minimum ropelength of knots and links, Invent. Math. 150 (2002) 257–286.
- [5] Denne, Alternating quadrisecants of knots, PhD thesis, UIUC (2004), arXiv:math.GT/0510561.
- [8] Diao, The lower bounds of the lengths of thick knots, JKTR 12 (2003) 1–16.
- [13] Kuperberg, Quadrisecants of knots and links, JKTR 3 (1994) 41–50.
- [16] Pannwitz, Eine elementargeometrische Eigenschaft von Verschlingungen und Knoten, Math. Ann. 108 (1933).
- [3] Cantarella, Kuperberg, Kusner, Sullivan, The second hull of a knotted curve, Amer. J. Math. 125 (2003).
- [11] Gonzalez, Maddocks, Global curvature, thickness and the ideal shapes of knots, PNAS 96 (1999).
- [17]–[19] Pieranski; Rawdon, Can computers discover ideal knots?; Sullivan (numerical trefoil values).

## Extraction notes
- Pages rendered: 3, 4, 8, 10, 12, 19, 20. Formula images checked: pp. 5, 7; roots on pp. 20–24 restored by arithmetic consistency.
- Page 5 imaged: Cor. 3.2 hypothesis is a,b ∉ B(p); Cor. 3.4 hypothesis is p ∉ γ_{ab} (the text layer shows ∈ because the negation slash is lost; the text layer may do this elsewhere, e.g. in other sets/arcs statements).
- ⚠ Convention warning: length/diameter here versus length/radius in CKS01, CFM02 and HHKNO14.
- Proofs of Lemmas 5.x–7.x abbreviated; figures 3, 6, 8–12 not described beyond caption.
