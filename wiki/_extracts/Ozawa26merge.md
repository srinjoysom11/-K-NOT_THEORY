# Ozawa26merge — Merge Trees of Length-Filtered Lattice Knot Spaces
- **Authors:** Makoto Ozawa
- **Venue / year / identifiers:** arXiv:2605.25322v6 [math.GT], 18 Oct 2026 (MSC 57K10; 57K12; 05C10; 68R10; 49Q10). Keywords: lattice knots, BFACF moves, merge trees, strong local minima, Gordian unknots, Hamiltonian polygons, connected sums, persistent homology, minimax length, ropelength. AI-use declaration p. 43 (ChatGPT/Codex/GPT-versions and Claude used for drafting, code, verification scripts, certificate checks; author takes responsibility). Zenodo supplementary data: 10.5281/zenodo.21304711 (the October-2026 additions are "supplied in the present source package", not assumed to be in that repository version, p. 42).
- **File:** papers/2_algorithms/Ozawa_2026_Merge_trees_lattice_knot_spaces_BFACF_2605.25322.pdf   **Pages:** 46
- **Text layer:** ok (tables re-read from page images for Tables 1, 4–7, 9, 10; Tables 2, 3, 8 from text only)

## Abstract
We study length-filtered BFACF graphs of self-avoiding polygons in the simple cubic lattice, emphasizing the birth and merging of connected components and the minimax length required to connect prescribed states. For the published shortest-layer censuses of 4_1 and 6_3, we compute BFACF merge trees: the former has four components at length 30 merging at 32, while the latter has twelve components at 40, two at 42, and one at 44. Completeness for the entire minimal layer is conditional on the published populations exhausting it (and on 40 being minimal for 6_3). For one trefoil chirality, we certify six selected nonminimal components born at length 26, with merge heights 28 or 30 relative to the minimal branch; completeness of this selected-birth tree is not asserted. We characterize eventual connectivity of capped BFACF graphs in terms of bounded birth levels of strong local-minimum components. An explicit 64-edge Hamiltonian lattice unknot has no neutral or shortening BFACF move, and a verified BFACF path gives exact merge height 66 with the square. Two-edge splicing produces frozen unknots of length 64m for every m ≥ 1. We further splice a minimal 24-edge trefoil to a frozen Hamiltonian block, obtaining an 88-edge frozen trefoil. Repeated protected-port splicing and reflection give frozen trefoils of both chiralities of length 64m + 24. Consequently both the unknot and either trefoil chirality have infinitely many nonminimal strong local-minimum births, and their capped BFACF graphs are not eventually connected. Explicit coordinate data and independent BFACF local-move verifiers accompany the constructions. The exact merge levels of the longer frozen families, unbounded minimax excess, extension to arbitrary knot types, and analogous barriers in continuous ropelength-filtered knot spaces remain open.

