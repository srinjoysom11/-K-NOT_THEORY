# Lattice stick number s_L(K) and its relation to arc index and length

s_L(K) = least number of maximal straight segments ("sticks") of a lattice polygon of type K in Z³ ([HNO12stick] p. 1; [Adams12] Def. 2 calls it the *lattice stick index* s_CL[K]). #sticks = #corners. Not to be confused with the off-lattice stick number s(K) ≤ s_L(K).

Relation to length: a stick has length ≥ 1, so s_L(K) ≤ Len(K); minimal-length and minimal-stick polygons are generally different ([Scharein09] §5.6: "There exist minimum stick representatives of a knot that do not correspond to canonical polygons (of minimum step)").

## Exact values (proved)

| K | s_L | source |
|---|---|---|
| unknot | 4 | trivial |
| 3_1 | 12 | Diao 1993 (via [Adams12] p. 2, [HNO12stick] p. 1) |
| 4_1 | 14 | Huh–Oh 2005; **s_L = 14 iff K = 4_1** [HO15] Thm 1 |
| 8_20, 8_21, 9_46 | 18 | [Adams12] Thm 2.2 (3-bridge, so 6b = 18 is attained) |
| T(p, p+1) | 6p (p ≥ 2): 3_1 = 12, 8_19 = T(3,4) = 18, T(4,5) = 24 … | [Adams12] Thm 2.3 |
| 9_47 | 18 | attributed to Promislow–Janse van Rensburg in [Adams12] p. 2 (⚠ as printed) |
| composites K_1#…#K_n of knots with s_L = 6b and suitable "clean/exterior L" | Σ s_L(K_i) − 6(n − 1) | [Adams12] Thm 3.1, Cor 3.2 |
| certain satellites of J differing from J_n by one permutation braid word | 6n·b(J) | [Adams12] Prop 4.1, Cor 4.2 |

Everything else s_L ≥ 15 ([HO15] Cor 2: s_L ≥ 15 for all nontrivial K except 3_1, 4_1).

*Cross-check (my remark):* [Scharein09] Table A2 numerical upper bounds are 19 for 8_19, 18 for 8_20, 19 for 8_21, 20 for 9_46 (after subtracting the superscript improvements; CSV `data/scharein2009_tableA2_lattice_stick.csv`). [Adams12]'s proved value 18 beats the search for 8_19, 8_21 and 9_46 — evidence that BFACF stick searches started from minimal-*length* polygons are not reliable for s_L.

## General bounds

**Lower bounds**
* s_L(K) ≥ 6·b(K), b = bridge index ([Adams12] Lemma 2.1; also Promislow–JvR): each direction needs ≥ 2b sticks.
* s_L(K) ≥ 3√(c(K) + 2) ([Adams12] Thm 5.1; via c ≤ |P_x||P_y| − 2 in a properly leveled projection).
* 3√(c(K) + 1) + 3 ≤ s_L(K) (Diao–Ernst, quoted in [HNOR15] p. 4).
* Off-lattice: (5 + √(8c + 9))/2 ≤ s(K) ≤ s_L(K) (Negami; [HNO12stick] writes it (5 + √(25 + 8(c − 2)))/2, the same).

**Upper bounds**
* s_L(K) ≤ 3a(K) − 2 (a = arc index) for nontrivial K ([HNO12stick] Thm 4); ≤ 3a(K) − 4 from any non-star-shaped arc presentation (Lemma 5); star-shaped presentations are (n+1, n)-torus knots or give 3a − 4 (Lemma 6).
* With Bae–Park a ≤ c + 2 and Jin–Park a ≤ c for non-alternating prime: **s_L(K) ≤ 3c(K) + 2** for nontrivial K ≠ 3_1, and **≤ 3c(K) − 4** for non-alternating prime K ([HNO12stick] Thm 1). (n+1, n)-torus knots, n ≥ 3: ≤ 3c − 5 (Lemma 7).
* Earlier: s_L ≤ 6a − 16 (≥ 7 pages) and s_L ≤ 6c − 4 ([Adams12] Lemma 5.2, Cor 5.3) — superseded.
* Off-lattice: s(K) ≤ (3/2)(c + 1), and ≤ (3/2)c for non-alternating prime (Huh–Oh 2011, quoted).

