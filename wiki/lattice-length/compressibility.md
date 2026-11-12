# Compressibility of minimal lattice knots

Uses the full sets of minimal-length polygons from [JvRR11] to define a pressure ensemble on their *volumes*, then asks how compressible each knot type is ([JvRR12comp]). All results are numerical: they assume the GAS-sampled lists of minimal polygons are complete (see reliability caveats in [algorithms/bfacf-and-gas](../algorithms/bfacf-and-gas.md)). Counts are up to translation; chemical length = n × edge length (1, √2, √3 for SC, FCC, BCC).

## Volumes used

* **V_b — box volume:** smallest axis-parallel box containing the polygon ("a large overestimate").
* **V_e — averaged excluded volume:** mean over x, y, z of the union of unit-thickness slabs whose cross-sections are the 2-D convex hulls of the vertices in each lattice plane. V_e ≤ V_b, and V_e = 0 for every minimal unknot.

## Ensemble

Z_L(K) = Σ_v p_L(v; K) e^{−p v}, F = −log Z, ⟨V⟩ = ∂F/∂p, compressibility **β(p) = −∂ log⟨V⟩/∂p** (isothermal, k_BT = 1). W_K = work of reversible expansion from the minimum-volume state to p = 0 (a free-energy difference).

Worked examples ([JvRR12comp] eqs 1–3):
* BCC unknot (V_b): Z = 6e^{−8p} + 6e^{−4p} (two classes, boxes 2×2×2 and 2×2×1); β(0) = 2/3, maximum 0.686 at p = 0.0866; W = log 2. The unknot is incompressible in SC and FCC (V_b) and in all lattices for V_e.
* SC trefoil (V_b): Z = 1220e^{−27p} + 432e^{−18p} + 12e^{−16p} (sums to 1664 = one chirality); β(0) = 0.653, global max 0.928 at p = 0.136, a second local max 0.059 at p = 1.82; W = log(416/3) = 4.932 (same for V_e). Minimal V_b = 16, minimal V_e = 8.
* FCC trefoil: all 64 minimal polygons have V_e = 13/2, so β ≡ 0 for V_e; V_b β(0) = 1.177. BCC trefoil is more compressible than FCC for both volumes.

## Main findings ([JvRR12comp] §3–5)

1. **β(p) is not monotone** in pressure (unlike linear polymers): many knots have a maximum at p > 0, some a second local maximum (SC, V_b: 3_1, 5_1, 6_2, 9_2, 10_1).
2. **Topology matters:** e.g. SC V_b 6_3 is the most compressible six-crossing knot and 6_1 the least; 5_2 is more compressible than 5_1. Incompressible (SC, V_b): 0_1, 7_3, 8_5, 8_6; (SC, V_e): 0_1, 8_7. Largest SC β(0) for V_b: **8_3** (3.98), whose single minimal class is very compact (minimal V_b = 27, smaller than any 5–8 crossing knot).
3. **Geometry matters:** little correlation of β(0) between lattices; FCC knots tend to be more compressible for V_b but not for V_e; V_b-compressibility generally exceeds V_e-compressibility.
4. Max compressibility and W_K are strongly correlated for V_e in SC (outliers 9_47, 10_1); knots with local maxima of β have larger W_K.
5. Largest work: SC V_e 9_2 (W = 11.13); FCC 8_1 (8.45 V_b, 9.14 V_e); BCC 8_4 (7.58, V_b) and 8_2 (7.81, V_e).

Full per-knot tables (β(0), position and value of maxima, W_K, minimal V_b and V_e) for SC, FCC, BCC and SC composites are in `_extracts/JvRR12comp.md` (Tables 3–11).

⚠ Source inconsistencies noted by the extractor: W_{6_2} (SC, V_e) printed as "log(36/19)" but valued 6.52795 = log 684; the text's claim that 3_1^+#5_2^+ is "most compressible" among composites holds for W_K but not for β(0) or max β.

## Relation to other pages

* Same minimal-polygon data: [minimal-polygon-census](minimal-polygon-census.md).
* Squeezing between walls (slabs) rather than by pressure on volume: [confinement-slabs](confinement-slabs.md).
