# BFACF moves, GAS sampling and minimal-polygon search

How the numerical minimal-length data in this wiki were produced, and what each method can and cannot certify. For the resulting numbers see [lattice-length/minimal-polygon-census](../lattice-length/minimal-polygon-census.md) and [lattice-length/tables-minimal-length](../lattice-length/tables-minimal-length.md).

**Bottom line:** every search method here finds polygons, so it gives **upper bounds** on Len(K) and **lower bounds** on counts P_K. None of them proves minimality. Proofs exist only for 3_1, 4_1, 5_1 ([exact-values-and-proofs](../lattice-length/exact-values-and-proofs.md)).

## BFACF moves (simple cubic lattice)

Named after Berg–Foerster and Aragão de Carvalho–Caracciolo–Fröhlich. Two kinds of local move on a lattice polygon ([JvRR11] Fig. 4, [Scharein09] Fig. 2, [JvRRgas] Fig. 1):

| move | effect | names used |
|---|---|---|
| corner flip across a unit square | length unchanged | Type II in [JvRR11]; Type I in [JvRRgas]; "type 0" in [Scharein09]; *neutral* |
| replace one edge by three edges of a unit square (⊓) | length +2 | *positive*; "type 2" |
| replace three edges of a ⊓ by one edge | length −2 | *negative*; "type −2" |

⚠ The papers number the two classes oppositely; this wiki uses positive/neutral/negative.

**Ergodicity on knot types (proved).** The irreducibility classes of BFACF on unrooted SC polygons are exactly the knot types ([JvRRgas] Thm 3.1, [Scharein09] Thm 1, both quoting Janse van Rensburg–Whittington 1991 = [JvRW91]). So a BFACF chain started at a type-K polygon can reach every type-K polygon, and no polygon of any other type. This is why BFACF is the standard tool for finding short polygons of a *fixed* knot type.

**Atmospheres.** a_+(ω), a_0(ω), a_−(ω) = number of available positive, neutral, negative moves at ω ([JvRR11] §2, [JvRRgas] p. 7–8; example polygon with a_+ = 11, a_0 = 6, a_− = 4 in [JvRRgas] Fig. 2).

### FCC and BCC analogues ([JvRR11] §2, [JvRR11univ] p. 3–4)

* **BCC** (girth 4): positive, neutral and negative moves on quadrilateral plaquettes, including non-planar ones; each edge lies in 12 plaquettes (6 planar, 6 non-planar). Irreducible on fixed knot type.
* **FCC**: one move class (edge ↔ two edges of an elementary triangle) and its inverse; 4 triangular plaquettes per edge; **no neutral move**. Irreducible on fixed knot type.
* Irreducibility proofs are in [JvRR10bfacf] (extract pending).

## Classical BFACF Monte Carlo (fugacity z)

Samples polygons of fixed type from the grand-canonical distribution ∝ z^n ([Scharein09] §4):

p(0) = (1 + z²) / (2(1 + 3z²)),  p(+2) = z² / (1 + 3z²),  p(−2) = 1 / (1 + 3z²),

valid for 0 ≤ z ≤ z_c = 0.2134 = 1/μ (μ ≈ 4.684 the SC growth constant). Small z drives the polygon short; z near z_c lets it grow and untangle.

## Minimal-polygon search as done in [Scharein09]