## Notation and conventions
- **Lattice / moves:** simple cubic lattice Z³ (SC); BFACF = three move types: (i) length-preserving corner flips (type 0), (ii) positive edge expansions (+2), (iii) negative edge contractions (−2) (p. 16); only moves producing self-avoiding polygons kept. Neutral move = two-edge corner flip in a unit plaquette; shortening move = replacing a three-edge plaquette detour (direction word a,b,−a, a⊥b) by its fourth edge (p. 10, 21). SC polygon lengths are even; lengths change by 0 or ±2 so searches visit N_0, N_0+2, … (p. 5, 28).
- **Quotient (counting convention):** P_N^L(K) = {lattice polygons of type K, ℓ ≤ N}/Isom⁺(L), orientation-preserving lattice isometries; "spatial reflections are not identified, even for amphichiral knot types" (p. 3, 8). Implementation canonicalizes up to translation, cyclic reparametrization, reversal of orientation and proper cubic rotations (24 proper rotations); full cubic group only with the --mirror option, not used unless stated (p. 16–17, 22). Vertices of graphs = proper-cubic classes, "unoriented quotient". ⚠ This is the same as the "mirror-sensitive quotient" of Ozawa26density; counts "translation classes" in Table 4 differ (translation classes vs proper-rotation classes, p. 22–26).
- **Graph notation:** G_N = G_N^{SC,BFACF}(K) level-N graph (vertices P_N(K), edges = one move; nested G_N ⊂ G_{N+2}); seed-generated component C_N^{seed}(x); explored subgraph E_N^{seed}(x) ⊂ C_N^{seed}(x) for capped runs (Def. 2.3). n_K = n_SC(K) minimal SC length; M_K = I^SC(K) minimal layer; "type-0 component" = connected component of the graph of length-n polygons under neutral moves.
- **Merge scales:** discrete merge scale m^D(C,D) = min{N ≥ N_0 : C, D have same image in π_0(G_N)} (Def. 3.2); ultrapseudometric d^D = m^D − N_0^D (Thm 3.3). Minimax reconfiguration height H(P,Q) = min_{Γ:P⇝Q} max_{R∈Γ} ℓ(R); excess-length barrier B(P,Q) = H(P,Q) − max{ℓ(P),ℓ(Q)} (p. 37). h_K(P) = min_{Q∈M_K} H(P,Q); e_K(P) = h_K(P) − ℓ(P) ≥ 0; P is "lattice Gordian" if e_K(P) > 0 (p. 10–11). Seed-generated merge scale m_seed^{BFACF}(x,y) first N at which seeds lie in same component (Def. 2.4; exact when exhaustive separation at the previous level plus a verified path).
- **Strong local-minimum component (Def. 4.10, p. 10):** connected component D of the type-0 graph on length-n polygons such that no vertex of D admits a shortening move. Immediately non-shortenable = no legal −2 move. "Frozen" polygon (Sections 11.2–11.3) = no legal type-0 and no legal type-(−2) move, hence an isolated vertex of G_{ℓ(P)}.
- Ropelength notation (p. 1): Y_Λ(K) = {γ∈K | Thi(γ) ≥ 1, Len(γ) ≤ Λ}/Isom⁺(R³) (as in [20, Def. 6.1] = Ozawa26rope), Thi = tube radius there; no ropelength numbers are computed here. Lattice edge number and Euclidean ropelength "are different resources" (p. 4, 12).
- Direction digits for coordinate words: 0,1,2,3,4,5 = +x,+y,+z,−x,−y,−z (p. 18).
- Knot-chirality notation: 4_1! = mirror image of 4_1 (in the text "4_1^!" printed as "41!"), 3_1#3_1 granny, 3_1#3_1! square.
- Seeds: ω = supplied 30-edge SC figure-eight seed, ω! its reflection (x,y,z)→(−x,y,z); σ = supplied 40-edge SC 6_3 seed (from Rechnitzer's published data, lies in A_7), σ! reflection; σ′ = independent second 6_3 seed from a 156-edge braid via stochastic BFACF descent.
- **Reference numbering in THIS paper:** [20] = Ozawa26rope (arXiv:2604.17905, "Ropelength-Filtered Knot Spaces"); [21] = Ozawa Reidemeister graphs (arXiv:2605.03350); [9] = Janse van Rensburg–Rechnitzer 2011; [4] = Scharein et al. 2009; [3] = Janse van Rensburg–Whittington 1991. Ozawa26density cites this paper as [16] ("Merge trees of lattice knots") and Zenodo [17]; Ozawa26geom cites it as [17] ("Discrete knot theory via lattice-filtered move graphs") — titles differ (⚠ see notes).
- **Differences from siblings:** this is the discrete/combinatorial source paper (no density/compression radii); it fixes the BFACF merge trees (4_1: 4→1 at 30,32; 6_3: 12→2→1 at 40,42,44) that Ozawa26density attaches density/compression functionals to and that Ozawa26rope/geom quote. Ozawa26density's "Table 6" is a restatement of this paper's Theorems 11.11/11.15.

## Numbered statements
- **Definition 2.1 (p. 6) — Filtered local-move model.** D(K) = (S(K), M, ℓ): S(K) countable set of finite representatives of K; M symmetric set of knot-type-preserving local moves; ℓ: S(K)→N complexity; S_N(K) = {x: ℓ(x) ≤ N} finite for every N. **Def. 2.2** level-N graph G_N^D(K) (vertices S_N, edges = one move). **Def. 2.3** seed-generated component / explored subgraph. **Def. 2.4 (p. 7)** seed-generated merge scale m_seed(x,y); positive search certificate gives an upper bound, exhaustive separation certificate a lower bound; capped search with no path = inconclusive.
- **Definition 2.5, Proposition 2.6 (p. 7) — Component persistence.** Inclusions G_N^D ⊂ G_{N+1}^D induce maps π_0(G_N)→π_0(G_{N+1}); discrete admissible components form a one-parameter persistence object. Proof: components of a subgraph lie in components of the larger graph.
- **Definition 3.1, 3.2 (p. 7).** N_0^D(K) = min{N : S_N ≠ ∅}, discrete ideal layer I^D(K) = S_{N_0}(K), C_0^D(K) = π_0(G_{N_0}); merge scale m^D(C,D) (∞ if never).
- **Theorem 3.3 (p. 8) — Merge ultrapseudometric.** If m^D(C,D) < ∞ for all C,D∈C_0^D(K), then d^D(C,D) = m^D(C,D) − N_0^D(K) satisfies d(C,C)=0, symmetry, and d(C,E) ≤ max{d(C,D), d(D,E)}. Proof idea: at level M = max{m(C,D), m(D,E)} images of C,D and of D,E coincide hence C,E. *Proved here (standard).* Remark 3.4: uses only nestedness; standard merge-tree/degree-zero persistence structure [7].
- **Lemma 4.1 (p. 8) — Finiteness.** P_N^L(K) is finite for each N (translation normalisation, finitely many closed self-avoiding edge sequences, finite point group).
- **Example 4.2 (p. 9).** BFACF moves; Janse van Rensburg–Whittington [3]: irreducibility classes of BFACF on unrooted SC polygons are exactly the knot types (*quoted*). **Remark 4.3:** global ergodicity ≠ bounded connectivity; a path may have to exceed both endpoints' length; seed-generated search does not enumerate the full bounded graph. **Example 4.4:** cubulated moves (Hinojosa–Verjovsky–Verjovsky Marcotte [14]) characterize isotopy of cubic knots (*quoted*).
- **Definitions 4.5–4.8 (p. 9).** Lattice-filtered move graph G_N^{L,M}(K); lattice admissible components; minimal lattice layer I^L(K) = P_{n_L(K)}(K); lattice merge scale m^{L,M}(C,D).
- **Corollary 4.9 (p. 10) — Lattice merge ultrapseudometric.** If every pair of initial lattice components eventually merges then d^{L,M} = m^{L,M} − n_L(K) is an ultrapseudometric on components of the minimal lattice layer. Proof: Thm 3.3.
- **Definition 4.10 (p. 10).** Immediate and strong local minima (see Notation).
- **Proposition 4.11 (p. 10) — Birth criterion.** A type-0 component D at length n is a strong local-minimum component iff it is a connected component of G_n disjoint from G_{n−2}; such components are exactly the branches born at level n in component persistence. Proof idea: if D has no shortening move, every allowed move under cap n is neutral and stays in D; conversely a component disjoint from G_{n−2} has only neutral edges.
- **Proposition 4.12 (p. 10) — Arbitrarily long immediately nonshortenable polygons.** For any SC polygon P of type K and integer m ≥ 2, the dilation P^{(m)} by m (subdivided into unit edges) is immediately nonshortenable, same knot type, ℓ(P^{(m)}) = m ℓ(P). Proof idea: every maximal straight run has ≥ m ≥ 2 edges; shortening needs a unit-length middle edge a,b,−a. **Remark 4.13:** this does not produce strong local minima (e.g. 2×2 square boundary: a neutral flip creates a shortening opportunity).
- **Proposition 4.14 (p. 11) — Finite-input merge bounds.** Fix Q*∈M_K. For every L ≥ n_K, M_K(L;Q*) = max_{P∈V(G_L(K))} H(P,Q*) < ∞; all vertices present by level L merge under some finite cap. Proof: finitely many quotient vertices, BFACF connectivity.
- **Proposition 4.15 (p. 11) — Gordian configurations and nonminimal births.** A lattice Gordian configuration of type K exists iff a strong local-minimum component is born at some n > n_K. Proof idea: least-length vertex of the component of P in G_N missing M_K; neutral component has no shortening move.
- **Proposition 4.16 (p. 11) — Eventual connectivity.** For fixed K TFAE: (i) G_N(K) connected for every sufficiently large N; (ii) birth lengths of strong local-minimum components bounded; (iii) only finitely many strong local-minimum components. Consequently unbounded strong birth levels ⇔ disconnectedness of G_N(K) at arbitrarily large caps.
- **Corollary 4.17 (p. 11).** If sup_P e_K(P) = ∞ then the strong birth levels for K are unbounded. (Converse not formal: an abstract filtered graph can have infinitely many births each merging after one +2.)
- **Definition 6.1 (p. 12) — PL-realizable local move system.** Every allowed move admits an ambient PL isotopy supported in a ball meeting the polygon only in the move region. **Remark 6.2:** cubulated moves [14] and BFACF (local isotopies, [3]) are examples.
- **Theorem 6.3 (p. 12) — Discrete-to-finite projection.** For PL-realizable M^L and a path ω_0,…,ω_r in G_N^{L,M}(K), for generic projection direction u the projected diagrams are related by a finite sequence of Reidemeister moves; every realized discrete path gives a finite Reidemeister certificate. **Corollary 6.4 (p. 13):** merge at level N with a realizing path ⇒ finite Reidemeister certificate. **Remark 6.5:** no sharp bound M(N) ≤ CN² asserted.
- **Definition 7.1, Proposition 7.2 (p. 13) — Finite-to-discrete realization (conditional).** Under properties (i) every diagram realizable by a lattice polygon, (ii) every Reidemeister move realizable by finitely many lattice moves, (iii) complexity control Q, finite Reidemeister paths of complexity ≤ M lift to paths in G_{Q′(M)}. **Remark 7.3:** not claimed for BFACF.
- **Definition 8.1 (p. 14) — Combinatorially thick lattice polygon (ρ-thick).** Disjoint closed regular neighbourhoods of radius ρ for non-adjacent edges and disjoint corner balls; automatic on SC for fixed small ρ (0<ρ<1/4; corner balls radius 2ρ).
- **Proposition 8.2 (p. 14) — Smoothing estimate.** Fix ρ and a smoothing convention; there is A_ρ>0 such that every ρ-thick lattice polygon ω of length N admits a smooth representative γ_ω of the same knot type with Thi(γ_ω)=1, Len(γ_ω) ≤ A_ρ N; gives a coarse map P_N^{L,ρ}(K) → Y_{A_ρ N}(K) (not a homotopy equivalence or merge-height comparison). **§8.2 (p. 14–15):** lattice graph ≠ Y_Λ(K) because (i) lattice polygons are a discrete subset, (ii) lattice moves do not encode all continuous deformations, (iii) length/ropelength relation coarse, (iv) merge scales depend on lattice and move system.
- **Problem 8.3 (p. 15) — Convergence of discrete merge scales (OPEN).** Mesh a>0, polygons in aZ³ with a discrete thickness condition, physical length aN, specified rounding/thickness convention: under what conditions do discrete merge scales converge, or bound, the continuous ropelength merge scales as a→0?
- **Theorem 9.1 (p. 15) — Finite computability.** For a filtered local-move model with effectively enumerated finite S_N(K) and move relation: G_N^D, π_0, images of components at higher levels, and merge scales up to any prescribed search bound are computable by finite graph procedures (BFS/DFS). **Remark 9.2:** effective finiteness, not efficient complexity; enumeration of lattice knots is itself hard.
- **Theorem 11.1 (p. 18–19) — Infinitely many BFACF-frozen unknots.** For every integer m ≥ 1 there is an SC unknot P_m with ℓ(P_m) = 64m, #{legal type-0 moves} = 0, #{legal type-(−2) moves} = 0. Thus [P_m] is an isolated vertex of G_{64m}(0_1) and H(P_m, □) ≥ 64m + 2. Hence the unknot has infinitely many nonminimal strong local-minimum components and its capped BFACF graphs are not eventually connected. *Proved here (computer-assisted base case + local splice proof).* Proof idea (paper): base P_1 = 64-edge Hamiltonian cycle on B={0,1,2,3}³ (cyclic word below) with ports e_L=[(0,0,0),(0,0,1)], e_R=[(3,0,0),(3,0,1)]; no plaquette with three consecutive sides (no −2 move) and fourth vertex of every two-edge corner plaquette is in B and occupied (no type-0 move); P_m obtained by translating P_1 by (4k,0,0), deleting right port of block k and left port of block k+1 and inserting bridges [(4k+3,0,z),(4k+4,0,z)], z=0,1; polygon visits every vertex of R_m={0..4m−1}×{0..3}² exactly once; separating plane x=4k+7/2 meets it in two points so connected sum, [P_m]=[P_1]^{#m}=0_1; local port check independent of m. Base word (64 digits, rows concatenate): `10001133322000443243311100044453` + `51331500222345455002111334234455`.
- **Certificate for base case (p. 18):** archived 25,436-move BFACF path reduces P_1 to the unit square, never exceeding 66 edges; every move checked by separate coordinate verifier; first move from P_1 must increase length so H(P_1,□) = 66 exactly (exact barrier 2 above 64).
- **Corollary 11.2 (p. 20) — Persistence and failure of eventual connectivity for the unknot.** For every m ≥ 1 the zero-dimensional BFACF persistence of the unknot has a component born at length 64m that survives beyond that level; death level d_m finite and d_m ≥ 64m + 2; #{nonminimal strong local-minimum components of 0_1} = ∞; no N_0 with G_N(0_1) connected for all N ≥ N_0. **Remark 11.3:** the exact merge levels of P_m for m>1 not computed; the family shows unbounded birth lengths and a uniform positive escape-excess lower bound (2) but does not prove sup_P (H(P,□)−ℓ(P)) = ∞; specific to SC BFACF; no thick-rope Gordian unknot implied.
- **Theorem 11.4 (p. 21) — Infinitely many BFACF-frozen trefoils.** For every m ≥ 1 and either trefoil chirality there is an SC polygon R_m of that chirality with ℓ(R_m) = 64m + 24 and #M_0(R_m) = #M_{−2}(R_m) = 0; R_m is an isolated vertex of G_{64m+24}(3_1) and for every minimal trefoil Q* of its chirality H(R_m, Q*) ≥ 64m + 26. The trefoil of either chirality has infinitely many nonminimal strong local-minimum births and its capped graphs are not eventually connected. *Proved here (computer-assisted verifier + local interface argument).* Construction: Q = 24-edge minimal trefoil word `000113342335500022133544` (chirality of §11.4; singleton type-0 component, no neutral or shortening moves); port edge [(0,2,1),(1,2,1)] of Q rotated by T(x,y,z) = (−y,−z,x) and translated by v=(6,1,0) becomes e_Q=[(4,0,0),(4,0,1)]; delete e_P=[(3,0,0),(3,0,1)] and e_Q, insert b_z=[(3,0,z),(4,0,z)], z=0,1 ⇒ R_1 with ℓ = 64+24 = 88, [R_1] = 0_1#3_1 = 3_1. General m: m Hamiltonian blocks spliced, trefoil attached at last right port x=4m−1. Neighbouring junction neighbourhoods disjoint (splice planes differ by 4).
- **Remark 11.5 (p. 22).** 64m+26 need not be the exact merge height; no frozen configurations for every knot type claimed.
- **Theorem 11.6 (p. 23) — Certified nonminimal trefoil merge heights.** Each D_i (i=1..6) is a complete strong local-minimum component of G_26. For every P∈D_i and every minimal 24-edge polygon Q of the fixed chirality, H(P,Q) = 30 if i=4 and 28 if i∈{1,2,3,5,6}; D_4 requires excess length 4 above its own birth level. *Computer-assisted proof:* Python coordinate verifier checks every vertex of each D_i (canonical, self-avoiding, all neutral neighbours in the list, no shortening move; connectivity; edge counts); six archived certificates (22, 22, 25, 46, 15, 17 moves; peak lengths 28, 28, 28, 30, 28, 28) connect a common minimal root to a representative of each D_i, each transition checked by an independent generator; lower bound for D_4: two exhausted cap-28 searches B (from A) and E (from D_4), disjoint, independently verified by a C++ audit (all legal neighbours under cap 28, neighbour-set equality with the search generator, explicit proper-rotation canonicalization, parent edges, connectedness) ⇒ H(D_4,A) > 28, parity ⇒ ≥ 30, explicit path gives equality.
- **Remark 11.7 (p. 24) — Coordinate spans.** s(P) = sorted triple of coordinate spans; s(P)=(1,3,3) for P∈D_6, (3,3,3) for P∈D_4; D_6's six classes fit in the width-one slab Z²×{0,1}, none of D_4's twenty does; merge heights 28 and 30, barriers 2 and 4. Does not assert width determines barrier. Ishihara et al. [26]: width-one-slab trefoil minimum is 26 (*quoted*).
- **Corollary 11.8 (p. 24) — Nine certified branches.** Tracking C_1,C_2,C_3 (born 24) and D_1..D_6 (born 26): merge tree ((C_1,C_2,C_3)_26, D_1,D_2,D_3,D_5,D_6)_28, D_4)_30. For a field F, V_N⊂H_0(G_N;F) spanned by classes of selected births present by level N is a persistence submodule with decomposition F_[24,∞) ⊕ F_[24,26)^{⊕2} ⊕ F_[26,28)^{⊕5} ⊕ F_[26,30). Selected component counts at 24, 26, 28, 30: 3, 7, 2, 1. Statement about V_• only, not the full barcode.
- **Proposition 11.9 (p. 26) — Conditional completeness through length 26.** If the total number of translation classes of length-26 trefoils of the fixed chirality is 140604 then G_26 has exactly seven components A, D_1..D_6, and Cor. 11.8 describes all branches born at lengths ≤ 26. Without the hypothesis, |π_0(G_26)| ≥ 7 and |π_0(G_28)| ≥ 2; neither B∪E = G_28 nor connectivity of G_30 asserted.
- **Observation 11.10 (p. 29) — Length-two BFACF mirror barrier for the figure-eight seed.** For the supplied 30-edge SC figure-eight seed ω and reflected seed ω!, mirrors not identified, m_seed^{BFACF}(ω, ω!) = 32 (separated at N=30, connected after two additional edges). *Computed, with verified 21-state, 20-move path.*
- **Theorem 11.11 (p. 29–30) — BFACF merge tree on the reported length-30 4_1 census.** Let S_4 = published collection of 152 proper-cubic classes of length-30 4_1 polygons. Within the full BFACF graph these meet exactly four type-0 components of sizes 58, 58, 18, 18, and all four merge at cap N = 32. For P,Q∈S_4: H(P,Q) = 30 if same birth-level component, 32 if distinct; excess barrier 0 or 2. If S_4 exhausts all length-30 representatives this is the reported-layer merge tree of 4_1. Exhaustive N=32 search from a 58-vertex component and independently from an 18-vertex component gives the same bounded set of 19618 canonical polygons (152 length-30 + 19466 length-32 states). Component edge counts: 58-vertex components 118 type-0 edges each, 18-vertex components 26 each. *Computed (exhaustive); conditional on census completeness for the whole minimal layer.*
- **Proposition 11.12 (p. 30) — Fourfold divisibility.** A SC knot polygon invariant under the order-four rotoreflection S(x,y,z)=(−y,x,−z) has number of edges divisible by 4. Proof idea: S² (half-turn about z) fixes no point of P (else P on the axis) so every edge has an orbit of size 4. Hence an S-invariant SC 4_1 has ≥ 32 edges (existence not asserted).
- **Corollary 11.13 (p. 30–31) — No improper symmetry at minimal length.** No 30-edge SC representative of 4_1 (among the published collection) is preserved by an orientation-reversing lattice isometry. Proof idea: otherwise P and r(P) would coincide in the proper-cubic quotient, contradicting the mirror pairing C_1↔C_2, C_3↔C_4. Amphichirality of the knot type does not entail improper symmetry of a minimal lattice representative.
- **Observation 11.14 (p. 32) — Length-four BFACF mirror barrier for the supplied 6_3 seed.** For σ and σ!, mirrors not identified, m_seed^{BFACF}(σ,σ!) = 44 (separated through N=42, connected after four extra edges).
- **Theorem 11.15 (p. 33) — BFACF merge tree on the reported length-40 6_3 census.** S_6 = published collection of 148 proper-cubic classes of length-40 6_3 polygons; they meet twelve distinct type-0 BFACF components of sizes 39, 39, 10, 10, 9, 9, 7, 7, 6, 6, 3, 3; at N=42 the six A_r merge into component A and the six B_r into B, reflection μ exchanging A_r↔B_r and A↔B; each of A,B contains 74 minimal classes and 12337 bounded states and A∩B=∅ at N=42; they merge at N=44. Hierarchy 12→2→1 (N=40,42,44). Minimal-representative excess-length barrier: 0 within a birth-level component, 2 between distinct birth-level components among the A_r's (or among the B_r's), 4 between any A_r and any B_s; each mirror pair A_r,B_r separated through N=42 and merging only at 44. If 40 is the true minimum and S_6 exhausts that layer this is the entire reported shortest-layer merge tree. *Computed (exhaustive N=40,42 + verified N=44 path).*
- **Proposition 11.16 (p. 35–36) — Two rigid representatives at length 48.** [P_83] and [P_87] (archived SC83.dat, SC87.dat) are each a singleton connected component of G_48^{SC,BFACF}(K) in the proper-cubic unoriented quotient. For P_83 every lattice reflection r satisfies [r(P_83)] = [P_83], H(P_83, r(P_83)) = 48, B(P_83, r(P_83)) = 0 (P_83 invariant under the order-four rotoreflection T(x,y,z)=(3−y,x,5−z), so r∘T^{-1} is orientation-preserving). Proper-rotation orbit sizes 12 and 24 respectively. Statements about the specified polygons, not their full layers. Consistent with divisibility 4 | 48.
- **Proposition 12.1 (p. 37) — Components under controlled simulation.** For resource-filtered deformation systems X,Y with maps F:X→Y, G:Y→X that increase resource by ≤ ε, simulate level-a paths by level-(a+ε) paths and admit connectors x→GFx, y→FGy at levels ≤ r_X(x)+2ε, r_Y(y)+2ε, the component functors are ε-interleaved and μ_Y(Fx,Fx′) ≤ μ_X(x,x′)+ε, μ_X(x,x′) ≤ max{μ_Y(Fx,Fx′)+ε, r_X(x)+2ε, r_X(x′)+2ε}. **Corollary 12.2 (p. 37) — Conditional excess transfer:** if |μ_X−μ_D| ≤ δ_m and geometric endpoint resources ≤ discrete + δ_r then μ_X − max(r_X(x),r_X(x′)) ≥ μ_D − max(r_D(d),r_D(d′)) − δ_m − δ_r. A forward smoothing of discrete paths gives only an upper bound on the continuum merge scale.
- **§12.1 (p. 38).** Reach of a polygon with genuine corners is zero; coordinate-axis paths from (0,0,0) to (1,1,1) have length at least 3 (text layer garbled: "√ ... 3 ... 3"), whereas the straight segment has length √3 (⚠? reading from garbled layer); anisotropy does not disappear by mesh refinement; Gamma-convergence counterexample f_n(t)=max(1−n|t|,0) on [−1,1]: Γ-limit 0 but every path from −1 to 1 has peak 1, so pathwise comparison needed.
- **Problem 13.1 (p. 38) — Eventual connectivity for nontrivial knots (OPEN).** For which nontrivial K is there a finite N_0(K) with G_N(K) connected for all N ≥ N_0? (Negative for unknot and both trefoil chiralities by Thms 11.1, 11.4.)
- **Problem 13.2 (p. 39) — Unbounded nonminimal birth levels (OPEN).** For fixed nontrivial K other than the trefoil, does every L admit even n>L and a component D of G_n^{SC,BFACF}(K) with D ∩ G_{n−2} = ∅?
- **Problem 13.3 (p. 39) — Lattice Gordian configurations of other knot types (OPEN).** For which K is there P with h_K(P) > ℓ(P)? Can the frozen Hamiltonian-block construction be adapted to arbitrary knot patterns? (Naive connected sum need not preserve a barrier.)
- **Problem 13.4 (p. 39) — Unbounded escape excess (OPEN).** For which K is sup_P h_K(P) − ℓ(P) = ∞? (Affirmative ⇒ unbounded births by Cor. 4.17; frozen unknot/trefoil families give only the lower bound 2.)
- **Problem 13.5 (p. 39) — Quantitative finite-input merging (OPEN).** Effective upper/lower bounds for M_K(L;Q*) as a function of L and K.
- **Lemma 13.6 (p. 39) — Coordinate confinement.** A neutral BFACF move preserves the axis-aligned bounding box; a shortening move cannot enlarge it; the sorted coordinate-span triple is invariant under neutral moves in the proper-cubic quotient. Proof: opposite corners V,W of a unit plaquette have V_j,W_j ∈ {A_j,B_j}.
- **Proposition 13.7 (p. 39–40) — Slab criterion for unbounded births.** Fix w ≥ 1, S_w = Z²×{0..w}; if the BFACF graph of type-K polygons confined to S_w (moves staying in S_w, mod translations parallel to S_w) has infinitely many components, then the unrestricted BFACF filtration of K has strong local-minimum components at unbounded birth levels. Not established for the trefoil.
- **Problem 13.8 (p. 40) — Distribution of BFACF mirror barriers (OPEN).** Determine {B(P,r(P))} over minimal representatives P and orientation-reversing cubic symmetries r for amphichiral K; every minimal 4_1 class has mirror barrier 2 and every minimal 6_3 class 4 (under the present quotient/system); uniformly bounded in terms of crossing number or minimal length? arbitrarily large for other amphichiral knots?
- **Conjecture 13.9 (p. 40) — Symmetry breaking for tight figure-eight knots (OPEN CONJECTURE).** Rop_{S_4}(4_1) > Rop(4_1), where Rop_{S_4}(4_1) = infimum of ropelength over smooth figure-eight embeddings invariant under an order-four Euclidean rotoreflection. Motivated by Section 11.7; no ropelength lower bound given.
- **Remark 13.10 (p. 40).** Merge tree strictly finer than birth level would need two knot types with equal birth level and different merge data; not established by the reported examples.
- **Problems 13.11–13.15 (p. 40–41), all OPEN:** 13.11 dependence on move system (BFACF vs cubulated: when same hierarchical clustering of minimal layer?); 13.12 dependence on lattice (SC, BCC, FCC); 13.13 stable discrete merge scale (lattice refinement/subdivision producing lattice-independent invariant); 13.14 comparison with ropelength: find A,B with A·m^{L,M}(C,D) ≤ m_rop(C′,D′) ≤ B·m^{L,M}(C,D) (continuous side unambiguous: connected = path merge by [20, Thm 6.20], and by [21, Thm 8.2] computed by the right-relaxed diagrammatic merge scale); 13.15 finite recognition length L^L_char(K) from lattice graphs versus continuous L_char,u(K) of [21, Thm 7.14].

