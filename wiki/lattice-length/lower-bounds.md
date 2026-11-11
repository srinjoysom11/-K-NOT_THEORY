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

* α_K := lim Len(K^p)/p (exists by subadditivity) satisfies **α_K ≥ 4(b_K − 1)** in SC, b_K = bridge index ([JvRR11] eq. 10, quoting [JvRP95] and Janse van Rensburg 1996); ≥ 3(b − 1) in FCC and ≥ 2(b − 1) in BCC (argued in [JvRR11]). Since b − 1 is additive under #, this gives Len(K^p) ≥ 4p(b − 1) asymptotically. Known: 4 ≤ α_{3_1} ≤ 17 ([JvRR11] p. 6). (Full statement and proof in [JvRP95] — extract pending.)
* *My remark:* for a single prime knot the bridge argument yields Len(K) ≳ 4(b − 1), trivially weaker than 24 for all knots with b ≤ 7.

## 5. Via ropelength

Lattice polygons carry an embedded tube of radius 1/2, so **Rop(K) ≤ 2·Len(K)** in the length/radius convention ([HNOR15] p. 4, [HKNO14] §1). Any ropelength lower bound therefore gives Len(K) ≥ Rop(K)/2:

* Four-thirds law: ((4π/11)·c(K))^{3/4} ≤ Rop(K) as printed in [HNOR15] p. 5 (summarising Buck, Buck–Simon, Cantarella–Kusner–Sullivan), power 3/4 optimal (attained by the (p,q)-Hopf link families of [HNOR15] Thm 2). ⇒ Len(K) ≥ ½((4π/11)c)^{3/4}.
* [Diao19] quotes Rop ≥ 31.32 for any nontrivial knot and Rop ≥ 1.105 c^{3/4}; convention not stated there (see [00-notation](../00-notation.md#ropelength-radius-vs-diameter)) — do not divide by 2 until the convention is confirmed against [CKS01]/[DDS04] (extracts pending; see [ropelength/](../ropelength/README.md)).
* Conversely [Diao19] uses L_c(K) < 14·Rop(K) (from Diao–Ernst–Janse van Rensburg 2002) — an *upper* bound on Len in terms of Rop.

## 6. Lattice stick number (related)

Diao–Ernst: 3√(c(K) + 1) + 3 ≤ s_L(K) ([HNOR15] p. 4, quoted). Since Len ≥ s_L·1 trivially (each stick has length ≥ 1) and in fact each stick of a minimal polygon is short, this is a weak bound on Len. See [lattice-stick-number](../invariants/lattice-stick-number.md).

## Open problems

* Is there any family with Len(K) superlinear in c(K)? Upper bound O(c (ln c)^5) [DEPZ09], lower bound order c^{3/4} attained by links ([HKNO14], [HHKNO14], [HNOR15]). Unknown.
* Certify Len for anything beyond 5_1. Candidates with few canonical minimal polygons (8_3, 8_7: one canonical polygon each, [Scharein09] §5.5) may be the most tractable to attack by enumeration.
* Ropelength ≥ const · c for alternating links ([Diao22] Remark 3.3).
