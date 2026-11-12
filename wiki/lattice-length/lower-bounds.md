# Lower bounds on minimal lattice length Len(K)

What is *proved* about how short a lattice polygon of type K can be. Upper bounds and constructions are in [upper-bounds-crossing-number](upper-bounds-crossing-number.md); exact values in [exact-values-and-proofs](exact-values-and-proofs.md).

Summary: the only general lower bounds are weak (linear in braid index, bridge index, or crossing number for alternating knots). Exact minimality has been certified only for 3_1 (24), 4_1 (30), 5_1 (34). For every other knot, the gap between the best lower bound and the numerical minimum is large.

## 1. Universal threshold: Len(K) ≥ 24 for every nontrivial K

[Diao93]: every lattice polygon with fewer than 24 edges is unknotted, and only the trefoil occurs at 24. Extended by [Scharein09] Thm 2 (proof outlined): polygons of ≤ 28 edges are unknotted or trefoils (⇒ Len(4_1) = 30), and Len(5_1) = 34. Details: [exact-values-and-proofs](exact-values-and-proofs.md).

## 2. Braid index: Len(K) > B(K)

**[Diao19] Thm 3.1 (proved).** For an unoriented link K let **B**(K) be the *absolute braid index* (largest braid index over all orientations of the components). Then **B**(K) < L_c(K), where L_c = minimum step number = Len.

Proof outline ([Diao19] §3): project a minimal polygon (z-steps the majority, so x+y steps ≤ (2/3)Len); near each lattice point the crossing strands form a "special cord diagram" with n_j cords in disjoint z-slabs; re-embed each so its Seifert diagram is coherent (Lemma 2.4: n partial circles, ≤ n − 1 full circles); count Seifert circles s < (3/2)Σn_j ≤ Len; Yamada's b ≤ s finishes.

Consequences stated there:
* (2, 2n) torus link: **B** = n + 1 = c/2 + 1 ⇒ Len > c/2 + 1 (Ex. 3.2).
* Twist knots: **B** = b = (c + 1)/2 for odd c = 2k + 1 and c/2 + 1 for even c = 2k + 2 ⇒ Len > (c + 1)/2 (Ex. 3.3).
* Alternating 3-column pretzels (2k+1, 2m+1, 2n+1): **B** = 2 + k + m + n > c/2 (Ex. 3.4).
* Thm 4.1: same with **B**_0 = max over orientations of the Morton–Franks–Williams bound (E − e)/2 + 1 from the HOMFLY-PT polynomial — computable.

*My remark:* for knots (one component) **B** = b, so this reads Len(K) ≥ b(K) + 1 — far below the observed minima (e.g. b(3_1) = 2 vs Len = 24); useful only asymptotically.

## 3. Alternating knots: linear in crossing number

**[Diao22] Thm 3.1 (proved).** For every alternating knot K, ropelength R(K) ≥ b_0·c(K) with b_0 > 1/59.5. The lattice step inside the proof gives directly:

**4·Len(K) + 6 ≥ c(K)** for alternating K ([Diao22] p. 3), i.e. Len(K) ≥ (c(K) − 6)/4; using Len ≥ 24 this is relaxed to Len ≥ c/4.25 to get the ropelength constant.

Proof outline: take a minimal polygon K_c, push off by (½,½,½), scale by 2 to get a lattice reverse-parallel link of length 4Len (or 4Len + 8 after one local modification changing the linking number by 1); by Rudolph's congruence + Cromwell, one of the two links has HOMFLY v-breadth ≥ 2c + 2 (Lemma 2.1, Remark 2.2), so braid index ≥ c + 2 (MFW), and [Diao19] gives length ≥ braid index.

Remark 3.3 there: the argument fails for alternating *links*; the conjecture stays open for them.

## 4. Bridge index and the minimal edge index

