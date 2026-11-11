# GJvRR12 — Lattice Knots in a Slab
- **Authors:** D. Gasumova, E. J. Janse van Rensburg, A. Rechnitzer
- **Venue / year / identifiers:** arXiv:1204.6674v4 [cond-mat.soft], 15 Aug 2012 (running head "Squeezed Lattice Knots")
- **File:** papers/1_core_lattice_length/Gasumova-JvR-Rechnitzer_2012_Lattice_knots_in_a_slab_1204.6674.pdf   **Pages:** 31
- **Text layer:** partly garbled (prose ok; Tables 1–4 readable but column-major; Tables 5–10 scrambled; Table 9/10 exponents read from 220-dpi images)

## Abstract
In this paper the number and lengths of minimal length lattice knots confined to slabs of width L, is determined. Our data on minimal length verify the results by Ishihara et. al. [8] for the similar problem, expect in a single case, where an improvement is found. From our data we construct two models of grafted knotted ring polymers squeezed between hard walls, or by an external force. In each model, we determine the entropic forces arising when the lattice polygon is squeezed by externally applied forces. The profile of forces and compressibility of several knot types are presented and compared, and in addition, the total work done on the lattice knots when it is squeezed to a minimal state is determined.

## Notation and conventions
- (p. 4) "A lattice polygon is a sequence ω_n = {v_0, …, v_{n−1}} of distinct vertices … unit length edges in the cubic lattice Z³. Two polygons ω_0 and ω_1 are equivalent if they are translates of each other." Length = number of edges (steps). So all counts p_n(K) are **up to translation only** (not rotations/reflections), unrooted, unoriented.
- p_n(K) = number of distinct polygons of length n and knot type K. Examples (p. 4): p_4(0_1) = 3; p_n(0_1)=0 for n<4 or n odd; p_n(3_1^+) = 0 for n<24 [22]; p_24(3_1^+) = 1664. p_n(K^+) = p_n(K^−) for chiral K.
- n_K = minimal length (edges) of lattice knot K: n_{0_1}=4, n_{3_1^±}=24 [4], n_{4_1}=30, n_{5_1^+}=34 [22]; "Beyond these, only upper bounds on n_K are known." (p. 4)
- Grafted polygon (p. 4): Z(v) ≥ 0 for all vertices and some vertex v_0 has Z(v_0)=0 (touches plane Z=0). Height h = max Z(v).
- Slab S_L = Z² × {0,1,…,L} (p. 5), L = width. Polygon confined to S_L if 0 ≤ Z(v) ≤ L. p_n^L(K) = number of grafted polygons of length n, type K, in slab S_L; p_n(K;h) = number with height h; p_n^L(K) = Σ_{h≤L} p_n(K;h) (eq. 1).
- n_{L,K} = minimal length of a (grafted) lattice knot of type K in S_L. E.g. n_{1,3_1}=26, n_{2,3_1}=24 (p. 4).
- p^L_{n_{L,K}}(K) = number of minimal-length (length n_{L,K}) grafted knots of type K fitting in S_L (Tables 6, 8).
- Free energy (model 1, p. 8, eq. 4): F_L = k (n_{L,K} − n_K)² − T log p^L_{n_{L,K}}(K); critical force f_L = −ΔF_L, ΔF_L = F_L − F_{L−1} (eqs. 5–6). Work W_K = Σ_L f_L (eq. 7, δL=1). k = Hooke constant, T = temperature (k_B T = 1 in model 2, lattice units; T=1 in tables).
- Model 2 (p. 16): n_{h;K} = min_{L≤h} n_{L,K}; Z*(f) = Σ_h p_{n_{h,K}}(h,K) e^{−k(n_{h,K}−n_K)² − f h} (eq. 13); F_f = log Z*(f); ⟨h⟩_K = −dF_f/df; compressibility κ_K = −d log⟨h⟩/df (eq. 16). Positive f = pushing towards bottom wall, negative = pulling.
- Symmetry-class notation (p. 6, p. 26): symbol 2^a 4^b 6^c 8^d 12^e 16^f means a classes with 2 members, b classes with 4 members, etc. (A^a B^b … = a classes of A members, b classes of B members). Classes arise from rotations, or reflections for amphicheiral knots, preserving orientation of S_L (p. 6).
- Knot labels: superscript ± = chirality; Tables 1–10 use 3_1^+ etc. Compound knots written e.g. 3_1^+#3_1^− (Tables 1,3,4) / 3_1^+ 3_1^− (Tables 7–10).
- ⚠ Table 1/2 column label offset: the table column headed "L = j" holds the critical force that eqs. (8)–(10) call f_{j+1} (e.g. unknot column L=0 is log 3 = f_1 of eq. 8; 3_1 column "L=1" is 4k+log(38/9) which eq. 9 gives for f_2). Printed as is below.

## Numbered statements
No theorems, propositions or numbered conjectures. Numbered displayed equations that carry results:
- **Eq. (9) (p. 9), 3_1^+ critical forces (numerical; from Tables 5–6).** F_1 = 4k − T log 36; F_2 = −T log 152; F_3 = −T log 1660; F_{≥4} = −T log 1664. f_1 = ∞; f_2 = 4k + T log(38/9); f_3 = T log(415/38); f_4 = T log(416/415); f_L = 0 for L ≥ 5. W_{3_1^+} = 4k + T log(416/9).
- **Eq. (10) (p. 10), 4_1.** f_1 = ∞; f_2 = 32k + T log(758/185); f_3 = 4k − T log(379/170); f_4 = T log(114/85); f_L = 0 for L ≥ 5. W_{4_1} = 36k + T log(456/185).
- **Eq. (17–19) (p. 17), unknot.** Z*_{0_1}(f) = 1 + 2e^{−f}; ⟨h⟩ = 2e^{−f}/(1+2e^{−f}) (printed "1/(2e^{−f}+2e^{−f})" in text layer, check image), κ_{0_1} = 1/(1+2e^{−f}); W_{0_1} = log 3. ⟨h⟩ = 2/3 at f = 0 (Fig. 11 caption).
- **Eq. (20) (p. 18), 3_1^+.** Z*(3_1^+) = 36 e^{−4k−f} + 152 e^{−2f} + 1508 e^{−3f} + 4 e^{−4f}. [Derived from p(1)=36 (L=1, n=26), p(2)=152, p(3)=1660−152=1508, p(4)=4, p(≥5)=0, n=24 for h≥2; p. 17.]
- **Eq. (21) (p. 18).** ⟨h⟩_{3_1^+} = (9e^{−4k} + 76e^{−f} + 1131e^{−2f} + 4e^{−3f}) / (9e^{−4k} + 38e^{−f} + 377e^{−2f} + e^{−3f}). κ_{3_1^+} given as a longer rational expression (p. 18).
- **Eq. (22) (p. 18).** W_{3_1^+} = log((1664 + 36e^{−4k})/(36e^{−4k})) = log((416/9) e^{4k} + 1).
- **Eq. (23) (p. 19), 4_1.** Z*(4_1) = 1480 e^{−f−36k} + 6064 e^{−2f−4k} + 2720 e^{−3f} + 928 e^{−4f}. Eq. (24): ⟨h⟩_{4_1} = (185e^{−36k} + 1516 e^{−f−4k} + 1020e^{−2f} + 464e^{−3f}) / (185e^{−36k} + 758e^{−f−4k} + 340e^{−2f} + 116e^{−3f}) (as read from text layer; exponent placement e^{−f−4k} implied by Eq. 23). Eq. (25): W_{4_1} = log((456/185)e^{36k} + (758/185)e^{32k} + 1).
- **Eq. (26)–(28) (p. 20), 5-crossing knots.** Z*(5_1^+) = 72e^{−f−16k} + 760e^{−2f} + 600e^{−3f} + 1936e^{−4f} + 40e^{−5f}; Z*(5_2^+) = 6240e^{−f−36k} + 720e^{−2f} + 24072e^{−3f} + 30544e^{−4f} + 2120e^{−5f}. ⟨h⟩_{5_1^+} = (9e^{−16k} + 190e^{−f}…) shown in garbled text; ⟨h⟩_{5_2^+} = (780e^{−36k} + 180e^{−f} + 9027e^{−2f} + 15272e^{−3f} + 1325e^{−4f})/(780e^{−36k} + 90e^{−f} + 3009e^{−2f} + 3818e^{−3f} + 265e^{−4f}) (⚠ exponents of e^{−f}-powers inferred from Z*; numerators as printed). W_{5_1^+} = log((139/3)e^{16k}+1); W_{5_2^+} = log((1197/130)e^{36k}+1).
- Status of all: numerical (GAS sampling), "not rigorous" (p. 5): n_{L,K} are upper bounds, p^L_{n_{L,K}}(K) are lower bounds in a strict sense.

