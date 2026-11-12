# HKNO14 — Minimum lattice length and ropelength of knots
- **Authors:** Kyungpyo Hong, Hyoungjun Kim, Sungjong No, Seungsang Oh (Korea University; No: Ewha Womans University)
- **Venue / year / identifiers:** arXiv:1411.1845v1 [math.GT] 7 Nov 2014 (no journal reference printed). MSC 2010: 57M25, 57M27.
- **File:** papers/1_core_lattice_length/Hong-Kim-No-Oh_2014_Min_lattice_length_and_ropelength_1411.1845.pdf   **Pages:** 9
- **Text layer:** ok (fractions garbled in text layer; all formulas read from page images)

## Abstract
Let Len(K) be the minimum length of a knot on the cubic lattice (namely the minimum length necessary to construct the knot in the cubic lattice). This paper provides upper bounds for Len(K) of a nontrivial knot K in terms of its crossing number c(K) as follows:

Len(K) ≤ min{ (3/4)c(K)^2 + 5c(K) + 17/4, (5/8)c(K)^2 + (15/2)c(K) + 71/8 }.

The ropelength of a knot is the quotient of its length by its thickness, the radius of the largest embedded normal tube around the knot. We also provide upper bounds for the minimum ropelength Rop(K) which is close to twice Len(K):

Rop(K) ≤ min{ 1.5c(K)^2 + 9.15c(K) + 6.79, 1.25c(K)^2 + 14.58c(K) + 16.90 }.

## Notation and conventions
- Cubic lattice Z^3 = (R×Z×Z) ∪ (Z×R×Z) ∪ (Z×Z×R); lattice knot = polygonal knot in Z^3 (p. 1).
- "An *edge* is a line segment of unit length joining two nearby lattice points in Z^3 … The minimum number of edges necessary to realize a knot K as a lattice knot is called the *minimum lattice length*, denoted by Len(K)." (p. 1)
- Ropelength: "the quotient of its length by its thickness where thickness is the radius of the largest embedded normal tube around the knot. We define the minimum ropelength Rop(K) to be the minimum ropelength of all embeddings of K." (p. 2) — i.e. length/radius convention. "the minimum ropelength of a knot is less than or equal to twice the minimum lattice length of the knot" (p. 2).
- c(K): minimum crossing number (p. 2).
- Grid diagram: "a knot diagram of vertical strands and the same number of horizontal strands with the properties that at every crossing the vertical strand crosses over the horizontal strand and no two horizontal strands are co-linear and no two vertical strands are co-linear." Grid index g(K) = minimum number of vertical strands over all grid diagrams of K (p. 3).
- Arc index α(K): minimum number of pages among arc presentations (open-book with half-plane pages, binding = z-axis, each page meets K in a single simple arc). α(K) = g(K) [6] (p. 3).
- x-stick, x-edge, x-level i (plane x = i); similarly y, z (p. 4).

## Numbered statements
**Theorem 1 (p. 2).** (proved here) Let K be any nontrivial knot.
Len(K) ≤ min{ (3/4)c(K)^2 + 5c(K) + 17/4, (5/8)c(K)^2 + (15/2)c(K) + 71/8 }.
Moreover if K is a non-alternating prime knot,
Len(K) ≤ min{ (3/4)c(K)^2 + 2c(K) − 11/4, (5/8)c(K)^2 + 5c(K) − 29/8 }.
Proof idea: settle a grid diagram in Z^3, fold it twice (horizontally and vertically) to reduce edges, then apply Proposition 3 (p. 4).

