# BPS26 — Entanglement complexity of spanning pairs of lattice polygons
- **Authors:** Ryan Blair (CSU Long Beach), Puttipong Pongtanapaisan (Pitzer College), Christine E. Soteros (Univ. of Saskatchewan)
- **Venue / year / identifiers:** arXiv:2601.11481v2 [math.GT], 3 May 2026
- **File:** papers/4_links/Blair-Pongtanapaisan-Soteros_2026_Spanning_pairs_lattice_polygons_2601.11481.pdf   **Pages:** 29
- **Text layer:** ok (a few floor/ceiling brackets and fractions garbled; Def. 6 and Thm 4 checked on page images)

## Abstract
We study the entanglement complexity of a system consisting of two simple-closed curves (self-avoiding polygons) that span a lattice tube, referred to as a 2SAP. 2SAPs are of interest as the first known model of confined ring polymers where the linking probability goes to 1 exponentially with the size of the system. Atapour et al proved this in 2010 by showing that all but exponentially few sufficiently large 2SAPs contain a pattern that guarantees the 2SAP is non-split, provided that the requisite pattern fits in the tube. This result was recently extended to all tubes sizes that admit non-trivial links. Here we develop and apply knot theory results to answer more general questions about the entanglement complexity of 2SAPs.
We first extend the 1992 concept of a good measure of knot complexity to a good measure, F, of spanning-link complexity for k-component links. Using tangle products, we show, for example, that the more complex the prime knot decomposition of any component of a given link type, the greater its F-measure. We then prove that all but exponentially few size m 2SAPs have F complexity that grows at least linearly in m as m → ∞. We establish that good measures of knot complexity yield good measures of spanning-link complexity. We also establish conditions whereby more general link invariants can yield good measures. In particular, we establish that measures based on several classical invariants are good measures by our definition, eg bridge number, the number of p-colourings or splitting number.
Finally, we consider how the tube dimensions affect which links are embeddable as 2SAPs as well as geometric restrictions on the entanglement complexity of the embeddings. For example, we establish that there are two-component links that occur as 2SAPs in a given tube size only when one of the components is forced into a non-minimal bridge number conformation.
Keywords: knot complexity, lattice polygons, link complexity, polymer confinement, nanochannel, tangle product, bridge number, splitting number, trunk.

