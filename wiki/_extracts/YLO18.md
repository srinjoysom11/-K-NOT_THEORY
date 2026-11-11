# YLO18 — Lattice stick number of spatial graphs
- **Authors:** Hyungkee Yoo, Chaeryn Lee, Seungsang Oh (Korea University; Univ. of Illinois Urbana-Champaign)
- **Venue / year / identifiers:** arXiv:1806.09720v1 [math.GT], 25 Jun 2018. MSC 2010: 57M25, 57M27.
- **File:** papers/4_links/Yoo-Lee-Oh_2018_Lattice_stick_number_spatial_graphs_1806.09720.pdf   **Pages:** 11
- **Text layer:** ok (some inline formulas on p. 2 and figure labels garbled; formulas read from text and checked for consistency)

## Abstract
The lattice stick number of knots is defined to be the minimal number of straight sticks in the cubic lattice required to construct a lattice stick presentation of the knot. We similarly define the lattice stick number s_L(G) of spatial graphs G with vertices of degree at most six (necessary for embedding into the cubic lattice), and present an upper bound in terms of the crossing number c(G)
s_L(G) ≤ 3c(G) + 6e − 4v − 2s + 3b + k, where G has e edges, v vertices, s cut-components, b bouquet cut-components, and k knot components.

## Notation and conventions
- (p. 1) Piecewise linear category throughout. "A stick presentation of a spatial graph consists of straight sticks glued together end to end. The minimal number of sticks necessary to construct a stick presentation of a spatial graph G is defined as the stick number s(G)."
- (p. 1) "we may choose to use sticks in the cubic lattice Z^3. A spatial graph embedded into Z^3 is called its lattice stick presentation. The length of each stick is a positive integer. The lattice stick number s_L(G) of G is the minimal number of sticks necessary to construct a lattice stick presentation of G." (So sticks are maximal straight lattice segments, not unit edges; s_L counts sticks, not lattice length.)
- (p. 2) Only spatial graphs with vertices of degree ≤ 6; no degree-1 or 2 vertices except for a disjoint circle ("knot component"), which "consists of a vertex and an edge".
- (p. 2) splitting-sphere: 2-sphere not meeting G. cut-sphere: meets G in a single vertex (cut-vertex). cut-components: pieces of G after maximal cutting; bouquet cut-component: one vertex and loops. d(x) = degree of vertex x.
- (p. 3–4) Arc presentation: G embedded in an open book (half-planes as pages, z-axis binding), meeting each page in one simple arc with distinct endpoints on the binding axis. Arc index α(G) = minimal number of pages (arcs). Binding points = points of G on the binding axis; β = number of binding points.
- (p. 4) x-stick = stick parallel to the x-axis; x-level = yz-plane containing the ends of an x-stick; y-, z- analogously.
- c(G): crossing number of G (min over diagrams). e, v, s, b, k as in abstract.
- arc cut-component: cut-component consisting of one edge with two distinct endpoints; θ_n cut-component: two vertices joined by n edges (n≥2); trivial if it lies in a plane (p. 5).

## Numbered statements
**Theorem 1 (p. 3) — main result, proved here.** Let G be a spatial graph with 3 ≤ d(x) ≤ 6 for each vertex x, only allowing d(x) = 2 for the unique vertex of each knot component. If G has e edges, v vertices, s cut-components, b bouquet cut-components and k knot components, then s_L(G) ≤ 3c(G) + 6e − 4v − 2s + 3b + k.
Remark (p. 3): "for a knot K this result implies s_L(K) ≤ 3c(K) + 4 which is close to the known upper bound s_L(K) ≤ 3c(K) + 2 in [5]." (⚠ the paper does not say which values of (e,v,s,b,k) it substitutes for a knot; with e=v=s=k=1 the formula gives 3c+1+3b, so 3c+4 corresponds to b=1.)
Proof idea (Sec. 3, pp. 4–10): from an arc presentation with α(G) arcs build a lattice arc diagram (each arc → one x-stick + one y-stick), stack arcs on z-levels in page order joined by z-sticks, save sticks by side-sliding and by straightening arc cut-components, fix degree>3 vertices by vertex-merging, combine cut-components via a tree of nested cylinders, then count sticks and apply Theorem 3.

