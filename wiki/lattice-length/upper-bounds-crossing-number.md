# Upper bounds on Len(K) in terms of crossing number (SC lattice)

c = c(K) minimal crossing number; Len = minimum lattice length; Rop = minimum ropelength in the **length / radius** convention used by these papers (so Rop ≤ 2·Len — see [notation](../00-notation.md)). a(K) = α(K) = arc index = g(K) grid index.

## Summary table (all rigorous)

| bound | applies to | source |
|---|---|---|
| Len ≤ 136c^{3/2} + 84c + 22c^{1/2} + 11 | knots (and, for the ropelength version 272c^{3/2}+168c+44c^{1/2}+22, quoted for non-split links in [HNO14len] §4) | Diao–Ernst–Yu 2004, *as quoted in* [HKNO14] §1, [HHKNO14] §1 (paper not in collection) |
| Len ≤ (3/2)c² + 2c + 1/2 | nontrivial knots ≠ 3_1 | [HNO14len] Thm 1 |
| Len ≤ (3/2)c² − 4c + 5/2 | non-alternating prime knots | [HNO14len] Thm 1 |
| Len ≤ 6c + 2√(c+1) + 6 | torus knots T(n+1, n), n ≥ 3 | [HNO14len] Thm 1 |
| Len ≤ min{ (3/4)c² + 5c + 17/4 , (5/8)c² + (15/2)c + 71/8 } | any nontrivial knot | [HKNO14] Thm 1 |
| Len ≤ min{ (3/4)c² + 2c − 11/4 , (5/8)c² + 5c − 29/8 } | non-alternating prime knots | [HKNO14] Thm 1 |
| Len ≤ 8c + 2 | nontrivial 2-bridge **knots and links** | [HHKNO14] Thm 1 |
| Len, Rop ≤ O(c·ln⁵c) | all knots (no explicit constant) | Diao–Ernst–Por–Ziegler, see [ropelength/upper-bounds](../ropelength/upper-bounds.md) |
| Len(H_{p²,q²}) ≤ 10p²⌈q²/p⌉ + 6p³ (1 ≤ p ≤ q) | (p², q²)-Hopf links | [HNOR15] proof of Thm 2 |

In terms of grid index g (the form the proofs give; [HKNO14] §3):
Len ≤ g² + 2g (Step 1) ; Len ≤ (3/4)g² + 2g − 11/4 (Step 2) ; Len ≤ (5/8)g² + 5g − 29/8 (Step 3).
In terms of arc index a ([HNO14len] Lemmas 2, 4, 5): a properly leveled lattice knot with n x-levels has ≤ (n²−1)/2 (n odd) or n²/2 (n even) x-edges; K is realised with (a−1, a−1, a) x-, y-, z-sticks, or (a−2, a−1, a−1) if K is not T(n+1, n).

Corresponding ropelength bounds ([HKNO14] Thm 2): Rop ≤ min{ (3/2)c² + (π+6)c + 2π + 1/2 , (5/4)c² + (π/2 + 13)c + π + 55/4 } ≈ min{1.5c² + 9.15c + 6.79, 1.25c² + 14.58c + 16.90}; for non-alternating prime knots min{ (3/2)c² + πc − 11/2 , (5/4)c² + (π/2 + 8)c − 29/4 }. Earlier general bound: Rop ≤ 1.64c² + 7.69c + 6.74 for knots and non-split links (Cantarella–Faber–Mullikin 2004, as quoted in [HKNO14], [HHKNO14]).

**How loose are they?** [HNO14len] §4: for c = 4, 5, 6, 7, 8 the best numerical values are 30, 36, 40, 46, 52 (max over knots of that crossing number) while (3/2)c² + 2c + 1/2 gives 32, 48, 66, 88, 112.

## Ingredients

