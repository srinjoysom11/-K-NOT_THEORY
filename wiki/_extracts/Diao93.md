# Diao93 — Minimal Knotted Polygons on the Cubic Lattice
- **Authors:** Yuanan Diao (Department of Mathematics, Kennesaw State College, Marietta, GA 30061)
- **Venue / year / identifiers:** Journal of Knot Theory and Its Ramifications, Vol. 2 No. 4 (1993) 413–425, © World Scientific Publishing Company. Received 15 November 1992.
- **File:** papers/diao1993.pdf   **Pages:** 13
- **Text layer:** scan (worked from page images only)

## Abstract
The polygons on the cubic lattice have played an important role in simulating various circular molecules, especially the ones with relatively big volumes. There have been a lot of theoretical studies and computer simulations devoted to this subject. The questions are mostly around the knottedness of such a polygon, such as what kind of knots can appear in a polygon of given length, how often it can occur, etc. A very often asked and long standing question is about the minimal length of a knotted polygon. It is well-known that there are knotted polygons on the lattice with 24 steps yet it is unproved up to this date that 24 is the minimal number of steps needed. In this paper, we prove that in order to obtain a knotted polygon on the cubic lattice, at least 24 steps are needed and we can only have trefoils with 24 steps.

Keywords: Knots, Knotted Polygons, Cubic Lattice, Self-avoiding Walks.

## Notation and conventions
All definitions are in Section 2 (pp. 2–3; printed pp. 414–415).
- **Polygon (Def. 1, p. 2):** "A polygon on the simple cubic lattice is a piece-wise linear simple closed curve such that each linear piece is a unit line segment with its end points on the simple cubic lattice. Each such unit segment is called a step and its end points are called vertices." Lattice = simple cubic lattice Z³. A polygon of n steps is denoted P(n) (or P).
- **l-equivalent (Def. 2, p. 2):** two polygons "of the same length and … also topologically equivalent".
- **Reducible (Def. 3, p. 2):** "A polygon P is called reducible if there is a shorter polygon which is topologically equivalent to P."
- **Minimal knotting number n₀ (Def. 4, p. 2):** "The minimal number of steps needed for a polygon to be knotted is called the minimal knotting number and is denoted by n₀."
- **x-step / y-step / z-step (Def. 5, p. 2):** a step parallel to the x-axis (resp. y, z).
- **Projection graph G (Def. 6, p. 2):** the projection of P onto the xy-plane, a graph on the square lattice; "P-vertex" vs "G-vertex". A single edge comes from the projection of a single x- or y-step; otherwise a *multiple edge*, whose *multiplicity* is the number of x- (or y-) steps projected to it. Degree d(v) = number of edges ending at v (1 to 4); multiplicity m(v) = sum of multiplicities of edges at v (must be even). Total multiplicity M(G) = sum of multiplicities of all edges = number of x- and y-steps in P.
- **Path / 1-path (Def. 7, p. 3):** a path is a continuous sequence of steps of P; a 1-path is a path whose projection onto the xy-plane contains only single edges.
- **Branch B(k) (Def. 8, p. 3):** a simple path of edges of G ending at a degree-one vertex on one side and at a degree 3 or 4 vertex on the other, every middle vertex of degree two; length k = number of edges.
- **G₁₄, l₁₄, mP(22), mG₁₄, ml₁₄ (p. 3):** for P(22) with a, b, c the numbers of x-, y-, z-steps, WLOG a + b ≤ 14, so M(G) ≤ 14; G written G₁₄. l₁₄ = number of loops in G₁₄ = number of generators of π₁(G₁₄). mP(22) is a knotted irreducible P(22) whose G₁₄ has the maximum number of loops; its graph/loop count are mG₁₄, ml₁₄.
- **Square move (Def. 9, pp. 3–4):** replace a 1-path L of mP₂₂ whose projection is half of a unit square (other vertex of the square not occupied by mG₁₄) by a 1-path L′ of same length and endpoints projecting to the other half; preserves length and knot type (Fig. 2(a)).
- **Rotation (p. 4):** replace a path whose projection is a B(1) by one with same length and end points projecting to a different B(1), provided the open end vertex is not occupied by mG₁₄ (Fig. 2(b)).
- **Rigid move (p. 5):** graphs are considered up to rigid moves; only non-equivalent cases are listed.
- p (Lemma 3 proof, p. 7): length of the outer loop of mG₁₄ bounding all other loops.

