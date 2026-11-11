# Minimal lattice knots confined to slabs

Slab S_L = Z² × {0, 1, …, L} (width L). n_{L,K} = minimal length of a polygon of type K inside S_L ([GJvRR12] p. 4–5). Trivially n_{1,K} ≥ n_{2,K} ≥ … ≥ n_K = Len(K), and n_{L,K} = Len(K) once L is large enough.

## What is proved

* **Trefoil in a 1-slab needs 26 edges** (> 24 unconfined): stated as proved analytically in [Ishihara12] (abstract only in this collection; the body of the technical report is not in `papers/`).
* Nothing else here is proved; all other values are search results (upper bounds on n_{L,K}, lower bounds on counts), [GJvRR12] p. 5: "not rigorous".

## Ergodicity caveat

BFACF irreducibility on fixed knot type holds in S_L for **L ≥ 2** ([GJvRR12] p. 5, citing Janse van Rensburg–Whittington). For L = 1 the authors generated polygons in S_2 and sieved those fitting in S_1 (biased sampling), and are "reasonably confident … in most cases" the lists are complete.

## Minimal lengths n_{L,K} — [GJvRR12] Table 5 (numerical)

Verified by the extractor against the page image. Bold = longer than at L + 1 (underlined in the source). Columns L ≥ 5 equal the L = 4 column for every knot listed and are omitted.

| K | L=1 | L=2 | L=3 | L≥4 |
|---|---|---|---|---|
| 0_1 | 4 | 4 | 4 | 4 |
| 3_1 | **26** | 24 | 24 | 24 |
| 4_1 | **36** | **32** | 30 | 30 |
| 5_1 | **38** | 34 | 34 | 34 |
| 5_2 | **42** | 36 | 36 | 36 |
| 6_1 | **48** | **42** | 40 | 40 |
| 6_2 | **48** | **42** | 40 | 40 |
| 6_3 | **50** | **44** | 40 | 40 |
| 7_1 | **50** | 44 | 44 | 44 |
| 7_2 | **54** | **48** | 46 | 46 |
| 7_3 | **54** | **48** | 44 | 44 |
| 7_4 | **54** | **46** | 44 | 44 |
| 7_5 | **56** | **48** | 46 | 46 |
| 7_6 | **56** | **48** | 46 | 46 |
| 7_7 | **56** | **50** | **46** | 44 |
| 8_1 | **60** | **52** | 50 | 50 |
| 8_2 | **60** | **54** | 50 | 50 |
| 8_3 | **60** | **52** | 48 | 48 |
| 8_4 | **60** | **52** | 50 | 50 |
| 8_5 | **60** | **56** | **52** | 50 |
| 8_6 | **62** | 52 | **52** | 50 |
| 8_7 | **62** | **54** | 48 | 48 |
| 8_8 | **62** | **54** | **52** | 50 |
| 8_9 | **62** | **54** | 50 | 50 |
| 8_10 | **62** | **56** | **52** | 50 |
| 8_11 | **62** | **54** | **52** | 50 |
| 8_12 | **64** | **56** | 52 | 52 |
| 8_13 | **64** | **54** | 50 | 50 |
| 8_14 | **64** | **54** | **52** | 50 |
| 8_15 | **62** | **56** | 52 | 52 |
| 8_16 | **66** | **56** | **52** | 50 |
| 8_17 | **68** | **58** | **54** | 52 |
| 8_18 | **70** | **60** | **56** | 52 |
| 8_19 | **48** | **44** | 42 | 42 |
| 8_20 | **52** | **46** | 44 | 44 |
| 8_21 | **54** | **48** | 46 | 46 |

(8_6: 62, 52, 52, 50 — the L=2 entry is not longer than L=3, so only L=1 and L=3 are bold.)

Observations from [GJvRR12]:
* n_{1,K} > Len(K) for every nontrivial knot listed, consistent with [Ishihara12] (prime knots ≤ 10 crossings, numerical).
* Agrees with [Ishihara12]'s 1-slab values except **8_18: 70 here vs 72 in [Ishihara12]** (improvement).
* Every knot ≤ 8 crossings reaches its unconfined minimum by L = 4; 8_18 is the slowest (70 → 60 → 56 → 52).
* The unconfined lengths in the L ≥ 4 column reproduce [JvRR11] Table 1 exactly.

Counts of minimal polygons per slab and their symmetry classes (with orientation-preserving symmetries of S_L) are in [GJvRR12] Tables 6–10 (`_extracts/GJvRR12.md`). Example: grafted minimal trefoils by height: 36 (h = 1, n = 26), 152 (h = 2), 1508 (h = 3), 4 (h = 4), total 1664 of one chirality at n = 24 for h ≥ 2.

## Squeezing models ([GJvRR12] §3–4)

Two toy thermodynamic models built from the minimal data (low-temperature, stiff-spring approximation; numerical):
1. Free energy F_L = k(n_{L,K} − Len(K))² − T log p^L(K); critical force f_L = F_{L−1} − F_L; total work W_K = Σ f_L. Trefoil: f_2 = 4k + T log(38/9), f_3 = T log(415/38), f_4 = T log(416/415), W = 4k + T log(416/9). Figure-eight: W = 36k + T log(456/185); f_3 < f_4 (forces not monotone in L).
2. Force ensemble Z*(f) = Σ_h p(h, K) e^{−k(n_{h,K} − Len)² − f h}; mean height and compressibility κ = −d log⟨h⟩/df show multiple peaks ("soft" and "hard" regimes). Unknot W = log 3.

Critical Hooke constants where elastic and entropic work are equal: k_c ≈ 0.958 T (3_1), 0.025 T (4_1), 0.240 T (5_1), 0.062 T (5_2), −0.015 T (6_1, negative because stretching to fit S_1 gains entropy).

## Related

* Confinement in the statistical sense (knot probabilities in slabs/tubes): [JvROT25], [JvROT26] — see [statmech/knot-probabilities](../statmech/knot-probabilities.md).
* Compressibility of minimal knots under other geometric constraints: [JvRR12comp] — see [compressibility](compressibility.md) (pending).
