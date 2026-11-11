# Ropelength lower bounds

**Convention used on this page: length / radius ("R-units")**, i.e. a unit-thickness curve sits in an embedded tube of radius 1. Numbers from length/diameter papers ("D-units") are doubled and the original value is shown in brackets. Lattice polygons have Rop ≤ 2·Len in R-units ([HNOR15] p. 4, [CKS01] p. 23), so every bound below also gives Len(K) ≥ Rop(K)/2.

| source | convention (as stated by the paper) |
|---|---|
| [CKS01] | R: "the radius of the largest embedded normal tube" (p. 1) |
| [DDS04] | D: thickness = diameter, explicitly noting others use radius (p. 1) |
| [KM16] | R: "the largest radius of the tube" (p. 1) |
| [CFM02], [HKNO14], [HHKNO14], [HNOR15] | R |
| [Diao19], [Diao22] | not stated. *Resolved here:* [Diao19]'s quoted "L ≥ 31.32 for any nontrivial knot" is exactly 2 × [DDS04]'s 15.66, and its "1.105 c^{3/4}" equals ((4π/11)c)^{3/4} (since (4π/11)^{3/4} = 1.105), both R-unit values. So Diao19 uses **R**. |

## Knots: absolute constants

| bound on Rop(K), K nontrivial | R-units | source, status |
|---|---|---|
| 5π | 15.71 | Litherland–Simon–Durumeric–Rawdon (quoted in [CKS01] p. 2) |
| 4π + 2π√PC(K) ≥ 2π(2 + √2) | ≥ 21.45 | [CKS01] Thm 19, proved; PC = parallel overcrossing number ≥ 2 |
| 2π(2 + √(2g(K) − 1)) | genus-dependent | [CKS01] Cor 22, proved |
| 24 | 24 [12 D] | Diao 2003 (quoted in [DDS04] p. 1–2, [CKS01] p. 25) |
| 2·(10π/3 + 2√3) | 27.87 [13.936 D] | [DDS04] Thm 9.5 (any of the three quadrisecant types) |
| **2·15.66** | **31.32** [15.66 D] | **[DDS04] Cor 9.7**, using Denne's theorem that every nontrivial knot has an essential alternating quadrisecant; best absolute bound in this collection |
| would-be 4π + 2π√3 | 23.45 | [CKS01] Conj. 25 (AC = PC = Cr) |
| would-be ≈ 30.51 | 30.51 | [CKS01] Conj. 26 |

Numerical comparison (not bounds): tight trefoil ≈ 32.66 R ([CKS01] p. 2, Pieranski) ≈ "slightly less than 16.372" D ([DDS04] p. 2 → 32.74 R); tight figure-eight "just over 21" D (≈ 42 R). So the best lower bound is within ≈ 4% of the trefoil value.

## Knots: growth in crossing number c = Cr(K)