## Numbered statements
**Theorem (p. 3).** The minimal knotting number n₀ = 24. *(proved here)*
Proof idea: "Figure 1 shows a polygon of 24 steps that is a trefoil. Therefore n₀ ≤ 24. Thus it suffices to show that any P(n) with n even and n ≤ 22 cannot be knotted." First show n₀ ≠ 22; "the same argument also applies to the smaller numbers". Strategy: "eliminate all possibilities of mP(22) by eliminating all the possibilities of mG₁₄", in seven lemmas.

**Lemma 1 (p. 5).** mG₁₄ cannot be a graph that contains two parts G′ and G″ such that G′ and G″ are connected at a single G-vertex v and each part contains at least one loop. (Printed with a typesetting artifact "G^Σprime".) "Lemma 1 tells us that every loop in mG₁₄ has to share at least one edge with some other loop unless there is only one loop."
Proof idea: if exactly two P-vertices project to v, mP(22) is the connected sum of two shorter polygons P₁, P₂, one of which would be knotted; for i ≥ 4 P-vertices at v, the multiplicity sum s of G′ satisfies s ≥ 8 (cases Fig. 7), and same for G″, so M(mG₁₄) ≥ 16, contradiction. "The case i ≥ 6 is much easier and is left to the reader."

**Lemma 2 (p. 6).** mG₁₄ cannot be a tree.
Proof idea: not a simple path (else deformable onto a plane); since B(k) does not appear for k ≥ 2 only Fig. 8 cases remain; 8(a),(b) eliminated by square moves creating loops; 8(c),(d) "either create more loops … or M(G₁₄) will exceed 14. Details are left to the reader."

**Lemma 3 (p. 7).** mG₁₄ has at most four loops.
Proof idea: outer loop of length p; only one or two loops if p = 14, 12, 6 or 4; for p = 8, 10 check the shapes of Fig. 9.

**Lemma 4 (p. 7).** mG₁₄ cannot have four loops.
Proof idea: must be Fig. 10(a); at most 3 crossover points, so the only knot is Fig. 10(b) (or z-mirror). With z-coordinates of steps: δ ≤ −1, χ ≥ 1, γ ≥ 1, ε ≤ γ − 1, φ ≥ γ + 1 ≥ 2, η ≤ −1, α ≥ η + 1, β ≤ η − 1 ≤ −2; hence χ − δ ≥ 2, φ − ε ≥ 2, α − β ≥ 2, γ − β ≥ 3 and φ − η ≥ 3 (p. 8). "That is, at least 12 z- steps are needed … Yet, we have only eight available."

**Lemma 5 (p. 8).** mG₁₄ cannot contain exactly three loops.
Proof idea: three loops only when p = 8 or 10; non-trivial cases Fig. 11(a)–(e), 12, 13 eliminated (≤ 2 crossovers, reducible paths, square moves). "11(d) can be discussed similarly. Details are left to the reader."

**Lemma 6 (p. 9).** mG₁₄ cannot contain exactly two loops.
Proof idea: p ≠ 12 (reducible); p = 10 cases eliminated via reducible 1-paths; p = 8 cases Fig. 14; p = 6 cases Fig. 15; case 15(d) / Fig. 16: δ ≤ −1, φ ≤ −1, ε ≥ 1, γ ≥ 1, β, χ ≥ ε + 1 ≥ 2, τ ≥ 1, η ≥ τ + 1 ≥ 2 (p. 11); needs at least nine (hence ten, even) z-steps but only eight available.

**Lemma 7 (p. 11).** mG₁₄ cannot contain a single loop.
Proof idea: a loop with no B(1) lies on a cylinder / 2-sphere; one B(1) is reducible or square-movable; two B(1)'s: Fig. 17 (17(d) has total multiplicity 16; 17(c) has ≤ 2 crossovers); three B(1)'s: Fig. 18 cases eliminated (18(c) forces 16 x- and y-steps). "For the other p values, the discussion is similar and easier so the details are left to the reader again."

**Conclusion (p. 12, unnumbered).** "Combine all the lemmas obtained, we now see that mG₁₄ must be empty, so is mP(22). … any number less than 22 cannot be the minimal knotting number either, so the theorem is proved."

