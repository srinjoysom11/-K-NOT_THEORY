# CFM02 — Upper bounds for ropelength as a function of crossing number
- **Authors:** Jason Cantarella, X.W. Faber, Chad A. Mullikin
- **Venue / year / identifiers:** arXiv:math/0210245v2 [math.GT], 16 Oct 2002 (published as Topology Appl. 135 (2004) 253–264 per later citations, not printed on this file)
- **File:** papers/0210245v2.pdf   **Pages:** 11
- **Text layer:** ok except displayed fractions/equations (all key formulas checked on page images pp. 4, 5, 8)

## Abstract
The paper provides bounds for the ropelength of a link in terms of the crossing numbers of its prime components. As in earlier papers, the bounds grow with the square of the crossing number; however, the constant involved is a substantial improvement on previous results. The proof depends essentially on writing links in terms of their arc-presentations, and has as a key ingredient Bae and Park's theorem that an n-crossing link has an arc-presentation with less than or equal to n + 2 arcs.

## Notation and conventions
- **Ropelength convention: LENGTH / RADIUS.** "The ropelength of a curve is defined to be the quotient of its length by the radius of the largest embedded tubular neighborhood around the curve. This radius is called the thickness of the curve." (p. 2; also p. 1). So unit-thickness curve = tube of radius 1. The constructions use tubes of radius 1 (e.g. polygon sides of length 2, floor height 2, p. 5).
- Rop(L) = minimum ropelength over curves of link type L (p. 1). c(L) = crossing number. Rop(L) < 2k(L), where k(L) = lattice number (number of edges in the unit lattice), quoted from [5] (p. 1) — consistent with the length/radius convention.
- Definition 1 (p. 2): thickness τ[c] := min{ min_s 1/κ(s), dcsd(c)/2 } for C² curves, κ = curvature, dcsd = shortest doubly-critical self-distance (shortest chord perpendicular to the tangent at both endpoints). Extended to C^{1,1} via the infimal radius of curvature (Def. 2, p. 2). Reach (Federer) agrees with thickness for curves (Def. 3, p. 2).
- Arc-presentation (Def. 4, p. 3): embedding of L in α open half-planes around a common axis (binding), each meeting L in one simple arc; α = arc-index. Levels 1..α on the axis. Data: α triples (x_i, y_i, θ_i) = arc from level x_i to level y_i on page θ_i.
- Total skip (Def. 5, p. 3): Skip(A) = Σ_{i=1}^{α} |x_i − y_i|.

## Numbered statements
- **Theorem 1 (p. 1).** If L is a non-split link, then Rop(L) ≤ 1.64 c(L)² + 7.69 c(L) + 6.74. In particular, this bound holds for prime links. *Proved here (p. 8) from Props 1–2 and Bae–Park α ≤ c(L)+2.* Proof computation (eqs 14–15, p. 8): Rop(L) ≤ 2α/tan(π/α) + (π−2)α + α² ≤ (2/π + 1)α² + (π − 2)α − 2π/3 (using 1/tan x ≤ 1/x − x/3); with α ≤ c+2: Rop(L) ≤ (2/π + 1)c² + (8/π + 2 + π)c + (8/π + 4π/3); "each of these constants evaluates to something smaller than" 1.64, 7.69, 6.74 (checked: 1.6366, 7.688, 6.735).
- **Theorem 2 (p. 5).** If L is a non-split composite link with prime components L_1, …, L_n, then Rop(L) ≤ 1.64 Σ c(L_i)² + 7.69 Σ c(L_i) + 6.74 n. *Proved here (p. 8–10).* Proof idea: construct L_1#L_2 from the Prop. 1 curves with ropelength ≤ Rop(L_1) + Rop(L_2) (top floor of L_1 and bottom floor of L_2 straightened and joined; each added component saves π − 2, not exploited).
- **Proposition 1 (p. 4).** An arc-presentation A composed of α half-planes can be realized with ropelength smaller than 2α/tan(π/α) + (π − 2)α + 2 Skip(A). *Proved here (p. 5–6).* Proof idea: regular α-gon prism of side 2 and height 2α as binding; α "fins" (two unit quarter-circles + vertical segment) outside, α circular arcs inside floors. Claim 1 (p. 5): Σ Rop(F_i) = (π − 2)α + 2 Skip(A). Claim 2 (p. 6): Σ Rop(B_i) ≤ 2α/tan(π/α) = 2α cot(π/α) (diameter of inscribed circle is exactly 2 cot(π/α)).
- **Proposition 2 (p. 5).** If an arc-presentation A has arc-index α, then Skip(A) ≤ (α² − 1)/2 if α is odd, α²/2 if α is even. This bound is sharp. *Proved here (p. 6–8).* Proof idea: Skip(A) = α + Σ_j (number of times level j is skipped); level j is skipped at most 2(j−1) times from below, α−j at most 2j times; the central level when α odd at most α−2 times. Sharpness: explicit arc-presentation (α, α/2, θ_1), (α/2, α−1, θ_2), (α−1, α/2−1, θ_3), …, (1, α, θ_{2k}) with Skip = α²/2 (even); "the same approach" gives (α²−1)/2 for odd α.
- **Quoted theorem (Bae–Park [1]) (p. 5, 8).** Any non-split link L admits an arc-presentation with α ≤ c(L) + 2.

