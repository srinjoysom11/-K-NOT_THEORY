# HHKNO14 — Minimum lattice length and ropelength of 2-bridge knots and links
- **Authors:** Youngsik Huh, Kyungpyo Hong, Hyoungjun Kim, Sungjong No, Seungsang Oh
- **Venue / year / identifiers:** arXiv:1411.1840v1 [math.GT], 7 Nov 2014
- **File:** papers/1_core_lattice_length/Huh-Hong-Kim-No-Oh_2014_2-bridge_knots_and_links_lattice_length_1411.1840.pdf   **Pages:** 14
- **Text layer:** ok for prose; figure labels use unmapped Korean fonts (garbled); formulas cross-checked arithmetically

## Abstract
Knots are commonly found in molecular chains such as DNA and proteins, and they have been considered to be useful models for structural analysis of these molecules. One interested quantity is the minimum number of monomers necessary to realize a molecular knot. The minimum lattice length Len(K) of a knot K indicates the minimum length necessary to construct K in the cubic lattice. Another important quantity in physical knot theory is the ropelength which is one of knot energies measuring the complexity of knot conformation. The minimum ropelength Rop(K) is the minimum length of an ideally flexible rope necessary to tie a given knot K.
Much effort has been invested in the research project for finding upper bounds on both quantities in terms of the minimum crossing number c(K) of the knot. It is known that Len(K) and Rop(K) lie between O(c(K)^{3/4}) and O(c(K)[ln(c(K))]^5), but unknown yet whether any family of knots has superlinear growth. In this paper, we focus on 2-bridge knots and links. Linear growth upper bounds on the minimum lattice length and minimum ropelength for nontrivial 2-bridge knots or links are presented: Len(K) ≤ 8c(K) + 2. Rop(K) ≤ 11.39c(K) + 12.37.

## Notation and conventions
- Cubic lattice Z³ = (R×Z×Z) ∪ (Z×R×Z) ∪ (Z×Z×R); edge = unit segment; x-edge, x-level i = plane x = i (p. 1).
- Len(K) = minimum number of edges to construct K in Z³ ("Diao … used 'minimal edge number'") (p. 2).
- Ropelength = length / thickness, **thickness = radius** of the largest embedded normal tube; Rop(K) minimum (p. 2). Construction uses rope of radius 1 (p. 6). Rop(K) ≤ 2 Len(K) (p. 2).
- c(K) = minimum crossing number. 2-bridge K given by Conway notation (a_1, …, a_m), all a_i > 0, m odd; this diagram is reduced alternating with c(K) = a_1 + … + a_m (p. 3–4).
- Cylindrical tower: stack of cylinders of radius h and height 2h, h ≥ 1 (p. 6).

## Numbered statements
- **Theorem 1 (p. 2).** Let K be a nontrivial 2-bridge knot or link. Then Len(K) ≤ 8c(K) + 2. *Proved (§3).*
- **Proposition 2 (p. 2).** Let K be a nontrivial 2-bridge knot or link. Then, for any constant h ≥ 1.205, Rop(K) ≤ 2h(√(π²+4) + 1)c(K) + 4π + 14h. With h = 1.205: Rop(K) ≤ 11.39c(K) + 29.44. *Proved (§4).*
- **Theorem 3 (p. 2).** Let K be a nontrivial 2-bridge knot or link with c(K) ≥ 6. Then Rop(K) ≤ 11.39c(K) + 12.37. *Proved (§5), realisability of the modified tubes confirmed with Mathematica (p. 12).*

## Key equations and quantitative claims outside numbered statements
- p. 2–3 (quoted): Len, Rop lie between O(c^{3/4}) and O(c[ln c]^5) [2, 13]; Cantarella–Faber–Mullikin [6]: Rop(K) ≤ 1.64c² + 7.69c + 6.74; Diao et al. [13, 14]: Len(K) ≤ 136c^{3/2} + 84c + 22c^{1/2} + 11, Rop(K) ≤ 272c^{3/2} + 168c + 44c^{1/2} + 22, and O(c[ln c]^5); authors' [17] (= HKNO14): Len(K) ≤ min{(3/4)c² + 5c + 17/4, (5/8)c² + (15/2)c + 71/8}, Rop(K) ≤ min{1.5c² + 9.15c + 6.79, 1.25c² + 14.58c + 16.90}.
- p. 3 (quoted): Len(3_1) = 24 [10]; Len(4_1) = 30, Len(5_1) = 34 [29]. Linear ropelength bound for Conway algebraic knots known [16].
- p. 4: unfolded lattice embedding uses 4 x-, 4 y-, 2 z-edges per crossing floor ⇒ **10c(K)** edges; folding removes the rightmost arc (2c(K) edges), adds 4 z-edges, removes 2 x/y-edges ⇒ 8c(K) + 2 (p. 6).
- p. 7: unfolded tower embedding length 2h(√(π²+4) + 2)c(K) + 8h (two helical arcs of length h√(π²+4) and two vertical segments 2h per floor, plus four diameters 2h).
- p. 9: non-overlap condition: dist(B, A_θ) = h√(2 + 2cos θ + 4θ²/π²) > h√f(θ) with f(θ) = 4 + (4/π² − 1)θ² + (2/4!)θ⁴ − (2/6!)θ⁶; minimiser θ° = √(10 − √(100 − 120(1 − 4/π²))) ≈ 2.3946; need h ≥ 2/√f(θ°) ≈ 1.2045.
- p. 10: with h = 1.205: bottom part ≈ 39.43, top part ≤ ≈ 35.55, middle 2h(√(π²+4)+1)(c − 4) ≈ 11.39c − 45.54. Replacement bottom arcs ≈ 28.38 (crossings same side) or ≈ 27.19 (opposite sides, β = 0.1); replacement top ≈ 27.19 (c even) or ≈ 29.52 (c odd) (pp. 10–12).