## Key equations and quantitative claims outside numbered statements
- p. 3: used GAS algorithm for knotted cubic lattice polygons in slabs [11]; data on knots up to eight crossings; data verify Ishihara et al. [8].
- p. 4: n_{1,3_1} = 26 (simulations [8]); if L ≥ 2, 24 edges suffice and are necessary.
- p. 5: data in Table 5 agree with [8] for all knots except 8_18: here n_{1,8_18} = 70, vs 72 in [8] ("improved"). BFACF irreducibility class = knot type, proved in [15] for unrooted polygons; applies to slabs "provided that L ≥ 2". L = 1 data: generated lattice knots in S_2 and sieved those fitting S_1, with sampling biased to fit S_1 ("reasonably confident that in most cases our lists … are complete").
- p. 5–6: n_{1,K} > n_K for all nontrivial knots (Fig. 3 scatter plot of (n_{1,K}, n_K) clusters along a line); n_{1,K} ≥ n_{L,K} ≥ n_K, n_{L,K} non-increasing in L. 8_18 minimal length: 52 (L=4), 56 (L=3), 60 (L=2), 70 (L=1) — text says "increases from 52 at L=4 through 56, 60 and to 70"; Table 5 agrees (70, 60, 56, 52 for L=1..4).
- p. 6: example symmetry-class string for 3_1^+#3_1^+ at L=1: 2^3 4^36 8^285 means 3 classes with two members, 36 with 4, 285 with 8. Entropy decreases with decreasing L if minimal length unchanged; where minimal length increases, entropy may increase or decrease a lot (see 8_5^+ and 8_6^+ at L=1, L=2 in Table 6).
- p. 7: unknot: n_{0_1}=4, p^0=1, p^1=3, so F_0 = 0, F_1 = −T log 3; critical force f_1 = T log 3; W_{0_1} = T log 3 (eq. 8).
- p. 8: low-temperature, stiff Hooke-spring approximation (only minimal-length polygons in S_L contribute). "In most cases the level of stretching is less than 10% of the rest length."
- p. 9: no entropy loss for 3_1^+ until L = 4; f_1 = ∞ since a nontrivial knot cannot fit in S_0; profile Fig. 5 with k=1/4, T=1.
- p. 10: fL ≥ f_{L+1} not always true: 4_1 has f_3 < f_4 (interplay of entropy and Hooke terms).
- p. 11–12: Fig. 8 caption: negative bar for 6_1^+ between L=2 and L=3: entropy gain overwhelms Hooke term.
- p. 13: critical Hooke constants (k_c where Hooke and entropic contributions to W are equal): k_c(3_1^+) = [T log(416/9)]/4 ≈ 0.95836 T; k_c(4_1) ≈ 0.02505 T; k_c(5_1^+) ≈ 0.23974 T; k_c(5_2^+) ≈ 0.06167 T; k_c(6_1^+) ≈ −0.015025 T (negative: "large entropy gain occurs when the knot stretches in length to fit in S_1"). Others from last column of Tables 1–2.
- p. 16: model 2 partition function eq. (11) Z(f)=Σ p_{n_{h;K}}(h,K) e^{−E_h − f h}; E_h = k(n_{h;K}−n_K)² (eq. 12). n_{1;3_1^+}=26, n_{h;3_1^+}=24 for h>1.
- p. 17: p_4(0,0_1)=1, p_4(1,0_1)=2; p(1,3_1)=36, p(2,3_1)=152; counts at L=3 minus those at L=2 give p(3,3_1)=1508.
- p. 18–19: Fig. 12 (k=1/4): ⟨h⟩ decreases from about 4 to about 3 at f=0 then to 1 for large positive f; two peaks in κ_{3_1}. Fig. 13 (k=4/3): three peaks in κ.
- p. 19: 4_1 minimal lengths: 36 in S_1, 32 in S_2, 30 for L≥3. W_{3_1^+} ≈ 3.855 > 2.023 ≈ W_{4_1} at k=0; at k=1/4: W_{3_1^+} ≈ 4.841 < "10/379" ≈ W_{4_1} (⚠ printed "10/379", almost certainly 10.379 — consistent with eq. 25 at k=1/4); equality at k = 0.06588….
- p. 20: 5-crossing: max height 5, Hooke terms for transition h=2→h=1; 5_2^+ undergoes smoother compression than 5_1^+. 6-crossing knots behave alike, 6_3 most resistant (p. 21, Fig. 16 caption).
- p. 23: Fig. 17 compares W at k=1/4 and k=1 for each knot type; points lie along a band; compressibility is not monotonic in f (peaks "soft regimes", troughs "hard regimes").
- p. 25: further energy terms (bending, wall binding) expected to modify results; bending would make the knot less compressible.

## Methods / algorithms
1. Sample knotted unrooted lattice polygons in S_L = Z²×{0..L} with the GAS (generalised atmospheric sampling) algorithm for knotted polygons [11,12,13], flat-histogram, using BFACF elementary moves [1,3] (p. 5).
2. Estimate p_{n_{L,K}}(K;h) for the minimal length n_{L,K}; sum over h ≤ L to get p^L (p. 5).
3. L ≥ 2 as in [12]; L = 1 by generating in S_2 with bias toward S_1 and sieving (p. 5).
4. Model 1 (hard walls, §3): free energy eq. (4), critical forces eq. (5–6), work eq. (7).
5. Model 2 (flexible membrane, §4): partition function eq. (11–13), mean height and compressibility eqs. (15–16).
6. Verification: comparison with Ishihara et al. [8] (agree except 8_18 at L=1).

