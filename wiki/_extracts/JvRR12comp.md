# JvRR12comp — The Compressibility of Minimal Lattice Knots
- **Authors:** E. J. Janse van Rensburg, A. Rechnitzer
- **Venue / year / identifiers:** arXiv:1203.3212v1 [cond-mat.soft], 14 Mar 2012 (no journal reference printed in this file; PACS 02.50.Ng, 02.70.Uu, 05.10.Ln, 36.20.Ey, 61.41.+e, 64.60.De, 89.75.Da; AMS 82B41, 82B80)
- **File:** papers/1_core_lattice_length/JvR-Rechnitzer_2012_Compressibility_of_minimal_lattice_knots_1203.3212.pdf   **Pages:** 32
- **Text layer:** partly garbled (prose ok; table columns recoverable in order; fraction formulas garbled)

## Abstract
The (isothermic) compressibility of lattice knots can be examined as a model of the effects of topology and geometry on the compressibility of ring polymers. In this paper, the compressibility of minimal length lattice knots in the simple cubic, face centered cubic and body centered cubic lattices are determined. Our results show that the compressibility is generally not monotonic, but in some cases increases with pressure. Differences of the compressibility for different knot types show that topology is a factor determining the compressibility of a lattice knot, and differences between the three lattices show that compressibility is also a function of geometry.

## Notation and conventions
- (p. 4) SC lattice = Z³ with basis {(1,0,0),(0,1,0),(0,0,1)}, edge length 1. FCC: basis {(±1,±1,0),(±1,0,±1),(0,±1,±1)} (all sign choices), edges of length √2. BCC: basis {(±1,±1,±1)}, edges of length √3.
- (p. 4) Polygon length n = number of edges; **chemical length** = n × edge length (SC n; FCC n√2; BCC n√3), which "coincides with the geometric length".
- (p. 4) "Polygons will be considered to be identical if one is a translate of the other." So all counts are up to translation only.
- (p. 4) P_K = set of minimal length (length n_K) polygons of knot type K; p_L(K) = |P_K| in lattice L. p_SC(0_1)=3, p_FCC(0_1)=8, p_BCC(0_1)=12. Minimal unknot length: 4 (SC), 3 (FCC), 4 (BCC).
- (p. 5) V_b = box volume = volume of the smallest axis-parallel rectangular box containing the knot (a "large overestimate"); V_C = convex hull volume ≤ V_b. p_L(v;K) = number of minimal polygons of knot type K with box volume v; Σ_v p_L(v;K) = p_L(K). Example: p_SC(0;0_1)=3, p_FCC(1;0_1)=8, p_BCC(8;0_1)=6, p_BCC(4;0_1)=6 (two BCC classes, boxes 2×2×2 and 2×2×1).
- (p. 5–6) V_e = averaged excluded volume = (V_x+V_y+V_z)/3; V_z = union of slabs S_z = C_z × [z−1/2, z+1/2] (end slabs half-height: S_{z_0}=C_{z_0}×[z_0, z_0+1/2], S_{z_m}=C_{z_m}×[z_m−1/2, z_m]), C_z = 2-D convex hull of the polygon's vertices in plane P_z; V_x, V_y analogous. V_e ≤ V_b; V_e = 0 for minimal unknots in SC, FCC, BCC (p. 6).
- (p. 8) Z_L(K) = Σ_v p_L(v;K) e^{−p v}; F_L(K) = −log Z_L(K) (natural log; k_BT = 1, lattice units). ⟨V⟩ = ∂F/∂p; compressibility β = −∂ log⟨V⟩/∂p ("fractional change in expected volume due to an increment in pressure", p. 9), isothermal.
- Work W_K (p. 9–10) = maximum useful work from reversible isothermal expansion from the minimal-volume state to equilibrium at p = 0 = free-energy difference between those states.
- Table headers: β(0) = compressibility at p=0; p_m = pressure at global maximum of β(p); max β(p) = its value; loc p_m / local max β(p) = position/value of secondary local maximum; W_K; Min V_b / Min V_e = least V over minimal-length polygons of that type. "−" = none / not applicable.
- K^+ marks one chirality; compounds written 3_1^+#3_1^+ etc.

