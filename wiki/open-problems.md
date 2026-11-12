# Open problems

Collected from the "stated limitations / open problems" of every extract, grouped by theme. Each item says who raised it. Items marked *my remark* are the wiki author's suggestions of where progress looks reachable for this project.

## A. Minimal lattice length Len(K)

1. **Certify Len beyond 5_1.** Only 3_1 = 24 [Diao93], 4_1 = 30 and 5_1 = 34 [Scharein09] are proved; everything else is an upper bound. [Scharein09] p. 13: enumeration methods will not scale to knots with many realisations ("such as the 5_2 knot, which has 2362 canonical lattice polygons. More powerful analytical results will be needed"). *My remark:* knots with very few canonical minimal polygons — 8_3 and 8_7 (one each), 9_31, 10_72, 10_123 ([Scharein09] §5.5) — and the "tight" knots with low entropy per edge ([JvRR11]: 8_3, 8_7, 8_16) are the natural next targets for a computer-assisted proof.
2. **Is the Diao enumeration's case analysis complete?** [Diao93] and [Diao94] leave several cases "to the reader"; [Scharein09] showed [Diao94]'s count was wrong (3496 → 3328). An independent machine verification of Len(3_1) = 24 and of the 3328 count would be valuable ([exact-values-and-proofs](lattice-length/exact-values-and-proofs.md)).
3. **Do the arithmetic patterns persist?** Steps of 10 along T(2, N) and twist-knot families in SC; 24 + 16(n − 1) for (3_1)^n and 30 + 22(n − 1) for (4_1)^n ([JvRR11] p. 13–14, "no proofs"); [JvRP95] p. 13 asks whether infinite arithmetic subsequences exist. The FCC/BCC patterns already break by 9 crossings.
4. **Minimal edge index.** 4 ≤ μ_{3_1} ≤ 17 ([JvRP95] Thm 13); data suggest 16. Additivity μ_{K_1#K_2} = μ_{K_1} + μ_{K_2} ([JvRP95] Conj. 7, "seems hard to prove").
5. **Entropic index** γ_K > 0 for all nontrivial K ([JvRR11] p. 6).
6. **Tables beyond 10 crossings.** No minimal-length table exists for ≥ 11 crossings ([READING_LIST.md](../READING_LIST.md) §0); [JvRR11] has only 11_1, 11_2, 12_1, 12_2.
7. **Other lattices.** Figure-eight minimal length in FCC (conjectured 20) and SC (30, now proved) ([MannML] Open Q. 2); trefoil in hexagonal-prism and other Voronoi-cell lattices (Open Q. 3); cube-knot ratio M_K/m_K = 2.5 in FCC ([MannML] Conj. 1).
8. **Pearl necklaces:** does a 14-sphere trefoil exist? Does N_L − N_P stay at 1–2 or grow? ([Klotz26pearl] p. 3).

## B. Bounds in terms of crossing number

9. **Superlinear growth?** Is there any family with Len or Rop growing faster than c? Known: O(c ln⁵ c) above ([DEPZ09]), order c^{3/4} attained below. Raised in [CKS01] p. 23, [DEPZ09] p. 2, [HHKNO14], [HNOR15]. [CKS01] suspects tree-of-meshes-type links need lattice number ≥ c log c; an O(c (log c)²) upper bound might follow from VLSI layout methods. [DEPZ09] Questions 9.2–9.4; its constant is not computed.
10. **Alternating links:** Rop ≥ const·c is proved for alternating *knots* ([Diao22]) but open for alternating *links* (Remark 3.3).
11. **Sharper universal constants.** The C^{3/4} prefactor: proved 1.105, unverified LLM-assisted 2.0996 ([Klotz26llm]; needs interval-arithmetic certification and precise hypotheses, p. 17), upper estimates 12.6–12.7 from 10_124 and 12n725 ([KA23], [KM21]). Absolute constant: 31.32 proved ([DDS04]) vs ≈ 32.7 for the tight trefoil; [CKS01] Conj. 25–26 would give 23.45, 30.51.
12. Does any knot have ropelength < 24 R-units? ([CKS01] p. 2) — answered no by Diao 2003 and [DDS04] (≥ 31.32); kept here because [CKS01] lists it.
13. **Composite links:** whether linking-number bounds are ever sharp for n > 1 ([CKS01]); relation between asymptotic crossing number and Milnor invariants ([KM16] p. 2).

## C. Stick numbers

14. All links with s_L = 15 ([HNO14links] p. 8: "future work"); s_L(6^2_1) undetermined ([Adams12]).
15. Stick number of T(P, 2): conjectured ⌊2(P + 1)/3⌋ + 4 (numerically attained for P ≤ 31), unproved ([Klotz26llm] §3.6).
16. Minimum-stick and minimum-length polygons differ ([Scharein09] p. 12); [Adams12]'s proved values beat [Scharein09]'s search for 8_19, 8_21, 9_46 — *my remark:* a dedicated stick-number search (not seeded from minimal-length polygons) is needed.

## D. Algorithms

17. **Which BFACF-style moves are necessary?** For BCC all four move classes were used in the irreducibility proof; "it is not clear that any of these are necessary" ([JvRR10bfacf] p. 22). Irreducibility for fixed-endpoint walks in BCC/FCC uninvestigated (p. 23). Irreducibility in pores/channels unknown ([GJvRR12] p. 25); in S_1 (1-slab) not proved.
18. What moves make BFACF ergodic on all polygons in 3D (crankshaft, per Brower), and ergodicity in ≥ 4 dimensions ([JvRW91] p. 15).
19. **Excursion depth and frozen states:** minimal polygons are disconnected under neutral moves; connecting them needs +2 (4_1) or +4 (6_3) edges ([Ozawa26merge]). Frozen (no neutral or shortening move) unknots and trefoils exist at lengths 64m and 64m + 24, so capped BFACF graphs never become connected for these knots. Open ([Ozawa26merge] Problems 13.1–13.4, 13.8): eventual connectivity for other knots; unbounded escape excess; lattice "Gordian" configurations for other knot types; distribution of mirror barriers; dependence on move system and lattice (13.11–13.13). *My remark:* directly relevant to designing complete searches.
20. Why does ReAPR work, and does a weakly decreasing sequence of pass moves always exist? ([CSS26]).

## E. Statistics of knotting

21. μ_K = μ_{0_1} for all K? ([JvRR11], [JvROT26]: data cannot decide.) Exponents α_K = α + N_K unproven.
22. Why do FCC and BCC amplitude-ratio curves agree while SC stands apart? ([JvRR11univ] p. 7). Are lattice and off-lattice models in the same universality class?
23. In confinement: is R(3_1^+/0_1) < 1 and universal? Does the unknot stay dominant as L grows? ([JvROT25]); is x_K = x_{0_1}, and does the knotted arc delocalise near the transition? ([JvROT26]).
24. Additivity of crossing number and unknotting number under # ([SSW92] Conj. 3.4, 3.6); RL search over millions of connected sums found no counterexample to unknotting-number additivity ([Applebaum24]).

## F. ML

25. Do knot-recognition networks learn topology or memorise geometry? ([Vandans20], [BKBO22]); RL success has been measured only on unknots ([GHRS20] p. 33).
26. Jones unknot conjecture: no counterexample among several 100k generated knots ([HR25]).