## Tables
All values below transcribed from page images. Columns of Tables 1–2 are labelled as printed (⚠ offset, see Notation).

**Table 1 (p. 14)** — "Critical forces f_L for knots up to seven crossings and for compound knot types up to eight crossings. The last column is the maximum amount of useful work which can be extracted if the lattice knot expands against the hard walls of the slab, pushing them apart from L = 1. In all these cases we set T = 1." (log = natural log)

| Knot | L=0 | L=1 | L=2 | L=3 | L=4 | L=5 | L=6 | L=7 | W |
|---|---|---|---|---|---|---|---|---|---|
| 0_1 | log 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | log 3 |
| 3_1^+ | ∞ | 4k+log(38/9) | log(415/38) | log(416/415) | 0 | 0 | 0 | 0 | 4k+log(416/9) |
| 4_1 | ∞ | 32k+log(758/185) | 4k+log(170/379) | log(114/85) | 0 | 0 | 0 | 0 | 36k+log(456/185) |
| 5_1^+ | ∞ | 16k+log(95/9) | log(34/19) | log(206/85) | log(417/412) | 0 | 0 | 0 | 16k+log(139/3) |
| 5_2^+ | ∞ | 36k+log(3/26) | log(1033/30) | log(6917/3099) | log(7182/6917) | 0 | 0 | 0 | 36k+log(1197/130) |
| 6_1^+ | ∞ | 60k+log(3176/2009) | 4k+log(73/794) | log(375/146) | log(128/125) | 0 | 0 | 0 | 64k+log(768/2009) |
| 6_2^+ | ∞ | 60k+log(15/46) | 4k+log(373/90) | log(1829/373) | log(2052/1829) | 0 | 0 | 0 | 64k+log(171/23) |
| 6_3 | ∞ | 84k+log(157/26) | 16k+log(37/471) | log(213/37) | log(74/71) | 0 | 0 | 0 | 100k+log(37/13) |
| 7_1^+ | ∞ | 36k+log(100/9) | log(1417/300) | log(2890/1417) | log(422/289) | log(849/844) | 0 | 0 | 36k+log(1415/9) |
| 7_2^+ | ∞ | 60k+log(62507/5607) | 4k+log(12924/62507) | log(7688/3231) | log(41069/30752) | log(42045/41069) | 0 | 0 | 64k+log(14015/1869) |
| 7_3^+ | ∞ | 84k+log(1202/31) | 16k+log(5/1803) | 0 | log(3/2) | 0 | 0 | 0 | 100k+log(5/31) |
| 7_4^+ | ∞ | 96k+log(100/3361) | 4k+log(1/20) | log(16/5) | log(21/16) | 0 | 0 | 0 | 100k+log(21/3361) |
| 7_5^+ | ∞ | 96k+log(52/115) | 4k+log(5/104) | log(581/15) | log(591/581) | 0 | 0 | 0 | 100k+log(197/230) |
| 7_6^+ | ∞ | 96k+log(220/731) | 4k+log(4/11) | log(323/16) | log(2127/1615) | 0 | 0 | 0 | 100k+log(2127/731) |
| 7_7^+ | ∞ | 108k+log(2248) | 32k+log(161/1124) | 4k+log(7/46) | log(9/7) | 0 | 0 | 0 | 144k+log(63) |
| 3_1^+#3_1^+ | ∞ | 64k+log(4/1215) | log(975) | log(2623/1950) | log(3826/2623) | 0 | log(1914/1913) | 0 | 64k+log(2552/405) |
| 3_1^+#3_1^− | ∞ | 16k+log(28/9) | log(1011/8) | log(3274/2359) | log(6839/4911) | 0 | log(13679/13678) | log(13680/13679) | 16k+log(760) |
| 3_1^+#4_1 | ∞ | 60k+log(3434/1509) | 4k+log(3559/1717) | log(16181/7118) | log(21026/16181) | log(11241/10513) | 0 | 0 | 64k+log(7494/503) |
| 3_1^+#5_1^+ | ∞ | 64k+log(10/27) | log(395) | log(53/25) | log(4464/4187) | log(4183/2976) | log(4187/4183) | 0 | 64k+log(4187/9) |
| 3_1^+#5_1^− | ∞ | 36k+log(197/18) | log(3374/197) | log(12431/3374) | log(15328/12431) | log(35447/30656) | log(35547/35447) | 0 | 36k+log(11849/12) |
| 3_1^+#5_2^+ | ∞ | 64k+log(235/18802) | log(91191/235) | log(273449/91191) | log(398758/273449) | log(454641/398758) | log(153271/151547) | 0 | 64k+log(459813/18802) |
| 3_1^+#5_2^− | ∞ | 96k−log(246) | 4k+log(110/7) | log(113/55) | log(165/113) | 0 | 0 | 0 | 100k+log(55/287) |
| 4_1#4_1 | ∞ | 60k+log(5477/100) | 4k+log(5076/5477) | log(21601/5076) | log(38653/21601) | log(41515/38653) | log(41853/41515) | 0 | 64k+log(41853/100) |

(Row/cell alignment taken from the page image and checked against the text layer; the small fractions of L=3..7 columns were checked at 130 dpi, not at higher zoom. ⚠ 7_3 L=3 = 0 and L=4 = log(3/2): as printed.)

**Table 2 (p. 15)** — "Critical forces f_L for knots with eight crossings. The last column is the maximum amount of useful work which can be extracted if the lattice knot expands against the hard walls of the slab, pushing them apart from L = 1. In all these cases we set T = 1." (L=0 column is ∞ for all rows; L=6 and L=7 columns are 0 for all rows.)

