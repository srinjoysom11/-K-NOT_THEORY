# NPP18 — Escher squares and lattice links
- **Authors:** Ramin Naimi, Andrei Pavelescu, Elena Pavelescu
- **Venue / year / identifiers:** arXiv:1804.04724v1 [math.GT], 12 Apr 2018 (MSC: primary 57M25, secondary 05C10). The page-1 footer prints "Date: August 30, 2021" (a compile date, apparently).
- **File:** papers/4_links/Naimi-Pavelescu-Pavelescu_2018_Escher_squares_lattice_links_1804.04724.pdf   **Pages:** 4
- **Text layer:** ok

## Abstract
We give a shorter and simpler proof of the result of [2], which gives a necessary and sufficient condition for when a lattice diagram is the projection of a lattice link.

## Notation and conventions
- For n = 2, 3, G_n = infinite graph with vertex set Z^n ⊂ R^n; vw is an edge iff it has length 1 (p. 1). A lattice link is a link L ⊂ G_3 with one or more components (p. 1). Stick = line segment possibly containing more than one edge (p. 1).
- Lattice diagram: a subgraph D ⊂ G_2 such that every vertex of D has degree 2 or 4, and every degree-4 vertex carries over/under crossing information (Fig. 1) (p. 1).
- π: R³ → R², π(x,y,z) = (x,y) (p. 2). **Definition 1 (p. 2):** a lattice diagram D is *realizable* if there is a lattice link L with (1) π(L) = D; (2) for p in the interior of an edge of D, π^{-1}(p) ∩ L is a single point; (3) for a degree-2 vertex v, π^{-1}(v) ∩ L is connected; (4) for a crossing v (degree 4), π^{-1}(v) ∩ L has exactly two connected components, and the component with greater z-coordinates is connected to the two edges of L whose projections are the overstrands at v.
- Escher square (p. 2): a 4-cycle v_1v_2v_3v_4 in D such that, up to reversing all four crossings, every edge v_iv_{i+1} is an understrand at v_i and an overstrand at v_{i+1} (v_{4+1} := v_1).
- Associated digraph Γ of D (p. 2): vertices = edges of D; if edges e, f meet at a crossing with e an understrand and f an overstrand, Γ has a directed edge e → f (written ef). n-cycle in Γ: sequence e_1…e_n of distinct vertices with e_ne_1 and e_ie_{i+1} edges. Height function: integer-valued h on vertices of Γ with h(e) < h(f) for each edge ef.
- Aligned edges in G_2: opposite edges of some unit square (p. 3).

## Numbered statements
- **Lemma 2 (p. 3).** A lattice diagram D is realizable if and only if its associated digraph Γ admits a height function. *Proved here.* Proof idea: (⇒) h(e) = z-coordinate of a point of L over the interior of e; (⇐) lift each edge e of D to the plane z = g(e), join lifts at degree-2 vertices and at both over/both under pairs at crossings; the height-function property makes the over-path and under-path disjoint.
- **Lemma 3 (p. 3).** A digraph Γ admits a height function if and only if it has no cycles. *Proved here.* Proof idea: a cycle would give h(v_1) < … < h(v_n) < h(v_1); conversely, set g = 0 on sources S and g(v) = length of the longest path from S to v.
- **Lemma 4 (p. 3).** The digraph Γ associated with a lattice diagram D has no cycles if and only if it has no 4-cycles. *Proved here.* Proof idea: in a cycle of length n > 4, some e_k and e_{k+2} are aligned (otherwise the edges would form the configuration of Fig. 3(b), contradicting that e_1 and e_n meet at a crossing); then D contains the Fig. 3(c) picture, giving a 4-cycle e_1e_2e_3f.
- **Theorem 5 (p. 4).** A lattice diagram is realizable if and only if it does not contain an Escher square. *Proved here as an immediate consequence of Lemmas 2, 3, 4; the result originally due to Allardice–Bloch [2] (arXiv:1803.03685); this paper gives a shorter proof.*

## Key equations and quantitative claims outside numbered statements
- p. 1: Diao [3] proved the lattice stick number of the trefoil is 12 (quoted). Adams et al. [1] found lattice stick numbers for various knots and links, including all (p, p+1)-torus knots (quoted). Hong–No–Oh [5] found all links with more than one component with lattice stick number ≤ 14 (quoted).
- p. 1: "Lattice links have played an important role in simulating various circular molecules [8]" (Tesi et al.).
- No numerical results, no lattice step-length or stick-number bounds proved here.

## Methods / algorithms
Pure-math proof (no algorithm), though the proof of Lemma 3 is constructive: height function g = longest-path length from sources of the DAG Γ (p. 3), and Lemma 2 gives the lifting of a lattice diagram to a lattice link by placing each edge e of D in the plane z = g(e) (p. 3). Steps: (1) Realizability ⇔ Γ has a height function (Lemma 2); (2) ⇔ Γ acyclic (Lemma 3); (3) ⇔ no 4-cycles (Lemma 4); (4) 4-cycles = Escher squares (Thm 5).

## Tables
None.

## Figures
- **Fig. 1 (p. 1)** — Diagram crossings. *What it shows:* the two over/under conventions at a degree-4 vertex.
- **Fig. 2 (p. 2)** — Lattice diagrams and associated digraphs. *What it shows:* two lattice diagrams (a), (b) with the arrows of Γ drawn over them; (b) contains an Escher square at its centre. Image: ../figures/NPP18/p02.png
- **Fig. 3 (p. 4)** — (a) aligned edges; (b) edge configuration; (c) Escher square. *What it shows:* the local configurations used in Lemma 4. Image: ../figures/NPP18/p04.png

## Stated limitations, open problems, future work
None stated.

## References worth following
- [2] Allardice, Bloch, Lattice diagrams of knots and diagrams of lattice stick knots, arXiv:1803.03685 (original result).
- [1] Adams et al., Stick index of knots and links in the cubic lattice, JKTR 21(5) (2012) 1250041.
- [3] Diao, Minimal knotted polygons on the cubic lattice, JKTR 2 (1993) 413-424.
- [5] Hong, No, Oh, Links with small lattice stick numbers, J. Phys. A 47 (2014) 155202.
- [6] Huh, Oh, Knots with small lattice stick number, J. Phys. A 43 (2010) 265002.
- [7] Janse van Rensburg, Promislow, The curvature of lattice knots, JKTR 8 (1999) 463-490.

## Extraction notes
- Pages 1-4 rendered; Definition 1 verified on the p. 2 image. Fig. 3 and the realizability picture described from text and captions.
- Relevance: gives an exact combinatorial criterion (no Escher square) for a planar lattice diagram (subgraph of Z², degree 2 or 4) to be the xy-projection of a lattice link in Z³; the lift places each diagram edge at integer height g(e) (a height function), so it is a constructive tool for lattice knots, but no length or stick-number optimisation is done.
