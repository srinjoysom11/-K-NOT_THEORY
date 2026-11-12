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

## Rigorous results: almost all long polygons are very knotted ([SSW92])

* **Pattern theorem** (Kesten for walks; Sumners–Whittington for polygons, quoted): for any Kesten pattern P there is λ_P > 0 such that all but exponentially few n-edge SC polygons contain P at least ⌊λ_P n⌋ times (Thm 2.3).
* **Every knot type is a tight Kesten pattern** (Thm 2.4; the trefoil by an explicit 18-step walk), so for every K there is ζ_K > 0 with **K appearing at least ⌊ζ_K n⌋ times in the prime factorisation of all but exponentially few n-polygons** (Cor 2.5).
* **Good measures of knot complexity** F (F(unknot) = 0 and F(nK # L) ≥ nF(K) > 0 for some K; Def 3.1) grow at least linearly: all but exponentially few n-polygons have F > F(K)(n/n_K − 1) (Cor 3.2). Good measures (Thm 3.3): number of prime factors, genus, bridge number − 1, span of any non-trivial Laurent knot polynomial, log(order), crossing number, unknotting number, minor index, braid index − 1.
* **Graphs** (§4): for every graph type τ with vertex degrees ≤ 6, embeddings in Z³ have the same connective constant κ as walks (Thm 4.2); if τ has no cut edge, all but exponentially few embeddings are knotted (Thm 4.4), and every good measure grows linearly (Thm 4.9); weaker result when τ has a cut edge and a cycle (Thm 4.8).
* Consequence for this project (*my remark*): minimal-length polygons are exponentially rare among polygons of their length for every nontrivial knot, which is why exhaustive enumeration is limited to small lengths and why sampling must be biased towards short polygons (low BFACF fugacity, GAS anchoring).

## Two-component systems in tubes ([BPS26])

kSAPs = k disjoint polygons spanning a lattice tube T_{N,M}, all with the same span. Results (proved): good measures of knot complexity induce good measures of *spanning-link* complexity (via 2-strand tangle products, Thm 1, Cor 1); all but exponentially few size-m 2SAPs in a tube have F-complexity growing at least linearly in m (Thms 2, 4); bridge number, numbers of p-colourings and the splitting number (Prop 6) are good measures; concatenating two unlinks can produce a non-split link.

## Knots confined in a cube ([JvROT25], [JvROT26])

Model: polygon of length n and fixed knot type K inside a cube of side L ((L+1)³ sites), concentration φ = n/V. GAS/GARM with BFACF moves gives ratios p_{n,L}(K)/p_{m,L}(K), anchored at exhaustive minimal-length counts per cube ([JvROT25] Table I, reproduced in [confinement-slabs](../lattice-length/confinement-slabs.md#confinement-in-a-cube-jvrot25-table-i)). All numerical.

* **Relative knotting probability** ρ_{n,L}(K/0_1) = p_{n,L}(K)/p_{n,L}(0_1) is small — the unknot dominates for L ≤ 14 — and increases with φ along a curve that flattens towards the Hamiltonian (space-filling) limit. L = 8: ρ(3_1^+/0_1) ≈ 0.10 at φ ≈ 0.5 ([JvROT25] p. 13).
* Extrapolated to φ → 1 (log R_L, Table III): non-trivial knots become more competitive as L grows; log R_L(4_1/3_1^+) → 0; 5_2 beats 5_1; 6_3 is the most likely six-crossing knot (except L = 6); the square knot beats the granny. ⚠ At L = 12 the extrapolation gives log R_12(4_1/0_1) = +0.291(42) > 0 (figure-eight more common than the unknot at φ = 1), in tension with the paper's conclusion that the unknot is most popular for L ≤ 14.
* Open questions raised there: is the limit R(3_1^+/0_1) < 1, and is it universal?
* Quoted numerics: tying a trefoil costs ≈ 8 edges (p_{n−ℓ}(0_1) ≃ n^{−1}p_n(3_1) with ℓ ≈ 8); trefoils overtake unknots at n ≈ 169 600 ± 5 600 (consistent with [JvRRgas]'s 170 000); log(μ/μ_{0_1}) = (4.15 ± 0.32)×10⁻⁶.
* **Thermodynamics** ([JvROT26]): with a chemical potential (fugacity x), the confined lattice knot shows a solvent-rich / polymer-rich phase transition for the unknot and for each fixed knot type. The limiting free energy χ_{0_1}(x) = lim L⁻³ log Z_{0_1,L}(x) exists (Thm 1, proved via a concatenation inequality); small but significant knot-type dependence of the free energy near the critical point (trefoil vs other knots). Open: is the critical point x_K = x_{0_1} (only x_{0_1} ≤ x_K is known)?

Knots squeezed into slabs at *minimal* length: [lattice-length/confinement-slabs](../lattice-length/confinement-slabs.md).
