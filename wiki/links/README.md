# Links (and spatial graphs) in the cubic lattice

Goal-3 background. Notation: Rolfsen names c^μ_i (2^2_1 = Hopf link, 4^2_1 = (2,4) torus link, 6^3_2 = Borromean rings, …) as printed in each source.

## Lattice stick numbers of links

| link | s_L | source |
|---|---|---|
| 2-component unlink 0^2_1 | 8 | [Adams12] Thm 6.1 |
| Hopf link 2^2_1 | 8 | [Adams12], [HNO14links] |
| 2^2_1 # 2^2_1, 6^3_2 (Borromean), 6^3_3 | 12 | [Adams12], [HNO14links] |
| 4^2_1 | 13 | [Adams12] Thm 6.5 |
| 5^2_1 (Whitehead) | 14 | [HNO14links] Thm 1 |
| 7^2_7 | 16 | [Adams12] |
| 8^2_15, 8^2_16 | 18 | [Adams12] |

**Classification ([HNO14links] Thm 1, proved):** the only links with ≥ 2 components and s_L ≤ 14 are 2^2_1, 2^2_1#2^2_1, 6^3_2, 6^3_3, 4^2_1 and 5^2_1. (Knot analogue: only 3_1 and 4_1 have s_L ≤ 14 — [HO15].) Proof tool: "extended properly leveled" lattice links with the same stick counts (Lemma 2); a planar component forces exactly four z-sticks (Prop 3).

**General bounds:**
* Two components, one planar, linking number n: ≥ 4n + 4 sticks (≥ 4n + 5 for n = 2, 3); 2-braid links other than 4^2_1, 6^2_1 attain 4n + 4 ([Adams12] Prop 6.2, Lemma 6.4, Cor 6.3).
* **Rational p/q links with exactly 4 z-sticks: s_L ≤ 2p + 6, and ≤ 2p + 5 for 2-component links** ([KN18] Thm 1), via "2-circuit presentations" (two planar arcs joined by segments above the plane) built from the (p, q)-form diagram.
* Links realise every growth exponent r ∈ [1/2, 1] of s and s_L in crossing number ((p,q)-Hopf links, [HNOR15] Thm 1).

## Which lattice diagrams lift to lattice links?

A knot/link diagram drawn on the Z² grid need not be the projection of a lattice stick link in Z³ ([AB18]). **Criterion:** a lattice diagram is the projection of a (proper) lattice stick knot or link iff it contains no "Celtic configuration" ([AB18] Thm 2.4), equivalently no "Escher square" ([NPP18] Thm 5, shorter proof): orient each edge of the diagram from the strand that must be lower to the one that must be higher; the diagram lifts iff this digraph has a height function, iff it has no directed cycle, iff it has no directed 4-cycle (Lemmas 2–4).

*My remark:* this matters for diagram-based constructions of short lattice links (draw on Z², then lift): check for Escher squares before lifting.

## Minimal lengths of links

Minimal SC lattice lengths for links are mostly unpublished in this collection; [READING_LIST.md](../../READING_LIST.md) records the Borromean rings at 36 edges (Uberti et al. 1998, not in `papers/`). Growth: [HNOR15] Thm 2 gives families of prime links with Len and Rop of order c^r for every r ∈ [3/4, 1] — see [lattice-length/upper-bounds-crossing-number](../lattice-length/upper-bounds-crossing-number.md).

## Ropelength of links

See [ropelength/lower-bounds](../ropelength/lower-bounds.md#links) (2πk-type bounds, linking number, Milnor invariants [KM16]) and [ropelength/upper-bounds](../ropelength/upper-bounds.md) (T(Q, Q) torus links [Klotz26tqq] within a factor ≈ 1.77 of their lower bound; chains of rings exact).

## Spatial graphs

* **Lattice stick number of spatial graphs** ([YLO18] Thm 1): for a spatial graph G with vertex degrees 3–6 (degree 2 only for one vertex per knot component), s_L(G) ≤ 3c(G) + 6e − 4v − 2s + 3b + k (e edges, v vertices, s cut-components, b bouquet cut-components, k knot components). Ingredients: arc index of graphs α(G) ≤ c(G) + e + b (Lee–No–Oh, quoted) and #binding points = α + v − e (Lemma 2).
* **Entanglement of random graph embeddings** ([SSW92] §4): for graph types with degrees ≤ 6, almost all long embeddings in Z³ are knotted if there is no cut edge — see [statmech/knot-probabilities](../statmech/knot-probabilities.md).

## Statistics of linked pairs

[BPS26]: pairs of polygons spanning a lattice tube — almost all are complex (linking, splitting number, bridge number grow linearly with size). Details in [statmech/knot-probabilities](../statmech/knot-probabilities.md#two-component-systems-in-tubes-bps26).