**Claim (p. 12, unnumbered; proof only sketched).** "The same argument can also be used to prove that the smallest knots we can obtain using 24 steps are only trefoils. Basically, one has to eliminate all impossible situations for the smallest projection G16 of mP(24) and show that the ones left can only produce trefoils." (Stated in the abstract as proved; in the body only this sketch is given.)

## Key equations and quantitative claims outside numbered statements
- p. 3: For P(22) with a, b, c x-, y-, z-steps, a + b + c = 22, so the two smaller numbers sum to at most 14 ⇒ M(G) ≤ 14 (rigorous).
- p. 3: All lattice polygons have even length.
- p. 5: For a B(2) path of mP(22) to be irreducible it must contain at least 12 steps (Fig. 5(d)); then "impossible to make a knot with the only ten steps left"; "any B(k) with k ≥ 3 cannot appear in G₁₄".
- p. 6 (Lemma 1 proof): s ≥ 8 for i ≥ 4, giving M(mG₁₄) ≥ 16 > 14.
- p. 8: Fig. 10(b) case needs ≥ 12 z-steps vs 8 available. p. 11: Fig. 16 case needs ≥ 10 z-steps vs 8 available.
- p. 12: Defines "the minimal knotting number for each knot type … the minimal number of steps needed for a polygon to have the given knot type", a knot invariant.

## Methods / algorithms
Proof by exhaustive case elimination on the xy-projection graph (pp. 3–12):
1. Exhibit a 24-step trefoil (Fig. 1) ⇒ n₀ ≤ 24.
2. Suppose a knotted P(22) exists; WLOG ≤ 14 x+y steps, so projection G₁₄ has total multiplicity ≤ 14 and only 8 z-steps (when a + b = 14).
3. Choose mP(22) knotted, irreducible, maximizing number of loops of G₁₄. Hence no square move or rotation may create more loops, and no subpath may be shortened.
4. List forbidden local configurations (Fig. 3) and show B(k), k ≥ 2, cannot occur (Figs. 4–5).
5. Lemmas 1–7: no cut-vertex joining two looped parts; not a tree; ≤ 4 loops; not 4, 3, 2 or 1 loops — using crossing count (≤ 2 crossovers ⇒ unknot; ≤ 3 crossovers ⇒ trefoil pattern only), z-coordinate inequalities counting needed z-steps, reducibility, and square moves.
6. Hence mG₁₄ empty; same argument for n < 22.

## Tables
No tables.

