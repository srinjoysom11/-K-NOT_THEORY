# Notation, conventions and traps

One page to read before quoting any number from this wiki. Every convention below is attributed to the paper that uses it.

## The central invariant has five names

| name | symbol | used by |
|---|---|---|
| minimal knotting number (for the unknot threshold only) | n_0 | [Diao93] |
| minimal edge number | M(K) | [JvRP95] |
| minimum step number | — (column "S") | [Scharein09], [Ishihara12] |
| minimal length | n_K | [JvRR11], [JvRR12comp], [GJvRR12] |
| minimum lattice length | Len(K) | [HKNO14], [HHKNO14], [HNOR15] |

All mean: least number of unit edges of a polygon in the simple cubic lattice Z³ of knot (or link) type K. **This wiki writes Len(K)**, with a subscript for other lattices (Len_FCC, Len_BCC). The project brief's "c(K)" for this quantity clashes with the universal use of **c(K) = minimal crossing number**; here c is always crossing number.

Len is always even in SC and BCC (bipartite lattices); FCC polygons can have odd length ([JvRR11] §1.1).

## Related invariants

| symbol | meaning | notes |
|---|---|---|
| s(K) | stick number (polygons in R³) | |
| s_L(K) | lattice stick number: least number of maximal straight segments of a lattice polygon | a stick of length n is n edges ([HNO14len] §1); #sticks = #corners |
| a(K) = α(K) | arc index = least number of pages of an arc presentation | equals grid index g(K) ([HKNO14] §2) |
| b(K) | bridge index | b − 1 additive under # |
| Rop(K) | minimum ropelength | **convention-dependent, see below** |
| μ_K ([JvRP95]) = α_K ([JvRR11]) | minimal edge index lim Len(K^n)/n | beware: [JvRP95] uses α_K for 4(b(K)−1), [JvRR11] uses α_K for the index itself and μ for the polygon growth constant |
| P_K | number of minimal-length polygons up to translation | "unrooted"; rooted = × length |
| canonical polygon | class under translation + rotation + reflection, orientation ignored ([Scharein09] Def. 1) | 75 for the trefoil |
| symmetry class S_K | class under the octahedral group action of [JvRR11] | 142 for the trefoil |
| p_n(K) | number of unrooted n-edge polygons of type K | |
| μ (statmech) | growth constant lim p_n^{1/n} ≈ 4.6844 in SC ([JvRP95] §3) | critical BFACF fugacity β_c ≈ 0.2134 = 1/μ |

## Ropelength: radius vs diameter

* **Length / radius** ("thickness = radius of the largest embedded normal tube"): [HKNO14], [HHKNO14], [HNOR15], and the Diao / Cantarella–Kusner–Sullivan line. In this convention a lattice polygon has thickness radius 1/2, so **Rop(K) ≤ 2·Len(K)** ([HNOR15] §2, [HKNO14] §1), and tight Hopf link = 8π... (see [ropelength/lower-bounds](ropelength/lower-bounds.md) for each paper's convention).
* **Length / diameter**: used by part of the numerical literature (Klotz et al.; values half as large). Each ropelength page states the convention per source; **always check before dividing or multiplying by 2**.
* Sharper lattice → rope conversion: doubling the lattice and rounding each corner by a quarter circle of radius 1 gives Rop ≤ 2·(length) − (2 − π/2)·(#corners) ([HKNO14] §4).

## Knot names

* Rolfsen/Alexander–Briggs names c_i (3_1 … 10_165). The Perko pair makes the tail of the 10-crossing table ambiguous: KnotInfo's 10_162…10_165 are SnapPy/old-Rolfsen 10_163…10_166 (`READING_LIST.md` §1). [Scharein09] Table A1 lists up to 10_165.
* Chirality: 3_1^+ is the right-handed trefoil in [JvRR11]; counts P_K include both chiralities for chiral K (P_{3_1} = 3328 = 2 × 1664).
* Composite knots: K^n or (K)^n = n-fold connected sum; K_1#K_2.
* Links: Rolfsen c^μ_i (4^2_1, 6^3_2 …) as printed in each source.

## Direction words

Polygons are stored as words over {N,E,W,S,U,D} ("NEWSUD form", [Scharein09] §4) / `nsewud` in this project's data. [Scharein09]'s *standard form* = lexicographically least word over all 24 rotations, all cyclic shifts and both orientations (reversal = reverse the string **and** swap N↔S, E↔W, U↔D; plain reversal gives the mirror image), plus reflections for achiral knots.

## Status vocabulary used in this wiki

* **proved** — a complete proof is in the cited paper.
* **proof outlined** — the paper states it as a theorem but defers details.
* **numerical** — found by Monte Carlo / search; an upper bound for a minimum, or a lower bound for a count.
* **conjecture / observed pattern** — stated as such by the source.
* *my remark* — added by the wiki author, not in any source.

## Citations

`[Key]` refers to an entry in [SOURCES.md](SOURCES.md); the locator after it (Thm, §, Table, p.) points into that paper. Faithful per-paper parses (abstract, every numbered statement, every table, figure captions) live in `_extracts/<Key>.md`; page images in `figures/<Key>/pNN.png`.
