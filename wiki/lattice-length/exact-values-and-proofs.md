# Exact minimal lattice lengths and how they were proved (SC lattice)

Terminology: *minimal knotting number* n_0 [Diao93], *minimal edge number* M(K) [JvRP95], *minimum step number* [Scharein09], *minimum lattice length* Len(K) [HKNO14] — all the same invariant (see [notation](../00-notation.md)).

## What is actually proved

| statement | status | source |
|---|---|---|
| Any SC polygon with < 24 edges is unknotted (n_0 = 24) | **proved** | [Diao93] Theorem |
| A knotted 24-step polygon is a trefoil | proof sketched ("the same argument… G_16 of mP(24)") in [Diao93] end of §4; carried out in [Diao94] | [Diao93], [Diao94] Theorem |
| Number of unrooted knotted 24-gons = 3496 (rooted 83 904) | **claimed proved in [Diao94], but wrong**: [Scharein09] §5.1 finds some polygons double-counted and 27 canonical polygons omitted; corrected value **3328 = 2 × 1664** (numerical enumeration, 75 canonical polygons) | [Diao94]; [Scharein09] §5.1, Table 1; confirmed numerically by [JvRR11] Table 3 |
| Len(4_1) = 30, Len(5_1) = 34 | **proof outlined** in [Scharein09] Thm 2; full proofs deferred there to two papers of Ishihara–Shimokawa et al. "to be reported elsewhere" ([16, 17] in that paper) — not in this collection | [Scharein09] Thm 2 |
| Every K ≠ 3_1, 0_1 has Len(K) > 24 | corollary of Diao | [JvRP95] Thm 9 |
| Trefoil confined to a 1-slab needs 26 | proved | [Ishihara12] (abstract only here) — see [confinement](confinement-slabs.md) |
| Everything else in the ≤10-crossing table | **upper bounds only** | [Scharein09] §1, §5 |

The resolution of the 3496 vs 3328 question raised in `READING_LIST.md` §7 item 2 is therefore: it is **not** a convention difference — [Scharein09] states that [Diao94]'s enumeration both over- and under-counted, and that "the total number … should be 3328, not 3496".

## Diao's proof that n_0 = 24 ([Diao93])

Figure pages: [p3](../figures/Diao93/p03.png) (24-step trefoil, Fig. 1), [p4](../figures/Diao93/p04.png) (moves and forbidden configurations, Figs. 2–4), [p7](../figures/Diao93/p07.png) (outer loop shapes, Fig. 9).

Setup ([Diao93] §2–3):
* a, b, c = numbers of x-, y-, z-steps of a polygon P(22); a+b+c = 22 ⇒ the two smallest sum to ≤ 14. Project along the third axis: the **projection graph** G is a weighted graph on the square lattice, edge weight = *multiplicity* (number of steps projecting to it), total multiplicity M(G) = a+b ≤ 14. Every G-vertex has even multiplicity.
* **l-equivalent** = same length and same knot type. **Reducible** = a shorter polygon of the same knot type exists. If 22 were minimal, every knotted P(22) would be irreducible.
* Choose mP(22): a knotted P(22) whose projection mG_14 has the **maximum number of loops** (generators of π_1 of the planar graph) among all l-equivalent polygons.
* **1-path**: path whose projection uses only single edges. **Branch B(k)**: simple path in G of length k from a degree-1 vertex to a vertex of degree 3 or 4.
* Two length- and type-preserving moves on 1-paths: the **square move** (flip a path across an empty unit square of the projection) and the **rotation** (swing a B(1) to another free position). Maximality of loops ⇒ no move on mP(22) may create a new loop.
* A list of local weighted configurations (Fig. 3 a–f′) is impossible in mG_14 because the polygon above them is reducible or a square move would add a loop; B(k), k ≥ 3 cannot occur, and a B(2) forces ≥ 12 steps.

Lemmas ([Diao93] §4), each eliminating a class of mG_14:
1. mG_14 is not two loop-containing parts joined at a single vertex (else mP(22) is a connected sum of shorter polygons, one knotted — or M(G) ≥ 16). ⇒ every loop shares an edge with another loop.
2. mG_14 is not a tree.
3. There is an outer loop of length p bounding all others; mG_14 has ≤ 4 loops (p ∈ {4,…,14}; enumeration of outer shapes, Fig. 9).
4. Not 4 loops: the unique candidate needs ≥ 12 z-steps to realise the 3 crossings but only 8 are available (height bookkeeping α, β, γ, … on the steps).
5. Not exactly 3 loops. 6. Not exactly 2 loops. 7. Not a single loop (a loop without branches lies on a cylinder ⇒ unknotted).

Hence mG_14 is empty, so no knotted P(22); "the same argument applies to any number less than 22". Several sub-cases are explicitly "left to the reader".