## Key equations and quantitative claims outside numbered statements
(All computational; "exhaustive" = full enumeration of the stated bounded component; "census" data are from the literature.)
- p. 2, 27, 31 (literature, not proved here): n_SC(4_1) = 30, published P_30(4_1)=3648 translation classes (numerical census), S_30(4_1)=152 proper-cubic classes [4,9,17]; n_SC(6_3)=40 (asserted from reported census), P_40(6_3)=3552, S_40(6_3)=148 [9]. n_SC(3_1)=24 [15,16,9], 1664 translation classes of one chirality at 24 (3328 both). Minimality of 40 for 6_3 and completeness of the censuses are not independently established; hence minimal-layer statements are conditional, while merge heights of explicitly verified representatives are unconditional (p. 2).
- p. 16: unknot demo: `python lattice_bfacf_graph.py --demo-unknot --max-len 8` gives 18 vertices, 31 edges, 1 component (also p. 17).
- p. 27: 4_1 exhaustive N=32 component: 19618 canonical polygons = 152 (length 30) + 19466 (length 32).
- p. 28: 4_1 + mirror under cap 30 mirrors not identified: 116 vertices, 236 edges, 2 components of sizes 58+58; mirrors identified: 58 vertices, 118 edges, 1 component. Merge-check script at N=30: connected=false, status "frontier exhausted"; with mirror identified: connected=true "same canonical state". At N=32: connected=true, status "connecting state found"; 3036 discovered states (first frontier), 10741 (second frontier), 11761 expanded states; runtime 851.825 s (Python/Linux, hardware dependent). Path: 21 states, 20 BFACF moves via 32-edge connecting state η (ω→η 5 moves, ω!→η 15); edge-number sequence 30,32,32,32,32,32,32,32,32,32,30,32,32,32,32,32,32,30,30,30,30; maximum length 32.
- p. 32 (6_3): exhaustive N=42 from σ: exactly 12337 states, 74 of length 40 and 12263 of length 42; second search from σ! gives B with 12337 states; sets disjoint. At N=44 deterministic C++17 implementation: 1601979 discovered states (first side), 1028207 (second), 2555900 expanded; runtime 347.037 s; path 153 states, 152 moves (σ→η 116 moves, σ!→η 36 moves, η a 42-edge state, some intermediate states 44 edges, none > 44). C++ cross-checked against Python at N=40 and N=42; path verified with verify_merge_certificate.py.
- p. 31: Alexander polynomial of σ and σ! computed from generic planar projection: Δ(t) ≐ t² − 3t + 5 − 3t^{-1} + t^{-2} (6_3); verifier validated on 3_1, 4_1, 4_1!, 5_1 and composite seeds.
- p. 34 (second seed): σ′ = 40-edge 6_3 seed constructed from a 156-edge closed 3-braid (word σ_1^{-1}σ_1^{-1}σ_2σ_1^{-1}σ_2σ_2) shortened by seed-recorded stochastic BFACF descent; (σ′,σ′!) separated at N=40 and 42, connected at N=44 by verified 157-state, 156-move certificate; exhausted level-42 component of σ′ has exactly 12337 states; a verified 15-move BFACF path at N ≤ 42 connects σ′! to σ (so σ′ ∈ component of σ!). Independent pure-Python implementation merge_check_bfacf_fast.py.
- p. 34–35 (5-crossing): n_SC(5_1)=34, n_SC(5_2)=36; minimal populations P_34(5_1)=6672, P_36(5_2)=114912 [9]. 5_1 birth-level seed graph: 5 vertices, 4 edges, 1 component; capped N=36 exploration (1000 vertices): 2207 edges, 1 component. 5_2 stress test is a non-minimal cubical closed-braid seed of length 238, cap 1000: 1000 vertices, 1043 edges, 1 component (not birth-layer evidence).
- p. 35 (Table 10 comparison): reported lengths n_rep (from [9, Table 1]): 40: 6_1,6_2,6_3; 42: 8_19; 44: 7_1,7_3,7_4,7_7,8_20; 46: 7_2,7_5,7_6,8_21; 48: 8_3,8_7; 50: 8_9; 52: 8_12,8_17,8_18. 8_19 = T(3,4) at 42 is below every seven-crossing knot.
- p. 36: 8_17 noninvertible negatively amphichiral: oriented BFACF would need mirror-reverse comparison; unoriented quotient used here.
- p. 36 (composite sanity check): granny 3_1#3_1 and square 3_1#3_1! seeds length 66; separate runs cap 20 vertices: 1 component each; together without mirror identification, cap 40 vertices: 40 vertices, 40 edges, 2 components of sizes 29 and 11; not scientific evidence.
- p. 37: B^{SC,BFACF}(ω,ω!)=2, B(σ,σ!)=4; for P∈D_4 and any minimal trefoil B=4; other five D_i: B=2.
- p. 42: certificate checks: 25,436 transitions in gordian64_bfacf_64_to_4_cap66.txt; frozen-unknot JSON for m=1,2,3,4,10; trefoil bundle: 3 type-0 minimal components etc.; commands in README.
- p. 3 (intro): for one trefoil chirality the three minimal components merge at length 26 but six certified components are born at that level; five join the minimal branch at 28, the 20-state one only at 30; lower bound witnessed by two disjoint, completely verified cap-28 components.
- p. 12 (§5): resource is lattice edge number; no formal correspondence with continuum theory.
- p. 37: "retain the component partitions themselves, not only the H_0 barcode".