1. **Phase 1:** BFACF on a type-K polygon, alternating "high" z (uniform in (0, 0.2), 100 000 iterations) and "low" z = 0.02 (60 000 iterations), cycle repeated 100 times; keep the shortest; discard if longer than the current bound; standardize and add new canonical polygons.
2. **Phase 2 (expansion):** run type-0 (neutral) moves exhaustively from every polygon found; keep new canonical polygons. Matters for some 9–10 crossing knots.
3. **Standard form:** NEWSUD word, lexicographically least over 24 rotations × all cyclic shifts × both orientations (reversal = reverse the string *and* swap N↔S, E↔W, U↔D), plus reflections for achiral knots ([00-notation](../00-notation.md#direction-words)).
4. **Type-0 classes:** polygons joined by neutral moves; *taut* = class of size one ([Scharein09] Defs 3–4). Trefoil: 75 canonical polygons in 3 classes (18, 56, 1).
5. **Stick-number search:** z random in (0.13, 0.19), 100 000 iterations, then all possible −2 moves, count direction changes; repeated up to several hours per knot ([Scharein09] §5.6).

## GAS — generalised atmospheric sampling ([JvRRgas], [JvRR11univ], [JvRR11] §2)

An approximate-enumeration method (a Rosenbluth-type algorithm with atmospheric moves) that estimates **ratios p_n(K)/p_m(K)** over a range of lengths; anchoring at the exactly enumerated minimal count p_{n_min}(K) turns ratios into absolute estimates.

1. From ω_j (length ℓ), pick a move uniformly among available atmospheric moves with weights Pr(+) ∝ β_ℓ a_+(ω_j), Pr(0) ∝ a_0(ω_j), Pr(−) ∝ a_−(ω_j).
2. **flatGAS:** β_ℓ = ⟨a_−⟩_ℓ / ⟨a_+⟩_ℓ, with β_{n_max} = 0, so lengths are visited roughly uniformly ([JvRRgas] eq. 3.4). ⚠ [JvRR11] and [JvRR11univ] print the reciprocal ⟨a_+⟩/⟨a_−⟩; [JvRRgas]'s version is the one that balances the moves.
3. Weight of the state reached after a sequence: W(ω_n) = [a_−(ω_0) + a_0(ω_0) + β a_+(ω_0)] / [a_−(ω_n) + a_0(ω_n) + β a_+(ω_n)] × ∏ β_{ℓ_j}^{σ_j}, σ = −1 for a positive move, +1 for a negative move ([JvRRgas] eq. 3.5).
4. Estimator: Σ_{|τ|=n}⟨W⟩ / Σ_{|σ|=m}⟨W⟩ → p_n(K)/p_m(K) ([JvRRgas] eq. 3.6).
5. Implementation: hash-coded O(1) updates of polygon and atmospheres; minimal-length polygons sieved from the stream and hashed into a table; symmetry classes, writhe and curvature computed offline ([JvRR11] p. 11).

**Run sizes reported.**

| source | lattice | lengths | effort |
|---|---|---|---|
| [JvRR11] | SC/FCC/BCC | n ≤ M, 500 ≤ M ≤ 700 | up to 500 sequences × 10⁷ states per knot type; (3_1^+)^5 and (4_1)^3 took weeks; (3_1^+)^2(3_1^-)^2 exceeded memory |
| [JvRRgas] | SC | even n up to 2500 (some 500) | 10⁷ states per sequence; 2500 sequences (unknot), 2000 (trefoil), 500 for most others |
| [JvRR11univ] | SC/FCC/BCC | n ≤ 512 | one week on one cluster node each: ≈1400 chains × 2²³ (SC), ≈400 × 2²⁷ (FCC), ≈500 × 2²³ (BCC) |

**Reliability of minimal counts (authors' own statement, [JvRR11] §3.1.2, repeated for FCC/BCC):** very sure if P_K ≲ 1000; reasonably certain up to 10⁴; less certain to 10⁵; only a lower bound beyond 10⁵. [JvRR11univ]: all minimal realisations found "within hours", then nothing new "after another few days of CPU time".

**Validation against exact series ([JvRRgas] Table 2 vs Clisby–Liang–Slade):** GAS gives p_18(0_1) ≈ (1.084 ± 0.004)×10⁸ vs exact 108 088 232, p_22(0_1) ≈ (2.987 ± 0.015)×10¹⁰ vs exact 29 764 630 632. GAS 26-edge trefoils 281 050 ± 630 vs the census count 281 208 ([JvRR11] Table 4).

## Other search methods (extracts pending)

* Ozawa 2026 merge-tree / ropelength-filtered analyses of BFACF state spaces — [Ozawa26merge], [Ozawa26rope], [Ozawa26density], [Ozawa26geom].
* Off-lattice tightening (ridgerunner) — [ACPR10]; stick-number search — [CRSS25].
* Reinforcement learning / nested Monte Carlo / LLM-guided search — see [ml-search/](../ml-search/README.md).

## Practical notes for this project (*my remarks*)

* To *certify* that a found polygon has type K, compute an invariant (e.g. HOMFLY or hyperbolic volume via SnapPy) on the final polygon; BFACF preserves type, so certifying the starting polygon is enough in principle, but checking the output guards against implementation bugs.
* GAS counts are anchored at p_{n_min}; an error in the minimal count propagates multiplicatively to every p_n(K) estimate.
* Lattice symmetry: the octahedral group has 48 elements (24 rotations × reflection). [JvRR11] and [JvRRgas] speak of a 24-element group acting by "rotations and reflections" with class sizes up to 24 — consistent with counting chiral knots one chirality at a time. Keep this in mind when comparing class counts S_K (142 for the trefoil) with canonical-polygon counts (75, [Scharein09]).