| Knot | L=1 | L=2 | L=3 | L=4 | L=5 | W |
|---|---|---|---|---|---|---|
| 8_1^+ | 96k+log(254/2145) | 4k+log(274/635) | log(1003/274) | log(2787/2006) | log(989/929) | 100k+log(989/3575) |
| 8_2^+ | 84k+log(73714/649) | 16k+log(1291/36857) | log(3248/1291) | log(5263/3248) | log(5730/5263) | 100k+log(11460/649) |
| 8_3 | 128k+log(500/2273) | 16k+log(1/250) | 0 | log(3/2) | 0 | 144k+log(3/2273) |
| 8_4^+ | 96k+log(140/297) | 4k+log(23/119) | log(933/115) | log(2933/1866) | log(2991/2933) | 100k+log(1994/1683) |
| 8_5^+ | 64k+log(102047/18) | 32k+log(1236/102047) | 4k+log(8/103) | log(3/2) | 0 | 100k+3 log 2 |
| 8_6^+ | 140k−log(1205) | log(3023) | 4k+log(460/3023) | log(3/2) | 0 | 144k+log(138/241) |
| 8_7^+ | 160k+log(6172/2429) | 36k+log(1/6172) | log 2 | log(3/2) | 0 | 196k+log(3/2429) |
| 8_8^+ | 128k+log(347/1696) | 12k+log(5035/347) | 4k+log(26/1007) | log(3/2) | 0 | 144k+log(195/1696) |
| 8_9 | 128k+log(355/318) | 16k+log(20/213) | log(147/10) | log(3/2) | log(3541/2940) | 144k+log(3541/1272) |
| 8_10^+ | 108k+log(2982/13) | 32k+log(221/1988) | 4k+log(70/663) | log(3/2) | 0 | 144k+log(105/26) |
| 8_11^+ | 128k+log(453/488) | 12k+log(5066/453) | 4k+log(4/2533) | log(3/2) | 0 | 144k+log(3/122) |
| 8_12 | 128k+log(2897/183) | 16k+log(18/14485) | log 6 | log(3/2) | 0 | 144k+log(54/305) |
| 8_13^+ | 180k+log(95/9987) | 16k−log(19) | log(537/5) | log(802/537) | log(408/401) | 196k+log(272/3329) |
| 8_14^+ | 180k+log(172/1475) | 12k+log(77/86) | 4k+log(3/77) | log(3/2) | 0 | 196k+log(9/1475) |
| 8_15^+ | 84k+log(55) | 16k+log(282/55) | log(3047/564) | log(5013/3047) | 0 | 100k+log(5013/2) |
| 8_16^+ | 220k+log(73/2045) | 32k+log(3/73) | 4k+log(2/3) | log(3/2) | 0 | 256k+log(3/2045) |
| 8_17 | 220k+log(518/3771) | 32k+log(231/74) | 4k+log(557/539) | log(1098/557) | log(554/549) | 256k+log(1108/1257) |
| 8_18 | 260k+log(189/8) | 48k+log(17000/189) | 16k+log(37/2125) | log 3 | 0 | 324k+log(111) |
| 8_19^+ | 32k+log(1656/163) | 4k+log(283/414) | log(1677/283) | log(583/559) | 0 | 36k+log(6996/163) |
| 8_20^+ | 60k+log(318/29) | 4k+log(5/159) | log 2 | log(3/2) | 0 | 64k+log(30/29) |
| 8_21^+ | 60k+log(30) | 4k+log(857/180) | log(6375/857) | log(467/425) | 0 | 64k+log(2335/2) |

**Table 3 (p. 22)** — "The work done by releasing the lattice knot in S_1 and letting it expand to equilibrium at zero pressure." (Work column = argument formula W = log(·)):

| Knot | Work |
|---|---|
| 0_1 | log 3 |
| 3_1^+ | log((416/9)e^{4k} + 1) |
| 4_1 | log((456/185)e^{36k} + (758/185)e^{32k} + 1) |
| 5_1^+ | log((139/3)e^{16k} + 1) |
| 5_2^+ | log((1197/130)e^{36k} + 1) |
| 6_1^+ | log((768/2009)e^{64k} + (3176/2009)e^{60k} + 1) |
| 6_2^+ | log((171/23)e^{64k} + (15/46)e^{60k} + 1) |
| 6_3 | log((37/13)e^{100k} + (157/26)e^{84k} + 1) |
| 7_1^+ | log((1415/9)e^{36k} + 1) |
| 7_2^+ | log((14015/1869)e^{64k} + (62507/5607)e^{60k} + 1) |
| 7_3^+ | log((5/31)e^{100k} + (1202/31)e^{84k} + 1) |
| 7_4^+ | log((21/3361)e^{100k} + (100/3361)e^{96k} + 1) |
| 7_5^+ | log((197/230)e^{100k} + (52/115)e^{96k} + 1) |
| 7_6^+ | log((2127/731)e^{100k} + (220/731)e^{96k} + 1) |
| 7_7^+ | log(63e^{144k} + 322e^{140k} + 2248e^{108k} + 1) |
| 8_1^+ | log((989/3575)e^{100k} + (254/2145)e^{96k} + 1) |
| 8_2^+ | log((11460/649)e^{100k} + (73714/649)e^{84k} + 1) |
| 8_3 | log((3/2273)e^{144k} + (500/2273)e^{128k} + 1) |
| 8_4^+ | log((1994/1683)e^{100k} + (140/297)e^{96k} + 1) |
| 8_5^+ | log(8e^{100k} + (206/3)e^{96k} + (102047/18)e^{64k} + 1) |
| 8_6^+ | log((138/241)e^{144k} + (1/1205)e^{140k} + 1) |
| 8_7^+ | log((3/2429)e^{196k} + (6172/2429)e^{160k} + 1) |
| 8_8^+ | log((195/1696)e^{144k} + (95/32)e^{140k} + (347/1696)e^{128k} + 1) |
| 8_9 | log((245/106)e^{144k} + (355/318)e^{128k} + 1) |
| 8_10^+ | log((105/26)e^{144k} + (51/2)e^{140k} + (2982/13)e^{108k} + 1) |
| 8_11^+ | log((3/122)e^{144k} + (2533/244)e^{140k} + (453/488)e^{128k} + 1) |
| 8_12 | log((54/305)e^{144k} + (2897/183)e^{128k} + 1) |
| 8_13^+ | log(1632e^{144k} + 190e^{128k} + 1) |
| 8_14^+ | log((9/1475)e^{196k} + (154/1475)e^{192k} + (172/1475)e^{180k} + 1) |
| 8_15^+ | log((5013/2)e^{100k} + 55e^{84k} + 1) |
| 8_16^+ | log((3/2045)e^{256k} + (3/2045)e^{252k} + (73/2045)e^{220k} + 1) |
| 8_17 | log((1108/1257)e^{256k} + (539/1257)e^{252k} + (518/3771)e^{220k} + 1) |
| 8_18 | log(111e^{324k} + 2125e^{308k} + (189/8)e^{260k} + 1) |
| 8_19^+ | log((6996/163)e^{36k} + (1656/163)e^{32k} + 1) |
| 8_20^+ | log((30/29)e^{64k} + (318/29)e^{60k} + 1) |
| 8_21^+ | log((2335/2)e^{64k} + 30e^{60k} + 1) |

⚠ The 8_13^+ row (two terms, e^{144k}, e^{128k}, coefficients 1632, 190) does not match the pattern of Table 2 for 8_13^+ (L=1 term 180k+log(95/9987), W = 196k+log(272/3329)); the rows for 8_12 and 8_14 do match Table 2. Printed as is.

**Table 4 (p. 23)** — "The work done by releasing the lattice knot in S_1 and letting it expand to equilibrium at zero pressure."

| Knot | Work |
|---|---|
| 3_1^+#3_1^+ | log((2552/405)e^{64k} + 1) |
| 3_1^+#3_1^− | log(760e^{16k} + 1) |
| 3_1^+#4_1 | log((7494/503)e^{64k} + (3434/1509)e^{60k} + 1) |
| 3_1^+#5_1^+ | log((4187/9)e^{64k} + 1) |
| 3_1^+#5_1^− | log((11849/12)e^{36k} + 1) |
| 3_1^+#5_2^+ | log((459813/18802)e^{64k} + 1) |
| 3_1^+#5_2^− | log((55/287)e^{100k} + (1/246)e^{96k} + 1) |
| 4_1#4_1 | log((41853/100)e^{64k} + (5477/100)e^{60k} + 1) |