## Methods / algorithms
Computation (Section 10–11):
1. (p. 16) Python prototype (lattice_bfacf_graph.py): polygon = cyclic vertex list in Z³; canonicalization by translation, cyclic reparametrization, orientation reversal, proper cubic rotations (in longer-seed version through cyclic edge-direction sequences); moves = corner flip (0), edge expansion (+2), edge contraction (−2), retaining only self-avoiding outputs; builds induced graph on a supplied vertex set or the seed-reachable subgraph with cap N (--explore, caps on vertex count), BFS for components. Minimal-layer enumerations are supplied externally (published data); the code does not enumerate minimal knots.
2. (p. 17) Input files (Table 1). Mirror option off by default.
3. (p. 28) Bidirectional merge checker merge_check_bfacf.py: outcomes (a) connecting state found, (b) one frontier exhausted ⇒ separated at that level, (c) state/time cap reached ⇒ inconclusive.
4. (p. 32) C++17 accelerator bfacf_fast.cpp for N=44 (6_3); cross-checked against Python at N=40, 42; independent path verifier verify_merge_certificate.py.
5. (p. 23–24) Trefoil certificates: six components D_i listed as canonical direction words; Python coordinate verifier; C++ coordinate audit (audit_coordinate.cpp) of A (cap 26), B and E (cap 28); disjointness check; six path certificates; every transition checked by a generator independent from the direction-word replacement generator (p. 23).
6. (p. 18–22) Frozen constructions: Hamiltonian base polygon verified by coordinate checks; BFACF path 64→4 (25,436 moves, cap 66) verified by independent checker; splice constructions; verifier verify_connected_sum_public.py regenerates polygon from the two cyclic words for m=1,2,3,4,8,16 and checks every two-edge corner flip and three-edge shortening detour.
7. (p. 39–40) Slab-criterion route for unbounded births (Lemma 13.6, Prop. 13.7).
Proof strategies: Section 4.4 by finite sublevels + BFACF connectivity; Theorem 3.3 by nestedness; Theorems 11.1/11.4 by explicit coordinates + locality of port checks.

