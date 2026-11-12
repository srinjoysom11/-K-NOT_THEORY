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

**Ergodicity on knot types (proved).** The irreducibility classes of BFACF on unrooted SC polygons are exactly the knot types ([JvRW91] Thm 3.11; quoted as [JvRRgas] Thm 3.1 and [Scharein09] Thm 1). So a BFACF chain started at a type-K polygon can reach every type-K polygon, and no polygon of any other type. This is why BFACF is the standard tool for finding short polygons of a *fixed* knot type.

Proof structure ([JvRW91] §3): (i) one direction is trivial — a move is a continuous deformation (Prop 2.1); (ii) BFACF can bring any polygon into a "standard form" with a *regular lattice knot projection* (Prop 3.6, Cor 3.7), using Lemma 3.5 to open up space by adding edges to every side crossing a plane; (iii) polygons with identical projections are connected (Prop 3.3); (iv) each Reidemeister move on projections is realised by BFACF moves (Prop 3.8); (v) plane isotopies and lattice translations of the projection are realised (Props 3.9, 3.10). Background quoted there: BFACF is ergodic in 2D (Madras 1986); no length-conserving local algorithm can be ergodic (Madras–Sokal 1987); adding a crankshaft move would make the 3D algorithm ergodic on *all* polygons (Brower, unpublished sketch) — useless for fixed-type sampling, but relevant if one wants to change knot type deliberately. Open there: higher dimensions.

**Atmospheres.** a_+(ω), a_0(ω), a_−(ω) = number of available positive, neutral, negative moves at ω ([JvRR11] §2, [JvRRgas] p. 7–8; example polygon with a_+ = 11, a_0 = 6, a_− = 4 in [JvRRgas] Fig. 2).

### FCC and BCC analogues ([JvRR11] §2, [JvRR11univ] p. 3–4)

* **BCC** (girth 4): positive, neutral and negative moves on quadrilateral plaquettes, including non-planar ones; each edge lies in 12 plaquettes (6 planar, 6 non-planar). Irreducible on fixed knot type.
* **FCC**: one move class (edge ↔ two edges of an elementary triangle) and its inverse; 4 triangular plaquettes per edge; **no neutral move**. Irreducible on fixed knot type.
* **Irreducibility proved** ([JvRR10bfacf] Thm 6 for BCC, Thm 10 for FCC): the irreducibility classes coincide with knot types. Method: make the polygon contact-free by subdividing (Lemmas 3, 8), sweep it into a sublattice isomorphic to Z³ (BCC: basis {c_1, c_3, c_4, c_5, c_7, c_8}, Thm 4; FCC: basis {d_1, d_3, d_5, d_7, d_9, d_11}, Lemma 9), then use SC ergodicity — each SC BFACF move in the sublattice is a composition of two FCC moves.
* Move counts per edge ([JvRR10bfacf] p. 24–25): BCC edges have 12 possible moves (at most one negative), classes (+, 0, −) ∈ {(12,0,0), (11,1,0), (10,2,0), (9,2,1), (9,3,0), (8,4,0), (7,4,1), (6,6,0)}; FCC edges have 4 (four positive, or three positive + one negative). Metropolis-style probabilities must satisfy e.g. 12P_+ ≤ 1 (BCC) and 3P_+ + P_− ≤ 1 with P_+ = e^{−β}P_− (FCC). ⚠ The extractor flags that the printed FCC formula P_+ = e^{−β}/(1 + 3e^{−2β}) is inconsistent with these constraints (they give 1 + 3e^{−β}).
* Limiting distribution (fixed knot type K): P_β(ω) ∝ |ω| e^{β|ω|} (eq. 9).

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

## Other search methods

