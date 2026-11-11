# JvRW91 — The BFACF algorithm and knotted polygons
- **Authors:** E J Janse van Rensburg (Supercomputer Computations Research Institute, Florida State University), S G Whittington (Department of Chemistry, University of Toronto)
- **Venue / year / identifiers:** J. Phys. A: Math. Gen. 24 (1991) 5553–5567; received 11 March 1991; IOPscience http://iopscience.iop.org/0305-4470/24/23/021
- **File:** papers/rensburg1991.pdf   **Pages:** 16 (p. 1 = IOPscience cover sheet; printed page 5553 = PDF page 2, i.e. PDF page = printed − 5551)
- **Text layer:** partly garbled (OCR of a scan; several words and symbols corrupted, statements still legible; displayed formulas checked on image only for Eq. 2.1–2.2)

## Abstract
The BFACF algorithm applied to polygons involves sampling on a Markov chain whose state space is the set of all polygons. In three dimensions, for the simple cubic lattice, we prove that the ergodic classes of this Markov chain are the knot classes of the polygons.

## Notation and conventions
- (p. 4 [printed 5555]) Unrooted self-avoiding polygon in any lattice: a sequence of lattice sites ω_0, ω_1, …, ω_n with associated edges (ω_i, ω_{i+1}) such that ω_0 = ω_n, ω_i and ω_{i+1} nearest neighbours, and ω_1, …, ω_n all distinct. If ω_0 ≠ ω_n it is a walk. Z^d = d-dimensional hypercubic lattice, {e_i} orthogonal unit vectors.
- (p. 3) P = space of equivalence classes of polygons **modulo translation** in Z^d ("unrooted polygons"); W_xy = set of walks connecting x and y. BFACF moves (Fig. 1, p. 4: "The elementary moves of the BFACF algorithm") change |ω| (number of edges) by −2, 0 or +2; endpoints of walks are fixed, whereas an unrooted polygon "can be translated anywhere" (Prop. 3.10).
- (p. 4) Limit distribution on ergodic class ℰ_i (Eq. 2.1): π_i(ω) = Z_i(β)^{−1} |ω| β^{|ω|}, with normalisation (Eq. 2.2) Z_i(β) = Σ_{ω∈ℰ_i} |ω| β^{|ω|} (checked on image: factor |ω| appears in both). β = "adjustable parameter".
- (p. 4–5) Knot = embedding (f; S¹, R³); oriented embeddings ambient isotopic if an orientation-preserving isotopy H_t with h_0 = id, h_1 f = g exists; knot type of a lattice polygon = its class as a piecewise-linear embedding of the circle in R³; "two oriented polygons which are ambient isotopic do not need to have the same number of edges".
- (p. 5–6) Projection onto the plane Q = {x e_1 + y e_2 | x,y ∈ R} (z = 0 plane); edges parallel to e_3 project to a point and are ignored; vertices of the projected polygon with 180° angles discounted; regular lattice knot projection = the regular projection (finitely many multiple points, all double, no vertex on a double point) of a lattice polygon, with over/under information.
- Definition 3.1 (p. 7): a segment [ω_i, ω_j] of a polygon ω is the set of vertices ω_i, ω_{i+1}, …, ω_j if i ≤ j, or the union of [ω_i, ω_n] and [ω_0, ω_j] if j < i. Definition 3.2: a segment is a *side* if the union of all edges associated with its vertices is a line segment; a polygon in P_n has at least 4 and at most n sides. Side operator M_{ij}(e_*) shifts a side [ω_i, ω_j]_s by one unit in direction e_* perpendicular to it (Eq. 3.1: M_{ij}(e_*)[ω_i, ω_j]_s = [ω_i + e_*, ω_j + e_*]_s); inverse M_{ij}(−e_*); can split a side into sections (Eq. 3.2).
- Definition 3.4 (p. 8): ω is in *standard form* if every plane Π that meets Q (the z=0 plane) at 90° contains at most a finite number of disjoint points and at most one segment of ω, and the projection of ω in Q contains no multiple edges; a polygon in standard form has a regular lattice knot projection.