## Tables
**Table 1 (p. 17)** — Input files used in the seed-generated experiments. The 6_3 seed is converted from the published minimal-coordinate data cited in the text. The 5_2 braid seed is a non-minimal stress-test input and is not used as birth-level evidence for 5_2.

| file | role | knot type or experiment |
|---|---|---|
| trefoil_seed.json | seed polygon | 3_1 |
| figure8_seed.json | seed polygon | 4_1 |
| figure8_mirror_seed.json | reflected seed polygon | 4_1! |
| figure8_and_mirror_seeds.json | two-seed input | 4_1 and 4_1! |
| six3_seed.json | minimal seed polygon | 6_3 |
| six3_mirror_seed.json | reflected seed polygon | 6_3! |
| six3_and_mirror_seeds.json | two-seed input | 6_3 and 6_3! |
| six3b_seed.json | independent second seed | 6_3 (braid + BFACF descent) |
| six3b_mirror_seed.json | reflected second seed | 6_3! |
| six3b_and_mirror_seeds.json | two-seed input | 6_3 second-seed check |
| five1_seed.json | seed polygon | 5_1 |
| five2_braid_seed.json | stress-test seed | non-minimal 5_2 input |
| granny_seed.json | sanity-check seed | 3_1#3_1 |
| square_seed.json | sanity-check seed | 3_1#3_1! |
| granny_square_seeds.json | two-seed input | composite-trefoil sanity check |

