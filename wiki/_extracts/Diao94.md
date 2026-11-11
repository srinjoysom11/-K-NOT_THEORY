# Diao94 — The Number of Smallest Knots on the Cubic Lattice
- **Authors:** Yuanan Diao (Department of Mathematics, Kennesaw State College, Marietta, Georgia 30061)
- **Venue / year / identifiers:** Journal of Statistical Physics, Vol. 74, Nos. 5/6, 1994, pp. 1247–1254. Received July 30, 1993; final September 14, 1993. 0022-4715/94/0300-1247$07.00/0 © 1994 Plenum Publishing Corporation. Communicated by H. Kesten.
- **File:** papers/diao1994.pdf   **Pages:** 8
- **Text layer:** partly garbled (OCR layer; prose usable, figures/equations checked against images)

## Abstract
It has been shown that the smallest knots on the cubic lattice are all trefoils of length 24. In this paper, we show that the number of such unrooted knots on the cubic lattice is 3496.

KEY WORDS: Knots; knotted polygons; cubic lattice; self-avoiding walks.

## Notation and conventions
- **P(n) (p. 1):** "Throughout this paper, a polygon always means a polygon on the cubic lattice and P(n) means a polygon of n steps."
- **Weighted projection (p. 1):** "The projection of P(24) onto a coordinate plane is a weighted graph on the square lattice with the weight of each edge being the number of steps projected onto it."
- **Minimal projection number m and G(m) (p. 1):** with a, b, c the numbers of x, y, z steps, a + b + c = 24, "hence the sum of the two smaller ones of a, b, and c will be at most 16. This number is called the minimal projection number and is denoted by m. The corresponding projection of P(24) onto a coordinate plane has total weight = m ≤ 16. This projection is called the minimal projection of P(24) and is denoted by G(m)." m is even; the sum of weights at a vertex (its degree) is even. WLOG the xy plane is the minimal projection plane (p. 2).
- **Reducible / l-equivalent (p. 2):** "A polygon is reducible if it is topologically equivalent to a shorter polygon. Two polygons are l-equivalent if they are topologically equivalent and have the same length." Any knotted P(24) is nonreducible.
- **Path, 1-path, square move, B(1), rotation (p. 2):** as in Diao93: a 1-path projects to single edges only; square move (Fig. 1a) and rotation of a B(1) (an edge of G(m) with one end open) (Fig. 1b) give l-equivalent polygons provided the target vertex is unoccupied by G(m).
- **Δ(p) (p. 3):** the loop of G(m) of Lemma 1 bounding every other loop, p its length.
- **Unrooted polygons (p. 6):** "Two polygons on the cubic lattice are regarded as the same if one can be translated to another by letting x₁ = x + a, y₁ = y + b, and z₁ = z + c for certain integers a, b, and c. Otherwise they are said to be different. Such polygons are called unrooted polygons." (i.e., counted up to translation only; reflections/rotations give different polygons.)
- **Rigid motion (Lemma 2, p. 6):** "any combination of reflection, rotation, and translation".

## Numbered statements
**Lemma 1 (p. 3).** If P(24) is knotted, then G(m) cannot be a tree. Furthermore, there exists a loop of G(m) which bounds every other loop of G(m) (if there is any). *(quoted: "Lemma 1 is proved in ref. 1 for P(22). The proof for P(24) is essentially the same with very little modification, so we refer for it to ref. 1.")*

**Lemma 2 (p. 6).** If P(24) is knotted, then G(m) can be transformed to one of the graphs given in Fig. 7 by a rigid motion (i.e., any combination of reflection, rotation, and translation). *(stated; "We state the result in the following lemma, but leave the details to the reader to verify." p. 5)*
Remark. The numbers in Fig. 7 indicate the weights of the corresponding edges and the unmarked edges are all single edges.

**Theorem (p. 8).** On the cubic lattice, there are 3496 unrooted polygons of 24 steps that are knotted and 83,904 rooted polygons of 24 steps that are knotted. Furthermore, they are all trefoils. *(proved here, by enumeration)*

## Key equations and quantitative claims outside numbered statements
- p. 2: total number of P(24) "should be around 10¹¹–10¹²" (citing ref. 6, Sykes et al.).
- p. 3: if p ≥ 14, G(m) is obviously reducible. "There are 25 different shapes for Δ(12) (up to a rigid move), which are listed in Fig. 4." Only the one marked with a single asterisk can give a knot projection (Fig. 7c); the double-asterisk one leads (Fig. 5d) to a G(m) like Fig. 7c.
- p. 4–5: Δ(10), Δ(8) shapes (Fig. 6): 6a and 6d–6f eliminated (reducible; at most 6 other edges since p = 10); 6b requires at least 26 steps to be knotted (ref. 1); 6g eliminated for m ≤ 14 in ref. 1, and "We leave it to the reader to verify that it can also be eliminated for m = 16"; 6c, 6h, 6i are candidates. Δ(6) (rectangle 1×2) is a candidate; Δ(4) is not. "there are five possible shapes left for Δ."
- p. 6: Figs. 7a, 7b have m = 14 ⇒ three possible projection planes, eight rigid-motion images each (not symmetric about any axis) ⇒ 3·8 = 24; with the mirror image about the projection plane (trefoil chirality), 48 different polygons per drawing.
- p. 6: Figs. 7c–7m have m = 16; each trefoil with projection 7c, 7d or 7e corresponds to eight different ones ("notice their symmetry property"); each with projection in 7f–7m to 16 different ones.
- p. 6–7: Count of distinct P(24) per projection: nine each for Figs. 7a and 7b (Fig. 9 example: 3·3 = 9), 63 for 7c, 31 for 7d, 5 for 7e, 39 for 7f, 21 for 7g, 18 for 7h, 13 for 7i, 6 for each of 7j–7m.
- p. 7: Total number of knotted P(24)'s = 48·(9 + 9) + 8·(63 + 31 + 5) + 16·(39 + 21 + 18 + 13 + 6 + 6 + 6 + 6) = 3496 (unrooted). (Arithmetic checks: 864 + 792 + 1840 = 3496.)
- p. 8: rooted count = 24 · 3496 = 83,904.