**Table 5 (p. 27)** — "The minimal length of lattice knots of prime knot type to eight crossings confined to slabs of width L. Cases with an increase in minimal length are underlined." n_{L,K}. Underline marks were not preserved here; on the image an entry is underlined exactly when it exceeds the entry at L+1 (checked on L=1,2,3 columns).

| Knot | L=1 | L=2 | L=3 | L=4 | L=5 | L=6 | L=7 | L=8 |
|---|---|---|---|---|---|---|---|---|
| 0_1 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 |
| 3_1^+ | 26 | 24 | 24 | 24 | 24 | 24 | 24 | 24 |
| 4_1 | 36 | 32 | 30 | 30 | 30 | 30 | 30 | 30 |
| 5_1^+ | 38 | 34 | 34 | 34 | 34 | 34 | 34 | 34 |
| 5_2^+ | 42 | 36 | 36 | 36 | 36 | 36 | 36 | 36 |
| 6_1^+ | 48 | 42 | 40 | 40 | 40 | 40 | 40 | 40 |
| 6_2^+ | 48 | 42 | 40 | 40 | 40 | 40 | 40 | 40 |
| 6_3 | 50 | 44 | 40 | 40 | 40 | 40 | 40 | 40 |
| 7_1^+ | 50 | 44 | 44 | 44 | 44 | 44 | 44 | 44 |
| 7_2^+ | 54 | 48 | 46 | 46 | 46 | 46 | 46 | 46 |
| 7_3^+ | 54 | 48 | 44 | 44 | 44 | 44 | 44 | 44 |
| 7_4^+ | 54 | 46 | 44 | 44 | 44 | 44 | 44 | 44 |
| 7_5^+ | 56 | 48 | 46 | 46 | 46 | 46 | 46 | 46 |
| 7_6^+ | 56 | 48 | 46 | 46 | 46 | 46 | 46 | 46 |
| 7_7^+ | 56 | 50 | 46 | 44 | 44 | 44 | 44 | 44 |
| 8_1^+ | 60 | 52 | 50 | 50 | 50 | 50 | 50 | 50 |
| 8_2^+ | 60 | 54 | 50 | 50 | 50 | 50 | 50 | 50 |
| 8_3 | 60 | 52 | 48 | 48 | 48 | 48 | 48 | 48 |
| 8_4^+ | 60 | 52 | 50 | 50 | 50 | 50 | 50 | 50 |
| 8_5^+ | 60 | 56 | 52 | 50 | 50 | 50 | 50 | 50 |
| 8_6^+ | 62 | 52 | 52 | 50 | 50 | 50 | 50 | 50 |
| 8_7^+ | 62 | 54 | 48 | 48 | 48 | 48 | 48 | 48 |
| 8_8^+ | 62 | 54 | 52 | 50 | 50 | 50 | 50 | 50 |
| 8_9 | 62 | 54 | 50 | 50 | 50 | 50 | 50 | 50 |
| 8_10^+ | 62 | 56 | 52 | 50 | 50 | 50 | 50 | 50 |
| 8_11^+ | 62 | 54 | 52 | 50 | 50 | 50 | 50 | 50 |
| 8_12 | 64 | 56 | 52 | 52 | 52 | 52 | 52 | 52 |
| 8_13^+ | 64 | 54 | 50 | 50 | 50 | 50 | 50 | 50 |
| 8_14^+ | 64 | 54 | 52 | 50 | 50 | 50 | 50 | 50 |
| 8_15^+ | 62 | 56 | 52 | 52 | 52 | 52 | 52 | 52 |
| 8_16^+ | 66 | 56 | 52 | 50 | 50 | 50 | 50 | 50 |
| 8_17 | 68 | 58 | 54 | 52 | 52 | 52 | 52 | 52 |
| 8_18 | 70 | 60 | 56 | 52 | 52 | 52 | 52 | 52 |
| 8_19^+ | 48 | 44 | 42 | 42 | 42 | 42 | 42 | 42 |
| 8_20^+ | 52 | 46 | 44 | 44 | 44 | 44 | 44 | 44 |
| 8_21^+ | 54 | 48 | 46 | 46 | 46 | 46 | 46 | 46 |

(Verified against the 110-dpi page image.)

**Table 6 (p. 28)** — "The number of lattice knots of prime knot type to eight crossings confined to slabs of width L." p_{n_{L,K}}(K).

| Knot | L=1 | L=2 | L=3 | L=4 | L=5 | L=6 | L=7 | L=8 |
|---|---|---|---|---|---|---|---|---|
| 0_1 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 |
| 3_1^+ | 36 | 152 | 1660 | 1664 | 1664 | 1664 | 1664 | 1664 |
| 4_1 | 1480 | 6064 | 2720 | 3648 | 3648 | 3648 | 3648 | 3648 |
| 5_1^+ | 72 | 760 | 1360 | 3296 | 3336 | 3336 | 3336 | 3336 |
| 5_2^+ | 6240 | 720 | 24792 | 55336 | 57456 | 57456 | 57456 | 57456 |
| 6_1^+ | 8036 | 12704 | 1168 | 3000 | 3072 | 3072 | 3072 | 3072 |
| 6_2^+ | 2208 | 720 | 2984 | 14632 | 16416 | 16416 | 16416 | 16416 |
| 6_3 | 1248 | 7536 | 592 | 3408 | 3552 | 3552 | 3552 | 3552 |
| 7_1^+ | 108 | 1200 | 5668 | 11560 | 16880 | 16980 | 16980 | 16980 |
| 7_2^+ | 22428 | 250028 | 51696 | 123008 | 164276 | 168180 | 168180 | 168180 |
| 7_3^+ | 1488 | 57696 | 160 | 160 | 240 | 240 | 240 | 240 |
| 7_4^+ | 13444 | 400 | 20 | 64 | 84 | 84 | 84 | 84 |
| 7_5^+ | 5520 | 2496 | 120 | 4648 | 4728 | 4728 | 4728 | 4728 |
| 7_6^+ | 5848 | 1760 | 640 | 12920 | 17016 | 17016 | 17016 | 17016 |
| 7_7^+ | 4 | 8992 | 1288 | 196 | 252 | 252 | 252 | 252 |
| 8_1^+ | 42900 | 5080 | 2192 | 8024 | 11148 | 11868 | 11868 | 11868 |
| 8_2^+ | 2596 | 294856 | 10328 | 25984 | 42104 | 45840 | 45840 | 45840 |
| 8_3 | 9092 | 2000 | 8 | 8 | 12 | 12 | 12 | 12 |
| 8_4^+ | 20196 | 9520 | 1840 | 14928 | 23464 | 23928 | 23928 | 23928 |
| 8_5^+ | 72 | 408180 | 4944 | 384 | 384 | 384 | 384 | 384 |
| 8_6^+ | 9640 | 8 | 24184 | 3680 | 5520 | 5520 | 5520 | 5520 |
| 8_7^+ | 19432 | 49376 | 8 | 16 | 24 | 24 | 24 | 24 |
| 8_8^+ | 13568 | 2776 | 40280 | 1040 | 1560 | 1560 | 1560 | 1560 |
| 8_9 | 15264 | 17040 | 4920 | 30584 | 42492 | 42492 | 42492 | 42492 |
| 8_10^+ | 208 | 47712 | 5304 | 560 | 840 | 840 | 840 | 840 |
| 8_11^+ | 3904 | 3624 | 40528 | 64 | 96 | 96 | 96 | 96 |
| 8_12 | 14640 | 231760 | 288 | 1728 | 2592 | 2592 | 2592 | 2592 |
| 8_13^+ | 159792 | 1520 | 80 | 8592 | 12832 | 13056 | 13056 | 13056 |
| 8_14^+ | 59000 | 6880 | 6160 | 240 | 360 | 360 | 360 | 360 |
| 8_15^+ | 16 | 880 | 4512 | 24376 | 40104 | 40104 | 40104 | 40104 |
| 8_16^+ | 32720 | 1168 | 48 | 32 | 48 | 48 | 48 | 48 |
| 8_17 | 60336 | 8288 | 25872 | 26736 | 52704 | 53184 | 53184 | 53184 |
| 8_18 | 32 | 756 | 68000 | 1184 | 3552 | 3552 | 3552 | 3552 |
| 8_19^+ | 163 | 1656 | 1132 | 6708 | 6996 | 6996 | 6996 | 6996 |
| 8_20^+ | 116 | 1272 | 40 | 80 | 120 | 120 | 120 | 120 |
| 8_21^+ | 24 | 720 | 3428 | 25500 | 28020 | 28020 | 28020 | 28020 |