**Reusable ingredients** for other exact-value proofs: projection along the most-used axis (M ≤ ⌊2n/3⌋), parity of vertex multiplicities, counting z-steps needed to realise crossings, reducibility patterns, and extremal choice (max loops) to kill square moves.

## Enumeration of 24-step trefoils ([Diao94], corrected by [Scharein09])

* [Diao94]: minimal projection number m ≤ 16; outer loop Δ(p) with p ≤ 12; 25 shapes of Δ(12) of which one survives; survivors for p = 10, 8, 6 give **13 minimal projection graphs** ([Diao94] Fig. 7 a–m, [figure page](../figures/Diao94/p05.png)); counts per graph 9, 9, 63, 31, 5, 39, 21, 18, 13, 6, 6, 6, 6 with symmetry multipliers 48, 8, 16: 48·(9+9) + 8·(63+31+5) + 16·(39+21+18+13+6+6+6+6) = 3496.
* [Scharein09] §5.1: BFACF search finds **75 canonical polygons** (classes under translations, rotations, reflections, ignoring orientation) in **3 type-0 equivalence classes** of sizes 18, 56, 1; polygon 3-1 is *taut* (admits no length-preserving BFACF move). 75 × 24 = 1800 rotations → 1664 distinct after removing symmetric duplicates → ×2 chiralities = **3328**. The 27 canonical polygons missing from [Diao94] are listed in [Scharein09] Table 1. All 75 standard-form words: [data/scharein2009_tableA3_trefoil_24_canonical.csv](../data/scharein2009_tableA3_trefoil_24_canonical.csv).
* [JvRR11] counts 142 symmetry classes for the same 3328 polygons (137 of size 24, 5 of size 8) under the rotation/reflection action it uses; 142 vs 75 differ by whether mirror images are identified (75 × 2 = 150 chirality-separated classes would be expected with no extra symmetry; reconcile before quoting either number — *my remark, not from the sources*).

* **4_1 and 5_1 counts.** [Scharein09] §5.2–5.3: 76 canonical polygons for 4_1 and 142 for 5_1, giving 1824 minimal 4_1 polygons and 6672 minimal 5_1 polygons up to translation. [JvRR11] Table 3 gives P_{4_1} = **3648** (152 classes of 24) and P_{5_1} = 6672. The two sources disagree by a factor 2 for the achiral 4_1: [Scharein09] doubles only chiral knots, having already merged mirror images into its canonical classes, so for an achiral knot whose minimal polygons are not individually mirror-symmetric its procedure would undercount by 2 (*my reading; unresolved — enumerate to settle*).

## The Scharein–Ishihara–Arsuaga–Diao–Shimokawa–Vazquez refinement ([Scharein09] §3)