**Theorem 2 (p. 3).** (proved here, from Theorem 1's construction) Let K be any nontrivial knot.
Rop(K) ≤ min{ (3/2)c(K)^2 + (π + 6)c(K) + 2π + 1/2, (5/4)c(K)^2 + (π/2 + 13)c(K) + π + 55/4 }.
Moreover if K is a non-alternating prime knot,
Rop(K) ≤ min{ (3/2)c(K)^2 + πc(K) − 11/2, (5/4)c(K)^2 + (π/2 + 8)c(K) − 29/4 }.
Stated consequence (p. 3): "the first inequality in Theorem 2 guarantees the following inequality which slightly improves the Cantarella's bound: Rop(K) ≤ min{1.5c(K)^2 + 9.15c(K) + 6.79, 1.25c(K)^2 + 14.58c(K) + 16.90}."
Proof idea: double the lattice knot and replace every corner with a quarter circle, so length becomes twice the lattice length minus (2 − π/2) per corner (p. 7, Fig. 5).

**Proposition 3 (p. 4).** (proved here from Bae–Park [2] Cor. 4, Thm 9 and Jin–Park [17]) Let K be any nontrivial knot. Then g(K) ≤ c(K) + 2. Moreover if K is a non-alternating prime knot, then g(K) ≤ c(K).
Proof idea: α(K) ≤ c(K)+2 [2], α(K) ≤ c(K) for non-alternating prime K [17], and α(K) = g(K).

## Key equations and quantitative claims outside numbered statements
- Quoted prior results (pp. 1–2): Len(3_1) = 24 and all other nontrivial knots need more than 24 edges (Diao [7]); Len(4_1) = 30, Len(5_1) = 34 (Ishihara–Shimokawa, see [18]).
- Quoted (p. 2): Diao et al [10]: Len(K) ≤ 136c(K)^{3/2} + 84c(K) + 22c(K)^{1/2} + 11 and Rop(K) ≤ 272c(K)^{3/2} + 168c(K) + 44c(K)^{1/2} + 22. Authors' earlier [12]: Len(K) ≤ (3/2)c(K)^2 + 2c(K) + 1/2 for nontrivial K ≠ 3_1. Cantarella et al [4]: Rop(K) ≤ 1.64c(K)^2 + 7.69c(K) + 6.74.
- Grid-index bounds (rigorous, pp. 4–7), g = grid index:
  - Step 1: #x-edges ≤ (g^2−1)/2 (g odd) or g^2/2 (g even); #z-edges = 2g; total ≤ g^2 + 2g − 1 (g odd) or g^2 + 2g (g even); Len(K) ≤ g^2 + 2g (p. 4).
  - Step 2: #x-edges ≤ (g^2−1)/4 (g odd); g^2/4 if g/2+1 odd, g^2/4 + 1 if g/2+1 even; two z-edges removed per relevant level. Totals: (3/4)g^2 + 2g − 11/4 (g odd), (3/4)g^2 + 2g − 4 (g = 4k), (3/4)g^2 + 2g − 3 (g = 4k+2). Len(K) ≤ (3/4)g^2 + 2g − 11/4 (pp. 5–6).
  - Step 3: #y-edges ≤ (3/8)g^2 + g − 11/8 (odd), (3/8)g^2 + g − 2 (g = 4k), (3/8)g^2 + g − 3/2 (g = 4k+2); #z-edges ≤ 4g − 2 (odd), 4g − 4 (even). Totals: (5/8)g^2 + 5g − 29/8 (odd), (5/8)g^2 + 5g − 6 (4k), (5/8)g^2 + 5g − 9/2 (4k+2). Len(K) ≤ (5/8)g^2 + 5g − 29/8 (pp. 6–7).
  - Step 4: Len(K) ≤ min{(3/4)g^2 + 2g − 11/4, (5/8)g^2 + 5g − 29/8} (p. 7).
- Ropelength in terms of g (pp. 7–8): Step 1 has 4g corners → Rop(K) ≤ 2(g^2+2g) + 4g(π/2 − 2) = 2g^2 + (2π − 4)g; Step 2 guarantees ≥ 2g corners → Rop(K) ≤ (3/2)g^2 + πg − 11/2; Step 3 guarantees ≥ g corners on z-levels 0 and 4 → Rop(K) ≤ (5/4)g^2 + (π/2 + 8)g − 29/4. Final: Rop(K) ≤ min{(3/2)g^2 + πg − 11/2, (5/4)g^2 + (π/2+8)g − 29/4}.

## Methods / algorithms
Construction (pp. 4–8), K with grid index g:
1. **Step 1 (natural settlement, p. 4):** the g horizontal strands become x-sticks on z-level 1 at y-levels 1…g; the g vertical strands become y-sticks on z-level 2 at x-levels 1…g; adjacent strands joined by a z-edge between z-levels 1 and 2 (Fig. 3 leftmost).
2. **Step 2 (horizontal folding, pp. 5–6):** fold along z = 1, x = (g+1)/2 (g odd) or x = g/2 + 1 (g even). About half the y-sticks (right side) move to z-level 0; x-sticks stay at z-level 1; overlapped x-edges are removed (Fig. 3). Knot type unchanged.
3. **Step 3 (vertical folding, p. 6):** fold along z = 2, y = (g+1)/2 (odd) or y = g/2 + 1 (even). y-sticks on z-level 2 stay; upper half of x-sticks on z-level 1 → z-level 3; upper half of y-sticks on z-level 0 → z-level 4. Overlapped y-edges removed; each broken y-stick pair on z-level 0 reconnected by two y-edges and four z-edges (Fig. 4).
4. **Step 4 (p. 7):** take min of the step bounds; substitute g ≤ c(K)+2 (or g ≤ c(K) for non-alternating prime) via Proposition 3.
5. **Ropelength (pp. 7–8):** scale by 2 and replace corners by quarter circles of the doubled lattice knot (Fig. 5); each corner saves 2 − π/2.

## Tables
None.

## Figures
- **Fig. 1 (p. 2)** — "Examples of 3_1, 4_1 and 5_1 with minimum lattice length". *What it shows:* perspective drawings of three lattice polygons (24, 30, 34 edges) with vertices marked. Image: ../figures/HKNO14/p02.png
- **Fig. 2 (p. 3)** — "An arc presentation and a grid diagram". *What it shows:* for the trefoil, an arc presentation on a vertical binding axis, the corresponding grid diagram, and a picture relating the arcs (dotted lines) to the grid diagram's strands. Image: ../figures/HKNO14/p03.png
- **Fig. 3 (p. 5)** — "Horizontal folding". *What it shows:* the Step-1 lattice presentation inside a dotted box (axes x, y, z), the box being folded along a vertical line, and the resulting half-width folded box with removed overlapping x-edges dotted. Image: ../figures/HKNO14/p05.png
- **Fig. 4 (p. 7)** — "Vertical folding". *What it shows:* the folded box from Step 2 being folded again about a horizontal line, ending in a quarter-size box; broken y-sticks are reconnected. Image: ../figures/HKNO14/p07.png
- **Fig. 5 (p. 8)** — "Replacing every corner with a quartile circle". *What it shows:* a lattice path with a corner, and the smoothed curve where the corner is replaced by a quarter-circle arc, with dotted tubes/circles indicating thickness. Image: ../figures/HKNO14/p08.png

## Stated limitations, open problems, future work
None stated explicitly (no conclusion section).

## References worth following
- [2] Y. Bae, C. Y. Park, An upper bound of arc index of links, Math. Proc. Camb. Phil. Soc. 129 (2000) 491–500.
- [4] J. Cantarella, X.W.C. Faber, C. Mullikin, Upper bounds for ropelength as a function of crossing number, Topology Appl. 135 (2004) 253–264.
- [6] P. Cromwell, Embedding knots and links in an open book I: Basic Properties, Topology Appl. 64 (1995) 37–58.
- [7] Y. Diao, Minimal knotted polygons on the cubic lattice, J. Knot Theory Ramif. 2 (1993) 413–425.
- [10] Y. Diao, C. Ernst, X. Yu, Hamiltonian knot projections and lengths of thick knots, Topology Appl. 136 (2004) 7–36.
- [11] K. Hong, S. No, S. Oh, Upper bound on lattice stick number of knots, Math. Proc. Camb. Phil. Soc. 155 (2013) 173–179.
- [12] K. Hong, S. No, S. Oh, Upper bounds on the minimum length of cubic lattice knots, J. Phys. A: Math. Theor. 46 (2013) 125001.
- [17] G. T. Jin, W. K. Park, Prime knots with arc index up to 11 and an upper bound of arc index for non-alternating knots, J. Knot Theory Ramif. 19 (2010) 1655–1672.
- [18] R. Scharein et al., Bounds for the minimum step number of knots in the simple cubic lattice, J. Phys. A 42 (2009) 475006.

## Extraction notes
- All formulas transcribed from page images pp. 1–8 and spot-checked algebraically: substituting g = c+2 into the g-bounds reproduces the coefficients of Theorems 1–2 exactly; π+6 ≈ 9.1416 and 2π+1/2 ≈ 6.7832 are printed as 9.15 and 6.79 (rounded up), π/2+13 ≈ 14.5708 → 14.58, π+55/4 ≈ 16.8916 → 16.90.
- ⚠ Proof of Prop. 3 writes "a(K) ≤ c(K)" (Latin a) where α(K) is meant; transcribed as α.
- The Step-1 ropelength bound 2g^2 + (2π−4)g (p. 8, §4, transcribed in the ropelength bullet above) is derived but not included in the final min, which is taken over Steps 2 and 3 only (as printed).
- Reference [12] here is the journal version of HNO14len (J. Phys. A 46 (2013) 125001).
- No tables. Figure pages 2, 3, 5, 7, 8 rendered.
