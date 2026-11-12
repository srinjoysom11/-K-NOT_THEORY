# Ropelength upper bounds (in terms of crossing number c)

**R-units** (length / tube radius) throughout, as on [lower-bounds](lower-bounds.md); every source on this page states the radius convention. A lattice polygon gives **Rop ≤ 2·Len** ([CKS01] p. 23, [HNOR15] p. 4), and rounding lattice corners by quarter circles gives the sharper Rop ≤ 2·Len − (2 − π/2)·#corners ([HKNO14] §4). So every lattice-length construction in [lattice-length/upper-bounds-crossing-number](../lattice-length/upper-bounds-crossing-number.md) is also a ropelength bound.

## General knots and links

| bound | applies to | source, status |
|---|---|---|
| ((4π/11)c)^{3/4} ≤ Rop ≤ 2·Len ≤ 24c² | any link | [CKS01] Thm 23 (lattice number < 12c² via Schnyder grid embedding of the diagram); proved |
| Rop < 25c² | any link | Johnston (quoted in [CFM02] p. 1) |
| **Rop ≤ 1.64c² + 7.69c + 6.74** | non-split links (so all prime links) | [CFM02] Thm 1; proved. From arc presentations: Rop ≤ 2α/tan(π/α) + (π − 2)α + 2·Skip (Prop 1), Skip ≤ (α² − 1)/2 or α²/2 (Prop 2, sharp), α ≤ c + 2 (Bae–Park) |
| Rop ≤ 1.64Σc(L_i)² + 7.69Σc(L_i) + 6.74n | non-split composite with prime factors L_i | [CFM02] Thm 2 |
| Rop ≤ min{1.5c² + 9.15c + 6.79, 1.25c² + 14.58c + 16.90} | knots | [HKNO14] (via Len ≤ ¾c² + 5c + 17/4 and ⅝c² + 7.5c + 71/8 with corner rounding) |
| Rop ≤ 272c^{3/2} + 168c + 44c^{1/2} + 22 | any | Diao–Ernst–Yu (quoted in [HHKNO14]) |
| **Rop = O(c ln⁵ c)** | any knot or link | **[DEPZ09] Thm 8.3**: every 4-regular plane graph with n vertices embeds in Z³ (topology preserved) in a box of volume O(n ln⁵ n). Proved; **no explicit constant** is given. |

How [DEPZ09] works: triangulate the diagram (max degree ≤ 12, Lemma 4.8), recursively split it with Miller's cycle separators of size O(√n) into balanced halves (depth O(ln n), Thm 4.6), embed the pieces "grid-like" in boxes and reconnect them; each reconnection costs O(√n ln n) new grid lines and the number of turns grows by an additive constant per level (Thm 8.2), giving the ln⁵ factor. [KM21] p. 3 notes that the Hopf link forces the unstated constant to be ≥ 4π/ln⁵2 ≈ 78.5 (⚠ printed there as 8π/ln⁵2), so the bound is far above measured values for small knots.

Open ([DEPZ09] p. 2, [HHKNO14], [HNOR15]): is Rop = O(c) for all knots? No superlinear family is known.

## Families with linear (or better) bounds

| family | bound | source |
|---|---|---|
| 2-bridge knots and links | Rop ≤ 11.39c + 12.37 (c ≥ 6); ≤ 2h(√(π²+4)+1)c + 4π + 14h for h ≥ 1.205 | [HHKNO14] Thm 3, Prop 2 |
| Conway algebraic knots | O(c) | Diao–Ernst–Ziegler (quoted in [HHKNO14], [DEPZ09]) |
| T(P, 2) torus knots/links | ≈ 7.31–7.36 per crossing (best: Kim et al. 7.32; Klotz–Maldonado 7.36) | quoted in [KT25] p. 1; [KM21] |
| simple chains of k rings | exactly (4π + 4)k − 8 (tight) | [CKS01] Fig. 1 |
| (p, q)-Hopf links H_{p², q²} | Rop ≤ 20p²⌈q²/p⌉ + 12p³ (gives every growth exponent in [3/4, 1]) | [HNOR15] Thm 2 |

## Sublinear constructions (non-alternating torus knots and links)

| construction | bound | source, status |
|---|---|---|
| concentric helices → non-alternating T(·, Q) torus knots | ≈ **7.83 Q^{3/2}** (Q = number of helices = minor index); prefactor "exact", a 75% reduction from earlier work | [KT25] abstract, numerical optimisation + explicit construction |
| extended into T(3Q, Q) links | ≈ 12 c^{3/4} | [KT25] |
| T(Q, Q) links, parameter-free construction | α_TQQ < 1.005·4π(5√5 − 8)/3 ≈ **13.39** (large Q); ≈ 11.68 using a conjectural helix no-overlap approximation | [Klotz26tqq] abstract |
| T(Q, Q) for Q ≤ 20 (optimised, annealed) | within 6–60% of the lower bound; many annealed to within 10% | [Klotz26tqq] |
| Diao–Ernst lattice torus knots | C^{3/4} with coefficient between 20 and 32 | quoted in [KT25] p. 1 |

Here α = Rop / c^{3/4}. Matching lower bounds for these families: [Klotz26tqq] proves α_TQQ > √(8π√3) + (2π + √(2π(7√3 − 12)))Q^{−1/2} ≈ 6.60 + 7.61 Q^{−1/2} from Wegner's disk-packing hull bound (⚠ the extractor evaluates the second coefficient as ≈ 7.17), so for T(Q, Q) the upper and lower bounds are within a factor ≈ 1.77. [KT25] narrows the upper-to-lower ratio for non-alternating torus knots from 29 to between 1.4 and 3.8.

Correction to note: [KM21] eq. 6 estimated packed Hopf tori at 8.65 c^{3/4}; [KT25] Appendix states the correct limit is 8√(π/2)·6^{1/4} ≈ 15.7 c^{3/4} ("a factor-of-two error and a minor algebraic error").

## LLM-assisted claims (unverified)

[Klotz26llm] (written largely by an LLM, flagged by its author as not fully checked) gives an explicit general torus-knot upper bound L(P, Q) ≤ 2π√(2P² + 2PQ + (3/2)Q²) and optimised standard parameterisations; status "LLM-claimed-unverified", "not claims of global ropelength minimization". It also reports failing to improve the [DEPZ09] constant.