"Minimum Step Algorithm" (their summary of Diao's method): (1) enumerate weighted planar graphs on Z² with total multiplicity ≤ 2n/3; (2) for each, all knot diagrams projecting to it; (3) all lattice realisations with ≤ n steps, determine knot type. Improvements:

* **Prop. 2 (bounding box).** An irreducible n-step polygon of nontrivial prime type lies in a box (k/2 + 1) × (l/2 + 1) × ((n − 2(k+l))/4 + 1) with 2 ≤ k ≤ n/6, k ≤ l ≤ (n−2k)/4, where 2k, 2l are the numbers of x- and y-steps (s_x ≤ s_y ≤ s_z). Key step: each lattice plane between two occupied levels is crossed by ≥ 4 edges (else composite or reducible), so the diameter D_i ≤ s_i/4 + 1. **Prop. 1**: the projection lies in a (k/2+1) × ((n−2k)/8 + 1) rectangle.
* **Prop. 3 (reducibility test).** If an edge e = v_1v_2 of G has 2m(e) ≥ m(v_1) and 2m(e) > m(v_2), K is reducible.
* **Prop. 4 (crossing bound from the projection).** c(K) ≤ Σ_v T(m(v)/2) − Σ_e T(m(e)) + 3(f − 1), T(x) = (x−2)(x−3)/2, f = number of faces of G. (Proofs of Props 3–4 deferred to their ref. [17].)
* Outline for 4_1: irreducible nontrivial polygon with n = 26 or 28 ⇒ projection of multiplicity ≤ 18 inside a 2×4 or 3×3 rectangle with ≤ 6 faces ⇒ finite check shows only unknot/trefoil. 5_1 "follows the same steps but the calculations are more involved".

(Formulas above checked against the page images [figures/Scharein09/p05.png](../figures/Scharein09/p05.png) and [p06.png](../figures/Scharein09/p06.png) on 11 Nov 2026: all inequality directions and bounds agree with the printed text.)

## Structural results on the minimal edge number ([JvRP95])

M(K) = minimal edge number; K^n = n-fold connected sum.

* **Lemma 1 (subadditivity).** M(K_1#K_2) ≤ M(K_1) + M(K_2) (concatenation of polygons, Fig. 1).
* **Lemma 2.** M(K_1#K_2) ≥ α_{K_1} + α_{K_2}, M(K^n) ≥ n·α_K with **α_K = 4(b(K) − 1)**, b = bridge index. Proof: total curvature of a lattice polygon comes in units of π/2, so #edges ≥ 2·C(P)/π ≥ 2c(K)/π = 4b(K), where c(K) = 2π·b(K) is the infimal total curvature (Milnor); b − 1 is additive.
* **Thm 3 (minimal edge index).** μ_K = lim M(K^n)/n exists; M(K^n) ≥ nμ_K; μ_K > 0 iff K nontrivial.
* **Thm 4 / Def. 5.** M(K) − 4 is a *weak measure of knot complexity*.
* **Thm 6.** μ_K = 0 ⇔ K trivial; μ_{K^n} = nμ_K; μ_{K_1#K_2} ≤ μ_{K_1} + μ_{K_2}; μ_{K_1^n # K_2} ≥ A n + B with A, B > 4 for nontrivial knots. **Conjecture 7:** μ_{K_1#K_2} = μ_{K_1} + μ_{K_2}.
* **Thm 10 / Cor. 11.** Q(n) = #{knot types with M(K) ≤ n} satisfies lim (log Q(n))/n = log Q; Q(n) ≤ Q^n; the number of knot types with M(K) = n grows exponentially. From their Table I, Q ≥ 1.073.
* **Thm 13 (tight knots).** If a *tight knot* ω (knotted ball-pair in the dual-cube neighbourhood of a walk) of type K has the Kesten property (three copies concatenate into a tight knot), then μ_K ≤ |ω|. A 17-edge tight trefoil ([JvRP95] Fig. 4) gives **μ_{3_1} ≤ 17**.
* **Thm 14.** M(K) ≥ 2c_p(K)/π ≥ 10 and μ_K ≥ lim inf 2c_p(K^n)/(πn) ≥ 4 for nontrivial K, where c_p = minimum curvature attainable by a lattice polygon of type K.
* Crude lower bound noted in passing: a polygon with M edges has at most M(M−3)/2 crossings in a projection, so M ≳ √(2C) (C = crossing number).
* T(2, 2k+1) construction: repeating the twist unit of [JvRP95] Fig. 3 costs 10 edges per twist plus 2 more every eighth repetition ⇒ **lim sup M(T_{2,2k+1})/k ≤ 10.25** (so the +10 pattern 24, 34, 44, 54 need not persist exactly).

### [JvRP95] Table I — M(K) estimated by simulated annealing (BFACF, β from ≈0.21 down in steps of 0.01, 10⁶ attempted moves per step, 3 repeats)

| M | knots |
|---|---|
| 4 | 0_1 |
| 24 | 3_1 |
| 30 | 4_1 |
| 34 | 5_1 |
| 36 | 5_2 |
| 40 | 6_1, 6_2, 6_3, 3_1^-#3_1^-, 3_1^+#3_1^- |
| 42 | 8_19 |
| 44 | 7_1, 7_3, 7_7 |
| 46 | 7_2, 7_4, 7_5, 7_6, 8_20, 8_21, 3_1#4_1 |
| 48 | 8_7, 9_42 |
| 50 | 8_1, 8_2, 8_4, 8_5, 8_6, 8_9, 8_13, 9_47, 10_161 |
| 52 | 8_3, 8_8, 8_10, 8_11, 8_15, 8_16, 8_17, 8_18 |
| 54 | 8_12, 8_14, 9_1 |
| 56 | 9_2, 3_1^-#3_1^-#3_1^- |
| 60 | 10_1 |

Later improvements over this table: 7_4 → 44, 8_20 → 44 (46 "reported in [15]" of [Scharein09]), 8_3 → 48, 8_8, 8_10, 8_11, 8_14 → 50, 8_16 → 50, 8_12 → 52 ([Scharein09] §5.4 and Table A1; [JvRR11] Table 1).

### [JvRP95] Table II — M(3_1^n) by simulated annealing

| n | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
|---|---|---|---|---|---|---|---|---|---|---|
| M(3_1^n) | 24 | 40 | 56 | 74 | 90 | 110 | 124 | 140 | 158 | 174 |

Linear fit M(3_1^n) ≈ 16.8n + 6.8. **Superseded for n = 4, 5, 6 by [JvRR11] (72, 88, 104)**, i.e. the annealing runs of 1995 had not reached the minimum; values for n = 7…10 have not been revisited in this collection and are upper bounds only. The authors expect "knots made of knots" to beat linear chains of tight trefoils eventually.