**Table 2 (p. 20)** — Direct coordinate checks on representative members of the Hamiltonian-block unknot family. All cases have one closed cycle, 64m occupied lattice vertices and exactly m−1 interfaces. The universal statement follows from the local splice proof, not from these finitely many tests.

| Number of blocks m | Edges 64m | Type 0 | Type −2 |
|---|---|---|---|
| 1 | 64 | 0 | 0 |
| 2 | 128 | 0 | 0 |
| 3 | 192 | 0 | 0 |
| 4 | 256 | 0 | 0 |
| 8 | 512 | 0 | 0 |
| 16 | 1024 | 0 | 0 |
| 32 | 2048 | 0 | 0 |
| 64 | 4096 | 0 | 0 |

**Table 3 (p. 22)** — Independent coordinate checks on the protected-port frozen-trefoil family. The proof of the universal statement uses locality of the junction checks; these six finite tests alone do not imply it.

| Blocks m | Edges 64m+24 | Legal type 0 | Legal type −2 |
|---|---|---|---|
| 1 | 88 | 0 | 0 |
| 2 | 152 | 0 | 0 |
| 3 | 216 | 0 | 0 |
| 4 | 280 | 0 | 0 |
| 8 | 536 | 0 | 0 |
| 16 | 1048 | 0 | 0 |

**Table 4 (p. 23)** — Trefoil populations from [9, Table 4]. The length-26 count is used only as a cross-check and an explicit conditional completeness hypothesis below.