**Lemma 2 (p. 4) — proved here.** Suppose G has v vertices and e edges. If β is the number of binding points of an arc presentation of G with α(G) arcs then β = α(G) + v − e.
Proof idea (as printed): count endpoints of arcs: 2α(G) = 2(β − v) + Σ_{x∈V} d(x), each of the β − v non-vertex binding points having degree 2; and Σ d(x) = 2e.

**Theorem 3 (Lee–No–Oh [13], p. 4) — quoted.** Let G be any spatial graph with e edges and b bouquet cut-components. Then α(G) ≤ c(G) + e + b. (Generalises the Bae–Park [2] bound on arc index of links.)

## Key equations and quantitative claims outside numbered statements
- (p. 10) Stick count: sticks(L) = 2α(G) − 2s + (α(G) − e + v) + Σ_{d(x)=3} 1 + Σ_{d(x)≥4}(2d(x) − 5) + Σ_{d(x)=2} 1 = 3α(G) − e + v − 2s + Σ_x(2d(x) − 5) + k = 3α(G) + 3e − 4v − 2s + k. Hence s_L(G) ≤ 3α(G) + 3e − 4v − 2s + k ≤ 3c(G) + 6e − 4v − 2s + 3b + k. (⚠ the printed middle line is typeset with the terms "Σ_{d(x)=3} 1" and "Σ_{d(x)≥4}(2d(x)−5)" in garbled text; the final line uses Σ_x(2d(x)−5)=4e−5v, which matches for d=3 only because 2·3−5=1.)
- (p. 4) Side-sliding removes one x-stick (at first binding point) and one y-stick (at last binding point) from each cut-component's lattice presentation, i.e. 2 sticks per cut-component; for a trivial θ_n cut-component n x-sticks can be deleted (p. 5); for arc cut-components at least two sticks are removed by straightening (Sec. 3.4, p. 9).
- (p. 8) Vertex-merging of a vertex of degree d (4≤d≤6) replaces d−2 degree-3 vertices; each merge increases stick number by 1; net per vertex d(x)−2 z-sticks and d(x)−3 extra x/y sticks (p. 9).
- (p. 2, historical, quoted from literature, not proved here): s(3_1)=6, s(4_1)=7 (Randell); stick number of (p,q)-torus knot p<q<2p is 2q (Jin); Negami: (5+√(25+8(c−2)))/2 ≤ s(K) ≤ 2c(K); Huh–Oh: s(K) ≤ (3/2)c(K)+3/2; McCabe: s(K) ≤ c(K)+3 for 2-bridge; Calvo lower bound (7+√(1+8c))/2 ≤ s(K).
- (p. 2, lattice, quoted): Diao: s_L(3_1)=12; Huh–Oh: s_L(4_1)=14 and every other nontrivial knot has s_L ≥ 15; Adams et al.: s_L(T_{p,p+1}) = 6p for p≥2 and s_L(K) ≤ 6c(K) − 4; Janse van Rensburg–Promislow: s_L(K) ≥ 12 for nontrivial K; Hong–No–Oh: s_L(K) ≤ 3c(K)+2 via arc presentation, and all multi-component links with s_L ≤ 14 classified. Lee–No–Oh [14]: s(G) ≤ (3/2)c(G) + 2e − v/2 + 3b/2.

## Methods / algorithms
(Proof strategy, constructive.)
1. (p. 3–4) Start from an arc presentation of G with α(G) arcs; number arcs (pages) 1..α(G) back to front.
2. (p. 4) Lattice arc diagram: move binding axis to line y=x in xy-plane; replace each arc by an x-stick and a y-stick below that line (perturb overlaps).
3. (p. 4–5) Lift to Z^3: place arcs of each cut-component on z-levels in page order from bottom; for arcs sharing a binding point add successive z-sticks between lowest and highest levels.
4. (p. 5–6) Side-sliding: at first binding point (only x-sticks) slide z-sticks along +x in the xz-plane until the shortest x-stick vanishes; same at the last binding point to remove a y-stick. Net −2 sticks per cut-component.
5. (p. 6–7) Combine cut-components: build tree of nested cut-spheres; stack lattice presentations L_k in tree order, each L_j fitted in a thin z-parallel cylinder through p_i and joined by one z-stick p_i–p_j.
6. (p. 7–9) Vertex-merging for degree 4–6 vertices via the pivot vertex z_2 (sliding segments of e_3,…; for d=6 choose the free direction v).
7. (p. 9) Arc cut-components: scale the ball containing branch components, straighten the arc, removing an x- and a y-stick. Rescale to fit Z^3.
8. (p. 9–10) Count sticks (see formula above) and apply Theorem 3.

