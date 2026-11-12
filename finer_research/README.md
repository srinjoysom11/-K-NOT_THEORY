# Finer research: the 11-crossing table and what predicts lattice length

Written 12 Nov 2026 on branch `finer_research` (branched from `research/len11-table`).
Labels as in `research/PLAN.md`: **[E]** established (source key from `wiki/SOURCES.md`),
**[C]** computed here (script and output file given), **[J]** proposal or conjecture
(with the check that would settle it).

Len(K) = least number of unit steps of a simple-cubic lattice polygon of knot type K.
c = crossing number, a = arc index (= grid index).

## 1. The open problem chosen, and why

`wiki/open-problems.md` item **A6: "Tables beyond 10 crossings. No minimal-length table
exists for 11 or more crossings."** It is the item that is literally Goal 1 (numerical
tables), it is the backbone of `research/PLAN.md` (task T6), and it is the only item
where a few CPU-hours produce results that are new by construction.

Items considered and set aside: A1 (certify Len beyond 5_1) needs proofs by exhaustive
enumeration and belongs to a later phase; A3 (arithmetic patterns in families) was
already tried for trefoil sums with no improvement; D17-D19 are about the move set, not
the table.

## 2. What had already been done

Literature:
- [E] Proved values: Len(3_1) = 24 [Diao93], Len(4_1) = 30 and Len(5_1) = 34 [Scharein09].
- [E] Best-known upper bounds for all 249 prime knots with at most 10 crossings
  [Scharein09], found in 2009 by BFACF annealing (100 cycles of 100,000 moves at
  fugacity up to 0.2 then 60,000 at 0.02); at most 7 crossings re-minimised by [JvRR11].
- [E] For 11 crossings the literature has exactly two values, both from the "step of
  10" families in [JvRR11] Table 1: the torus knot T(2,11) at 64 and the 11-crossing
  twist knot at 66. Nothing else.
- [E] Rigorous upper bounds in terms of arc index: a knot is realised with (a-2, a-1,
  a-1) sticks in the three directions, giving bounds quadratic in a [HNO14len]; they are
  loose (112 for 8 crossings against the numerical 52).
- [E] No lower bound on Len in terms of arc index appears in any of the 66 papers in
  the wiki. The only general lower bounds are Len > braid index [Diao19] and
  4 Len + 6 >= c for alternating knots [Diao22].

This repository (branch `research/len11-table`):
- [C] Seeds for all 801 prime knots with 3-11 crossings from planar diagrams.
- [C] Calibration: 245 of 249 literature values reproduced with 24 runs, the other 4
  with 240 runs, none beaten.
- [C] A first 11-crossing table, all 552 knots verified, **24 runs per knot**, flagged
  in PLAN.md as "some values probably 2 too long".

## 3. Questions asked here

1. How loose is the first 11-crossing table? (PLAN.md T6, first bullet.)
2. Is there a knot invariant that predicts Len well enough to say *which* table
   entries are probably too long, so that search effort can be aimed?
3. Does the starting polygon matter? The project's seeds come from planar diagrams;
   minimal grid diagrams give a second, independent family of seeds.
4. Are any of the 2009 literature values for 10 crossings improvable?

## 4. Results

Experiments are still running; this section is filled in by the next commit.