| Length | Reported translation classes, both chiralities |
|---|---|
| 24 | 3328 |
| 26 | 281208 |
| 28 | 14398776 |

(Text p. 22: at the higher lengths these are "reported sampling results, not exhaustive upper bounds"; GAS sampling in [9].)

**Table 5 (p. 23)** — Certified strong local-minimum components of one trefoil chirality at length 26. Translation populations sum the proper-rotation orbit sizes, including stabilizers. The table does not presuppose exhaustiveness among all length-26 trefoils.

| Component | States | Type-0 edges | Translation classes | H(D_i, A) |
|---|---|---|---|---|
| D_1 | 87 | 205 | 2016 | 28 |
| D_2 | 18 | 27 | 432 | 28 |
| D_3 | 30 | 59 | 672 | 28 |
| D_4 | 20 | 28 | 384 | 30 |
| D_5 | 36 | 72 | 864 | 28 |
| D_6 | 6 | 6 | 108 | 28 |

**Table 6 (p. 24)** — Complete connected components certified by exhaustive coordinate-neighborhood audits. This does not assert that B ∪ E = G_28.

| Component | Length 24 | Length 26 | Length 28 | Total | Edges |
|---|---|---|---|---|---|
| A ⊂ G_26 | 75 | 5685 | – | 5760 | 19941 |
| B ⊂ G_28 | 75 | 5862 | 297897 | 303834 | 1366087 |
| E ⊂ G_28 | 0 | 20 | 1673 | 1693 | 5269 |

(Checks: 75+5685=5760; 75+5862+297897=303834; 20+1673=1693. The three minimal trefoil type-0 components have sizes 56, 18, 1 with 127, 27, 0 edges, in the single component A of G_26 [p. 22]: 75 = 56+18+1 proper-rotation classes of the 1664 translation classes. Population cross-check p. 26: A∪D_1..D_6 contains 5882 length-26 proper-rotation classes: 5685 + (87+18+30+20+36+6=197); translation classes 136128 + (2016+432+672+384+864+108=4476) = 140604, ×2 = 281208 = Table 4, but the source uses GAS sampling so this is a cross-check only.)

**Table 7 (p. 27)** — Seed-generated and capped BFACF computations used in the paper. The capped rows are partial explorations. The 6_3 row at N = 42 is the complete component generated from one supplied seed; its reflected component is isomorphic and disjoint at this level.

| K | n_SC(K) | level N | mode | cap | \|V\| | \|E\| |
|---|---|---|---|---|---|---|
| 3_1 | 24 | 24 | seed-generated | none | 56 | 127 |
| 3_1 | 24 | 26 | capped | 1000 | 1000 | 2164 |
| 4_1 | 30 | 30 | seed-generated | none | 58 | 118 |
| 4_1 | 30 | 32 | capped | 1000 | 1000 | 2137 |
| 6_3 | 40 | 40 | seed-generated | none | 7 | 6 |
| 6_3 | 40 | 42 | seed-generated | none | 12337 | 34146 |
| 5_1 | 34 | 34 | seed-generated | none | 5 | 4 |
| 5_1 | 34 | 36 | capped | 1000 | 1000 | 2207 |

**Table 8 (p. 28)** — Mirror comparison for the supplied figure-eight seed and its reflected mirror seed.

| input | mirror identified? | N | \|V\| | \|E\| | #π_0 |
|---|---|---|---|---|---|
| (4_1, 4_1!) | no | 30 | 116 | 236 | 2 |
| (4_1, 4_1!) | yes | 30 | 58 | 118 | 1 |

**Table 9 (p. 32)** — Seed-generated BFACF mirror analysis for the supplied minimal 6_3 seed and its reflected mirror. Reflections are not identified.

| level | result | exact evidence | principal size data |
|---|---|---|---|
| 40 | separated | complete two-seed graph | 14 vertices; 7 + 7 |
| 42 | separated | complete graph; frontiers exhausted | 24674 vertices; 12337 + 12337 |
| 44 | connected | verified explicit path | 153 states; 152 moves |

**Table 10 (p. 35)** — Selected published simple-cubic lengths through eight crossings. These are comparison data, not additional complete merge-tree computations.

| n_rep | Selected knot types |
|---|---|
| 40 | 6_1, 6_2, 6_3 |
| 42 | 8_19 |
| 44 | 7_1, 7_3, 7_4, 7_7, 8_20 |
| 46 | 7_2, 7_5, 7_6, 8_21 |
| 48 | 8_3, 8_7 |
| 50 | 8_9 |
| 52 | 8_12, 8_17, 8_18 |

(No table is long enough to need a CSV. Figure-eight/6_3 component-size/state-level CSVs mentioned on p. 41 (figure8_minimal_components.csv, six3_minimal_component_summary.csv, figure8_merge_tree_summary.txt) are not part of the PDF.)

## Figures
- **Fig. 1 (p. 18)** — "Left: the 64-edge frozen Hamiltonian unknot (the three-dimensional picture is a projection, not a plane knot diagram). Right: the two-edge untwisted splice between adjacent blocks. Dashed edges are deleted and solid blue edges are inserted. The other edges are unchanged." *Shows:* 3D picture of the 4×4×4 Hamiltonian cycle and the port splice P^(k)→P^(k+1) with two bridges. Image: ../figures/Ozawa26merge/p18.png
- **Fig. 2 (p. 25)** — "The nine certified trefoil branches. Births occur at the bottom endpoints; horizontal segments join branches at a common merge height. The counts 3, 7, 2, 1 refer to these selected branches only. Unlisted births, in particular those at levels 28 and above, are not excluded by this diagram." *Shows:* tree with levels 24, 26, 28, 30; C_1,C_2,C_3 born at 24 merge at 26 into A; D_1,D_2,D_3,D_5,D_6 born at 26 merge with A at 28 (B); D_4 born at 26 (component E) merges at 30. Image: ../figures/Ozawa26merge/p25.png
- **Fig. 3 (p. 26)** — "A certified trefoil BFACF path from the 26-edge component D_4 to the minimal layer…" *Shows:* top row three 3D polygons (p0 length 26, p7 length 30 peak, p46 length 24), middle row samples p0,p4,p7,p9,p10,p17,p27,p36,p46, bottom plot of ℓ(p_i) vs move index (46 moves; peak 30 at p7, back to 24); text: first 30-edge peak after 7 moves, 39 moves remaining. Image: ../figures/Ozawa26merge/p26.png
- **Fig. 4 (p. 29)** — "An extracted BFACF path connecting the supplied 30-edge figure-eight seed ω to its reflected mirror seed ω! under the length bound N = 32. The two search branches meet at a 32-edge state η. The seed ω reaches η in 5 BFACF moves, while the mirror seed ω! reaches η in 15 BFACF moves. Hence the full extracted path has 21 states and 20 moves, and gives an explicit certificate for m_seed^BFACF(ω,ω!) = 32…" *Shows:* selected states s0, s1, s5=η, s10, s16, s17, s20 as oblique projections. Image: ../figures/Ozawa26merge/p29.png
- **Fig. 5 (p. 30)** — "BFACF merge tree on the reported census of the minimal simple-cubic 4_1 layer. The four type-0 components at N = 30 have sizes 58, 58, 18, 18 and merge simultaneously at N = 32. The paired 58- and 18-vertex components are exchanged by reflection…" *Shows:* tree 4 leaves C1,C2 (58),C3,C4 (18) at N=30 joining at N=32 in one component of 19,618 states. Image: ../figures/Ozawa26merge/p30.png
- **Fig. 6 (p. 33)** — "An extracted BFACF path connecting the supplied 40-edge 6_3 seed σ to its reflected mirror seed σ! under the length bound N = 44…" *Shows:* selected states s0, s1, s39, s77, s116=η, s134, s152 (lengths 40,42,44,44,42,44,40). Image: ../figures/Ozawa26merge/p33.png
- **Fig. 7 (p. 34)** — "BFACF merge tree on the reported census of the minimal simple-cubic 6_3 layer…" *Shows:* twelve leaves A39,A10,A9,A7,A6,A3 | B3,B6,B7,B9,B10,B39 at N=40, merging to A and B (74 classes, 12,337 states) at N=42 and to one component at N=44; dashed reflection μ. Image: ../figures/Ozawa26merge/p34.png
- Table pages rendered: p17, p20, p22, p23, p24, p27, p28, p32, p35 (../figures/Ozawa26merge/pNN.png).