## Numbered statements
All statements are proved in the paper (this paper is the source of the quoted "Theorem 1" in Scharein et al. 2009).
- **Proposition 2.1 (p. 6 [5557]).** Let d = 3 and let ω and ν be two polygons in the set P = ∪_n P_n. If ω and ν are in the same ergodic class, then they have the same knot-type. *Proof (paper):* "A BFACF move corresponds to a continuous deformation of the pair (ω, R³), if we consider the polygon to be embedded in Euclidean 3-space."
- **Proposition 2.2 (p. 6).** Suppose that ω is a walk in the cubic lattice in W_xy with projection ν in the square lattice. Suppose that ν is a self-avoiding walk connecting the vertices u and v (the projections of x, y). Then there exists a sequence of BFACF moves on ω which will change the projection ν into any other self-avoiding walk connecting u and v. (Follows from ergodicity of BFACF in the square lattice, Madras 1986.)
- **Proposition 3.3 (p. 7).** Let ω and ν be two polygons in Z³ which have regular lattice knot projections. If ω and ν have identical lattice knot projections, then there exists a set of BFACF moves which connects ω and ν. *Proof idea:* split lines at underpasses, use the side operator M(e_*) to move segments to a standard position and each underpassing side to unit distance from the overpassing vertex.
- **Lemma 3.5 (p. 8).** Let ω be a polygon. With m ∈ Z, the plane π(m + ½) [perpendicular to a lattice axis] intersects ω in a finite number of points which are elements of a number of sides in ω. We can use BFACF moves to add an edge to each of the sides intersected by this plane. (Used to "open up space"/create empty working space in a projection.)
- **Proposition 3.6 (p. 9).** Let ω be any polygon. Then we can apply BFACF moves to ω to transform it into a polygon in standard form.
- **Corollary 3.7 (p. 10).** Let ω be any polygon. Then, by applying BFACF moves, we can transform ω into a polygon which has a regular lattice knot projection.
- **Proposition 3.8 (p. 12).** Let ω and ν be polygons of the same knot type, each with a regular lattice knot projection, W and V. Then, by applying BFACF moves, we can transform ω into ω′, such that there exists a plane isotopy ι : (W′, Q) → (V, Q), where W′ is the regular lattice knot projection of ω′. *Proof idea:* W and V are connected by Reidemeister moves; perform them one by one with BFACF moves (Reidemeister I–III constructions use Lemma 3.5 to make room and Prop. 2.2 to realise the move; Figs 3–5).
- **Proposition 3.9 (p. 13).** Let ω and ν be two polygons with regular lattice knot projections W and V such that there exists an isotopy of the plane ι : (W, Q) → (V, Q). Then we can perform BFACF moves such that ι is the identity or a translation of the lattice Z². *Proof idea:* make areas of W large (Lemma 3.5), then label the areas, fix bounding vertices and "close in" areas using Prop. 2.2 (Figs 6, 7).
- **Proposition 3.10 (p. 14).** Let ω be any polygon with projection W in the plane Q. Then we can apply BFACF moves to translate W any distance in a lattice direction in Q. *Proof:* apply M_{ij}(e_1) d times to all sides in the extremal plane, then step the plane inwards.
- **Theorem 3.11 (p. 15).** The ergodicity classes of the BFACF algorithm, when applied to unrooted polygons, are the knot types of the polygons. *Proof:* direct from Proposition 3.3, Corollary 3.7, and Propositions 3.8, 3.9 and 3.10 (with Prop. 2.1 for the converse). Equivalent statement (p. 3): two polygons of the same knot type can be interconverted by BFACF moves, but not otherwise.

## Key equations and quantitative claims outside numbered statements
- p. 3: Madras (1986): BFACF is ergodic on polygons in the square lattice; Madras & Sokal (1987): no length-conserving local-move algorithm can be ergodic (quoted); in 3D BFACF is reducible ("it is easy to see … a knotted polygon is enough to show that the algorithm is not ergodic").
- p. 4: in 2D the Markov chain has one ergodic class; in 4 and higher dimensions "little is known" / p. 15: "still open though we think it unlikely that topological obstructions will occur".
- p. 15–16 (discussion): Brower (1991, unpublished) suggested adding a four-bond crankshaft move makes the algorithm ergodic for all polygons: put ω into a conformation whose vertices have third coordinate only 0 or 1, with nonzero third component only at overpasses; a descending-overcrossing diagram represents the unknot, so any knot can be untied by crankshaft moves (Figs 8). Heuristic/sketch, not proved here.