* Ozawa 2026 series. [Ozawa26geom] (theory): for any scale-covariant size functional D (diameter, minimal enclosing radius, L^p radii, convex-hull volume^{1/3}), Rop(γ) = (Len/D)·(D/Thi) = density × compression radius, hence Rop(K) ≥ ρ_D(K)·CRad_D(K), with equality iff minimizing sequences optimise all three at once (Prop 3.7); polygonal versions under Rawdon–Simon-type approximation hypotheses. [Ozawa26density]: finite-state "density / compression-radius profiles" on BFACF-explored graphs of lattice polygons (modulo lattice isometries), filtered by length N and by a geometric threshold; only finite-state statements are proved (computability, monotonicity in the length cap, inequalities under mergers); the lattice-to-continuum limit is left open. Pilot numbers: 24-step trefoil seed ρ_2 = 11.358, ρ_∞ = 5.821; best ρ_∞ from +2 detours falls 5.821 → 4.239 over N = 24…32 (non-exhaustive).
* **Merge trees of BFACF graphs** ([Ozawa26merge]; graph G_N = polygons of length ≤ N joined by BFACF moves, classes modulo translation and proper rotations):
  * **4_1:** the 152 published minimal classes form **four components at length 30 (58, 58, 18, 18) that merge at 32** (Thm 11.11; exhaustive N = 32 component: 19 618 polygons = 152 + 19 466). Figure-eight seed and its mirror: merge at 32 (Obs. 11.10).
  * **6_3:** 148 minimal classes form **twelve components at 40, two at 42, one at 44** (Thm 11.15); seed–mirror barrier 4 extra edges (Obs. 11.14; exhaustive N = 42 search from one seed: 12 337 states).
  * **Trefoil (one chirality):** six certified nonminimal components born at length 26 with merge heights 28 or 30 relative to the minimal branch (Thm 11.6); one of them fits in the slab Z²×{0,1}. Completeness through 26 is conditional on there being 140 604 length-26 translation classes (Prop 11.9).
  * **Frozen polygons:** an explicit 64-edge Hamiltonian lattice unknot admits no neutral or shortening move (exact merge height 66 with the square, certified by a 25 436-move path); splicing gives frozen unknots of length 64m and **frozen trefoils of length 64m + 24 for every m ≥ 1, both chiralities** (Thm 11.4). Hence capped BFACF graphs of the unknot and trefoil **never become connected** at any finite cap: new strong local minima are born at arbitrarily large lengths (Cor 11.2). Open whether this holds for every nontrivial knot (Problems 13.1–13.4).
  * Completeness of the minimal-layer trees is conditional on the published populations ([JvRR11]) being complete.
  * *My remark:* (i) a search using only neutral and shortening moves gets stuck in local minima — including frozen states far above the minimum — so it must allow length increases; (ii) for the knots measured, an excursion of 2–6 edges above the minimum connects all minimal polygons, but no general bound is known. Consistent with [Scharein09]'s 3 type-0 classes for the trefoil.
* **Continuous counterpart — ropelength-filtered knot spaces** ([Ozawa26rope], theory): Y_Λ(K) = unit-thickness C^{1,1} realisations of K with length ≤ Λ (modulo rigid motions). Proved: every Y_Λ(K) is compact in the normalised model; components merge at attained levels, giving an ultrametric on components of the ideal (ropelength-minimising) stratum; Y_L(K) deformation-retracts onto its exact-length shell; any finite sublevel becomes path-connected at some finite higher level; finite ropelength levels exhaust the ordinary knot space homotopically. This is the smooth analogue of the lattice merge-tree picture above (excursion depth = merge level minus minimum).
* **Lattice-first stick-number search** ([CRSS25]): embed the diagram on the lattice (e.g. via Knoodle/ReAPR: 9k–34k edges for 64-crossing knots), shrink with BFACF (the authors find lattice search "several orders of magnitude" faster than searching n-gons directly), then anneal off-lattice to few sticks. Example 9_29: 168-edge lattice start → 58-edge near-minimal lattice polygon → 10-stick → 9-stick equilateral. Typical runtime ≈ 10 min per knot. Large flat embeddings "sometimes needed to grow to almost twice their initial length before shrinking" — another instance of the excursion phenomenon above.
* Off-lattice tightening (Ridgerunner) — [ACPR10]; see [ropelength/numerics](../ropelength/numerics.md).
* Reinforcement learning / nested Monte Carlo / LLM-guided search — see [ml-search/](../ml-search/README.md).

## Practical notes for this project (*my remarks*)

* To *certify* that a found polygon has type K, compute an invariant (e.g. HOMFLY or hyperbolic volume via SnapPy) on the final polygon; BFACF preserves type, so certifying the starting polygon is enough in principle, but checking the output guards against implementation bugs.
* GAS counts are anchored at p_{n_min}; an error in the minimal count propagates multiplicatively to every p_n(K) estimate.
* Lattice symmetry: the octahedral group has 48 elements (24 rotations × reflection). [JvRR11] and [JvRRgas] speak of a 24-element group acting by "rotations and reflections" with class sizes up to 24 — consistent with counting chiral knots one chirality at a time. Keep this in mind when comparing class counts S_K (142 for the trefoil) with canonical-polygon counts (75, [Scharein09]).