(Verified cell by cell against the 110-dpi image. 8_19^+ at L=1 is 163 (odd; consistent with Table 10 symmetry classes 1·1+2·3+4·9+8·15 = 163). 3_1^+ L=1 36 ⇒ F_1 = 4k − T log 36 ✓.)

**Table 7 (p. 29)** — "The minimal length of lattice knots of compound knot type to eight crossings confined to slabs of width L. Cases with an increase in minimal length are underlined." (L=1 and L=2 entries that exceed next L are underlined.)

| Knot | L=1 | L=2 | L=3 | L=4 | L=5 | L=6 | L=7 | L=8 |
|---|---|---|---|---|---|---|---|---|
| 3_1^+3_1^+ | 48 | 40 | 40 | 40 | 40 | 40 | 40 | 40 |
| 3_1^+3_1^− | 44 | 40 | 40 | 40 | 40 | 40 | 40 | 40 |
| 3_1^+4_1 | 54 | 48 | 46 | 46 | 46 | 46 | 46 | 46 |
| 3_1^+5_1^+ | 58 | 50 | 50 | 50 | 50 | 50 | 50 | 50 |
| 3_1^+5_1^− | 56 | 50 | 50 | 50 | 50 | 50 | 50 | 50 |
| 3_1^+5_2^+ | 60 | 52 | 52 | 52 | 52 | 52 | 52 | 52 |
| 3_1^+5_2^− | 60 | 52 | 50 | 50 | 50 | 50 | 50 | 50 |
| 4_1 4_1 | 60 | 54 | 52 | 52 | 52 | 52 | 52 | 52 |

**Table 8 (p. 29)** — "The number of lattice knots of compound knot type to eight crossings confined to slabs of width L."

| Knot | L=1 | L=2 | L=3 | L=4 | L=5 | L=6 | L=7 | L=8 |
|---|---|---|---|---|---|---|---|---|
| 3_1^+3_1^+ | 2430 | 8 | 7800 | 10492 | 15304 | 15304 | 15312 | 15312 |
| 3_1^+3_1^− | 144 | 448 | 56616 | 78576 | 109424 | 109424 | 109432 | 109440 |
| 3_1^+4_1 | 12072 | 27472 | 56944 | 129448 | 168208 | 179856 | 179856 | 179856 |
| 3_1^+5_1^+ | 216 | 80 | 31600 | 66992 | 71424 | 100392 | 100488 | 100488 |
| 3_1^+5_1^− | 288 | 3152 | 53984 | 198896 | 245248 | 283576 | 284376 | 284376 |
| 3_1^+5_2^+ | 150416 | 1880 | 729528 | 2187592 | 3190064 | 3637128 | 3678504 | 3678504 |
| 3_1^+5_2^− | 13776 | 56 | 880 | 1808 | 2640 | 2640 | 2640 | 2640 |
| 4_1 4_1 | 800 | 43816 | 40608 | 172808 | 309224 | 332120 | 334824 | 334824 |

**Table 9 (p. 30)** — "The symmetry classes of prime lattice knots upto seven crossings, and compound lattice knots upto eight crossings, confined to S_L with L ≤ 8." Format A^a B^b … (see Notation). Read from 220-dpi crops.

