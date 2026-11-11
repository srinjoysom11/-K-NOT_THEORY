# HNO12stick — Upper bound on lattice stick number of knots
- **Authors:** Kyungpyo Hong, Sungjong No, Seungsang Oh
- **Venue / year / identifiers:** arXiv:1209.0048v1 [math.GT], 1 Sep 2012 (MSC 57M25, 57M27)
- **File:** papers/3_analytic_bounds/Hong-No-Oh_2012_Upper_bound_lattice_stick_number_1209.0048.pdf   **Pages:** 7
- **Text layer:** ok (displayed fractions split across lines; Negami formula checked on the p. 1 image)

## Abstract
The lattice stick number s_L(K) of a knot K is defined to be the minimal number of straight line segments required to construct a stick presentation of K in the cubic lattice. In this paper, we find an upper bound on the lattice stick number of a nontrivial knot K, except trefoil knot, in terms of the minimal crossing number c(K) which is s_L(K) ≤ 3c(K) + 2. Moreover if K is a non-alternating prime knot, then s_L(K) ≤ 3c(K) − 4.

## Notation and conventions
- Cubic lattice Z³ = (R×Z×Z) ∪ (Z×R×Z) ∪ (Z×Z×R) (p. 1).
- Stick = straight line segment; lattice stick number s_L(K) = minimal number of sticks needed for a stick presentation of K in Z³ (p. 1). s_L(trivial knot) = 4 (p. 1). A stick here is a straight segment (not a unit step), so this is neither unit-step lattice length nor ropelength. No ropelength is considered in the paper, so no length/radius vs length/diameter convention applies.
- x-stick, y-stick, z-stick; x-level n = plane x = n (p. 3). (x_{ii'}, j, k) = {(x,y,z) ∈ Z³ | i ≤ x ≤ i', y = j, z = k} (p. 3).
- Arc presentation: embedding in an open book with finitely many half-plane pages H_θ about the z-axis (binding axis), K meeting each page in one simple arc; arc index a(K) = minimal number of pages (p. 2). Binding indices 1..a(K) bottom to top; page numbers 1..a(K) back to front.
- Dual arc presentation: binding indices and page numbers exchanged (p. 2).
- Circular arc presentation: binding axis ∪ ∞ drawn as boundary of a disk, binding indices clockwise starting right after b_∞, arcs as chords (p. 3–4).
- Page number rotating / binding index rotating: indices shifted mod* a(K), where x (mod* y) = x (mod y) except that y is used instead of 0 (p. 4).
- Star shaped arc presentation: a(K) odd and the difference of the two binding indices of the endpoints of every arc is n or n+1, n = (a(K) − 1)/2 (p. 4).
- Lattice arc presentation: binding axis moved to the line y = x, each arc replaced by an x-stick and a y-stick below y = x; binding point b_i = (i,i) (p. 3).

## Numbered statements
- **Theorem 1 (p. 1).** Let K be a nontrivial knot which is not trefoil knot. Then s_L(K) ≤ 3c(K) + 2. Moreover if K is a non-alternating prime knot, then s_L(K) ≤ 3c(K) − 4. *Proved here (p. 6: follows from Lemmas 5, 6, 7 with Theorems 2 and 3).*
- **Theorem 2 (Bae–Park) (p. 2).** Let K be any nontrivial knot. Then a(K) ≤ c(K) + 2. Moreover if K is a non-alternating prime knot, then a(K) ≤ c(K) + 1. *Quoted from Bae–Park [2] (Cor. 4 and Thm 9 there).*
- **Theorem 3 (Jin–Park) (p. 2).** Let K be any non-alternating prime knot. Then a(K) ≤ c(K). *Quoted from Jin–Park [12, Thm 3.3].*
- **Theorem 4 (p. 3).** s_L(K) ≤ 3a(K) − 2 for a nontrivial knot K. *Proved here.* Proof idea: each arc of a lattice arc presentation becomes an x-stick plus a y-stick at z-level = page number, the pair of arcs at each binding point is joined by a z-stick, giving 3a(K) sticks; then two sticks are saved by merging the two x-sticks on y-level 1 with their z-stick, and likewise the two y-sticks on x-level a(K).
- **Lemma 5 (p. 4).** If K has a non-star shaped arc presentation with a(K) arcs, then s_L(K) ≤ 3a(K) − 4. *Proved here (p. 4–5).* Proof idea: pick a pair of arcs sharing a binding index β' whose other endpoints differ by neither 1 nor a(K)−1; after rotations they sit at 1<α<β<a(K); put the page-1 arc l above y = x, apply the Thm 4 construction (3a(K) − 2), then lift l to z-level k so its x-stick lies on the same line as the x-stick of the page-k arc, saving 2 more sticks.
- **Lemma 6 (p. 5).** If K has a star shaped arc presentation with a(K) arcs, then either K is (n + 1, n)-torus knot or s_L(K) ≤ 3a(K) − 4. *Proved here (p. 6).* Proof idea: if page numbers of c_1..c_{2n+1} are in order or reverse order of their indices, bending the pairs gives the (n+1,n)-torus knot (Fig. 7); otherwise the dual arc presentation is non-star-shaped and Lemma 5 applies.
- **Lemma 7 (p. 6).** If K is (n + 1, n)-torus knot except trefoil (so n ≥ 3), then s_L(K) ≤ 3c(K) − 5. *Proved here.* Proof as printed: c(K) = (n+1)(n−1) = n² − 1 and a(K) = (n+1)+n = 2n+1, so a(K) ≤ c(K) − 1; "Then s_L(K) ≤ 3c(K) − 5 by Lemma 4." ⚠ There is no Lemma 4 (Theorem 4 gives only 3a(K) − 2, which would yield 3c(K) − 5 exactly: 3(c−1) − 2 = 3c − 5). So the intended reference is almost certainly Theorem 4; transcribed as printed.

## Key equations and quantitative claims outside numbered statements
- p. 1 (quoted, Negami [13]): (5 + √(25 + 8(c(K) − 2)))/2 ≤ s(K) ≤ 2c(K) for nontrivial K (ordinary stick number in R³).
- p. 1 (quoted, Huh–Oh [10]): s(K) ≤ (3/2)(c(K) + 1); and s(K) ≤ (3/2)c(K) for non-alternating prime K.
- p. 1 (quoted, rigorous): s_L(trivial) = 4; s_L(K) ≥ 12 for every nontrivial K (Janse van Rensburg–Promislow [11]); s_L(3_1) = 12, s_L(4_1) = 14, s_L(K) ≥ 15 for every other nontrivial knot (Huh–Oh [8, 9], "proper leveledness").
- p. 2: arc index of figure-8 knot is 6 (example in Fig. 2).
- p. 3: Theorem 4 construction first gives 3a(K) sticks, then 2 are removed.
- Derivation of Theorem 1 (implicit, p. 6): a(K) ≤ c(K) + 2 and s_L ≤ 3a(K) − 4 give 3c(K) + 2; non-alternating prime a(K) ≤ c(K) gives 3c(K) − 4.

## Methods / algorithms
Pure-math construction.
1. (p. 2–3) Arc presentation with a(K) pages; draw as lattice arc presentation in the plane (each arc = x-stick + y-stick, below y = x).
2. (p. 3) Lift the arc with page number k to z-level k; join the pair of arcs at each binding point b_i by a z-stick (i, i, z_{kk'}) → 3a(K) sticks; merge at the first/last binding points → 3a(K) − 2 (Thm 4).
3. (p. 4–5) Non-star-shaped case: raise special arc l to the z-level of another arc's x-stick so two sticks merge → 3a(K) − 4 (Lemma 5).
4. (p. 5–6) Star-shaped case: either (n+1,n)-torus knot (Lemma 7) or the dual presentation is non-star-shaped (Lemma 6).
5. (p. 6) Combine with Bae–Park and Jin–Park arc-index bounds.

## Tables
None.

## Figures
- **Fig. 1 (p. 2)** — 3_1 and 4_1 in the cubic lattice. *What it shows:* lattice stick presentations of the trefoil and figure-8 knots. Image: ../figures/HNO12stick/p02.png
- **Fig. 2 (p. 3)** — An arc presentation and its dual arc presentation. *What it shows:* figure-8 knot as an open-book arc presentation and its dual (binding indices and page numbers swapped). Image: ../figures/HNO12stick/p03.png
- **Fig. 3 (p. 4)** — s_L(K) ≤ 3a(K) − 2. *What it shows:* lattice arc presentation → 3a(K) sticks → 3a(K) − 2 sticks. Image: ../figures/HNO12stick/p04.png
- **Fig. 4 (p. 4)** — Circular arc presentation and how rotations work. Image: ../figures/HNO12stick/p04.png
- **Fig. 5 (p. 5)** — Star shaped arc presentation. Image: ../figures/HNO12stick/p05.png
- **Fig. 6 (p. 5)** — Lattice stick presentation from a non-star shaped arc presentation. Image: ../figures/HNO12stick/p05.png
- **Fig. 7 (p. 6)** — (n+1, n)-torus knot. *What it shows:* bending pairs of arcs inside the circular disk. Image: ../figures/HNO12stick/p06.png

## Stated limitations, open problems, future work
None stated.

## References worth following
- [2] Bae, Park, An upper bound of arc index of links, Math. Proc. Camb. Phil. Soc. 129 (2000) 491–500.
- [12] Jin, Park, Prime knots with arc index up to 11 and an upper bound of arc index for non-alternating knots, JKTR 19 (2010) 1655–1672.
- [8, 9] Huh, Oh, Lattice stick numbers of small knots, JKTR 14 (2005) 859–867; Knots with small lattice stick numbers, J. Phys. A 43 (2010) 265002.
- [10] Huh, Oh, An upper bound on stick number of knots, JKTR 20 (2011) 741–747.
- [11] Janse van Rensburg, Promislow, The curvature of lattice knots, JKTR 8 (1999) 463–490.
- [13] Negami, Ramsey theorems for knots, links, and spatial graphs, Trans. AMS 324 (1991) 527–541.

## Extraction notes
- Figure pages rendered: 1–6 (p. 1 used to check the Negami formula). Figures described only from captions and text.
- ⚠ Lemma 7 cites a non-existent "Lemma 4" (see above).
- Lemma 5 is stated for non-star-shaped arc presentations; "Proof of Theorem 1" is a one-line combination (p. 6).