## Notation and conventions
- (p. 7) Z^3 = simple cubic lattice, vertices Z^3, edges between vertices at unit distance. "The length of an embedding f: S^1 → Z^3 is the number of edges in f(S^1)." SAP = self-avoiding polygon.
- (p. 7) "An N × M tube is the sublattice of Z^3 induced by the vertex set {(x,y,z) ∈ Z^3 | x ≥ 0, 0 ≤ y ≤ N, 0 ≤ z ≤ M}, we denote this tube by T_{N,M}." (So an N×M tube has (N+1)(M+1) vertices per cross-section; p. 1 also defines M-slab (0≤z≤M) and (N,M)-tube.) From p. 5: assume M ≥ N ≥ 1 and M+N ≥ 3.
- (p. 7) span of an embedding = absolute difference between smallest and largest x value of its vertices.
- Definition 1 (p. 7): "A kSAP in a tube T_{N,M} is the image of an embedding f: ⊔_{i=1}^k S^1 → T_{N,M}, which consists of k disjoint self-avoiding polygons with the additional property that each component has the same span and each has a vertex in the x = 0 plane." Span of a kSAP = largest x value. (Components may have different numbers of edges.)
- Q^k_T = set of kSAPs in T; Q^k_{T,s}(n) = those of span s and length n; q^{(k,s)}_T(n) = |Q^k_{T,s}(n)|; q^{(k,s)}_T = Σ_n; q^{(k)}_T(n) = Σ_s. Size of a kSAP = span or length (p. 7). A(N,M) = number of lattice edges per span in an (N,M)-tube (p. 8).
- ω_T^{(k)}: exponential growth rate for span-s kSAPs; Ω_T^{(k)}: for length-n kSAPs (p. 8).
- Pattern terminology (p. 8): span-b block at x = j−1/2; kSAP pattern P = (η_P, E_P); start/end/proper pattern; link pattern; link-type of a link pattern.
- Definition 3 (p. 9): "A graph G is an n-star graph if G has n edges and n + 1 vertices such that n of the vertices are valence one and one of the vertices is valence n. Denote by ∂(G) the set of valence one vertices." (added by reviewer)
- Definition 5 (p. 10): a k-tangle-triple is (L, G_1, G_2), L a k-component link in S³, G_i disjoint k-star graphs with G_i ∩ L = ∂(G_i), each G_i meeting each component of L in exactly one point; equivalence by smooth ambient isotopy carrying L, G_1, G_2 to their counterparts. (added by reviewer)
- Definition 7 (p. 15): "The splitting number of a link is the minimum number of crossing changes between distinct components that is required to convert the link into a split link." (added by reviewer)
- L^k = set of smooth ambient isotopy classes of k-component links; L^k_T = k-tangle-triples (Def. 5). Tangle product ∗ (Def. 4), concatenation (+)_k (Def. 2).
- Good measure of knot complexity (p. 9, from [35]): F: K → [0,∞) with (i) F(unknot)=0; (ii) ∃K such that F(#_{i=1}^n K # L) ≥ nF(K) > 0 for all L.
- trunk(l) = max_t |h^{-1}(t) ∩ l| for height h(x,y,z) = y, Morse embedding; trunk of link type = min over Morse embeddings (p. 18). EH-trunk: same but only over embeddings where highest maximum of each component lies at same height h_max and lowest minimum at same height h_min (p. 18). EH-trunk_{K_1=j}(L): EH-trunk with the K_1 component constrained to have j maxima (p. 6, 24).
- index σ_i of a pattern (V_i,K_i): minimal geometric intersection of K_i with meridian disk of V_i; dual index ω_1 of unknotted companion L^0_1 = index of the pattern (S^3∖V_1, L^0_2) (p. 21).
- Splitting number (Def. 7, p. 15): minimum number of crossing changes between distinct components required to convert link into a split link. Col_p(L) = number of Fox p-colorings of a diagram (monochromatic included); Col_p(k-component unlink) = p^k (p. 14).
- Meridionally small knot: no essential surface properly embedded in knot exterior with meridional boundary (p. 5); includes 2-bridge and torus knots.

## Numbered statements
(Numbering as printed; Definitions 1–7 transcribed under Notation/Methods.)

**Theorem 1 (pp. 3, 11) — proved here.** Suppose that F: ⊔_{i=1}^∞ L^i → [0,∞) is a function defined on links of any number of components. Additionally, suppose: 1. if U is an unlink, F(U) = 0; 2. if a link L = L′ ∪ U is a split link with splitting sphere separating L′ from U, then F(L) = F(L′); 3. the restriction F: L^1 → [0,∞) is a good measure of knot complexity; and 4. for any knot K and for any link L with component knot K, F(L) ≥ F(K). Then the restriction F: L^k → [0,∞) is a good measure of k-component spanning link complexity for any k ≥ 1.
Proof idea (p. 11): choose K from the good-measure property; each copy of L(K) in the decomposition is a connected-summing of a copy of K onto some component of a link M′, so some component has ≥ ⌈m/k⌉ copies of K; apply hypotheses 4, 3, 2.
Examples (p. 4, 11–12): F = bridge number − k, crossing number, unlinking number, braid index − k satisfy conditions 1–4 (hence are good measures).

**Corollary 1 (pp. 4, 12) — proved here.** If F_1: L^1 → [0,∞) is a good measure of knot complexity, then F: ⊔_{i≥1} L^i → [0,∞) given by F(L) = max_{K⊂L} F_1(K), the maximum over all components K of L, is a good measure of k-component spanning link complexity when restricted to k-component links. Hence (using [35, Thm 3.3]) the component-wise maximum of each of the following knot invariants gives a good measure: number of prime factors, genus, bridge number minus one, span of any non-trivial Laurent knot polynomial, log(order), crossing number, unknotting number, minor index, braid index minus one.

**Theorem 2 (pp. 4, 14) — proved here.** Given k ≥ 1, suppose F: L^k → [0,∞) satisfies: (1) if U ∈ L^k is an unlink, F(U) = 0; (2) there exists a knot K such that for any link L ∈ L^k containing m factors having knot-type K, F(L) ≥ mF(L(K)), where L(K) is defined in Fig. 3a. Then F is a good measure of k-component spanning link complexity.
Applications (pp. 4, 14–15): genus, number of prime factors, span of the Alexander polynomial (K = trefoil, say; any nontrivial K for genus and prime factors), and F = log_p(Col_p(L)) − (number of components) (K = T(2,p), Col_p(T(2,p)) = p²; Col_p of split union of (k−1)-unlink and T(2,p) = p^{k+1}) are good measures.

**Theorem 3 (pp. 5, 18) — proved here (adaptation of Theorem 7).** A nontrivial 2-component link can be confined in a M × N tube in such a way that each component has the same span if and only if EH-trunk(L) < (M+1)(N+1).
Proof idea (p. 19): if trunk equals (M+1)(N+1) translate an edge of the higher hinge H_b in the −x direction onto hinge H_a, an isotopy lowering the number of such levels; conversely use the construction in the proof of Theorem 7 which preserves relative heights of minima and maxima.

**Corollary 2 (pp. 5, 20) — proved here.** For a split 2-component link L = 0_1 ∪ K, EH-trunk(L) = trunk(K) + 2. Furthermore, if L embeds as a 2SAP in a (N × M) tube (i.e. if EH-trunk(L) < (N+1)(M+1)), a local 2SAP knot pattern of K embeds in a ((N+1) × M) tube. For any meridionally small knot K, a local 2SAP knot pattern of K also embeds in a (N × M) tube.
Proof idea (pp. 20–21): place the unknot with exactly one maximum at height a and one minimum at height b to get ≤ trunk(K)+2; every level plane between h_min and h_max meets the unknot ≥ 2 times and K ≥ trunk(K) times at some level; remaining claims via [5, Result 4*] and Prop. 9.

**Theorem 4 (pp. 5, 17) — proved here.** Let F be a good measure of 2-component spanning link complexity and let L ∈ L^2_T be a 2-tangle-triple that satisfies condition (ii) for F of Definition 6. Suppose there exists a proper 2SAP pattern P_L such that whenever a 2SAP contains j > 0 non-overlapping translates of P_L it is equivalent as a link to a tangle product L′ = J_1∗L∗J_2∗L∗J_3∗…∗J_j∗L∗J_{j+1} for some choice of J_1,…,J_{j+1} ∈ L^2_T. Consider any T = T_{N,M} that admits 2SAPs containing P_L. Fix the 2SAP size measure m to be either span or length. Then there exists a positive integer m_L such that for sufficiently large m > m_L, all but exponentially few size-m 2SAPs in T have F-complexity which exceeds F(L)( m/(2m_L) − 1 ).
Proof idea (p. 17): pattern theorem (Thm 6) gives ≥ ⌊ε_L m⌋ translates of P_L; at least ⌊ε_L m⌋/(s+1) of them are non-overlapping (s = span of P_L; greedy argument); then F(L′) ≥ (⌊m ε̂_L⌋/2)F(L). Taking m > 2m_L + 1 and 0 < β ≤ 1/(2m_L) − 1/(2m_L+1) gives F(L′) ≥ βmF(L), i.e. linear growth in m.

**Theorem 5 (pp. 6, 25) — proved here.** Fix j ≥ β(K_1), where β(K_1) is the bridge number of K_1 in S^3. Suppose that the index σ_1 of K_1 in V_1 is strictly greater than j. Let L = K_1 ∪ K_2 be a 2-component satellite link, where K_1 and the companion of K_1 are each unknots. Then EH-trunk_{K_1=j}(L) ≥ 2 + 2ω_1σ_2.
Proof idea (p. 25): combine Lemmas 10–13: the highest essential saddle of the foliation of ∂V_1 is nested, giving a level sphere meeting L in ≥ 2ω_1σ_2 + 2 points.

**Theorem 6 (pp. 8, quoted from [2, 34]) — pattern theorem for kSAPs, k = 1, 2.** Given a proper kSAP pattern P, let q^{(k,s)}_T(P, <ℓ) be the number of span-s kSAPs that contain fewer than ℓ x-translates of P. Then there exists ε_P > 0 such that limsup_{s→∞} (1/s) log q^{(k,s)}_T(P, < ε_P s) < log ω^{(k)}_T. Similarly with length: there exists ε̃_P > 0 with limsup_{n→∞} (1/n) log q^{(k)}_T(n; P, < ε̃_P n) < log Ω^{(k)}_T. Consequence (p. 9): all but exponentially few span-s (resp. length-n) kSAPs contain P at least ε_P s (resp. ε̃_P n) times.

**Theorem 7 (pp. 18, quoted: Theorem 1 of [19]).** A link type L can be confined in a M × N tube if and only if trunk(L) < (M+1)(N+1).

**Lemma 3 (p. 15, quoted from Nakanishi [26,27]).** (1) Let (C,v) be a 2-string tangle and let D be a disk properly embedded in C that intersects both arcs of (C,v) in a single point each and separates (C,v) into two 2-string tangles (A,t) and (B,u). Let (B,u) be an inseparable tangle. Suppose that for any disk D′ properly embedded in A with D′ ∩ ∂D = ∅ and D′ ∩ t = ∅, D′ does not separate t; then (C,v) is inseparable. (2) Let L be a link in S^3. Suppose S is a 2-sphere meeting L transversely in 4 points and dividing (S^3,L) into two 2-string tangles (A,A∩L) and (B,B∩L). If both tangles are inseparable then L is non-split. [A tangle (C,v) is inseparable if there is no properly embedded disk in C disjoint from v and separating components of v.]

**Proposition 4 (p. 15) — proved here.** Let (C_1,t_1) and (C_2,t_2) be inseparable tangles. If the tangle diagram in Fig. 8 appears in a diagram of a 2-component link L in such a way that the solid arcs belong to the same link component and the dotted arcs belong to the other component, then L is non-split. (Generalises Theorem 6.3 of [2], where both tangles are the granny tangle.)

**Proposition 5 (p. 16) — proved here.** Let L be a 2-component link. Assume that there exists a 2-sphere S intersecting each component of L in 4 points such that S bounds the tangle in Fig. 9 on one side, then L is a non-split link. (Fig. 9 tangle built from Kanenobu's prime tangles 5_1 and 6_3 [21].)

**Proposition 6 (p. 16) — proved here.** The splitting number is a good measure of 2-component spanning link complexity. Furthermore, for this measure, the L in criterion (ii) of Definition 6 cannot be of the form L(K) for any K.
Proof idea (p. 16): the link L̄ of Fig. 10 is non-split by Prop. 5; one crossing change at the highlighted crossing splits it, so F(L̄) = 1; by Prop. 5 each instance requires at least one crossing change.

**Proposition 7 (p. 17) — proved here.** There exist patterns P_L and associated tubes T_{N,M} as required for Theorem 4 for F equal to splitting number or for F a good measure of 2-component spanning link complexity that satisfies either Theorem 1 or Theorem 2.
Proof notes (p. 18): a local 2SAP knot pattern of K works as P_L; fits in T_{N,M} with (N+1)(M+1) > trunk(K)+4; for K = 3_1 (meridionally small) the pattern exists in T_{3,1} (or larger), so all but exponentially few sufficiently large size-m 2SAPs in T have F-complexity exceeding F(L(3_1))(m/(2m_L) − 1). For splitting number the pattern is the tangle of Fig. 10 which fits T_{3,1} (Prop. 8); then splitting number exceeds (m/(2m_L) − 1). Number of prime factors: for any tube admitting a local 2SAP knot pattern of a nontrivial K, ∃β>0 with ≥ βm prime factors for all but exponentially few large 2SAPs.

**Proposition 8 (p. 19) — proved here.** The tangle in Figure 9 can be embedded in a (3 × 1)-tube. (Proof: the link of Fig. 10 has EH-trunk 6 < (3+1)(1+1) = 8, apply Theorem 3.)

**Proposition 9 (p. 20) — proved here (⚠ called "Lemma 9" on p. 5).** Suppose that K ∈ L^1 embeds in an (N×M)-tube. Suppose also that a trunk minimizing diagram of K contains an arc of the diagram that connects the highest local maximum to the lowest local minimum isolated as shown in Fig. 13, then a local knot pattern of K also embeds in an (N×M)-tube. Proof: cutting the special arc at its ends yields a 2-string tangle that is a local knot pattern. Context: [29] shows meridionally small knots (2-bridge, torus knots) have trunk-minimizing embedding in bridge position.

**Lemma 10 (p. 22) — proved here.** If D is a meridian disk for ∂V_1 in S^3∖V_1, then |D ∩ K_2| ≥ ω_1σ_2. (Authors suspect it exists in the literature.)

**Lemma 11 (p. 23) — proved here.** F_{∂V_1} has an essential saddle. Furthermore, if S is the height of a highest essential saddle, then h^{-1}(p) ∩ ∂V_1 is a collection of inessential curves in ∂V_1 for all regular values p > S.

**Lemma 12 (p. 24) — proved here.** Fix j ≥ β(K_1). Suppose the index σ_1 of (V_1,K_1) is strictly greater than j. Suppose ℓ′ is an EH-trunk minimizing embedding of L subject to the constraint that the K_1 component of ℓ′ has j maxima. Let σ be the highest essential saddle. Then σ is nested with respect to V_1.

**Lemma 13 (p. 25) — proved here.** Same hypotheses as Lemma 12; let the highest essential saddle lie in the level sphere h^{-1}(r). Then |L ∩ h^{-1}(r)| ≥ 2ω_1σ_2 + 2.

**Remark 1 (p. 25).** If EH-trunk is replaced by the usual version of trunk in the previous statement, the conclusion becomes |L ∩ h^{-1}(r)| ≥ 2ω_1σ_2 (the +2 is missing).

⚠ Numbering: "Lemma 9" cited on p. 5 corresponds to Proposition 9 on p. 20 (no Lemma 9 appears). Also Theorem 1, Corollary 1 and Theorem 2 are stated twice (intro and body); Theorem 3 and Cor. 2 likewise; Theorem 4 likewise. ⚠ Definition 6 (ii): as printed in the page image "≥ (m/k) F(L) > 0" (the text layer and the proof of Thm 1 indicate floor/ceiling brackets ⌊m/k⌋ or ⌈m/k⌉ whose exact form is not legible; the proof of Thm 1 uses ⌈m/k⌉ copies; the proof of Thm 4 uses ⌊m ε̂⌋/2 for k=2).

## Key equations and quantitative claims outside numbered statements
- Concatenation (Def. 2, p. 7): θ_1 (+)_k θ_2 ∈ Q^k_{T,s_1+s_2+d_k}(n_1+n_2+e_k); for k=2, N+M ≥ 3: d_2 = 18 + 8(N+M), e_2 = 4d_2 + 8(N+M) + 4 [from 2, Lemma 3.3]; k=1, N+M ≥ 2 from [4], with d_1 < d_2, e_1 < e_2.
- (1) q^{(k,s_1)} q^{(k,s_2)} ≤ q^{(k,s_1+s_2+d)} ≤ 2^{A(N,M)(s_1+s_2+d)} (p. 7); (2) superadditivity of log q^{(k,s−d)} ⇒ by Fekete's lemma lim (1/s) log q^{(k,s)} = sup_s (1/s) log q^{(k,s−d)} = log ω_T^{(k)} exists; likewise log Ω_T^{(k)} = lim (1/n) log q^{(k)}(n) = sup (1/n) log q^{(k)}(n−e) (p. 8).
- (p. 1) Literature context: linking probability for 2SAPs → 1 exponentially fast ([2] for min{M,N} ≥ 1, N+M ≥ 4; extended to N+M ≥ 3 by [13]); for non-spanning pairs of SAPs in tubes/slabs, exponential growth rates of split and non-split pairs are equal [28, 39] (so exponentially-fast linking cannot be claimed). All 2SAPs in the 2×1 tube are prime [13] so the 2×1 tube is excluded from the high-complexity result (p. 2).
- (p. 3–5) Known minimal lattice results cited: "For polygons in the simple cubic lattice all knots are embeddable [35] and there are proofs regarding the minimal number of steps needed to create some knots [32]. Algorithms have also been used to obtain upper bounds for these minimal step numbers for knots and links in various lattices and for slab and tube sublattices [18, 19, 20]. In [19], the authors used the complexity called the trunk of knots [29] to completely characterize the knots and links that fit inside an N × M tube."
- Example 1 (p. 25–26): link with Whitehead link 5^2_1 pattern, σ_1 = 2, σ_2 = 2, ω_1 = 2; EH-trunk ≤ 8 (Fig. 20 top, a 2SAP in a (2×2)-tube); with unknotted component constrained to one local maximum, EH-trunk ≥ 2 + 2(2·2) = 10 and the bottom embedding (trunk 10) cannot be a 2SAP in a (2×2)-tube.
- Example 2 (p. 26–27): pattern L6a1, σ_1 = 2, σ_2 = 3, ω_1 = 2; EH-trunk ≤ 10; constrained ≥ 2 + 2(2·3) = 14; the trunk-14 embedding cannot be a 2SAP in a (2×3)-tube; top embedding is a 2SAP in (2×3)-tube.
- DNA/nanopore remark (p. 26): if the black component of Example 1 always meets the nanopore plane in ≤ 2 points then ≥ 10 DNA strands translocate simultaneously vs 8 without the constraint.
- Splitting-number link L̄ of Fig. 10 has EH-trunk 6; a single crossing change splits it (p. 16–17).
- Colourings (p. 14): Col_p(unlink on k components) = p^k; Col_p(T(2,p)) = p²; Fig. 6 family (unknot ∪ connected sum of m trefoils) has Col_3(L) = 9 but Col_3(K) = 3^{m+1}, showing p-colouring number fails condition 4 of Thm 1.

## Methods / algorithms
Pure-math; proof strategy:
1. (pp. 7–9) Concatenation of 2SAPs in tube (blocks of added edges) gives superadditivity ⇒ growth rates; pattern theorem (Thm 6) from [2, 34, 3, 24].
2. (p. 9–10) Interpret 2SAP concatenation as a 2-strand tangle product of k-tangle-triples (Def. 3–5); define good measures (Def. 6) via tangle products.
3. (pp. 10–15) Prove criteria (Thms 1, 2, Cor. 1) and list invariants; splitting number via Nakanishi's inseparable-tangle criterion (Lemma 3, Props. 4–6).
4. (p. 17) Combine with pattern theorem and greedy non-overlap argument for linear growth (Thm 4); Prop. 7–8 give tube sizes (T_{3,1} suffices for splitting number and for K = 3_1).
5. (pp. 18–21) EH-trunk, Theorem 3 via the translation-reduction of hinges; Corollary 2.
6. (pp. 21–25) Satellite links, Morse foliation of ∂V_1, essential/nested saddles, Lemmas 10–13, Theorem 5.

## Tables
None.

## Figures
- **Fig. 1 (p. 2)** — "(a) An embedding of a 2-component unlink in a (2 × 3) lattice tube that is a 2SAP. In this case, the span of the 2SAP is 6. (b) An embedding of a 2-component unlink in a (2 × 1) lattice tube that is not a 2SAP." Image: ../figures/BPS26/p02.png
- **Fig. 2 (p. 3)** — "(a) Two 2-component links (top) are concatenated together by component-wise connected sum operations to create a new link (bottom). This concatenation operation is equivalent to a 2-strand tangle product operation (middle) as in Definition 4. This example also illustrates that concatenating two unlinks can yield a non-split link. (b) Half of the concatenation algorithm described in Definition 2 for concatenating kSAPs, k = 2: dashed lines represent a 2SAP θ_1 and solid lines indicate half the edges added to concatenate to any other 2SAP." Image: ../figures/BPS26/p03.png
- **Fig. 3 (p. 4)** — "(a) The link L(K) is the split union of k knots (shown in black for k = 2) where one is knot-type K (localized in the dashed blue circle) and the others are the unknot (0_1). L(K) is also used to represent the k-tangle triple (L(K), G_1, G_2) where G_1 and G_2 are the k-star graphs … (b) A pattern that increases some complexities of 2SAPs. Using our terminology, this is L(3_1)." Image: ../figures/BPS26/p04.png
- **Fig. 4 (p. 10)** — "(a) Two 3-tangle-triples (L(K_1), G_1^1, G_2^1) and (L(K_2), G_2^1, G_2^2) where K_i for i = 1, 2 is any knot. (b) A result of performing a 3-strand tangle product to get (L(K_1#K_2), G_1^1, G_2^2)."
- **Fig. 5 (p. 13)** — "(a) The number of prime knot factors may decrease under concatenation. The resulting link after concatenation is the prime link L10a38 from Thistlethwaite's table of prime links. (b) A closure of this pattern is a prime link L7a2." **Fig. 6 (p. 13)** — "A family of 2-component links that shows that the number of p-colorings fails condition 4 of Theorem 1. Each link L in this family has one component the unknot and the other, K, is a connected sum of m ≥ 1 trefoils. Such an L can be shown to have 9 distinct 3-colorings. Additionally, K has 3m+1 distinct 3-colorings." (⚠ the text says K has 3^{m+1}? as printed "3m+1" in caption and "3m+1" on p. 12; the superscript may be lost in the text layer: for the connected sum of m trefoils Col_3 = 3^{m+1}; not verified on image.) Image: ../figures/BPS26/p13.png
- **Fig. 7 (p. 14)** — "The link L6a1 is tricolorable".
- **Fig. 8 (p. 16)** — "This figure shows a 4-string tangle. Let (C_1,t_1) and (C_2,t_2) be inseparable 2-string tangles. If a link contains the 4-string tangle in this figure, where the solid lines belong to the same component, then the link is non-split." **Fig. 9 (p. 16)** — "If a link contains this tangle, then the link is non-split." (endpoints labelled a–h, 1–8). Image: ../figures/BPS26/p16.png
- **Fig. 10 (p. 17)** — "The 2-component link L̄ is obtained from the tangle in Figure 9 by connecting endpoints labeled a with d and then b with c. The equal height trunk of this link is 6. The purple line represents a level sphere that intersects the link 6 times, and there are no other level spheres that intersect the corresponding Morse embedding in more than 6 times. Also, changing the highlighted crossing turns the link into a split link." Image: ../figures/BPS26/p17.png
- **Fig. 11 (p. 19)** — "A 2SAP with an (M+1)(N+1) section." **Fig. 12 (p. 19)** — "After reductions, a nontrivial 2SAP does not contain an (M+1)(N+1) section."
- **Fig. 13 (p. 20)** — "Cutting the special arc colored in blue at its ends (in the top diagram) gives a local pattern (bottom diagram). The rectangles represent braid boxes." **Fig. 14 (p. 20)** — "A case where trying to create a local pattern (bottom diagram) from the top diagram may need a larger tube size."
- **Fig. 15 (p. 22)** — "A satellite 2-component link is formed by taking two solid tori each containing a knot, and then knotting up those solid tori." **Fig. 16 (p. 23)** nested saddle; **Fig. 17 (p. 24)** Type I / Type II saddles; **Fig. 18 (p. 24)**; **Fig. 19 (p. 25)** knee component.
- **Fig. 20 (p. 26)** — "Two morse embeddings of the same link type. By the proof of Theorem 7, the top embedding can be realized as a 2SAP in a (2 × 2)-tube. However, the bottom embedding has trunk 10 and cannot be realized as a 2SAP in a (2 × 2)-tube." **Fig. 21 (p. 27)** — same for (2×3)-tube, bottom has trunk 14. Images: ../figures/BPS26/p26.png, p27.png
(Descriptions from captions; figures were rendered but not individually analysed beyond captions.)

## Stated limitations, open problems, future work
- (p. 6) "we expect the previous result can be extended in at least two directions … First, based on the general pattern theorem [24], the result should also hold for length n 2SAPs subject to a stretching or compressing force as well as to Hamiltonian 2SAPs. Second, we expect it can be generalized to kSAPs, k mutually avoiding spanning SAPs in T."
- (p. 7) "For sufficiently large N, M it is expected that an analogous algorithm [concatenation] can be defined for k > 2 but we do not provide details here."
- (p. 5) Local-pattern embeddability: "for other kinds of knots a larger tube may be needed for the local than for the non-local knot patterns" (only meridionally small knots shown to need the same tube).
- (p. 12/15) Theorems 1 and 2 only give measures that "increase linearly as the complexity of the prime decompositions of each component increases"; splitting number shows other L are possible.
- (p. 5) The 2×1 tube is excluded from the high-complexity theorem (all 2SAPs there are prime).

## References worth following
- [2] Atapour, Soteros, Ernst, Whittington, The linking probability for 2-component links which span a lattice tube, JKTR 19 (2010) 27–54.
- [13] Eng, Pongtanapaisan, Scharein, Soteros, Link statistics for pairs of polygons spanning a tube or nano-channel (in preparation, 2025).
- [19] Ishihara, Pouokam, Suzuki, Scharein, Vazquez, Arsuaga, Shimokawa, Bounds for minimum step number of knots confined to tubes in the simple cubic lattice, J. Phys. A 50 (2017) 215601 (Theorem 7).
- [18] Ishihara et al., Bounds for the minimum step number of knots confined to slabs in the simple cubic lattice, J. Phys. A 45 (2012); [32] Scharein et al., Bounds for the minimum step number of knots in the simple cubic lattice, J. Phys. A 42 (2009) 475006; [20] Janse van Rensburg–Rechnitzer, Minimal knotted polygons in cubic lattices, J. Stat. Mech. (2011); [22] H. Kim, Minimum lattice length of 2-bridge knots and links, Topology Appl. 371 (2025).
- [35] Soteros, Sumners, Whittington, Entanglement complexity of graphs in Z^3, Math. Proc. Camb. Phil. Soc. 111 (1992) (good measures).
- [5] Beaton, Eng, Ishihara, Shimokawa, Soteros, Characterising knotting properties of polymers in nanochannels, Soft Matter 14 (2018); [4] Beaton–Eng–Soteros, Knotting statistics for polygons in lattice tubes, J. Phys. A 52 (2019).
- [24] Madras, A pattern theorem for lattice clusters, Ann. Comb. 3 (1999); [34] Soteros, Knots in graphs in subsets of Z^3 (1998); [29] Ozawa, Waist and trunk of knots, Geom. Dedicata 149 (2010); [23] Kodani, A new bridge index for links with trivial knot components, Math. Proc. Camb. 154 (2013).

## Extraction notes
- All 29 pages read from text layer; Theorem 4, Definition 6, Theorem 3, Cor. 2 and Theorem 1 statements checked against page images (pp. 5, 11, 17). Proof details in Section 3.2 (Lemmas 10–13) read from text only (proof ideas summarised, not transcribed in full).
- Lattice relevance: key. Lattice tube T_{N,M} embeddability criterion trunk(L) < (M+1)(N+1) (Theorem 7, quoted from [19]) and its EH-trunk variant (Theorem 3) characterise which links fit in an N×M lattice tube; pattern theorem and exponential growth rates for spanning pairs of lattice polygons; minimal-step-number references [18–20, 22, 32]. No numerical minimal lengths are given in this paper.
- ⚠ Lemma 9 / Proposition 9 numbering; ⚠ possible lost superscript in "3m+1" (3^{m+1}) in Fig. 6 caption and p. 12 text; ⚠ Def. 6 floor/ceiling.