## Key equations and quantitative claims outside numbered statements
- p. 1: earlier bounds quoted: Rop(L) < 24 c(L)² [3] (Cantarella–Kusner–Sullivan) and Rop(L) < 25 c(L)² [9] (Johnston). Lattice approach gives O(c²) ("constructing a particular diagram of a link with crossing number c(L) may require ropelength O(c(L)²) [9]"). Authors "believe that bounds with a slower order of growth must be attainable" (p. 2).
- p. 4 (numerical example, rigorous bound): trefoil with α = 5, Skip(A) = 12 gives Prop. 1 upper bound ≈ 43.47 (check: 10/tan 36° = 13.76; (π−2)·5 = 5.71; 2·12 = 24; sum 43.47). Numerical tight trefoil ropelength ≈ 32.66 [11] (Stasiak et al., numerical); slack ≈ 33% of total value.
- p. 4 (Fig. 3 caption): realized 7_1 has ropelength 97.05 vs numerical minimum 61.40 [11].
- p. 6: each fin has length π − 2 + 2|x_i − y_i| (straight segment 2|x_i−y_i| − 2).
- p. 9: replacement step inequality tan θ ≤ 2θ for 0 ≤ θ ≤ π/4 ("a simple computation").
- p. 8: for trefoil arc-presentation of Fig. 2: α = 5 and Skip = 12 = (25 − 1)/2, so the odd bound is attained.

## Methods / algorithms
1. (p. 5) Take an arc-presentation A of L with α pages; build a prism P × [0, 2α] over a regular α-gon of side 2; α floors of height 2.
2. (p. 5) Fins: outside the prism, each = two radius-1 quarter-circles + vertical segment, in disjoint 2α × 2 × 2 boxes; curvature ≤ 1, no doubly-critical chords → unit thickness.
3. (p. 6) Floor arcs B_i: circular arcs joining midpoints of two edges of the polygon cross-section, radius ≥ 1, one per floor of height 2 → tubes disjoint; length ≤ diameter of inscribed circle 2cot(π/α).
4. (p. 6–8) Bound Skip(A) combinatorially (Prop. 2), use Bae–Park α ≤ c+2 → Thm 1.
5. (p. 8–10) Composite links: join top floor of L_1 (single horizontal arc) with bottom floor of L_2; two cases ℓ_1 ≤ ℓ_2 − 2 or ℓ_1 > ℓ_2 − 2 (tangent diagonal segment, Figs 7–9); length does not increase.

## Tables
None.