## Methods / algorithms
Theorem 1 (§3):
1. Step 1 (p. 4): draw the Conway diagram on z-level 2 with x- and y-edges (axes rotated 45°); under-strands ("bold edges") on z-level 1, joined by z-edges. 10c(K) edges.
2. Step 2 (p. 4–6): delete the rightmost arc between vertices a and b (2c(K) edges); cut at three vertices on a middle line l (y = x + k) into pieces A and B; rotate B by 180° about l and lift to z-levels 3, 4; reconnect a, b and the three cut pairs with 4 z-edges (odd c: delete one x-edge, add one y-edge first); remove 2 more x/y-edges. Total 8c(K) + 2.

Proposition 2 (§4): Step 1 draw the diagram on three parallel cylindrical towers, one crossing per floor (helical arcs); Step 2 fold as above, gap 2 between towers A and B, reconnect four pairs by arcs of two unit quarter circles plus a segment 2h; Step 3 compute minimal h (above).

Theorem 3 (§5): replace the bottom four cylinders' arcs (two cases by crossing positions, Figs 9–10) and the top part (c even / odd, Figs 11–12) by shorter explicit arcs.

## Tables
None.

## Figures
- **Fig. 1 (p. 4)** — Conway notation (a_1, a_2, …, a_m). Image: ../figures/HHKNO14/p04.png
- **Fig. 2 (p. 5)** — 2-bridge knot or link in the cubic lattice (example: link (2, 3, 2), 7 crossings). Image: ../figures/HHKNO14/p05.png
- **Fig. 3 (p. 5)** — Folding argument (pieces A, B, middle line l). Image: ../figures/HHKNO14/p05.png
- **Fig. 4 (p. 6)** — Connecting four pairs of cutting points (even / odd cases). Image: ../figures/HHKNO14/p06.png
- **Fig. 5 (p. 7)** — 2-bridge knot or link in three cylindrical towers. Image: ../figures/HHKNO14/p07.png
- **Fig. 6 (p. 8)** — Folding argument (towers). Image: ../figures/HHKNO14/p08.png
- **Fig. 7 (p. 8)** — Connecting four pairs; tube link of radius 1. Image: ../figures/HHKNO14/p08.png
- **Fig. 8 (p. 9)** — Distance between two arcs on a cylinder. Image: ../figures/HHKNO14/p09.png
- **Fig. 9 (p. 10–11)** — Two crossings lying on the same side at the bottom part. Image: ../figures/HHKNO14/p10.png
- **Fig. 10 (p. 11)** — Two crossings lying on other sides at the bottom area. Image: ../figures/HHKNO14/p11.png
- **Fig. 11 (p. 12)** — c(K) is even. **Fig. 12 (p. 12)** — c(K) is odd. Image: ../figures/HHKNO14/p12.png

## Stated limitations, open problems, future work
- p. 1–2: "unknown yet whether any family of knots has superlinear growth" of Len or Rop in c(K).

## References worth following
- [6] Cantarella, Faber, Mullikin, Upper bounds for ropelength as a function of crossing number, Topology Appl. 135 (2004) 253–264.
- [13] Diao, Ernst, Por, Ziegler, The ropelengths of knots are almost linear in terms of their crossing numbers, arXiv:0912.3282.
- [14] Diao, Ernst, Yu, Hamiltonian knot projections and lengths of thick knots, Topology Appl. 136 (2004) 7–36.
- [16] Diao, Ernst, Ziegler, The linearity of the ropelengths of Conway algebraic knots…, Kobe J. Math. 28 (2011) 1–19.
- [17] Hong, Kim, No, Oh, Minimum lattice length and ropelength of knots, JKTR (to appear) = HKNO14.
- [27] McCabe, An upper bound on edge numbers of 2-bridge knots and links, JKTR 7 (1998) 797–805.

## Extraction notes
- Written by the wiki author. Formulas taken from the text layer; Prop. 2 constants verified arithmetically (2·1.205·(√(π²+4)+1) = 11.385; 4π + 14·1.205 = 29.44). Figure-label text is garbled (unmapped CJK fonts); captions are clean.
- ⚠ The abstract and Theorem 3 give constant 12.37 but Theorem 3 requires c(K) ≥ 6; the abstract omits this hypothesis.
- Figure pages rendered: 4–12. No figure descriptions beyond captions.