## Tables
None.

## Figures
- **Fig. 1 (p. 2)** — "Stick and lattice stick presentation". *What it shows (from caption/layout):* stick and lattice stick presentations of the θ-curve 3_1 (text p. 1: "See Figure 1 for an example… of the θ-curve 3_1"). Image: ../figures/YLO18/p02.png
- **Fig. 2 (p. 3)** — "Knot component and bouquet cut-component". *What it shows:* illustrations of the two special cut-component types (not rendered).
- **Fig. 3 (p. 3)** — "Arc presentation". *What it shows:* arc presentation of the θ-curve 3_1 with six pages (per text), labelled vertices/not vertices of G on the binding axis.
- **Fig. 4 (p. 5)** — "Lattice arc diagram and lattice presentation". *What it shows:* a lattice arc diagram in the xy-plane and the resulting 3D lattice presentation. Image: ../figures/YLO18/p05.png
- **Fig. 5 (p. 5)** — "Side-sliding". Sliding z-sticks in +x on the xz-plane to eliminate the shortest x-stick. Image: ../figures/YLO18/p05.png
- **Fig. 6 (p. 6)** — "Tree structure on the set of cut-components". **Fig. 7 (p. 7)** — "Branch and stem cut-component". **Fig. 8 (p. 7)** — "Combining cut-components".
- **Fig. 9 (p. 8)** — "Vertex-merging" (cases d=4,5,6; pivot vertex z_2). Image: ../figures/YLO18/p08.png
- **Fig. 10 (p. 9)** — "Several ways of vertex-merging". **Fig. 11 (p. 10)** — "Reducing the number of sticks for arc cut-components".
(Figure descriptions are from captions and surrounding text; only pp. 2, 5, 8 were rendered.)

## Stated limitations, open problems, future work
None stated explicitly. Only remark: the knot-case corollary 3c(K)+4 is "close to" the known 3c(K)+2 of [5] (p. 3).

## References worth following
- [5] K. Hong, S. No, S. Oh, Upper bound on lattice stick number of knots, Math. Proc. Camb. Phil. Soc. 155 (2013) 173–179 (s_L(K) ≤ 3c(K)+2).
- [13] M. Lee, S. No, S. Oh, Arc index of spatial graphs, arXiv:1711.08116 (Theorem 3).
- [2] Y. Bae, C. Y. Park, An upper bound of arc index of links, Math. Proc. Camb. Phil. Soc. 129 (2000).
- [1] C. Adams et al., Stick index of knots and links in the cubic lattice, JKTR 21 (2012) 1250041.
- [4] Y. Diao, Minimal knotted polygons on the cubic lattice, JKTR 2 (1993) 413–425.
- [8,9] Huh–Oh, Lattice stick numbers of small knots (JKTR 2005); Knots with small lattice stick numbers (J. Phys. A 2010).
- [11] Janse van Rensburg–Promislow, The curvature of lattice knots, JKTR 8 (1999).
- [14] Lee–No–Oh, Stick number of spatial graphs, JKTR 26 (2017).

## Extraction notes
- All 11 pages read via text layer; figures were not inspected visually except by filename/caption, so figure descriptions are from captions and body text. No tables. Lattice relevance: this paper counts sticks (maximal straight segments) in Z^3, not lattice edges/length; bound s_L(K) ≤ 3c(K)+4 for knots (and 3c+2 quoted from [5]).
- ⚠ Remark on p. 3 (3c+4 for knots) requires b=1 for a knot, not stated.