## Stated limitations, open problems, future work
- p. 1–2: completeness for the whole minimal layer is conditional on census completeness and on 40 being minimal for 6_3; minimal-length/population data "are not all established by independent exhaustive mathematical proofs".
- p. 3, 12: lattice-filtered graph is "a computable combinatorial surrogate", not a canonical discretization; values lattice- and move-system dependent; no universality claimed; no lattice-to-continuum implication (Section 8, Problem 8.3).
- p. 20, 22: exact merge levels of P_m (m>1) and R_m not computed; unbounded escape excess open (Problem 13.4); no thick-rope Gordian unknot implied.
- p. 26–27: Prop. 11.9 conditional; births at 28 and above not classified; G_30 connectivity not asserted.
- p. 34–35: 5_2 stress test not birth-layer evidence; genuine 5_2 experiment needs curated minimal 36-edge seeds; "a future version".
- p. 36: 8_9, 8_12, 8_17, 8_18 mirror-branch computations not done; oriented version of 8_17 needs mirror-reverse.
- p. 36: composite-knot sanity check capped at 40 vertices, not evidence.
- p. 44: "The next step is to extend certified merge computations to further knot types and higher birth levels" and determine geometric features constraining merge heights.
- Open: Problems 8.3, 13.1–13.5, 13.8, 13.11–13.15, Conjecture 13.9.

## References worth following
- [3] Janse van Rensburg, Whittington, The BFACF algorithm and knotted polygons, J. Phys. A 24 (1991) (ergodicity within knot type).
- [4] Scharein, Ishihara, Arsuaga, Diao, Shimokawa, Vazquez, Bounds for the minimum step number of knots in the simple cubic lattice, J. Phys. A 42 (2009) 475006 (minimal 4_1 etc., type-0 classes); [9] Janse van Rensburg, Rechnitzer, Minimal knotted polygons in cubic lattices, J. Stat. Mech. (2011) P09008 (populations, 3552/3648/1664 etc.); [10], [11] Rechnitzer data pages for minimal 6_3, 8_3, 8_7.
- [15] Diao, Minimal knotted polygons on the cubic lattice, JKTR 2 (1993); [16] Diao, The number of smallest knots on the cubic lattice, J. Stat. Phys. 74 (1994); [17] Hong, No, Oh, Upper bounds on the minimum length of cubic lattice knots, J. Phys. A 46 (2013).
- [26] Ishihara et al., Bounds for the minimum step number of knots confined to slabs, J. Phys. A 45 (2012) (width-one-slab trefoil 26).
- [20] Ozawa, Ropelength-Filtered Knot Spaces, arXiv:2604.17905 (= Ozawa26rope); [21] Ozawa, Ropelength-Filtered Reidemeister Graphs, arXiv:2605.03350.
- [14] Hinojosa, Verjovsky, Verjovsky Marcotte, Cubulated moves and discrete knots, JKTR 22 (2013); [23] Janse van Rensburg, Rechnitzer, BFACF-style algorithms for polygons in BCC and FCC lattices, arXiv:1011.3847.
- [28] Coward–Hass 2015; [29] Kusner–Kusner 2023; [30] Ayala–Hass, Gordian unlinks, arXiv:2502.08499; [31],[32] Ayala; [33] Bauermeister, Gordian split links in the Gehring ropelength problem, arXiv:2506.04644 (Gordian context).
- [13] Cantarella, Ellis, Fu, Mastin, Symmetric criticality for tight knots, JKTR 23 (2014) (symmetry context for Conj. 13.9).

## Extraction notes
- Pages rendered: 17, 18, 20, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33, 34, 35 (16 pages). Tables 1, 4, 5, 6, 7, 9, 10 cell-verified against page images (17, 23, 24, 27, 32, 35); Tables 2, 3, 8 read from the text layer (p. 20, 22, 28 images rendered, simple 0-count tables); Fig. 1–7 content described from text captions and renders (Figure 1, 3 images not individually inspected in detail).
- Arithmetic consistency checks passed: Table 6 totals; p. 26 population cross-check (136128+4476=140604; 2×=281208 = Table 4); Corollary 11.8 interval decomposition matches counts 3,7,2,1; path-state counts (116+36=152; 5+15=20); 12337 = 74 + 12263.
- ⚠ Page 38 §12.1: coordinate-axis path (0,0,0)→(1,1,1) "length at least √3 ... whereas straight segment" — the printed comparison is garbled in the text layer (as "at least 3 whereas ... √3"); not image-verified, so not transcribed as a claim.
- ⚠ Title/numbering inconsistencies across the series: this paper's own title "Merge Trees of Length-Filtered Lattice Knot Spaces"; Ozawa26density [16] cites it as "Merge trees of lattice knots"; Ozawa26geom [17] cites arXiv:2605.25322 as "Discrete knot theory via lattice-filtered move graphs" (the framework name used inside this paper, "discrete knot theory", p. 2).
- ⚠ Abstract/intro say "exact merge height 66 with the square" for the 64-edge frozen unknot while Remark 11.3 calls this "exact barrier two" (consistent: 66−64=2).
- ⚠ Table 1 lists the 6_3 two-seed N=40 graph as 14 vertices (Table 9) vs Table 7's single-seed 7 vertices — consistent (7+7).
- Section 11.4.1 mentions Table 7's earlier prototype search "finds the 56-state minimal component, then stops at 1000 states under cap 26", superseded by the certificates.
- Fig. 3 caption numbers: "7 moves / 39 moves" label on the figure sums to 46.
- Run times (hardware dependent): 851.825 s (4_1 mirror merge at N=32, Python), 347.037 s (6_3 N=44, C++17). No other run times reported.