* **Arc index vs crossing number** (quoted in [HNO14len] Thm 3, [HKNO14] Prop. 3): a(K) ≤ c(K) + 2 for any nontrivial knot (Bae–Park 2000); a(K) ≤ c(K) for non-alternating prime knots (Jin–Park 2010). See [arc-index](../invariants/arc-index.md).
* **Arc presentation → lattice knot** ([HNO14len] §2–3, building on [HNO12stick]): move the binding axis to the line y = x, replace each arc (page k, binding indices i < j) by an x-stick and a y-stick at z-level k, join arcs sharing a binding index by a z-stick. Result is *properly leveled* (each x-level contains exactly two endpoints of x-sticks, etc.). Two sticks are saved at y-level 1 and x-level a; two more if K ≠ T(n+1, n) by using a non-star-shaped arc presentation and lifting one arc. Figures: [HNO14len p3](../figures/HNO14len/p03.png), [p4](../figures/HNO14len/p04.png).
* **Edge count for a leveled diagram**: at most 2 edges cross between levels 1–2, 4 between 2–3, … growing by 2 towards the middle ⇒ ≤ n²/2 edges per direction.
* **Grid diagram + two folds** ([HKNO14] §3):
  1. Put the g horizontal strands as x-sticks on z-level 1 and the g vertical strands as y-sticks on z-level 2, joined by 2g unit z-edges: ≤ g² + 2g edges.
  2. *Horizontal fold* about the line z = 1, x = middle: the right half of the y-sticks moves to z-level 0; overlapped x-edges are deleted ⇒ x-edges ≤ (g²−1)/4: total ≤ (3/4)g² + 2g − 11/4.
  3. *Vertical fold* about z = 2, y = middle: half the x-sticks go to level 3, y-sticks on level 0 are broken and half go to level 4, each broken pair reconnected by 2 y-edges and 4 z-edges: total ≤ (5/8)g² + 5g − 29/8.
  Figures: [HKNO14 p5](../figures/HKNO14/p05.png) (horizontal folding), [p7](../figures/HKNO14/p07.png) (vertical folding).
* **Lattice → rope**: double the scale and replace every corner by a quarter circle of radius 1: Rop ≤ 2·(length) − (2 − π/2)·(#corners) ([HKNO14] §4).

## 2-bridge knots and links: Len ≤ 8c + 2 ([HHKNO14])

Standard alternating diagram in Conway notation (a_1, …, a_m), all a_i > 0, m odd, c = Σa_i.
1. Draw the diagram on z-level 2 (axes rotated 45°) with over-arcs dropped to z-level 1; each crossing "floor" costs 4 x-edges + 4 y-edges + 2 z-edges ⇒ 10c edges.
2. Delete the rightmost long arc (2c edges), cut the rest along a middle line, rotate the lower half by 180° about it and stack it on z-levels 3–4, reconnect with 4 z-edges, save 2 more edges ⇒ **8c + 2**.

Figures: [HHKNO14 p5](../figures/HHKNO14/p05.png), [p6](../figures/HHKNO14/p06.png). Ropelength analogue with helices on three cylindrical towers of radius h ≥ 1.205: Rop ≤ 2h(√(π²+4) + 1)c + 4π + 14h ≈ 11.39c + 29.44 (Prop. 2), improved to **Rop ≤ 11.39c + 12.37 for c ≥ 6** (Thm 3). This is the only Len-vs-c result in the collection whose statement explicitly includes links.

## Growth exponents are not determined by c: links ([HNOR15])

H_{p,q} = (p, q)-Hopf link: p parallel copies of one component of the Hopf link and q of the other; prime for p, q ≥ 2; c(H_{p,q}) = 2pq.

* **Thm 1.** For every real r ∈ [1/2, 1] there is an infinite family of non-splittable prime links with stick number s and lattice stick number s_L of order c^r. (s(H_{k^m,k^n}) = 3(k^m+k^n), s_L = 4(k^m+k^n), c = 2k^{m+n}.)
* **Thm 2.** For every real r ∈ [3/4, 1] there is an infinite family of non-splittable prime links with Len and Rop of order c^r. Sandwich: 2πqp² + 2πpq² ≤ Rop(H_{p²,q²}) ≤ 2·Len(H_{p²,q²}) ≤ 20p²⌈q²/p⌉ + 12p³ (1 ≤ p ≤ q). Lower bound: a component linked with q² unit-radius tubes bounds a disc of area ≥ πq², so has length ≥ 2πq (Beckenbach–Radó). Upper bound: nested stacks of rectangles ([figure](../figures/HNOR15/p06.png)).
* Background facts quoted there: Negami (5 + √(8c+9))/2 ≤ s(K) and s ≤ 2c; Huh–Oh s ≤ (3/2)(c+1); Diao–Ernst lower bound on s_L of order √c (printed as "3√(c(K)+1) + 3 ≤ s_L(K)" in the extracted text — check the original before using the constant); s_L ≤ 3c + 2 ([HNO12stick]); Rop ≥ (4π/11)^{3/4}·c^{3/4} "summarising [Buck, Buck–Simon, Cantarella–Kusner–Sullivan]" and the 3/4 power is optimal; **whether any family of knots has super-linear Len or Rop is open**.

## What is missing (candidates)

* No quadratic-in-c bound for links is stated in [HNO14len]/[HKNO14] (both say "knot"); the constructions use arc presentations/grid diagrams, which exist for links, and the arc-index bound a ≤ c + 2 is from a paper titled "arc index of links" — extending needs care with split links (*my remark*).
* Linear bounds only for 2-bridge and T(n+1, n); nothing for T(p, q) in general, Montesinos, closed 3-braids, etc.
* The O(c ln⁵ c) bound has no explicit constant.