* **Four-thirds law:** Rop(K) ≥ ((4π/11)·c)^{3/4} ≈ 1.105 c^{3/4} (Buck–Simon; [CKS01] Thm 23, [KM16] eq. 1.11), and Rop ≥ 4√(π c) (better for small c). The exponent 3/4 is attained by families of links (k-component Hopf links, (k, k−1) torus knots — [CKS01] p. 23; [HNOR15] Thm 2 for every exponent in [3/4, 1]).
* **Diao 2003:** 16π·c ≤ Rop(Rop − 17.334), i.e. Rop ≥ ½(17.334 + √(17.334² + 64πc)) ([KM16] eq. 1.14, [CKS01] p. 25; ⚠ [KM16] misprints d_0 = 10 − 6(π+√2), which is −17.334).
* **Average crossing number:** Rop^{4/3} ≥ (4π/11)·acr(K), Rop² ≥ 16π·acr(K) ([KM16] eq. 1.12).
* **Finite-type invariants:** Cr(K) ≥ ((2n)!|c_{2n}(K)|)^{1/2n} ≥ (2n/3)|c_{2n}|^{1/2n} ([KM16] Thm B), giving Rop(K) ≥ ½(d_0 + √(d_0² + (128nπ/3)|c_{2n}|^{1/2n})) (Cor C). Pretzel knots P(a,b,c) have genus 1 but c_2 = (ab + ac + bc + 1)/4 → ∞, so this beats the genus bound on such families.
* **Braid index:** Rop(K) > **B**(K)/14 for any link, **B** = absolute braid index ([Diao19] Thm 3.1: **B** < Len < 14·Rop). Gives linear growth for (2,2n) torus links, twist knots, alternating 3-pretzels (Rop > c/28).
* **Alternating knots: Rop(K) ≥ c/59.5** ([Diao22] Thm 3.1; ≥ c/51 with the improved constant of Remark 3.2). Proof goes through the lattice: Rop > Len/14 and 4·Len + 6 ≥ c — see [lattice-length/lower-bounds](../lattice-length/lower-bounds.md#3-alternating-knots-linear-in-crossing-number). Open for alternating *links* (Remark 3.3).

## Links

* **Non-split k-component link:** Rop ≥ 4πk R [2πk D] ([DDS04] Cor 10.2); sharp for the tight Hopf link (two round circles, 8π R).
* **One component K linked to n disjoint sublinks:** Len(K) ≥ 2π + P_n, P_n = shortest curve enclosing n disjoint unit disks (P_1 = 2π, P_n = 2π + 2n for 2 ≤ n ≤ 5) ([CKS01] Thm 10). Sharp for n ≤ 5; simple chains of k rings have exact ropelength (4π + 4)k − 8, showing minimizers need not be C² ([CKS01] Fig. 1).
* **Linking number:** Len(K) ≥ 2π + 2π√Lk(J, K) ([CKS01] Thm 11). (2,4) torus link ≥ 4π(1 + √2) ≈ 30.34 (⚠ [CKS01] prints 33.34); numerical ≈ 41.2.
* **Asymptotic crossing number / Thurston norm:** Len(K) ≥ 2π + 2π√AC(K, L), ≥ 4π + 2π√AC if K is knotted ([CKS01] Thm 21); Len(K) ≥ 2π(1 + √χ_−(K, L)) (Cor 22).
* **Quadrisecant types** for a component A ([DDS04] Thm 10.6, R-units = 2×): AAAB ≥ 2(7π/3 + 2√3), AABA ≥ 2(8π/3 + 1 + √3), ABBA and ABCA ≥ 2(2π + 2).
* **Milnor invariants** ([KM16] Thm A): Rop(L)^{4/3} ≥ ∛n·[μ̄(L)]^{1/(n−1)} for top Milnor linking numbers of n-component links; pairwise linking: Rop^{4/3} ≥ (6n^{1/3}/(n−1))Σ|Lk|, Rop² ≥ (32πn²/(n²−1))Σ|Lk| (Cor H); pairwise crossing number versions (Cor I).
* **Borromean rings:** 12π ≈ 37.70 from [CKS01] Thm 10 (genus bound); 6√(6π) ≈ 26.05 from Milnor μ̄ ([KM16] eq. 5.13 — better than linking number 6π but below 12π); would be 6π(1 + √2) ≈ 45.51 if AC = Cr; best configuration ≈ 58.05 ([CKS01] p. 25–26).

## Existence and regularity

Every tame link type has a ropelength minimizer, and minimizers are C^{1,1} ([CKS01] Thm 7). Thickness = reach = normal injectivity radius (Lemma 2). Conjecture: minimizers are piecewise analytic (Conj. 24).

## Pending

[DEPZ09] (O(c log⁵ c) upper bound), [KM21], [KT25], [Klotz26llm], [Klotz26pearl], [KA23] numerics and [Klotz26tqq] torus links feed [upper-bounds](upper-bounds.md) and [numerics](numerics.md).