[JvRP95] (they write M(K) for Len and μ_K for the index):
* Len is subadditive: Len(K_1#K_2) ≤ Len(K_1) + Len(K_2) (Lemma 1), and **Len(K_1#K_2) ≥ α_{K_1} + α_{K_2} with α_K = 4(b(K) − 1)**, additive because b − 1 is (Lemma 2). Hence the **minimal edge index** μ_K = lim Len(K^n)/n exists, Len(K^n) ≥ nμ_K, and μ_K > 0 for nontrivial K (Thm 3). Properties: μ_{K^n} = nμ_K, μ_{K_1#K_2} ≤ μ_{K_1} + μ_{K_2} (Thm 6); additivity is Conjecture 7.
* **μ_{3_1} ≤ 17**, via a 17-edge "tight" trefoil with the Kesten property concatenated into long strings (Thm 13 + Fig. 4); so 4 ≤ μ_{3_1} ≤ 17. Numerically Len(3_1^n) ≈ 16.8n + 6.8 (Table II, n ≤ 10); [JvRR11]'s later data give 24 + 16(n − 1) for n ≤ 6 (see [census](minimal-polygon-census.md)).
* Curvature bound: Len(K) ≥ 2c_p(K)/π ≥ 10 (c_p = minimal lattice curvature) and μ_K ≥ 4 (Thm 14) — weaker than 24.
* Trivial crossing bound: an M-edge polygon has at most M(M − 3)/2 crossings in a regular projection, so Len ≥ √(2c) (p. 9).
* Growth of the number of knot types with Len = n: exponential, lim (log Q(n))/n exists (Thm 10, Cor 11); Q ≥ 1.073 from their table.
* Same index in FCC and BCC: α_K ≥ 3(b − 1) and ≥ 2(b − 1) (argued in [JvRR11] p. 6).
* *My remark:* for a single prime knot the bridge argument yields Len(K) ≳ 4(b − 1), trivially weaker than 24 for all knots with b ≤ 7; it matters only for long composites.

## 4a. Equivalent formulation: cube knots ([MannML])

**Minimal cube number = 2 × minimal step number** for every knot type in Z³ (Thm 1, proved): a knot made of face-adjacent unit cubes needs exactly twice as many cubes as a lattice polygon needs edges. Conjectured analogue in FCC (Voronoi cells = rhombic dodecahedra): M_K = 2.5·m_K (Conj. 1). So any lower bound for cube knots is a lower bound for Len, and vice versa.

## 5. Via ropelength

Lattice polygons carry an embedded tube of radius 1/2, so **Rop(K) ≤ 2·Len(K)** in the length/radius convention ([HNOR15] p. 4, [HKNO14] §1). Any ropelength lower bound therefore gives Len(K) ≥ Rop(K)/2:

* Four-thirds law: ((4π/11)·c(K))^{3/4} ≤ Rop(K) as printed in [HNOR15] p. 5 (summarising Buck, Buck–Simon, Cantarella–Kusner–Sullivan), power 3/4 optimal (attained by the (p,q)-Hopf link families of [HNOR15] Thm 2). ⇒ Len(K) ≥ ½((4π/11)c)^{3/4}.
* Absolute constant: Rop ≥ 31.32 for every nontrivial knot ([DDS04] Cor 9.7, = 15.66 in its diameter units; [Diao19] quotes the same 31.32, confirming it uses length/radius). ⇒ Len(K) ≥ 15.66 — weaker than 24. Details and conventions: [ropelength/lower-bounds](../ropelength/lower-bounds.md).
* Conversely [Diao19] uses L_c(K) < 14·Rop(K) (from Diao–Ernst–Janse van Rensburg 2002) — an *upper* bound on Len in terms of Rop.

## 6. Lattice stick number (related)

Diao–Ernst: 3√(c(K) + 1) + 3 ≤ s_L(K) ([HNOR15] p. 4, quoted). Since Len ≥ s_L·1 trivially (each stick has length ≥ 1) and in fact each stick of a minimal polygon is short, this is a weak bound on Len. See [lattice-stick-number](../invariants/lattice-stick-number.md).

## Open problems

* Is there any family with Len(K) superlinear in c(K)? Upper bound O(c (ln c)^5) [DEPZ09], lower bound order c^{3/4} attained by links ([HKNO14], [HHKNO14], [HNOR15]). Unknown.
* Certify Len for anything beyond 5_1. Candidates with few canonical minimal polygons (8_3, 8_7: one canonical polygon each, [Scharein09] §5.5) may be the most tractable to attack by enumeration.
* Ropelength ≥ const · c for alternating links ([Diao22] Remark 3.3).
