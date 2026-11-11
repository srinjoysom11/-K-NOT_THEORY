# HNO14len — Upper bounds on the minimal length of cubic lattice knots
- **Authors:** Kyungpyo Hong, Sungjong No, Seungsang Oh (Korea University)
- **Venue / year / identifiers:** arXiv:1411.1849v1 [math.GT] 7 Nov 2014 (no journal reference printed). PACS 02.10.Kn, 82.35.Pq, 02.40.Sf.
- **File:** papers/1_core_lattice_length/Hong-No-Oh_2014_Upper_bounds_minimal_length_cubic_lattice_knots_1411.1849.pdf   **Pages:** 7
- **Text layer:** ok (fractions/radicals garbled in text layer; read from page images)

## Abstract
Knots have been considered to be useful models for simulating molecular chains such as DNA and proteins. One quantity that we are interested on molecular knots is the minimum number of monomers necessary to realize a knot. In this paper we consider every knot in the cubic lattice. Especially the minimal length of a knot indicates the minimum length necessary to construct the knot in the cubic lattice. Diao introduced this term (he used "minimal edge number" instead) and proved that the minimal length of the trefoil knot 3_1 is 24. Also the minimal lengths of the knots 4_1 and 5_1 are known to be 30 and 34, respectively. In the article we find a general upper bound of the minimal length of a nontrivial knot K, except the trefoil knot, in terms of the minimal crossing number c(K). The upper bound is (3/2)c(K)^2 + 2c(K) + 1/2. Moreover if K is a non-alternating prime knot, then the upper bound is (3/2)c(K)^2 − 4c(K) + 5/2. Our work are considerably direct consequences of the results done by the authors in [10]. Furthermore if K is (n+1, n)-torus knot, then the upper bound is 6c(K) + 2√(c(K)+1) + 6.