| Knot | L=1 | L=2 | L=3 | L=4 | L=5 | L=6 | L=7 | L=8 |
|---|---|---|---|---|---|---|---|---|
| 0_1 | 3^1 | 3^1 | 3^1 | 3^1 | 3^1 | 3^1 | 3^1 | 3^1 |
| 3_1^+ | 4^3 8^3 | 8^19 | 4^1 8^3 12^6 24^65 | 4^1 8^2 12^7 24^65 | 4^1 8^2 12^7 24^65 | 4^1 8^2 12^7 24^65 | 4^1 8^2 12^7 24^65 | 4^1 8^2 12^7 24^65 |
| 4_1 | 4^22 8^174 | 8^750 16^4 | 16^116 24^36 | 24^152 | 24^152 | 24^152 | 24^152 | 24^152 |
| 5_1^+ | 4^6 8^6 | 8^95 | 4^6 8^105 16^31 | 12^6 16^5 24^131 | 12^6 24^136 | 12^6 24^136 | 12^6 24^136 | 12^6 24^136 |
| 5_2^+ | 4^30 8^765 | 8^90 | 4^4 8^1687 16^705 | 12^4 16^265 24^2127 | 12^4 24^2392 | 12^4 24^2392 | 12^4 24^2392 | 12^4 24^2392 |
| 6_1^+ | 4^43 8^983 | 8^1588 | 8^112 16^17 | 12^2 16^9 24^118 | 12^2 24^127 | 12^2 24^127 | 12^2 24^127 | 12^2 24^127 |
| 6_2^+ | 4^18 8^267 | 8^90 | 8^365 16^4 | 16^223 24^461 | 24^684 | 24^684 | 24^684 | 24^684 |
| 6_3 | 8^156 | 8^942 | 8^38 16^18 | 16^18 24^130 | 24^148 | 24^148 | 24^148 | 24^148 |
| 7_1^+ | 4^9 8^9 | 8^150 | 4^1 8^666 16^21 | 8^7 12^2 16^674 24^29 | 8^5 12^4 16^10 24^693 | 12^9 24^703 | 12^9 24^703 | 12^9 24^703 |
| 7_2^+ | 4^41 8^2783 | 4^9 8^31249 | 8^4600 16^931 | 8^127 16^5403 24^1481 | 12^7 16^488 24^6516 | 12^7 24^7004 | 12^7 24^7004 | 12^7 24^7004 |
| 7_3^+ | 8^186 | 8^7212 | 16^10 | 16^10 | 24^10 | 24^10 | 24^10 | 24^10 |
| 7_4^+ | 2^6 4^86 8^1636 | 4^10 8^45 | 4^1 8^2 | 8^1 16^2 24^1 | 12^1 24^3 | 12^1 24^3 | 12^1 24^3 | 12^1 24^3 |
| 7_5^+ | 8^690 | 8^312 | 8^13 16^1 | 16^10 24^187 | 24^197 | 24^197 | 24^197 | 24^197 |
| 7_6^+ | 8^731 | 8^220 | 8^80 | 16^512 24^197 | 24^709 | 24^709 | 24^709 | 24^709 |
| 7_7^+ | 4^1 | 4^32 8^1108 | 4^10 8^156 | 12^1 16^7 24^3 | 12^1 24^10 | 12^1 24^10 | 12^1 24^10 | 12^1 24^10 |
| 3_1^+3_1^+ | 2^3 4^36 8^285 | 4^2 | 8^303 16^336 | 8^2 12^1 16^600 24^36 | 12^2 16^1 24^636 | 12^2 16^1 24^636 | 12^2 24^637 | 12^2 24^637 |
| 3_1^+3_1^− | 8^18 | 8^56 | 8^2050 16^2500 24^9 | 8^1 16^3856 24^703 | 8^1 24^4559 | 8^1 24^4559 | 16^1 24^4559 | 24^4560 |
| 3_1^+4_1 | 8^1509 | 8^3434 | 8^4758 16^1180 | 8^282 16^5737 24^1475 | 16^1456 24^6038 | 24^7494 | 24^7494 | 24^7494 |
| 3_1^+5_1^+ | 8^27 | 8^10 | 8^3756 16^97 | 8^36 16^4115 24^36 | 16^3633 24^554 | 16^12 24^4175 | 24^4187 | 24^4187 |
| 3_1^+5_1^− | 8^36 | 8^394 | 8^6006 16^371 | 8^470 16^9745 24^1634 | 16^4891 24^6958 | 16^100 24^11749 | 24^11849 | 24^11849 |
| 3_1^+5_2^+ | 8^18802 | 8^235 | 8^74813 16^8189 | 8^37388 16^111588 24^4295 | 16^61055 24^92216 | 16^5172 24^148099 | 24^153271 | 24^153271 |
| 3_1^+5_2^− | 8^1722 | 8^7 | 8^110 | 16^104 24^6 | 24^110 | 24^110 | 24^110 | 24^110 |
| 4_1 4_1 | 8^100 | 4^118 8^5418 | 8^4466 16^305 | 8^6873 16^6551 24^542 | 12^30 16^3200 24^10736 | 12^30 16^338 24^13598 | 12^30 24^13936 | 12^30 24^13936 |

(Arithmetic check, no problem found: e.g. 3_1^+ L=4: 4+16+84+1560=1664 ✓; 3_1^+3_1^+ L=8: 24+15288=15312 ✓.)

**Table 10 (p. 31)** — "The symmetry classes of prime lattice knots up to eight crossings, confined to S_L with L ≤ 8."

| Knot | L=1 | L=2 | L=3 | L=4 | L=5 | L=6 | L=7 | L=8 |
|---|---|---|---|---|---|---|---|---|
| 8_1^+ | 4^55 8^5335 | 8^635 | 8^274 | 8^1 16^480 24^14 | 12^1 16^90 24^404 | 12^1 24^494 | 12^1 24^494 | 12^1 24^494 |
| 8_2^+ | 4^23 8^313 | 8^36857 | 8^1271 16^10 | 8^594 16^1294 24^22 | 16^467 24^1443 | 24^1910 | 24^1910 | 24^1910 |
| 8_3 | 4^3 8^1135 | 8^250 | 8^1 | 8^1 | 12^1 | 12^1 | 12^1 | 12^1 |
| 8_4^+ | 4^63 8^2493 | 8^1190 | 8^230 | 8^147 16^831 24^19 | 16^58 24^939 | 24^997 | 24^997 | 24^997 |
| 8_5^+ | 2^2 4^5 8^6 | 4^57 8^50994 | 4^10 8^613 | 16^24 | 16^24 | 16^24 | 16^24 | 16^24 |
| 8_6^+ | 8^1205 | 8^1 | 8^3013 16^5 | 16^230 | 24^230 | 24^230 | 24^230 | 24^230 |
| 8_7^+ | 8^2429 | 8^6172 | 8^1 | 16^1 | 24^1 | 24^1 | 24^1 | 24^1 |
| 8_8^+ | 8^1696 | 8^347 | 8^4959 16^38 | 16^65 | 24^65 | 24^65 | 24^65 | 24^65 |
| 8_9 | 8^1908 | 8^2130 | 8^239 16^134 24^36 | 8^1 16^1488 24^282 | 12^1 24^1770 | 12^1 24^1770 | 12^1 24^1770 | 12^1 24^1770 |
| 8_10^+ | 8^26 | 8^5964 | 8^663 | 16^35 | 24^35 | 24^35 | 24^35 | 24^35 |
| 8_11^+ | 8^488 | 8^453 | 8^5056 16^5 | 16^4 | 24^4 | 24^4 | 24^4 | 24^4 |
| 8_12 | 8^1830 | 8^28970 | 8^36 | 16^108 | 24^108 | 24^108 | 24^108 | 24^108 |
| 8_13^+ | 8^19974 | 8^190 | 8^10 | 8^121 16^316 24^107 | 16^28 24^516 | 24^544 | 24^544 | 24^544 |
| 8_14^+ | 8^7375 | 8^860 | 8^748 16^11 | 16^15 | 24^15 | 24^15 | 24^15 | 24^15 |
| 8_15^+ | 4^2 8^1 | 8^110 | 4^10 8^559 | 4^7 8^350 12^3 16^1259 24^57 | 12^10 24^1666 | 12^10 24^1666 | 12^10 24^1666 | 12^10 24^1666 |
| 8_16^+ | 4^14 8^4083 | 8^146 | 8^6 | 16^2 | 24^2 | 24^2 | 24^2 | 24^2 |
| 8_17 | 8^7542 | 8^1036 | 8^3234 | 8^1154 16^998 24^64 | 16^60 24^2156 | 24^2216 | 24^2216 | 24^2216 |
| 8_18 | 4^4 8^2 | 2^6 4^6 8^90 | 8^8500 | 8^148 | 24^148 | 24^148 | 24^148 | 24^148 |
| 8_19^+ | 1^1 2^3 4^9 8^15 | 8^207 | 4^13 8^75 16^30 | 8^12 12^13 16^30 24^249 | 12^25 24^279 | 12^25 24^279 | 12^25 24^279 | 12^25 24^279 |
| 8_20^+ | 4^3 8^13 | 8^159 | 8^5 | 16^5 | 24^5 | 24^5 | 24^5 | 24^5 |
| 8_21^+ | 4^2 8^2 | 8^90 | 4^1 8^428 | 12^1 16^315 24^852 | 12^1 24^1167 | 12^1 24^1167 | 12^1 24^1167 | 12^1 24^1167 |

