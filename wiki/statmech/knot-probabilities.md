# Knot probabilities in long lattice polygons

How often each knot type occurs among random lattice polygons of length n, and the "crossover lengths" at which knotted types overtake simpler ones. Background for why minimal polygons are rare and why compound knots dominate long chains.

## Scaling ansatz (numerical, not proved)

p_n(K) ≃ C_K · n^{α − 3 + N_K} · μ_0^n  as n → ∞ ([JvRRgas] eq. 2.7, [JvRR11univ] eq. 1, [JvRR11] eq. 4)

* μ_0 = growth constant of unknotted polygons, believed the same for every knot type; μ_0 < μ (pattern theorem — Sumners–Whittington 1988, quoted).
* α = entropic exponent of polygons, believed knot-independent; N_K = number of prime summands of K.
* C_K = amplitude, depends on K and the lattice.
* Rigorous status ([JvRR11univ] p. 2): "the exponential growth rate is only known to exist when K is the unknot"; only lim sup p_n(K)^{1/n} = μ_K with μ_0 ≤ μ_K < μ is proved.

Known constants (quoted in [JvRRgas] §1): SC μ = 4.684044(11), α ≈ 0.24 (ε-expansion 0.237 ± 0.002); square lattice μ = 2.63815853034(10), α = 1/2.

Supermultiplicativity from concatenation ([JvRR11] eqs 5–7, proved for SC): p_n(K)p_m(L) ≤ 2 p_{n+m}(K#L) (SC); constants 36 (FCC) and 16 (BCC) with an extra N = 2 edges.

## Crossover lengths M_{K,L} ([JvRRgas])

Definition: if N_K = N_L, M_{K,L} = C_K/C_L is the limiting relative frequency (p_n(K) ≈ M_{K,L} p_n(L)); if N_L > N_K, M_{K,L} ≈ (C_K/C_L)^{1/(N_L − N_K)} is roughly the length at which L starts to outnumber K. Counts are p^± (both chiralities) unless marked ^+.

**Unknot vs prime knots** ([JvRRgas] Table 3, SC, numerical):

| K | M_{0_1,K} |
|---|---|
| 3_1 | (1.70 ± 0.12) × 10⁵ |
| 4_1 | (4.89 ± 0.46) × 10⁶ |
| 5_1 | (5.58 ± 0.70) × 10⁷ |
| 5_2 | (2.78 ± 0.32) × 10⁷ |
| 6_1 | (6.42 ± 0.64) × 10⁸ |
| 6_2 | (7.28 ± 0.74) × 10⁸ |
| 6_3 | (1.54 ± 0.22) × 10⁹ |
| 8_19 | (2.78 ± 0.28) × 10¹⁰ |

So trefoils outnumber unknotted SC polygons only beyond ≈170 000 edges (≈340 000 for one chirality).

**Relative frequencies between prime knots** ([JvRRgas] Table 4 selection; full table in `_extracts/JvRRgas.md`): 3_1/4_1 = 27.0 ± 2.2; 3_1/5_1 = 399 ± 44; 3_1/5_2 = 216 ± 24; 4_1/5_1 = 16.2 ± 1.5; 4_1/5_2 = 9.0 ± 1.2; 5_1/5_2 = 0.417 ± 0.040 (5_2 is more common than 5_1); 6_1/6_2 = 1.05 ± 0.13.

**Compound trefoils** ([JvRRgas] §5): M_{0_1,(3_1^+)^2} = 977 000 ± 66 000; M_{0_1,3_1^+#3_1^-} = 496 000 ± 30 000; (3_1^+)^2 is ≈0.535 ± 0.066 times as common as 3_1^+#3_1^-; M_{3_1^+,(3_1^+)^2} ≈ 1.47 × 10⁶; M_{0_1,(3_1^+)^3} = (2.18 ± 0.80) × 10⁶ (⚠ Table 5 prints ×10⁵); M_{0_1,(3_1^+)^4} = (8.40 ± 0.40) × 10⁶.

**Conjecture ([JvRRgas] pp. 25–26).** At each length the most populous knot types are K_±(N) = (3_1^±)^{⌈N/2⌉} # (3_1^∓)^{⌊N/2⌋}, with N growing proportionally to n.

## Universality across lattices ([JvRR11univ])

Amplitude ratios between prime knots appear lattice-independent (SC, FCC, BCC agree within error): C_{3_1}/C_{4_1} = 28(1) (27 ± 2 including the less-converged BCC data), C_{3_1}/C_{5_1} = 400(20), C_{3_1}/C_{5_2} = 280(20), C_{4_1}/C_{5_1} = 15(1), C_{4_1}/C_{5_2} = 9(1), C_{5_1}/C_{5_2} = 0.67(3). Linear-fit intercepts for log(p_n(3_1)/p_n(4_1)) vs 1/n: 3.34(3) SC, 3.35(3) FCC, 3.29(3) BCC. An earlier SC estimate ≈22 (their ref. [11]) is "close … but not within mutual error bars"; off-lattice models give "quite different results".

By contrast, **properties at minimal length are not universal** ([JvRR11] §4) — see [minimal-polygon-census](../lattice-length/minimal-polygon-census.md#cross-lattice-conclusions-jvrr11-4).

## Pending sources

[SSW92] (entanglement complexity / Kesten pattern theorem for knots and graphs), [JvRW91] (BFACF and knotted polygons), [JvROT25], [JvROT26] (knot probabilities and thermodynamics under confinement), [GJvRR12] (knots in a slab), [BPS26] (spanning pairs) — extracts in progress; this page will be extended.