## Methods / algorithms
1. (pp. 1–3) Consider knotted P(24) (necessarily nonreducible since 24 is minimal [ref. 1]); study its minimal projection G(m), m ≤ 16. Exclude configurations of Fig. 2 (each gives a reducible P(24)); examples of reductions in Fig. 3.
2. (p. 3) Lemma 1: G(m) is not a tree and has an outer loop Δ(p). p ≥ 14 ⇒ reducible.
3. (pp. 3–5) Enumerate outer-loop shapes: 25 shapes of Δ(12) (Fig. 4), shapes of Δ(10), Δ(8) (Fig. 6), Δ(6), Δ(4); eliminate via reducible patterns, square moves, two-component outcomes, step counts. Five shapes remain.
4. (pp. 5–6) Lemma 2: list of 13 minimal projections (Fig. 7a–m) of knotted P(24) (details left to the reader).
5. (p. 6–7) For each projection, draw a trefoil realization (Fig. 8); count the distinct realizations with the same projection (dashed alternatives, e.g. Fig. 9: 3·3 = 9 for Fig. 7a); multiply by the number of distinct rigid-motion images per projection (48, 8 or 16).
6. (p. 7–8) Sum to 3496 unrooted; multiply by 24 roots ⇒ 83,904 rooted.

## Tables
No tables. (The per-projection counts are given in prose; see Key equations.)

## Figures
- **Fig. 1 (p. 2)** — "The square move and the rotation." *What it shows:* (a) square move with dotted replacement half-square; (b) rotation of a B(1). Image: ../figures/Diao94/p02.png
- **Fig. 2 (p. 2)** — "Impossible projections for a knotted P(24)." *What it shows:* local configurations (a), (b), (c), (c′), (d), (e), (f), (f′) with edge weights 1, 2, 3 and big dots for vertices connected to the rest of G(m). Image: ../figures/Diao94/p02.png
- **Fig. 3 (p. 3)** — "Examples of reducible paths." *What it shows:* (a)–(d) 3D paths with dotted shorter replacements, labels u′, v′. Image: ../figures/Diao94/p03.png
- **Fig. 4 (p. 3)** — "All possible Δ(12)'s." *What it shows:* 25 outer-loop shapes of length 12 on the square lattice; one marked * and one marked **. Image: ../figures/Diao94/p03.png
- **Fig. 5 (p. 4)** — "Cases from Fig. 4(**)." *What it shows:* (a)–(d) the plus-shaped Δ(12) with an inner square, arrows on 1-paths; (d) has a dashed square move. Image: ../figures/Diao94/p04.png
- **Fig. 6 (p. 4)** — "All possible shapes of Δ(8) and Δ(10)." *What it shows:* nine shapes (a)–(i): L-shapes, step shapes, rectangles, square. Image: ../figures/Diao94/p04.png
- **Fig. 7 (p. 5)** — "Minimal projections of knotted P(24)." *What it shows:* 13 weighted square-lattice graphs (a)–(m) with edge weights 2 or 3 marked (7a has edges labelled (1), (2), (3)). Image: ../figures/Diao94/p05.png
- **Fig. 8 (p. 7)** — "The realization of knot projections." *What it shows:* 13 three-dimensional 24-step trefoil polygons (a)–(m), one per projection of Fig. 7, with dashed alternative sub-paths. Image: ../figures/Diao94/p07.png
- **Fig. 9 (p. 7)** — "Different knotted P(24) with the same projection, that of Fig. 7a." *What it shows:* three 3D polygons differing in one dashed region. Image: ../figures/Diao94/p07.png

## Stated limitations, open problems, future work
- p. 5: "We state the result in the following lemma, but leave the details to the reader to verify." (Lemma 2.)
- p. 5: Fig. 6g elimination for m = 16 left to the reader.
- p. 2: "The number of cases we will need to study is large but manageable."

## References worth following
1. Y. Diao, Minimal knotted polygons on the cubic lattice, J. Knot Theory Ramification 2:413–425 (1993) (n₀ = 24; Lemma 1).
6. M. F. Sykes, D. S. McKenzie, M. G. Watts, and J. L. Martin, The number of self-avoiding rings on a lattice, J. Phys. A: Gen. Phys. 5:661–666 (1972) (total number of P(24)).
4. N. Madras and G. Slade, The Self-Avoiding Walk (Birkhäuser, Boston, 1993).

## Extraction notes
- All 8 pages read from images; OCR text layer used to confirm prose of p. 6.
- The per-figure counts and the final sum verified arithmetically (= 3496); 24·3496 = 83,904.
- Edge weights in Fig. 7 are small in the image; not transcribed cell by cell (see rendered p05.png).
- No tables.