(Arithmetic checks against Table 6, all consistent: 8_3 L=1: 4·3+8·1135 = 9092 ✓; 8_6 L=2: 8^1 = 8 ✓; 8_19 L=1: 1+6+36+120 = 163 ✓ (explains odd 163). 8_2 L=4 8^594 16^1294 24^22: 4752+20704+528 = 25984 ✓. 8_18 L=4: 8^148 = 1184 ✓; but 8_18 L=5: 24^148 = 3552 ✓.)

## Figures
- **Fig. 1 (p. 3)** — "A minimal length lattice knot of type 3_1 squeezed between two hard walls. The lattice knot is grafted to the bottom wall – that is, it has at least one vertex in this wall. If the two hard walls are a distance L apart, then the height of the lattice knot is h ≤ L, since the polygon must fit between the two walls. The number of these lattice knots of length n are denoted p^L_n(K)." *What it shows:* 3D lattice trefoil between two parallel plates. Image: ../figures/GJvRR12/p03.png
- **Fig. 2 (p. 3)** — "A minimal length lattice knot of type 3_1 grafted to the bottom wall and covered by a weightless flexible membrane. … The number of these lattice knots of length n is denoted by p_n(K; h)." *What it shows:* trefoil on a hard floor with a membrane resting on its top vertices. Image: ../figures/GJvRR12/p03.png
- **Fig. 3 (p. 6)** — "A scatter plot of minimal lengths n_{1,K} in S_1 (X-axis) and minimal lengths n_K (Y-axis)." *What it shows:* one point per knot type up to 8 crossings; points lie near a line, n_{1,K} > n_K for all nontrivial knots. Image: ../figures/GJvRR12/p06.png
- **Fig. 4 (p. 7)** — "A scatter plot of the number of minimal length lattice knots p_{n_{1,K}}(K) in S_1 (X-axis) and the number of minimal length lattice knots p_{n_K}(K) (Y-axis) on a log-log scale." *What it shows:* wide scatter, no strong correlation. Image: ../figures/GJvRR12/p07.png
- **Fig. 5 (p. 10)** — "A profile of critical forces f_L for the lattice knot of type 3_1^+ … k = 1/4 and T = 1." *What it shows:* bar graph of f_L vs L (0..10); red bars entropic only, blue bars with Hooke contribution; big bar at small L (f_1 = ∞ drawn off-scale), small bars at L=3,4, zero for L ≥ 5. Image: ../figures/GJvRR12/p10.png
- **Fig. 6 (p. 10)** — same for 4_1 (k_1 = k_2 = 1/4 as printed ⚠ "k1 = k2" vs single k elsewhere, T=1). Image: ../figures/GJvRR12/p10.png
- **Fig. 7 (p. 11)** — critical-force profiles for 5_1^+ and 5_2^+ (k=1/4, T=1); no resistance until L=5. 
- **Fig. 8 (p. 12)** — profiles for 6_1^+, 6_2^+, 6_3; negative bar for 6_1^+ between L=2 and 3. Image: ../figures/GJvRR12/p12.png
- **Fig. 9, 10 (pp. 12–13)** — profiles for 3_1^+#3_1^+ and 3_1^+#3_1^− (Fig. 10 logarithmic vertical axis).
- **Fig. 11 (p. 17)** — ⟨h⟩ (red) and κ (blue) vs f for unknot. *Shows:* ⟨h⟩ from 1 (pulling) to 0 (pushing), ⟨h⟩ = 2/3 at f = 0.
- **Fig. 12 (p. 18)** — ⟨h⟩ and κ of 3_1^+ vs f, k = 1/4; two peaks in κ. Image: ../figures/GJvRR12/p18.png
- **Fig. 13 (p. 19)** — same with k = 4/3; three peaks. Image: ../figures/GJvRR12/p19.png
- **Fig. 14 (p. 20)** — ⟨h⟩, κ of 4_1 (k=1/4); two peaks. Image: ../figures/GJvRR12/p20.png
- **Fig. 15 (p. 21)** — ⟨h⟩ and κ for 5_1^+ (red) and 5_2^+ (blue), k=1/4. Image: ../figures/GJvRR12/p21.png
- **Fig. 16 (p. 21)** — ⟨h⟩ and κ for 6_1^+, 6_2^+, 6_3, k=1/4; two peaks each, 6_3 most resistant.
- **Fig. 17 (p. 24)** — "A scatter plot of W with k = 1/4 (horizontal axis) and k = 1, (vertical axis)." Prime knots lie along a band. Image: ../figures/GJvRR12/p24.png
- Table pages rendered: p14 (Table 1), p28 (Table 6). Images: ../figures/GJvRR12/p14.png, p28.png

## Stated limitations, open problems, future work
- p. 5: "Our results are not rigorous, and in a strict sense the results of n_{L,K} are upper bounds while p^L_{n_{L,K}}(K;h) are lower bounds." "A comparison of our results with the data in reference [8] makes us confident that our results are exact in almost all cases." L=1 lists: "reasonably confident that in most cases our lists … are complete."
- p. 8: low-temperature stiff-spring approximation; thermal fluctuations in length not modelled.
- p. 25: add bending or wall-binding energy; simulate in pores or channels, where "the algorithm is not known to be irreducible."

## References worth following
- [4] Diao, Minimal knotted polygons on the cubic lattice, JKTR 2 (1993) 413–425.
- [8] Ishihara, Scharein, Diao, Arsuaga, Vazquez, Shimokawa, Bounds for the minimum step number of knots confined to slabs in the simple cubic lattice, J. Phys. A 45 (2012) 065003.
- [22] Scharein et al., Bounds for the minimum step number of knots in the simple cubic lattice, J. Phys. A 42 (2009) 475006.
- [11,12] JvR & Rechnitzer, Generalized atmospheric sampling of self-avoiding walks (2009) / of knotted polygons (JKTR 2010).
- [13] JvR & Rechnitzer, The compressibility of minimal lattice knots, J. Stat. Mech. 2012 P05003.
- [15] JvR & Whittington, The BFACF algorithm and knotted polygons, J. Phys. A 24 (1991) 5553.
- [9] JvR, Squeezing knots, J. Stat. Mech. 2007 P03001.

## Extraction notes
- All of Tables 1–10 checked against page images (Tables 5, 6, 7, 8 at 110 dpi; 9, 10 at 220 dpi crops; 1, 2, 3 at 120–130 dpi with the text layer as backup for small fractions). Small fractions in Tables 1–2 were read from the text layer, whose numerator–denominator order was validated against Eqs. (9)–(10) and Table 3.
- ⚠ Table 1/2 column label offset (see Notation); ⚠ "10/379" typo; ⚠ Table 3 8_13 entry; ⚠ Appendix intro (p. 26) refers to "tables ??, 7, 6 and 8" (broken reference); ⚠ Fig. 6 caption "k1 = k2 = 1/4".
- ⟨h⟩ for 5_1^+ in eq. (27) and κ expressions not fully transcribed (garbled in text layer; low value).
- Figure pages rendered: 3, 6, 7, 10, 12, 14, 18, 19, 20, 21, 24, 28.