## Numbered statements
No theorems or numbered conjectures. All results are numerical (GAS-sampled minimal-length data assumed complete), given as displayed equations:
- **Eq. (1) (p. 8).** F_BCC(0_1) = −log(6e^{−8p} + 6e^{−4p}) (V_b).
- **Unknot (pp. 8–10).** Z_SC(0_1)=3, Z_FCC(0_1)=8e^{−p}, Z_BCC(0_1)=6e^{−8p}+6e^{−4p} (V_b); with V_e: 3, 8, 12. ⟨V_b⟩_BCC = 4(1+2e^{−4p})/(1+e^{−4p}) (=6 at p=0, →4 as p→∞); β_BCC(0_1) = 4e^{−4p}/((1+e^{−4p})(1+2e^{−4p})) (garbled in text layer; consistent with β(0)=2/3 stated in Fig. 7 caption). Global max at p=0.08664… with β=0.68629…. Unknot incompressible in SC, FCC (V_b) and in all three lattices for V_e. W_{0_1} = log 12 − log 6 = log 2 (BCC, V_b).
- **Eq. (2) (p. 11).** Z_SC(3_1^+) = 1220e^{−27p} + 432e^{−18p} + 12e^{−16p} (V_b). ⟨V_b⟩ = 3(2745e^{−27p}+648e^{−18p}+16e^{−16p})/(305e^{−27p}+108e^{−18p}+3e^{−16p}); β = (889380e^{−45p}+36905e^{−43p}+432e^{−34p})/[(2745e^{−27p}+648e^{−18p}+16e^{−16p})(305e^{−27p}+108e^{−18p}+3e^{−16p})]. β(0)=0.65347…; global max p=0.13557… (β=0.92845…); local max p=1.82115… (β=0.05888…).
- **Eq. (3) (p. 12).** Z_SC(3_1^+) with V_e = 84e^{−32p/3} + 24e^{−65p/6} + 300e^{−10p} + 96e^{−61p/6} + 240e^{−59p/6} + 128e^{−21p/2} + 48e^{−28p/3} + 168e^{−31p/3} + 48e^{−19p/2} + 72e^{−29p/3} + 12e^{−11p} + 72e^{−103p/12} + 192e^{−53p/6} + 48e^{−26p/3} + 24e^{−35p/4} + 48e^{−17p/2} + 24e^{−25p/3} + 24e^{−101p/12} + 12e^{−8p} (coefficients sum to 1664). Global max p=0.61046… (β=0.05907…); secondary maximum absent.
- **W for SC trefoil (p. 13).** W_{3_1^+} = log 1664 − log 12 = log(416/3) = 4.93207… (same for V_b and V_e).
- **4_1, SC (p. 14).** W_{4_1} = log(38/9) = 1.44036… (V_b); log 38 = 3.63759… (V_e).
- **5-crossing, SC (p. 14).** V_b maxima: 5_1^+ at p=0 (β=0.82695…), 5_2^+ at p=0.13237… (β=1.22294…); 5_1^+ local max p=1.43622… (β=0.03260…). V_e global maxima: p=1.43811… (β=0.01308…) [5_1^+], p=1.11177… (β=0.06718…) [5_2^+]. W_{5_1^+} = log(139/5) = 3.32504… (V_b), log 139 = 4.93447… (V_e); W_{5_2^+} = log(133/5) = 3.28091… (V_b), log 2394 = 7.78072… (V_e). 5_2^+ more compressible than 5_1^+ for both volumes.
- **6-crossing, SC (pp. 14–15).** V_b global maxima: p=0.22958… (β=0.81816…) [6_1^+]; p=0.09103… (β=0.94524…) [6_2^+] with local max p=1.20977… (β=0.04840…); p=0.04118… (β=1.33719…) [6_3]. V_e: p=0.61767… (β=0.02723…) [6_1^+]; p=0.66097… (β=0.04609…) [6_2^+]; p=0.37398… (β=0.05988…) [6_3]. Work (V_b): W_{6_1^+}=log(128/9)=2.65481…, W_{6_2^+}=log 171=5.14166…, W_{6_3}=log(74/9)=2.10684…. Work (V_e): W_{6_1^+}=log 256=5.54517…, W_{6_2^+}=log(36/19)=6.52795… ⚠ (as printed; log(36/19)=0.64, and 6.52795=log 684, matching Table 4's 6.52796), W_{6_3}=log 74=4.30406…. 6_3 most compressible, 6_1^+ least (both volumes).
- **FCC / BCC trefoil (pp. 19–21).** V_b: Z_FCC(3_1^+) = 16e^{−27p}+48e^{−24p}; Z_BCC(3_1^+) = 24e^{−125p}+480e^{−100p}+696e^{−80p}+384e^{−75p}. V_e: Z_FCC = 64e^{−13p/2} (Eq. 4); Z_BCC = 168e^{−16p}+240e^{−52p/3}+432e^{−50p/3}+144e^{−53p/3}+288e^{−17p}+72e^{−18p}+96e^{−55p/3}+24e^{−56p/3}+96e^{−47p/3}+24e^{−44p/3} (Eq. 5). ⟨V_e⟩=13/2 independent of p in FCC so β≡0. V_b: global β max at p=0, β=1.17690… (FCC), 1.48918… (BCC), then monotone decrease. V_e BCC: global max p=1.62452… (β=0.04773…). W_{3_1^+}: log(4/3)=0.28768… (FCC, V_b); log(33/8)=1.41707… (BCC, V_b); 0 (FCC, V_e); log 66=4.18965… (BCC, V_e). 3_1^+ more compressible in BCC than FCC for both volumes.
- **4_1, FCC/BCC (p. 21).** FCC: V_b max β=1.17690… at p=0; V_e max at p=0.86318… (β=0.07938…). Incompressible in BCC for both volumes. W_{4_1}=log(233/16)=2.67844… (FCC, V_b), log(233/8)=3.37159… (FCC, V_e) (⚠ Tables 7, 8 print 2.67845 and 3.37160).

## Key equations and quantitative claims outside numbered statements
- p. 2: compressibility of linear polymers is monotone non-increasing with pressure [20, 28]; here β of lattice knots is non-monotone.
- p. 2–3: 75 symmetry classes of right-handed lattice trefoils expand to 1664 polygons when rotational degrees of freedom are included [25].
- p. 10 (methods data): GAS runs of up to 500 sequences each of length 10⁷ (numerical).
- p. 15 (Table 3 discussion): incompressible knots include 0_1, 7_3^+, 8_5^+, 8_6^+; largest β(0) is 8_3 (3.98158…) (also largest overall); only 3_1^+, 5_1^+, 6_2^+, 9_2^+, 10_1^+ have local maxima (SC, V_b); W_K between 0 and 3 for most, > 4 for 3_1^+, 6_2^+, 7_5^+, 8_2^+, 8_15^+, 9_2^+, 10_1^+, 10_2^+. Minimal V_b: trefoil 16; 6_1^+ smallest among 6-crossing (36); 7_1^+ among 7-crossing (40); 8_3 = 27, smaller than any 5/6/7/8-crossing knot.
- p. 17 (Table 4, SC, V_e): all knots compressible except 0_1 and 8_7^+; max compressibility 10_1^+ at p=1.29256… (β=0.33799…); largest β(0) is 10_2^+; no secondary local maxima; W_K between 0 and 6 mostly, > 6 for 5_2^+, 6_2^+, 7_1^+, 7_2^+, 8_1^+, 8_2^+, 8_4^+, 8_9, 8_13^+, 8_15^+, 8_19^+, 8_21^+, 9_1^+, 9_2^+, 10_1^+, 10_2^+; W_{9_2^+}=11.13255…; min V_e(3_1^+)=8 (half of V_b = 16); min V_e(8_3)=12.
- p. 22 (FCC, Tables 7–8): max β mostly at p=0; V_b secondary local maxima only 7_1^+ (loc p_m 0.46211, value 0.17066) and 8_11^+ (0.58372, 0.18936), agreeing with Table 7; V_e only 8_18 (Table 8: 0.85036 on row 8_18). V_b = 45 for 8_18, 8_19^+, 8_20^+; V_b(8_1^+) = 48. Max work: 8_1^+ with W=8.44779… (V_b), 9.14094… (V_e).
- p. 22 (BCC, Tables 9–10): unknot max β at p=0.08664…; V_b secondary maxima: 6_3, 7_1^+, 8_4^+, 8_7^+, 8_9, 8_18, 9_2^+, 9_47^+; V_e: 6_2^+, 7_3^+, 9_2^+. V_b = 144 for 8_1^+, 8_3, 8_12, 8_18, 8_19^+. Max W: 8_4^+ 7.57968… (Table 9), 8_2^+ 7.80792… (Table 10).
- p. 27: Table 10: 8_19^+ and 8_20^+ have V_e = 42 and 134/3. V_b-compressibility generally exceeds V_e-compressibility (box corner room); little correlation of β(0) across lattices (Figs. 15–17); FCC more compressible than SC/BCC for V_b but not for V_e.
- p. 29: max compressibility and W_K strongly correlated for V_e, SC (Fig. 18), outliers 9_47^+, 10_1^+. Knot types with local β maxima have higher W_K.
- p. 30: qualitative conclusions: (1) β non-monotone, up to two local maxima; (2) weak trend of larger β(0) down the tables; (3) FCC knots likely more compressible with V_b, not with V_e.
- p. 31: compound knots (Table 11): text says 3_1^+#5_2^+ is most compressible with largest W_K and 3_1^+#5_2^− least compressible with lowest W_K for both volumes. ⚠ By the table, W_K is largest for 3_1^+#5_2^+ (9.99405 V_b, 11.24682 V_e) and lowest for 3_1^+#5_2^− (2.90872; 4.00733), but β(0) is largest for 4_1#4_1 (V_b: 2.30417) and max β largest for 3_1^+#5_1^+ (2.91011), so "most compressible" holds only loosely.

## Methods / algorithms
1. Sample minimal-length polygons of fixed knot type in SC, FCC, BCC with GAS using BFACF-type atmospheric moves (SC: BFACF [1,2,17]; FCC/BCC: moves of [16]); irreducible on fixed knot type; hash coding, O(1) moves (p. 10).
2. Up to 500 GAS sequences of length 10⁷; minimal polygons detected, classified by symmetry class, stored by hashing and written to disk (p. 10).
3. Compute V_b and V_e for each symmetry class; assemble Z_L(K) = Σ p_L(v;K)e^{−pv} (Tables 1, 2, 5, 6).
4. F = −log Z; ⟨V⟩ = ∂F/∂p; β = −∂log⟨V⟩/∂p; locate maxima numerically; W_K from free-energy difference (pp. 8–10).
5. Cover prime knots to 8 crossings plus 9_1, 9_2, 9_42, 9_47, 10_1, 10_2 and 8 compound knots (Tables 3, 4, 7–11).

## Tables
Tables 1, 2, 5, 6 are partition functions with long cells: Table 1 is inline, Tables 2, 5, 6 are in `wiki/data/JvRR12comp_table2.csv`, `…_table5.csv`, `…_table6.csv` (columns knot, partition_function; verbatim from the text layer, row/knot alignment checked against known entries). Tables 3, 4, 7–10 inline, built column-by-column from the text layer (exactly 42 tokens per column, so no misalignment); Tables 3 and 9 checked cell-by-cell against 100-dpi page images (no differences found); Tables 4, 7, 8, 10 not image-checked.

**Table 1 (p. 11)** — "Partition Functions: Minimal SC lattice knots in a Pressurized Rectangular Box." (Z_SC(p), volume V_b)

| Knot | Z_SC(p) |
|---|---|
| 0_1 | 01   3 |
| 3_1 | 3+1  1220e−27p + 432e−18p + 12e−16p |
| 4_1 | 41   2784e−36p + 864e−27p |
| 5_1 | 5+1  432e−48p + 624e−36p + 2160e−32p + 120e−30p |
| 5_2 | 5+2  40536e−48p + 4200e−45p + 10560e−36p + 2160e−30p |
| 6_1 | 61+  2640e−48p + 216e−45p + 216e−36p |
| 6_2 | 62+  7560e−64p + 5256e−60p + 3504e−48p + 96e−45p |
| 6_3 | 63   2208e−64p + 912e−48p + 432e−45p |
| 7_1 | 71+  288e−80p + 252e−64p + 11808e−60p + 300e−54p + 468e−48p + 264e−45p + 3600e−40p |
| 7_2 | 7+2  22404e−80p + 2880e−75p + 13032e−64p + 85008e−60p + 11712e−54p + 22512e−48p + 10632e−45p |
| 7_3 | 7+3  240e−45p |
| 7_4 | 7+4  24e−64p + 60e−60p |
| 7_5 | 75+  4392e−64p + 216e−60p + 96e−48p + 24e−45p |
| 7_6 | 7+6  10368e−80p + 4728e−64p + 1920e−60p |
| 7_7 | 77+  168e−80p + 84e−64p |

**Table 2 (p. 12)** — "Partition Functions: Minimal SC lattice knots in pressurized in their averaged excluded volumes." Full expressions in `wiki/data/JvRR12comp_table2.csv` (0_1: 3; 3_1^+: the 19-term Eq. (3); 4_1, 5_1^+, 5_2^+: long sums). ⚠ Typos in the printed table: the 5_1^+ expression begins "96e^{−29/2}" (no p); the 5_2^+ expression contains "504e^{33p/2}" (no minus sign) — kept as printed.

**Table 3 (p. 16)** — "Compressibility of SC Lattice Knots with volume V_b."

| Knot | β(0) | p_m | max β(p) | loc p_m | local max β(p) | W_K | Min V_b |
|---|---|---|---|---|---|---|---|
| 0_1 | 0 | – | – | – | – | 0 | 0 |
| 3_1^+ | 0.65347 | 0.13557 | 0.92845 | 1.82115 | 0.05888 | 4.93207 | 16 |
| 4_1 | 0.43228 | 0.14599 | 0.64617 | – | – | 1.44036 | 27 |
| 5_1^+ | 0.82695 | 0 | 0.82695 | 1.43622 | 0.03260 | 3.32504 | 30 |
| 5_2^+ | 0.66116 | 0.13237 | 1.22294 | – | – | 3.28091 | 30 |
| 6_1^+ | 0.20546 | 0.22958 | 0.81816 | – | – | 2.65481 | 36 |
| 6_2^+ | 0.65497 | 0.09103 | 0.94525 | 1.20977 | 0.04840 | 5.14166 | 45 |
| 6_3 | 1.18846 | 0.04119 | 1.33719 | – | – | 2.10684 | 45 |
| 7_1^+ | 1.43410 | 0.06558 | 1.93627 | – | – | 1.55110 | 40 |
| 7_2^+ | 1.56522 | 0 | 1.56522 | – | – | 2.76117 | 45 |
| 7_3^+ | 0 | – | – | – | – | 0 | 45 |
| 7_4^+ | 0.05340 | 0 | 0.05340 | – | – | 0.33647 | 60 |
| 7_5^+ | 0.11667 | 0.23179 | 1.28010 | – | – | 5.28320 | 45 |
| 7_6^+ | 0.97333 | 0.03759 | 1.07580 | – | – | 2.18183 | 60 |
| 7_7^+ | 0.76190 | 0.05029 | 0.89165 | – | – | 1.09861 | 64 |
| 8_1^+ | 1.31169 | 0.04611 | 1.49428 | – | – | 3.56449 | 48 |
| 8_2^+ | 2.49340 | 0 | 2.49340 | – | – | 4.61042 | 48 |
| 8_3 | 3.98158 | 0 | 3.98158 | – | – | 2.12193 | 27 |
| 8_4^+ | 0.23441 | 0.18360 | 1.03728 | – | – | 3.68587 | 60 |
| 8_5^+ | 0 | – | – | – | – | 0 | 80 |
| 8_6^+ | 0 | – | – | – | – | 0 | 80 |
| 8_7^+ | 0 | – | – | – | – | 0 | 60 |
| 8_8^+ | 0 | – | – | – | – | 0 | 80 |
| 8_9 | 0.60841 | 0.09961 | 1.43594 | – | – | 1.99470 | 60 |
| 8_10^+ | 0 | – | – | – | – | 0 | 80 |
| 8_11^+ | 0 | – | – | – | – | 0 | 80 |
| 8_12 | 1.21212 | 0.04185 | 1.43594 | – | – | 1.09861 | 60 |
| 8_13^+ | 1.78904 | 0 | 1.78904 | – | – | 1.62612 | 64 |
| 8_14^+ | 0 | – | – | – | – | 0 | 80 |
| 8_15^+ | 2.36553 | 0 | 2.36553 | – | – | 4.45076 | 48 |
| 8_16^+ | 0 | – | – | – | – | 0 | 80 |
| 8_17 | 1.26959 | 0.04260 | 1.43108 | – | – | 3.54458 | 64 |
| 8_18 | 0 | – | – | – | – | 0 | 100 |
| 8_19^+ | 1.16978 | 0.04525 | 1.34959 | – | – | 2.09152 | 45 |
| 8_20^+ | 0 | – | – | – | – | 0 | 60 |
| 8_21^+ | 0.36279 | 0.15514 | 0.95539 | – | – | 2.33082 | 48 |
| 9_1^+ | 2.99129 | 0 | 2.99129 | – | – | 1.62095 | 50 |
| 9_2^+ | 1.97047 | 0 | 1.97047 | 0.40139 | 0.60045 | 7.39488 | 48 |
| 9_42^+ | 0.80392 | 0 | 0.80392 | – | – | 2.00459 | 60 |
| 9_47^+ | 1.81376 | 0 | 1.81376 | – | – | 0.26236 | 80 |
| 10_1^+ | 1.66066 | 0 | 1.66066 | 0.18995 | 0.98320 | 6.97624 | 54 |
| 10_2^+ | 3.12685 | 0 | 3.12685 | – | – | 4.57009 | 60 |

**Table 4 (p. 18)** — "Compressibility of SC Lattice Knots with volume V_e."

| Knot | β(0) | p_m | max β(p) | loc p_m | local max β(p) | W_K | Min V_e |
|---|---|---|---|---|---|---|---|
| 0_1 | 0 | – | – | – | – | 0 | 0 |
| 3_1^+ | 0.05167 | 0.61046 | 0.05907 | – | – | 4.93207 | 8 |
| 4_1 | 0.02684 | 1.22731 | 0.03290 | – | – | 3.63759 | 12 |
| 5_1^+ | 0.01159 | 1.43811 | 0.01308 | – | – | 4.93447 | 14 |
| 5_2^+ | 0.04600 | 1.11177 | 0.06718 | – | – | 7.78072 | 44/3 |
| 6_1^+ | 0.02500 | 0.61768 | 0.02724 | – | – | 5.54518 | 37/2 |
| 6_2^+ | 0.03982 | 0.66098 | 0.04609 | – | – | 6.52796 | 113/6 |
| 6_3 | 0.05438 | 0.37398 | 0.05989 | – | – | 4.30407 | 37/2 |
| 7_1^+ | 0.03748 | 0.15097 | 0.03787 | – | – | 6.56174 | 121/6 |
| 7_2^+ | 0.05004 | 0.02186 | 0.05005 | – | – | 8.85474 | 85/4 |
| 7_3^+ | 0.00354 | 0.53600 | 0.00357 | – | – | 2.30259 | 65/3 |
| 7_4^+ | 0.00706 | 0.93823 | 0.00819 | – | – | 1.25276 | 68/3 |
| 7_5^+ | 0.01311 | 1.95942 | 0.04274 | – | – | 5.28320 | 68/3 |
| 7_6^+ | 0.03711 | 0 | 0.03711 | – | – | 5.87071 | 143/6 |
| 7_7^+ | 0.03062 | 0.56027 | 0.03859 | – | – | 1.65823 | 139/6 |
| 8_1^+ | 0.06928 | 0 | 0.06928 | – | – | 6.20355 | 73/3 |
| 8_2^+ | 0.07573 | 0 | 0.07573 | – | – | 7.55486 | 293/12 |
| 8_3 | 0.02684 | 1.22731 | 0.03290 | – | – | 3.63759 | 12 |
| 8_4^+ | 0.03488 | 0.53631 | 0.03840 | – | – | 6.21160 | 311/12 |
| 8_5^+ | 0.01102 | 0.08509 | 0.01103 | – | – | 3.17805 | 167/6 |
| 8_6^+ | 0.01169 | 0.63470 | 0.01226 | – | – | 5.43808 | 167/6 |
| 8_7^+ | 0 | – | – | – | – | 0 | 77/3 |
| 8_8^+ | 0.01758 | 0 | 0.01758 | – | – | 3.48124 | 57/2 |
| 8_9 | 0.04620 | 0.55186 | 0.05906 | – | – | 6.59987 | 79/3 |
| 8_10^+ | 0.00935 | 0.47816 | 0.00954 | – | – | 3.55535 | 28 |
| 8_11^+ | 0.00299 | 0.01757 | 0.00299 | – | – | 0.69315 | 169/6 |
| 8_12 | 0.01639 | 0.47743 | 0.01709 | – | – | 3.98898 | 83/3 |
| 8_13^+ | 0.05487 | 0.17977 | 0.05581 | – | – | 6.29895 | 161/6 |
| 8_14^+ | 0.00514 | 0.23152 | 0.00516 | – | – | 2.70805 | 169/6 |
| 8_15^+ | 0.05797 | 0.77810 | 0.07990 | – | – | 7.42118 | 76/3 |
| 8_16^+ | 0.00367 | 0.01653 | 0.00367 | – | – | 0.69315 | 359/12 |
| 8_17 | 0.03236 | 1.33662 | 0.03686 | – | – | 5.62402 | 343/12 |
| 8_18 | 0.01720 | 0.53164 | 0.01797 | – | – | 3.61092 | 377/12 |
| 8_19^+ | 0.06651 | 0.47415 | 0.08667 | – | – | 6.36819 | 107/6 |
| 8_20^+ | 0.00291 | 0.60279 | 0.00298 | – | – | 1.60944 | 275/12 |
| 8_21^+ | 0.05177 | 0.54428 | 0.05510 | – | – | 7.06262 | 263/12 |
| 9_1^+ | 0.07013 | 0.31127 | 0.07755 | – | – | 8.88288 | 103/4 |
| 9_2^+ | 0.04825 | 0.66653 | 0.05275 | – | – | 11.13255 | 169/6 |
| 9_42^+ | 0.02316 | 0.12142 | 0.02312 | – | – | 6.36130 | 289/12 |
| 9_47^+ | 0.02259 | 1.15783 | 0.19259 | – | – | 5.65599 | 101/4 |
| 10_1^+ | 0.05728 | 1.29256 | 0.33799 | – | – | 9.17347 | 83/3 |
| 10_2^+ | 0.07893 | 0 | 0.07893 | – | – | 9.11339 | 377/12 |

**Table 5 (p. 19)** — "Partition Functions: Minimal FCC lattice knots pressurized in a rectangular box." Full in `wiki/data/JvRR12comp_table5.csv` (0_1: 8; 3_1^+: 16e^{−27p}+48e^{−24p}; 4_1: 24e^{−64p}+576e^{−48p}+348e^{−45p}+1416e^{−36p}+192e^{−32p}+48e^{−30p}+192e^{−27p}; …). The knot-label column is vertically staggered in the PDF; expressions assigned to knots in order (0_1 first) and checked against Z_FCC(3_1^+) and the minimal V_b of Table 7.

**Table 6 (p. 20)** — "Partition Functions: Minimal BCC lattice knots pressurized in a rectangular box." Full in `wiki/data/JvRR12comp_table6.csv` (0_1: 6e^{−8p}+6e^{−4p}; 3_1^+: 24e^{−125p}+480e^{−100p}+696e^{−80p}+384e^{−75p}; 4_1: 12e^{−80p}; …), same alignment caveat; checked against Z_BCC(0_1), Z_BCC(3_1^+).

**Table 7 (p. 23)** — "Compressibility of FCC Lattice Knots with volume V_b."

| Knot | β(0) | p_m | max β(p) | loc p_m | local max β(p) | W_K | Min V_b |
|---|---|---|---|---|---|---|---|
| 0_1 | 0 | – | – | – | – | 0 | 0 |
| 3_1^+ | 0.06818 | 0 | 0.06818 | – | – | 0.28768 | 24 |
| 4_1 | 1.17690 | 0 | 1.17690 | – | – | 2.67845 | 27 |
| 5_1^+ | 0.54661 | 0.10381 | 0.72940 | – | – | 1.38629 | 36 |
| 5_2^+ | 1.84036 | 0 | 1.84036 | – | – | 2.77259 | 40 |
| 6_1^+ | 2.78110 | 0 | 2.78110 | – | – | 5.98141 | 40 |
| 6_2^+ | 2.28512 | 0 | 2.28512 | – | – | 2.57452 | 45 |
| 6_3 | 2.31350 | 0 | 2.31350 | – | – | 4.77819 | 36 |
| 7_1^+ | 1.63106 | 0.02343 | 1.65022 | 0.46211 | 0.17066 | 4.44265 | 54 |
| 7_2^+ | 2.63144 | 0 | 2.63144 | – | – | 3.76120 | 45 |
| 7_3^+ | 2.10233 | 0 | 2.10233 | – | – | 1.60944 | 60 |
| 7_4^+ | 0.03030 | 0.27976 | 0.04082 | – | – | 1.38629 | 96 |
| 7_5^+ | 2.86502 | 0 | 2.86502 | – | – | 4.15191 | 54 |
| 7_6^+ | 2.77693 | 0 | 2.77693 | – | – | 2.14007 | 48 |
| 7_7^+ | 2.79374 | 0 | 2.79374 | – | – | 1.90954 | 48 |
| 8_1^+ | 3.54811 | 0 | 3.54811 | – | – | 8.44779 | 48 |
| 8_2^+ | 3.08699 | 0 | 3.08699 | – | – | 5.59306 | 54 |
| 8_3 | 3.39870 | 0 | 3.39870 | – | – | 3.10109 | 60 |
| 8_4^+ | 3.35418 | 0 | 3.35418 | – | – | 3.75654 | 60 |
| 8_5^+ | 1.21929 | 0 | 1.21929 | – | – | 3.43399 | 63 |
| 8_6^+ | 3.92441 | 0 | 3.92441 | – | – | 3.08089 | 60 |
| 8_7^+ | 1.61860 | 0 | 1.61860 | – | – | 1.46634 | 64 |
| 8_8^+ | 2.82549 | 0 | 2.82549 | – | – | 2.06369 | 60 |
| 8_9 | 3.13220 | 0 | 3.13220 | – | – | 2.60269 | 60 |
| 8_10^+ | 2.03727 | 0 | 2.03727 | – | – | 0.81093 | 80 |
| 8_11^+ | 3.10730 | 0 | 3.10730 | 0.58372 | 0.18936 | 8.04093 | 54 |
| 8_12 | 3.14959 | 0.00838 | 3.16225 | – | – | 2.65676 | 60 |
| 8_13^+ | 3.25299 | 0 | 3.25299 | – | – | 5.24965 | 48 |
| 8_14^+ | 3.07391 | 0 | 3.07391 | – | – | 2.12613 | 60 |
| 8_15^+ | 2.67195 | 0 | 2.67195 | – | – | 4.84024 | 60 |
| 8_16^+ | 1.88507 | 0 | 1.88507 | – | – | 1.21640 | 64 |
| 8_17 | 1.81676 | 0 | 1.81676 | – | – | 1.21640 | 64 |
| 8_18 | 3.11696 | 0.01503 | 3.16790 | – | – | 3.28916 | 45 |
| 8_19^+ | 0.25869 | 0.17760 | 1.50198 | – | – | 3.13549 | 45 |
| 8_20^+ | 1.73255 | 0 | 1.73255 | – | – | 5.95551 | 45 |
| 8_21^+ | 2.06897 | 0 | 2.06897 | – | – | 2.39253 | 60 |
| 9_1^+ | 2.00000 | 0.01014 | 2.02041 | – | – | 1.38629 | 80 |
| 9_2^+ | 3.82335 | 0 | 3.82335 | – | – | 5.21577 | 60 |
| 9_42^+ | 0 | – | – | – | – | 0 | 80 |
| 9_47^+ | 0.92683 | 0.10758 | 1.04061 | – | – | 2.36712 | 64 |
| 10_1^+ | 4.11636 | 0 | 4.11636 | – | – | 4.13116 | 80 |
| 10_2^+ | 4.42190 | 0 | 4.42190 | – | – | 3.02852 | 80 |

**Table 8 (p. 24)** — "Compressibility of FCC Lattice Knots with volumes V_e."

| Knot | β(0) | p_m | max β(p) | loc p_m | local max β(p) | W_K | Min V_e |
|---|---|---|---|---|---|---|---|
| 0_1 | 0 | – | – | – | – | 0 | 0 |
| 3_1^+ | 0 | – | – | – | – | 0 | 13/2 |
| 4_1 | 0.05773 | 0.86318 | 0.07939 | – | – | 3.37160 | 61/6 |
| 5_1^+ | 0.01793 | 1.00305 | 0.02393 | – | – | 1.38629 | 37/3 |
| 5_2^+ | 0.02808 | 0.39566 | 0.02899 | – | – | 2.77259 | 85/6 |
| 6_1^+ | 0.05461 | 0.18826 | 0.05525 | – | – | 5.98141 | 101/6 |
| 6_2^+ | 0.06128 | 0.57204 | 0.07799 | – | – | 4.65396 | 33/2 |
| 6_3 | 0.03845 | 1.33926 | 0.07523 | – | – | 6.97541 | 107/6 |
| 7_1^+ | 0.03763 | 1.23906 | 0.05985 | – | – | 4.44265 | 56/3 |
| 7_2^+ | 0.04219 | 0.81100 | 0.05525 | – | – | 4.45435 | 41/2 |
| 7_3^+ | 0.02067 | 0 | 0.02067 | – | – | 2.99573 | 22 |
| 7_4^+ | 0 | – | – | – | – | 0 | 59/3 |
| 7_5^+ | 0.04597 | 0.83134 | 0.06570 | – | – | 6.34914 | 127/6 |
| 7_6^+ | 0.02878 | 0.60837 | 0.03174 | – | – | 4.62497 | 23 |
| 7_7^+ | 0.00706 | 0 | 0.00706 | – | – | 2.60269 | 149/6 |
| 8_1^+ | 0.07131 | 0.83333 | 0.08379 | – | – | 9.14094 | 68/3 |
| 8_2^+ | 0.07810 | 0.70937 | 0.11184 | – | – | 7.09714 | 70/3 |
| 8_3 | 0.05429 | 0.24897 | 0.05568 | – | – | 5.99146 | 51/2 |
| 8_4^+ | 0.07784 | 0.64740 | 0.13305 | – | – | 6.05912 | 23 |
| 8_5^+ | 0.03590 | 0.05611 | 0.03594 | – | – | 4.82028 | 27 |
| 8_6^+ | 0.05098 | 0 | 0.05098 | – | – | 5.27811 | 157/6 |
| 8_7^+ | 0.01714 | 1.00129 | 0.02788 | – | – | 3.25810 | 80/3 |
| 8_8^+ | 0.02133 | 0 | 0.02133 | – | – | 4.14313 | 82/3 |
| 8_9 | 0.03862 | 0.99643 | 0.05810 | – | – | 4.68213 | 76/3 |
| 8_10^+ | 0.01719 | 0 | 0.01719 | – | – | 3.58352 | 55/2 |
| 8_11^+ | 0.04565 | 0.90466 | 0.05686 | – | – | 8.73408 | 76/3 |
| 8_12 | 0.04210 | 0.50800 | 0.04937 | – | – | 5.14166 | 82/3 |
| 8_13^+ | 0.05485 | 0.93825 | 0.08329 | – | – | 8.65085 | 149/6 |
| 8_14^+ | 0.02199 | 1.48654 | 0.02628 | – | – | 6.34564 | 167/6 |
| 8_15^+ | 0.03477 | 0.53993 | 0.03777 | – | – | 6.63200 | 163/6 |
| 8_16^+ | 0.02406 | 0.34559 | 0.02490 | – | – | 5.78074 | 85/3 |
| 8_17 | 0.01195 | 0.63042 | 0.01246 | – | – | 4.68213 | 29 |
| 8_18 | 0.04895 | 0 | 0.04895 | 0.85036 | 0.04679 | 6.06175 | 85/3 |
| 8_19^+ | 0.01621 | 1.02391 | 0.01949 | – | – | 3.13549 | 56/3 |
| 8_20^+ | 0.05023 | 0.98438 | 0.08007 | – | – | 6.24320 | 59/3 |
| 8_21^+ | 0.02566 | 1.25537 | 0.03751 | – | – | 5.91889 | 133/6 |
| 9_1^+ | 0.00758 | 0.03410 | 0.00758 | – | – | 1.38629 | 86/3 |
| 9_2^+ | 0.07279 | 0.67316 | 0.08113 | – | – | 8.47387 | 161/6 |
| 9_42^+ | 0.00028 | 0.02007 | 0.00028 | – | – | 0.69315 | 149/6 |
| 9_47^+ | 0.01177 | 0.45773 | 0.01190 | – | – | 4.15888 | 89/3 |
| 10_1^+ | 0.06685 | 0.55416 | 0.07921 | – | – | 7.38926 | 31 |
| 10_2^+ | 0.06372 | 0.45145 | 0.08370 | – | – | 5.22575 | 32 |

**Table 9 (p. 25)** — "Compressibility of BCC Lattice Knots with volumes V_b."

| Knot | β(0) | p_m | max β(p) | loc p_m | local max β(p) | W_K | Min V_b |
|---|---|---|---|---|---|---|---|
| 0_1 | 0.66667 | 0.08664 | 0.68629 | – | – | 0.69315 | 4 |
| 3_1^+ | 1.48918 | 0 | 1.48918 | – | – | 1.41707 | 75 |
| 4_1 | 0 | – | – | – | – | – | 80 |
| 5_1^+ | 2.58695 | 0.02790 | 2.78116 | – | – | 2.96075 | 105 |
| 5_2^+ | 2.08587 | 0.00813 | 2.09679 | – | – | 2.31747 | 112 |
| 6_1^+ | 2.33657 | 0.02208 | 2.77037 | – | – | 1.09861 | 112 |
| 6_2^+ | 2.06977 | 0 | 2.06977 | – | – | 4.04888 | 125 |
| 6_3 | 1.54825 | 0 | 1.54825 | 0.09268 | 1.34564 | 4.23411 | 120 |
| 7_1^+ | 1.37260 | 0 | 1.37260 | 0.28854 | 0.03530 | 1.91365 | 175 |
| 7_2^+ | 0 | – | – | – | – | – | 180 |
| 7_3^+ | 2.41600 | 0.04325 | 3.10143 | – | – | 3.84695 | 144 |
| 7_4^+ | 5.70413 | 0 | 5.70413 | – | – | 3.37374 | 150 |
| 7_5^+ | 2.49925 | 0.01719 | 2.56136 | – | – | 2.90690 | 144 |
| 7_6^+ | 0 | – | – | – | – | – | 150 |
| 7_7^+ | 0 | – | – | – | – | – | 144 |
| 8_1^+ | 2.25572 | 0.05046 | 5.70492 | – | – | 3.43399 | 144 |
| 8_2^+ | 3.20299 | 0 | 3.20299 | – | – | 7.11477 | 168 |
| 8_3 | 1.96612 | 0.03662 | 5.29029 | – | – | 2.19722 | 144 |
| 8_4^+ | 5.43599 | 0 | 5.43599 | 0.38809 | 0.10046 | 7.57968 | 168 |
| 8_5^+ | 3.14193 | 0 | 3.14193 | – | – | 2.01653 | 175 |
| 8_6^+ | 3.44004 | 0 | 3.44004 | – | – | 5.23644 | 160 |
| 8_7^+ | 3.37683 | 0 | 3.37683 | 0.10270 | 1.94863 | 6.90475 | 160 |
| 8_8^+ | 3.49969 | 0 | 3.49969 | – | – | 4.79027 | 168 |
| 8_9 | 2.59394 | 0 | 2.59394 | 0.05510 | 1.94102 | 3.16969 | 175 |
| 8_10^+ | 2.24347 | 0 | 2.24347 | – | – | 2.55205 | 180 |
| 8_11^+ | 2.41677 | 0 | 2.41677 | – | – | 5.80212 | 175 |
| 8_12 | 0 | – | – | – | – | – | 144 |
| 8_13^+ | 4.10106 | 0 | 4.10106 | – | – | 5.21221 | 168 |
| 8_14^+ | 3.13157 | 0 | 3.13157 | – | – | 5.86647 | 160 |
| 8_15^+ | 1.73039 | 0.05233 | 2.12601 | – | – | 3.39002 | 168 |
| 8_16^+ | 0.97928 | 0 | 0.97928 | – | – | 1.29928 | 175 |
| 8_17 | 0.92879 | 0 | 0.92879 | – | – | 0.30538 | 180 |
| 8_18 | 4.70675 | 0 | 4.70675 | 0.16392 | 2.02337 | 6.59987 | 144 |
| 8_19^+ | 1.69240 | 0.03863 | 2.08744 | – | – | 1.72385 | 144 |
| 8_20^+ | 3.41192 | 0 | 3.41192 | – | – | 4.96634 | 150 |
| 8_21^+ | 2.03630 | 0 | 2.03630 | – | – | 2.26868 | 175 |
| 9_1^+ | 4.05666 | 0 | 4.05666 | – | – | 5.92604 | 180 |
| 9_2^+ | 4.80856 | 0 | 4.80856 | 0.08777 | 2.46128 | 5.66296 | 168 |
| 9_42^+ | 1.80198 | 0 | 1.80198 | – | – | 3.34990 | 175 |
| 9_47^+ | 2.10389 | 0 | 2.10389 | 0.09644 | 1.64930 | 5.06189 | 175 |
| 10_1^+ | 3.33858 | 0 | 3.33858 | – | – | 1.79176 | 210 |
| 10_2^+ | 2.72186 | 0.01441 | 2.79899 | – | – | 2.14251 | 240 |

**Table 10 (p. 26)** — "Compressibility of BCC Lattice Knots with volumes V_e."

| Knot | β(0) | p_m | max β(p) | loc p_m | local max β(p) | W_K | Min V_e |
|---|---|---|---|---|---|---|---|
| 0_1 | 0 | – | – | – | – | 0 | 0 |
| 3_1^+ | 0.03402 | 1.62452 | 0.04773 | – | – | 4.18965 | 44/3 |
| 4_1 | 0 | – | – | – | – | 0 | 64/3 |
| 5_1^+ | 0.06553 | 1.22854 | 0.10245 | – | – | 5.32788 | 80/3 |
| 5_2^+ | 0.05674 | 0 | 0.05674 | – | – | 4.62006 | 91/3 |
| 6_1^+ | 0.00629 | 0 | 0.00629 | – | – | 0.40547 | 35 |
| 6_2^+ | 0.05241 | 0 | 0.05241 | 1.37261 | 0.03755 | 5.14749 | 116/3 |
| 6_3 | 0.03892 | 0.79096 | 0.05619 | – | – | 4.23411 | 116/3 |
| 7_1^+ | 0.03748 | 0 | 0.03748 | – | – | 1.71298 | 124/3 |
| 7_2^+ | 0 | – | – | – | – | 0 | 44 |
| 7_3^+ | 0.06347 | 0 | 0.06347 | 0.22071 | 0.06115 | 6.14954 | 134/3 |
| 7_4^+ | 0.09845 | 0.57690 | 0.38184 | – | – | 5.45318 | 40 |
| 7_5^+ | 0.06912 | 0 | 0.06912 | – | – | 5.20949 | 48 |
| 7_6^+ | 0 | – | – | – | – | 0 | 47 |
| 7_7^+ | 0 | – | – | – | – | 0 | 48 |
| 8_1^+ | 0.09074 | 0.23262 | 0.11279 | – | – | 2.74084 | 49 |
| 8_2^+ | 0.09247 | 0.71950 | 0.17808 | – | – | 7.80792 | 152/3 |
| 8_3 | 0.00856 | 0 | 0.00856 | – | – | 0.58779 | 152/3 |
| 8_4^+ | 0.13367 | 0.39542 | 0.26081 | – | – | 6.88653 | 148/3 |
| 8_5^+ | 0.07155 | 0 | 0.07155 | – | – | 5.03695 | 167/3 |
| 8_6^+ | 0.06902 | 0.65504 | 0.10783 | – | – | 5.23644 | 54 |
| 8_7^+ | 0.08047 | 0.57910 | 0.13155 | – | – | 6.90475 | 52 |
| 8_8^+ | 0.11540 | 0.46546 | 0.11558 | – | – | 6.58203 | 54 |
| 8_9 | 0.06412 | 0 | 0.06412 | – | – | 4.77912 | 169/3 |
| 8_10^+ | 0.04289 | 0.77248 | 0.05574 | – | – | 5.44242 | 166/3 |
| 8_11^+ | 0.07035 | 0.93770 | 0.07418 | – | – | 5.80212 | 166/3 |
| 8_12 | 0 | – | – | – | – | 0 | 176/3 |
| 8_13^+ | 0.05706 | 0.71565 | 0.07935 | – | – | 5.90536 | 56 |
| 8_14^+ | 0.09919 | 0 | 0.09919 | – | – | 5.86647 | 170/3 |
| 8_15^+ | 0.05556 | 0.86305 | 0.06846 | – | – | 4.48864 | 57 |
| 8_16^+ | 0.08002 | 0.19909 | 0.08208 | – | – | 3.09104 | 58 |
| 8_17 | 0.04271 | 0 | 0.04271 | – | – | 2.94444 | 58 |
| 8_18 | 0.16917 | 0 | 0.16917 | – | – | 5.21358 | 191/3 |
| 8_19^+ | 0.17811 | 0 | 0.17811 | – | – | 2.44777 | 42 |
| 8_20^+ | 0.11282 | 0.07141 | 0.11314 | – | – | 7.79955 | 134/3 |
| 8_21^+ | 0.04977 | 0 | 0.04977 | – | – | 2.67415 | 148/3 |
| 9_1^+ | 0.07219 | 0 | 0.07219 | – | – | 7.43011 | 57 |
| 9_2^+ | 0.08763 | 0 | 0.08763 | 0.89024 | 0.08575 | 5.66296 | 170/3 |
| 9_42^+ | 0.04013 | 0.46670 | 0.05049 | – | – | 4.04305 | 157/3 |
| 9_47^+ | 0.09375 | 0 | 0.09375 | – | – | 6.56597 | 63 |
| 10_1^+ | 0.05363 | 0.23863 | 0.06286 | – | – | 1.79176 | 64 |
| 10_2^+ | 0.06635 | 0.89586 | 0.09463 | – | – | 6.01372 | 200/3 |

**Table 11 (p. 30)** — "Compressibility of Compound SC Lattice Knots with volumes V_b (top data) and V_e (bottom data)."

| Knot | β(0) | p_m | max β(p) | loc p_m | local max β(p) | W_K | Min V |
|---|---|---|---|---|---|---|---|
| *V_b data* | | | | | | | |
| 3_1^+#3_1^+ | 1.27231 | 0.33117 | 2.24876 | – | – | 7.15149 | 24 |
| 3_1^+#3_1^− | 1.51949 | 0.20408 | 1.25617 | – | – | 8.42508 | 24 |
| 3_1^+#4_1 | 1.76227 | 0.00000 | 1.76227 | – | – | 4.79472 | 36 |
| 4_1#4_1 | 2.30417 | 0.03292 | 2.57205 | – | – | 6.77072 | 45 |
| 3_1^+#5_1^+ | 0.46721 | 0.19779 | 2.91011 | – | – | 6.03715 | 40 |
| 3_1^+#5_1^− | 1.50415 | 0.10167 | 1.73399 | – | – | 7.07741 | 40 |
| 3_1^+#5_2^+ | 2.22590 | 0.00000 | 2.22590 | – | – | 9.99405 | 40 |
| 3_1^+#5_2^− | 0.12513 | 0.24702 | 0.66874 | – | – | 2.90872 | 48 |
| *V_e data* | | | | | | | |
| 3_1^+#3_1^+ | 0.04653 | 0.89401 | 0.71536 | – | – | 6.45834 | 53/4 |
| 3_1^+#3_1^− | 0.05839 | 1.28041 | 0.13051 | – | – | 8.42508 | 97/6 |
| 3_1^+#4_1 | 0.05482 | 0.96456 | 0.07746 | – | – | 8.22871 | 259/12 |
| 4_1#4_1 | 0.06322 | 1.42818 | 0.09618 | – | – | 8.85016 | 51/2 |
| 3_1^+#5_1^+ | 0.04639 | 1.28800 | 0.11847 | – | – | 8.33974 | 70/3 |
| 3_1^+#5_1^− | 0.04577 | 1.40675 | 0.10193 | – | – | 9.38000 | 91/4 |
| 3_1^+#5_2^+ | 0.07706 | 1.31128 | 0.16266 | – | – | 11.24682 | 70/3 |
| 3_1^+#5_2^− | 0.03321 | 0.95426 | 0.05034 | – | – | 4.00733 | 101/4 |

⚠ In the V_e block the layout engine printed the "p_m" and "max β(p)" values in the order above (e.g. row 3_1^+#3_1^+: β(0)=0.04653, p_m=0.89401, max β=0.71536); with p_m ≈ 0.9–1.4 and max β ≥ β(0) one expects max β ~0.05–0.17, so 0.71536 looks anomalous (only the 3_1^+#3_1^+ row is out of pattern). This block was read from the text layer only (not image-checked); the "−" entries in the loc columns are as printed.

## Figures
- **Fig. 1 (p. 2)** — "Examples of minimal length lattice trefoils (knot type 3_1^+ in the standard knot tables [3]) in three dimensional cubic lattices. These are embeddings in the simple cubic lattice (left), the face centered cubic lattice (middle), and the body centered cubic lattice (right)." *What it shows:* three 3D renderings of minimal trefoils. Image: ../figures/JvRR12comp/p02.png
- **Fig. 2 (p. 4)** — "Compressibility of the minimal lattice knot of type 3_1^+ in the SC lattice." *What it shows:* β vs p (p from 0 to 4, β from 0 to 1): a peak near p≈0.14, a decline, a second smaller local maximum near p≈1.8, then decay to 0. Image: ../figures/JvRR12comp/p04.png
- **Fig. 3 (p. 6)** — "A scatter plot of the minimum rectangular box volumes V_b of knot types in the FCC and BCC. The points are contained in a narrow wedge, and the volumes are strongly correlated." Image: ../figures/JvRR12comp/p06.png
- **Fig. 4 (p. 7)** — "A scatter plot of the minimum average excluded volumes V_e of knot types in the SC and FCC. The points, with the exception of 8_3, are contained in a narrow wedge, and the volumes are strongly correlated." Image: ../figures/JvRR12comp/p07.png
- **Fig. 5 (p. 7)** — "A scatter plot of the minimum average excluded volumes V_e of knot types in the FCC and BCC. The points are contained in a narrow wedge, and the volumes are strongly correlated."
- **Fig. 6 (p. 8)** — "A scatter plot of min V_e(K) and min V_b(K) in the SC lattice for knot types K as indicated. The points are contained in a narrow wedge, and the volumes are strongly correlated."
- **Fig. 7 (p. 9)** — "Compressibility of the BCC minimal lattice knot of type 0_1 in a rectangular box of volume V_b. Observe the global maximum at p = 0.08664… where β = 0.68629…. If p = 0, then β = 2/3." Image: ../figures/JvRR12comp/p09.png
- **Fig. 8 (p. 13)** — "Compressibility of the minimal lattice knot of type 3_1^+ with volume V_e in the SC lattice." *What it shows:* β (0–0.08) vs p (0–16): single maximum ≈0.059 near p≈0.6. Image: ../figures/JvRR12comp/p13.png
- **Fig. 9 (p. 13)** — "Compressibility of the minimal lattice knots of type 4_1 in the SC lattice": (a) V_b, (b) V_e.
- **Fig. 10 (p. 14)** — Compressibility of 5_1^+ and 5_2^+ in SC: (a) V_b, (b) V_e.
- **Fig. 11 (p. 15)** — Compressibility of 6_1^+, 6_2^+, 6_3 in SC: (a) V_b, (b) V_e.
- **Fig. 12 (p. 17)** — "Compressibility of the SC minimal lattice knot of type 10_1^+ in its averaged excluded volume V_e." *What it shows:* a large peak, max β ≈ 0.338 near p≈1.29.
- **Fig. 13 (p. 21)** — "Compressibility of the minimal lattice knots of type 3_1^+ in the FCC and BCC lattices. The compressibility in the SC lattice (see figures 2 and 8) are included for comparison." (a) V_b, (b) V_e. Image: ../figures/JvRR12comp/p21.png
- **Fig. 14 (p. 22)** — same for 4_1. Image: ../figures/JvRR12comp/p22.png
- **Fig. 15 (p. 27)** — "Scatter plot of zero pressure compressibilities (V_b) of minimal lattice knots in the SC and FCC lattices. Generally, the lattice knots are more compressible in the FCC, although there are exceptions to this, these would be the knot types which lay below the diagonal in this diagram." Image: ../figures/JvRR12comp/p27.png
- **Fig. 16 (p. 28)** — "Scatter plot of zero pressure compressibilities (V_b) of minimal lattice knots in the FCC and BCC lattices. Generally, the lattice knots are more compressible in the FCC." Image: ../figures/JvRR12comp/p28.png
- **Fig. 17 (p. 28)** — "Scatter plot of zero pressure compressibilities of minimal lattice knots computed from the volume V_e in the FCC and BCC lattices." (⚠ the text on p. 28 describes it as "the SC and FCC lattices".)
- **Fig. 18 (p. 29)** — "Scatter plot of maximum compressibilities of minimal lattice knots and the total amount of work W_L computed from the volume V_e in the SC lattice. The data show a close correlation, with the knot types 9_47^+ and 10_1^+ clear outliers in this graph." Image: ../figures/JvRR12comp/p29.png
- Table 3 page: ../figures/JvRR12comp/p16.png

## Stated limitations, open problems, future work
- p. 3: lattice results "would not necessarily give a qualitative indication of the nature of real compressed ring polymers" (lattice vs real geometry).
- p. 5: V_b is "a large overestimate" of occupied volume; the convex hull volume is "much harder to determine".
- p. 11: non-monotone β for V_b is "likely due to the choice of V_b as an enclosing volume" (exploration of box corners).
- p. 19: V_e partition functions for FCC/BCC are "more complicated, and we do not reproduce those here".

## References worth following
- [6] Diao 1993, Minimal knotted polygons on the cubic lattice, JKTR 2, 413–425.
- [7] Diao 1994, The number of smallest knots on the cubic lattice, J. Stat. Phys. 74, 1247–1254.
- [14,15] JvR & Rechnitzer, Generalised atmospheric sampling of self-avoiding walks (J. Phys. A 42, 2009, 335001) and of knotted polygons (JKTR 20, 2010, 1145).
- [16] JvR & Rechnitzer 2011, BFACF-style algorithms for polygons in the BCC and FCC lattices, J. Phys. A 44, 165001.
- [17] JvR & Whittington 1991, The BFACF algorithm and knotted polygons, J. Phys. A 24, 5553.
- [18] Mann, McLoud-Mann, Ranalli, Smith 2009, Minimal knotting numbers, JKTR 18, 1159.
- [25] Scharein et al. 2009 (75 classes / 1664 trefoils).

## Extraction notes
- Tables 3 and 9 verified cell-by-cell against images; Tables 4, 7, 8, 10 from column-wise text (consistent 42-token columns); Table 11 from layout text; Tables 1, 2, 5, 6 parsed programmatically.
- ⚠ list: Table 11 V_e anomaly; W_{6_2^+} formula typo (log(36/19)); Fig. 17 text vs caption; Table 2 typos; small rounding differences between prose and tables (6_2^+ β 0.94524 vs 0.94525; W_{4_1} 2.67844 vs 2.67845; log 256 5.54517 vs 5.54518 in Table 4).
- Formulas for ⟨V_b⟩ and β of FCC/BCC trefoil (pp. 19–20) are garbled and not reproduced beyond the partition functions.
- Figure pages rendered: 2, 4, 6, 7, 9, 13, 16, 21, 22, 27, 28, 29.