## Figures
- **Fig. 1 (p. 3)** — "Fig. 1". *What it shows:* a 24-step lattice trefoil drawn in perspective. Image: ../figures/Diao93/p03.png
- **Fig. 2 (p. 4)** — "Fig. 2". *What it shows:* (a) square move (path on half a unit square replaced by the other half, dotted); (b) rotation of a B(1). Image: ../figures/Diao93/p04.png
- **Fig. 3 (p. 4)** — "Fig. 3". *What it shows:* forbidden configurations (a), (b), (c), (c′), (d), (e), (f), (f′) in mG₁₄ with edge multiplicities (1, 2, 3) labelled and big dots for vertices connected to the rest of the graph. Image: ../figures/Diao93/p04.png
- **Fig. 4 (p. 4)** — "Fig. 4". *What it shows:* reductions (a)–(d) corresponding to cases 3(a), 3(b), 3(c), 3(e), with u′, v′ labels and dotted replacement paths. Image: ../figures/Diao93/p04.png
- **Fig. 5 (p. 5)** — "Fig. 5". *What it shows:* (a)–(d) 3D paths over a B(2), showing an irreducible one needs ≥ 12 steps (5(d), with vertex v). Image: ../figures/Diao93/p05.png
- **Fig. 6 (p. 6)** — "Fig. 6". *What it shows:* cutting mP(22) at q₁, q₂ into walks W₁, W₂ and closing W₂ into polygon P₂. Image: ../figures/Diao93/p06.png
- **Fig. 7 (p. 6)** — "Fig. 7". *What it shows:* cases (a)–(d) for G′ at vertex v with multiplicities m, m′, m″, n′, n″ (and (d) with 1,1,1,3). Image: ../figures/Diao93/p06.png
- **Fig. 8 (p. 7)** — "Fig. 8". *What it shows:* four tree shapes (a)–(d) (T, cross, and two double-bar shapes). Image: ../figures/Diao93/p07.png
- **Fig. 9 (p. 7)** — "Fig. 9". *What it shows:* nine possible outer-loop shapes (a)–(i) for p = 8, 10 (L-shapes, rectangles, square). Image: ../figures/Diao93/p07.png
- **Fig. 10 (p. 8)** — "Fig. 10". *What it shows:* (a) the four-loop graph with one edge of multiplicity 2; (b) the trefoil-candidate with steps labelled by z-coordinates χ, 0, δ, ε, α, γ, η, φ, β. Image: ../figures/Diao93/p08.png
- **Fig. 11 (p. 8)** — "Fig. 11". *What it shows:* three-loop graphs (a)–(e) with multiplicity-2 edges marked. Image: ../figures/Diao93/p08.png
- **Fig. 12 (p. 9)** — "Fig. 12". *What it shows:* two remaining 11(e) cases with an attached B(1), multiplicities 2. Image: ../figures/Diao93/p09.png
- **Fig. 13 (p. 9)** — "Fig. 13". *What it shows:* 11(e) without branches: (a) edges of multiplicity 2; (b) multiplicities 2, 3, 2. Image: ../figures/Diao93/p09.png
- **Fig. 14 (p. 9)** — "Fig. 14". *What it shows:* two-loop cases for p = 8, (a)–(d), with multiplicities 1 or 2. Image: ../figures/Diao93/p09.png
- **Fig. 15 (p. 10)** — "Fig. 15". *What it shows:* two-loop cases for p = 6, (a)–(d) (c contains a multiplicity-4 edge). Image: ../figures/Diao93/p10.png
- **Fig. 16 (p. 10)** — "Fig. 16". *What it shows:* case 15(d) labelled with z-coordinates α, β, γ, ε, η, φ, 0, δ, χ, τ. Image: ../figures/Diao93/p10.png
- **Fig. 17 (p. 11)** — "Fig. 17". *What it shows:* single loop with two B(1)'s, cases (a)–(d) for p = 4 and p = 6. Image: ../figures/Diao93/p11.png
- **Fig. 18 (p. 11)** — "Fig. 18". *What it shows:* single loop with three B(1)'s, cases (a)–(c) (c has multiplicities 2, 3, 2, 3, 2). Image: ../figures/Diao93/p11.png

## Stated limitations, open problems, future work
- p. 2: Question (i) "Given a positive integer n, how many different knots can be realized by a polygon of length n on the cubic lattice?" — "trivial for small n but soon becomes very hard". Question (iv) "Given a knot type, what is the minimal length needed for a polygon on the cubic lattice to be a knot with the given knot type?" — only the simplest case (24 steps ⇒ trefoils) addressed.
- Several cases are "left to the reader" (Lemma 1 case i ≥ 6, Lemma 2 cases 8(c),(d), Lemma 5 case 11(d), Lemma 7 other p values) (pp. 6, 7, 9, 12).
- p. 12: "It should be very interesting if we can see a relation between this knot invariant [minimal knotting number per knot type] and other knot invariants such as the minimal number of crossover points of a knot."

## References worth following
- [1] G. Burde and H. Zieschang, Knots, Walter de Gruyter, Berlin 1985 (classical knot theory used in proofs).
- [9] N. Pippenger, Knots in Random Walks, Discrete Applied Math. 25 (1989) 273–278.
- [11] D. W. Sumners and S. G. Whittington, Knots in Self-Avoiding Walks, J. Phys. A: Math. Gen. 21 (1988) 1689–1694 (printed "Wittington").

## Extraction notes
- Scan; transcribed entirely from page images. All 13 pages read.
- Lemma 1 statement prints "G^Σprime" (typesetting error for G′); reference [10] prints "nineit Entanglement Complexity of Graphs in bf Z³" (LaTeX artifact). Transcribed as G′.
- ⚠ The abstract states the trefoil-only result for 24 steps as proved; the body (p. 12) only sketches it ("Basically, one has to eliminate …").
- The Theorem is unnumbered ("Theorem."). Greek labels in Figs. 10(b) and 16 read from the images; inequalities copied as printed.
- No tables in this paper.