## Notation and conventions
- Cubic lattice: "Z^3 = (R × Z × Z) ∪ (Z × R × Z) ∪ (Z × Z × R)" (p. 1). "A *lattice knot* is a polygonal knot in the cubic lattice" (p. 1).
- "An *edge* is a line segment of unit length joining two nearby lattice points in Z^3. Obviously a stick with length n of a lattice knot consists of n edges." (p. 1). Sticks = maximal straight line segments ("finite line segments, called sticks, attached end-to-end", p. 1).
- "The minimum number of edges necessary to realize a knot as a lattice knot is called the *minimal length*." (p. 1) (Diao's "minimal edge number", abstract.)
- c(K) = minimal crossing number (abstract). a(K) = arc index: "the minimal number of pages among all possible arc presentations of K" (p. 3).
- x-stick / x-edge: stick/edge parallel to x-axis; x-stick (x_{ii'}, j, k) = {(x,y,z) ∈ Z^3 | i ≤ x ≤ i', y = j, z = k}; "The plane with the equation x = i … is called an *x-level i*" (p. 2). Similarly for y, z.
- "A lattice knot is said to be *properly leveled* if each x-level (resp. y, z-level) contains exactly two endpoints of x-sticks (resp. y, z-sticks)." If it has n x-levels these may be relabelled 1,…,n (p. 2).
- Arc presentation: embedding in an open-book (pages = open half-planes H_θ, binding = z-axis) meeting each page in a simple arc; binding indices 1,…,a(K) bottom to top; page numbers 1,…,a(K) back to front (p. 3).
- Lattice arc presentation: binding axis moved to line y = x in the x-y plane, each arc replaced by an x-stick and a y-stick "properly below the line y = x" (p. 3).
- Ropelength (p. 6): "the quotient of its length by its thickness, where thickness is the radius of the largest embedded tubular neighborhood around the knot" (i.e. length/radius).

## Numbered statements
**Theorem 1 (p. 2).** (proved here) Let K be a nontrivial knot which is not the trefoil knot 3_1. Then the minimal length of K is at most (3/2)c(K)^2 + 2c(K) + 1/2. Moreover if K is a non-alternating prime knot, then the minimal length is at most (3/2)c(K)^2 − 4c(K) + 5/2. Furthermore if K is (n+1, n)-torus knot, then the minimal length is at most 6c(K) + 2√(c(K)+1) + 6.
Proof idea: realize K as a properly leveled lattice knot with few sticks via arc presentations (Lemmas 4, 5), bound a(K) by c(K) (Theorem 3), then count edges per level via Lemma 2 (p. 5).

**Lemma 2 (p. 2).** (proved here) If a properly leveled lattice knot has n x-levels, then this lattice knot contains at most (n^2 − 1)/2 x-edges if n is odd, or n^2/2 x-edges if n is even.
Proof idea: "exactly two x-edges between x-level 1 and 2 … at most four x-edges between x-level 2 and 3 … Keep going to add two x-edges when x-levels approach to the middle level"; total 2·Σ_{i=1}^{(n−1)/2} 2i = (n^2−1)/2 (n odd) or 2·Σ_{i=1}^{n/2−1} 2i + 2(n/2) = n^2/2 (n even) (p. 2).

**Theorem 3 (p. 3).** (quoted: Bae–Park [2] Cor. 4 & Thm 9; Jin–Park [16] Thm 3.3) Let K be any nontrivial knot. Then a(K) ≤ c(K) + 2. Moreover if K is a non-alternating prime knot, then a(K) ≤ c(K).
(Context p. 3: Bae–Park gave a(K) ≤ c(K)+2 and a(K) ≤ c(K)+1 for non-alternating prime; Jin–Park improved the latter to a(K) ≤ c(K).)

**Lemma 4 (p. 3).** (proved here; "almost direct consequence" of Lemmas 4–6 of [10]) Let K be a nontrivial knot with the arc index a(K). Then we can realize K as a properly leveled lattice knot by using a(K) − 1 x-sticks, a(K) − 1 y-sticks, and a(K) z-sticks.
Proof idea: each arc with page k and binding indices i<j becomes sticks (x_{ij}, i, k) and (j, y_{ij}, k); arcs sharing binding index i joined by z-stick (i, i, z_{kk'}), giving a(K) sticks of each direction; then on y-level 1 delete the shorter x-stick and replace the other two sticks by (x_{ii'},1,k') and (i,1,z_{kk'}); repeat for y-sticks on x-level a(K) (p. 4).

**Lemma 5 (p. 4).** (proved here, using proofs of Lemmas 5, 6 in [10]) Let K be a nontrivial knot with the arc index a(K). Suppose that K is not (n+1, n)-torus knot. Then we can realize K as a properly leveled lattice knot by using a(K) − 2 x-sticks, a(K) − 1 y-sticks, and a(K) − 1 z-sticks.
Proof idea: if K is not an (n+1,n)-torus knot there is a lattice arc presentation with an arc l on page 1 with binding indices a, b and an arc l′ with binding indices b and a(K), 1 < a < b < a(K) (from a non-star-shaped arc presentation, or the dual of a star-shaped one). Put only l above y = x, run Lemma 4, then lift l along z to the z-level k of l′ so its x-stick is collinear with that of l′, deleting one x-stick and one z-stick (pp. 4–5).

## Key equations and quantitative claims outside numbered statements
- Known values quoted (pp. 1–2): minimal length of any nontrivial lattice knot ≥ 24, only 3_1 realized with 24 edges (Diao [5]); minimal lengths of 4_1 and 5_1 are 30 and 34 [19].
- Proof of Thm 1 (p. 5), general (non-torus) case: c(K) x-sticks, c(K)+1 y-sticks, c(K)+1 z-sticks; edge count ≤ (c^2−1)/2 + (c+1)^2/2 + (c+1)^2/2 = (3c^2+4c+1)/2 if c odd; c^2/2 + ((c+1)^2−1)/2 + ((c+1)^2−1)/2 = (3c^2+4c)/2 if c even; hence ≤ (3/2)c^2 + 2c + 1/2.
- Non-alternating prime: c−2 x-sticks, c−1 y-sticks, c−1 z-sticks; "the lattice knot K consists of (3/2)c(K)^2 − 4c(K) + 5/2 edges" (p. 5).
- (n+1,n)-torus knot, n ≥ 3: c(K) = (n+1)(n−1) = n^2 − 1, a(K) = 2n+1 = 2√(c(K)+1) + 1; by Lemma 4: 2√(c+1) x-sticks, 2√(c+1) y-sticks, 2√(c+1)+1 z-sticks; total ≤ (2√(c+1))^2/2 + (2√(c+1))^2/2 + ((2√(c+1)+1)^2 − 1)/2 = 6c(K) + 2√(c(K)+1) + 6 (p. 5).
- Comparison (p. 6): numerical upper bounds from [11, 15, 19] for knots with crossing numbers 4, 5, 6, 7, 8 are 30, 36, 40, 46, 52; "our upper bound formula gives the upper bounds as 32, 48, 66, 88 and 112, respectively" (rigorous but loose).
- Ropelength remarks (p. 6): "the minimum ropelength of a knot is less than or equal to two times of the minimal length of the knot" (thickness = radius). Quoted bounds: [3] minimum ropelength of non-split link L ≤ 1.64c(L)^2 + 7.69c(L) + 6.74; [6] proposes 272c(L)^{3/2} + 168C(L) + 44c(L)^{1/2} + 22.

## Methods / algorithms
Construction (pp. 3–5):
1. Take an arc presentation of K with a(K) pages; convert to a lattice arc presentation (binding axis on y = x, each arc = x-stick + y-stick below the diagonal) (p. 3, Fig. 2).
2. Lift to Z^3: arc with page k, binding indices i<j → sticks (x_{ij}, i, k), (j, y_{ij}, k); join arcs at a common binding index by z-sticks → properly leveled lattice knot with a(K) sticks per direction (p. 4).
3. Remove 2 sticks at y-level 1 and x-level a(K) (Lemma 4, Fig. 3).
4. If K is not an (n+1,n)-torus knot, remove one more x-stick and z-stick by lifting a special arc l (Lemma 5, Fig. 4).
5. Bound a(K) by c(K) (Theorem 3) and count edges per direction with Lemma 2 (p. 5).

## Tables
None.

## Figures
- **Fig. 1 (p. 2)** — "3_1, 4_1, and 5_1 in the cubic lattice". *What it shows:* three perspective drawings of lattice polygons realizing the minimal-length conformations of 3_1, 4_1, 5_1, with lattice vertices dotted. Image: ../figures/HNO14len/p02.png
- **Fig. 2 (p. 3)** — "Arc presentation and lattice arc presentation". *What it shows:* left, a 6-page arc presentation of the figure-8 knot on a vertical binding axis (binding indices 1–6, page numbers labelled); right, the corresponding lattice arc presentation with binding points on the line y = x and each arc as an x-stick + y-stick below the diagonal. Image: ../figures/HNO14len/p03.png
- **Fig. 3 (p. 4)** — "Lattice presentation with 2 sticks reduced". *What it shows:* the 3D lattice knot built over the plane y = x (labels (x_{13},1,4), (1,1,z_{14}), (x_{13},1,1)) and, right, the result after deleting/replacing sticks (dotted sticks indicate changes). Image: ../figures/HNO14len/p04.png
- **Fig. 4 (p. 5)** — "Lattice presentation with 4 sticks reduced". *What it shows:* left, lattice arc presentation with arcs l (binding indices a, b, page 1) and l′ (binding indices b, a(K), page k), l drawn above the diagonal; right, the 3D lattice knot after lifting l, with removed sticks dotted. Image: ../figures/HNO14len/p05.png

## Stated limitations, open problems, future work
- "These upper bounds are rather loose even for small knots, and will be very loose for knots with larger number of crossings. However, we need to point out that our upper bound formula is obtained by purely analytic calculations instead of numerical calculations." (p. 6)

## References worth following
- [2] Y. Bae and C. Y. Park, An upper bound of arc index of links, Math. Proc. Camb. Phil. Soc. 129 (2000) 491–500.
- [3] J. Cantarella, X.W.C. Faber, C. Mullikin, Upper bounds for ropelength as a function of crossing number, Topology Appl. 135 (2004) 253–264.
- [4] P. Cromwell, Embedding knots and links in an open book I: Basic Properties, Topology Appl. 64 (1995) 37–58.
- [5] Y. Diao, Minimal knotted polygons on the cubic lattice, J. Knot Theory Ramif. 2 (1993) 413–425.
- [6] Y. Diao, C. Ernst, X. Yu, Hamiltonian knot projections and lengths of thick knots, Topology Appl. 136 (2004) 7–36.
- [10] K. Hong, S. No, S. Oh, Upper bound on lattice stick number of knots, arXiv:1209.0048.
- [11] X. Hua, D. Nguyen, B. Raghavan, J. Arsuaga, M. Vazquez, Random state transitions of knots…, Topology Appl. 154 (2007) 1381–1397.
- [15] E. J. Janse van Rensburg, S. D. Promislow, Minimal knots in the cubic lattice, J. Knot Theory Ramif. 4 (1995) 115–130.
- [16] G. T. Jin, W. K. Park, Prime knots with arc index up to 11 and an upper bound of arc index for non-alternating knots, J. Knot Theory Ramif. 19 (2010) 1655–1672.
- [19] R. Scharein, K. Ishihara, J. Arsuaga, Y. Diao, K. Shimokawa, M. Vazquez, Bounds for the minimum step number of knots in the simple cubic lattice, J. Phys. A 42 (2009) 475006.

## Extraction notes
- All formulas checked against page images (pp. 1–7).
- ⚠ The comparison values on p. 6 ("32, 48, 66, 88 and 112" for c = 4…8) are the formula (3/2)c^2 + 2c + 1/2 = 32.5, 48, 66.5, 88, 112.5 rounded down for even c (not stated in paper; the paper prints the integers only).
- ⚠ The torus-knot case of the proof (p. 5) states "Suppose that K is (n+1,n)-torus knot for n ≥ 3"; the theorem statement itself does not restrict n.
- ⚠ In the non-alternating case the proof says K "consists of" (3/2)c^2 − 4c + 5/2 edges (rather than "at most"); transcribed as printed.
- ⚠ p. 6: "168C(L)" uses capital C — likely typo for c(L); transcribed as printed.
- No tables. Figures pages 2–5 rendered.