## Figures
- **Fig. 1 (p. 2)** — "These are two curves of unit thickness in the plane with their largest embedded tubular neighborhoods. In the left curve, thickness is controlled by curvature while in the right curve, thickness is controlled by the length of the doubly-critical chord shown." *What it shows:* two planar unit-thickness curves with tubes; one curvature-limited, one self-distance-limited. Image: ../figures/CFM02/p02.png
- **Fig. 2 (p. 3)** — arc-presentation of a trefoil (arc-index 5) with 5 triples (x_i, y_i, θ_i). *What it shows:* a 5-page book diagram and the combinatorial data (read from image): (1,3,2π/5), (3,5,6π/5), (5,2,0), (2,4,4π/5), (4,1,8π/5); skips 2+2+3+2+3 = 12. Image: ../figures/CFM02/p03.png
- **Fig. 3 (p. 4)** — trefoil (top) and 7_1 (bottom) with tubular neighborhoods from Prop. 1; ropelengths 43.47 vs min 32.66, 97.05 vs min 61.40. Image: ../figures/CFM02/p04.png
- **Fig. 4 (p. 6)** — sections B_i inside the binding prism are circular arcs joining midpoints of edges of the cross-section. Image: ../figures/CFM02/p06.png
- **Fig. 5 (p. 7)** — each B_i is contained in a sector of the inscribed circle; length ≤ the two bounding radii. Image: ../figures/CFM02/p07.png
- **Fig. 6 (p. 9)** — preparing arc-index-5 and arc-index-9 knots for a connect sum (binding pentagon and nonagon). Image: ../figures/CFM02/p09.png
- **Fig. 7 (p. 9)** — extreme arcs of the two components straightened; new shorter curve (case ℓ_1 ≤ ℓ_2 − 2). Image: ../figures/CFM02/p09.png
- **Fig. 8 (p. 10)** — case ℓ_1 > ℓ_2 − 2: tangent diagonal line. **Fig. 9 (p. 10)** — enlargement of Fig. 8 (triangle used for tan θ ≤ 2θ). Image: ../figures/CFM02/p10.png
- **Fig. 10 (p. 11)** — two mirror trefoils from Prop. 1 joined by Theorem 2 to give 3_1#3_1. Image: ../figures/CFM02/p11.png

## Stated limitations, open problems, future work
- p. 2: "While we believe that bounds with a slower order of growth must be attainable, it is becoming clear that the problem of constructing such bounds is likely to be challenging." The authors' methods "seem to be essentially of order c(L)²".
- p. 8: the constant term of Theorem 2 could be slightly improved by tracking a saving of π − 2 per added prime component (not done).

## References worth following
- [1] Bae, Park, An upper bound of arc index of links, Math. Proc. Cambridge Philos. Soc. 129 (2000) 491–500 (α ≤ c+2).
- [3] Cantarella, Kusner, Sullivan, On the minimum ropelength of knots and links, Invent. Math. 150 (2002) 257–286 (Rop < 24c²; C^{1,1} tight representatives).
- [4] Cromwell, Arc presentations of knots and links, Banach Center Publ. (Warsaw 1995), 1998.
- [5] Diao, Ernst, Janse van Rensburg, Upper bounds on linking number of thick links (Rop < 2k(L)).
- [9] Johnston, An upper bound on the minimal edge number of an n-crossing lattice knot (Rop < 25c²).
- [11] Stasiak, Dubochet, Katritch, Pieranski, Ideal knots and their relation to the physics of real knots (numerical minima 32.66, 61.40).

## Extraction notes
- Equations (5), (6), (14), (15), (7) and the Prop. 1/2 statements verified from page images (pp. 4, 5, 8); arithmetic of 43.47 and of the constants in (15) re-checked.
- Claim 2 (eq. 9, p. 6) text layer shows "2α tan(π/α)" with the fraction bar lost; it is 2α/tan(π/α) = 2α·cot(π/α), consistent with the proof (diameter of inscribed circle = 2cot(π/α)) and with Prop. 1. Not re-imaged on p. 6.
- Fig. 2 triples read from the p. 3 image.
- ⚠ Prop. 1 says "smaller than" (strict); Theorem 1 non-strict. Minor.
- Pages rendered: 2, 3, 4, 6, 7, 9, 10, 11.