## Methods / algorithms
Proof strategy of Theorem 3.11 (pp. 6–15):
1. (⟸ direction: same ergodic class ⇒ same knot type) Prop. 2.1: a BFACF move is an ambient isotopy.
2. (Converse) Step A: use BFACF side-shifting moves M_{ij}(e) (Eq. 3.1) to open empty space around any point of a projection (Lemma 3.5).
3. Step B: bring any polygon to standard form (no more than one segment per perpendicular plane, no multiple edges), hence to a regular lattice knot projection (Prop. 3.6, Cor. 3.7).
4. Step C: given two polygons of the same knot type with regular lattice knot projections, there is a sequence of Reidemeister moves between projections; realise each Reidemeister move I, II, III by BFACF moves (make segments planar using M(±e_3), use Prop. 2.2 for planar moves) (Prop. 3.8).
5. Step D: make isotopic projections identical edge-by-edge (Prop. 3.9; "close in" areas using Prop. 2.2), and translate the projection (Prop. 3.10); then identical projections imply polygons connected by BFACF (Prop. 3.3).

## Tables
None.

## Figures
- **Fig. 1 (p. 4)** — "The elementary moves of the BFACF algorithm." *What it shows:* the three local moves (a) and (b): type ±2 (spike in/out) and type 0 (shifting a unit square flip). Image: ../figures/JvRW91/p04.png
- **Fig. 2 (p. 5)** — "The three Reidemeister moves". Image: ../figures/JvRW91/p05.png
- **Fig. 3 (p. 11)** — "A Reidemeister move of type I performed on a polygon." Image: ../figures/JvRW91/p11.png
- **Fig. 4 (p. 11)** — "Reidemeister II performed on a projection of a polygon."
- **Fig. 5 (p. 12)** — Reidemeister III (regions P_1, P_2, P_3 enlarged). Image: ../figures/JvRW91/p12.png
- **Fig. 6 (p. 13)** — "To make W_1 identical to V_1 we fix the segments bounding W_1 at the vertices i and apply proposition 2.2." Image: ../figures/JvRW91/p13.png
- **Fig. 7 (p. 14)** — "The areas labelled W_i, i = 1 to 5, and A form a cluster. V_1 forms a second cluster." Image: ../figures/JvRW91/p14.png
- **Fig. 8 (p. 15)** — "A crankshaft which 'passes' one segment of a polygon through another." Image: ../figures/JvRW91/p16.png (continues on p. 16)

## Stated limitations, open problems, future work
- p. 15: the BFACF algorithm "cannot be applied (as it stands) to sample uniformly from the space of all polygons" (p. 3), but is "a convenient one for studying the properties of polygons with given knot type".
- p. 15: "A question which arises naturally in three dimensions is what extra moves are needed to make the algorithm ergodic?" — Brower's crankshaft proposal (unpublished).
- p. 15: ergodicity in four and higher dimensions still open.

## References worth following
- Madras N 1986, ergodicity of BFACF on square-lattice polygons (cited; reference entry "Madras N and Slade G … in preparation" and "Madras N and Sokal A D 1987 J. Stat. Phys. 47 573").
- Berg B and Foerster D 1981, Phys. Lett. 106B 323; Aragão de Carvalho, Caracciolo, Fröhlich 1983, Nucl. Phys. B 215 209 (BFACF origin).
- Janse van Rensburg & Whittington 1991 J. Phys. A 24 3935 (companion: dimensions of knotted polygons).
- Reidemeister 1932 Knotentheorie; Burde & Zieschang 1985 Knots.

## Extraction notes
- OCR text layer has garbled symbols/words (e.g. "AbstracL", figure remnants); statements reconstructed from OCR and cross-checked against context; the displayed Eq. (2.1)–(2.2) verified on page image. Statement text for Prop. 2.2 and Lemma 3.5 is partly reconstructed (variable names u, v and the plane notation π(m+½) were garbled in OCR): ⚠ treat the exact notation as approximate; content/meaning is clear.
- Figure pages rendered: 4, 5, 6, 7, 11, 12, 13, 14, 16.