So s_L and s are Θ between c^{1/2} and c; [HNOR15] Thm 1 shows every exponent r ∈ [1/2, 1] is realised by a family of prime links ((p, q)-Hopf links H_{k^m, k^n}, with s = 3(k^m + k^n), s_L = 4(k^m + k^n)).

## Off-lattice stick number s(K) — computational state of the art ([CRSS25])

Simulated annealing with knot-type-preserving moves (BFACF on the lattice to shrink, then off-lattice polygon moves) gives upper bounds on s(K) for **all 12 965 knots through 13 crossings** (improving 12 160 of them), verified by Jones/Alexander polynomial checks.
* Exact new values (Thm 1): s = 10 for 19 knots (11n71, 11n75, 11n76, 11n78; 13n225, 13n230, 13n285, 13n288, 13n307, 13n584, 13n586, 13n593, 13n602, 13n603, 13n604, 13n607, 13n608, 13n1192, 13n5018), since they are 4-bridge and b < superbridge ≤ s/2 forces s ≥ 10.
* Asymptotics (Thm 2): α√c ≤ s ≤ βc for large c, with the optimal constants α_* ∈ [√2, 2] and β_* ∈ [2/3, 3/2].
* **Conjecture 3:** s(K) ≤ c(K) for every knot with c ≥ 12 (verified for all 12- and 13-crossing knots).
* T(q, 2): the ⌊2(q + 1)/3⌋ + 4 construction was matched but never beaten for q ≤ 31 (suggests optimal); 9_29 has equilateral stick number 9 (Thm 4).

## Arc index (the bridge to length bounds)

a(K) = least number of pages of an arc presentation (open book with half-plane pages, one arc per page). Equals the grid index ([HKNO14] §2). Bae–Park: a(K) ≤ c(K) + 2; non-alternating prime: a ≤ c + 1 (Bae–Park) and a ≤ c (Jin–Park). The arc-presentation → lattice construction ("lattice arc presentation": binding axis on y = x, each arc = one x-stick + one y-stick at height = page number) underlies [HNO12stick], [HNO14len], [HKNO14] and the ropelength bound [CFM02]. [JL11]: alternating knots have a(K) = c(K) + 2 exactly (Morton–Beltrami lower bound a ≥ spread of the Kauffman polynomial + 2), and a prime link is non-alternating iff a ≤ c (Jin–Park). JL11 gives diagrammatic conditions (nonalternating triangular faces, Thms 4.9–4.11) forcing **a(K) < c(K)**, and minimal grid diagrams of some 13- and 14-crossing non-alternating knots with a = c − 1. *My remark:* every unit saved in a(K) saves 3 sticks in the [HNO12stick] construction and shrinks the arc-presentation lattice constructions behind the length bounds.

## Links

[Adams12] Thm 6.1 (Table 1): s_L of 0^2_1 (unlink) = 8, Hopf 2^2_1 = 8, 7^2_7 = 16, 8^2_15 = 18, 8^2_16 = 18, 6^3_2 = 12, 6^3_3 = 12; 4^2_1 = 13 (Thm 6.5). [HNO14links] Thm 1: the only links with s_L ≤ 14 are 2^2_1 (8), 2^2_1#2^2_1, 6^3_2, 6^3_3 (12), 4^2_1 (13), 5^2_1 (14). Rational p/q links with 4 z-sticks: s_L ≤ 2p + 6 (2p + 5 for two components) ([KN18]). Full table and the lifting criterion for lattice diagrams ([AB18], [NPP18]): [links/](../links/README.md).

## Spatial graphs

s_L(G) ≤ 3c(G) + 6e − 4v − 2s + 3b + k ([YLO18] Thm 1) — see [links/](../links/README.md#spatial-graphs).
