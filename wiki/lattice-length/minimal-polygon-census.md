# Census of minimal-length lattice knots (SC / FCC / BCC): lengths, counts, symmetry, writhe, curvature

Numerical data on the *set* of minimal-length polygons of each knot type. For which values are **proved** see [exact-values-and-proofs](exact-values-and-proofs.md); for the full ≤10-crossing SC length table see [tables-minimal-length](tables-minimal-length.md).

**Status of everything on this page: numerical (Monte Carlo), not proved**, unless a proof is cited. All from [JvRR11] unless marked.

## Definitions ([JvRR11] §1)

| symbol | meaning |
|---|---|
| p_n(K) | number of polygons of length n, knot type K, modulo translation ("unrooted") |
| n_K | minimal length: p_{n_K}(K) > 0 and p_n(K) = 0 for n < n_K |
| P_K = p_{n_K}(K) | number of minimal-length polygons (both chiralities counted if K chiral) |
| S_K | number of symmetry classes of minimal polygons under the 24-element octahedral rotation/reflection action used in the paper; notation 24^a 12^b 8^c = a classes of size 24, b of size 12, … |
| W_K, \|W\|_K | mean writhe, mean absolute writhe over the minimal polygons |
| K_K | mean total curvature in units of 2π (SC: curvature = (π/2)·#right angles) |
| E_K = log P_K / n_K | entropy per unit length at minimal length |
| α_K = lim n_{K^p}/p | minimal lattice edge index (exists by subadditivity) |
| γ_K = limsup log P_{K^m} / m | entropic index per knot component |

Basic facts quoted in [JvRR11] §1.1–1.2:
* SC: p_4(0_1)=3; p_n(K)=0 for n<24 if K≠0_1, p_24(3_1)=3328 (1664 per chirality) — proof of 24 is [Diao93], count attributed to [Scharein09]; S_{3_1}=142 = 137 classes of 24 + 5 classes of 8.
* FCC: p_3(0_1)=8, n_{3_1}=15, p_15(3_1)=64. BCC: p_4(0_1)=12, n_{3_1}=18, p_18(3_1)=1584. (Numerical.)
* Concatenation ([JvRR11] Fig. 2, eq. 5–9): p_n(K)p_m(L) ≤ 2 p_{n+m}(K#L) in SC ⇒ **n_{K#L} ≤ n_K + n_L**, n_{K^p} ≤ p·n_K. FCC/BCC analogues with constants 36, 16 and an additive N=2.
* α_K ≥ 4(b_K − 1) (b = bridge number) in SC, ≥ 3(b−1) FCC, ≥ 2(b−1) BCC; 4 ≤ α_{3_1} ≤ 17 (attributed to [JvRP95] and JvR 1996).
* 4·Wr is an integer for SC polygons (Wr = average linking number with 4 push-offs, Lacher–Sumners); 12·Wr integer in BCC; FCC writhe generally irrational.
* Minimal lattice curvature (JvR–Promislow 1999, quoted): C_{0_1}=2π, C_{3_1}=6π, C_{9_47}=9π in SC; minimum curvature need not occur at minimal length.

## Method

GAS (generalised atmospheric sampling) with BFACF moves in SC and BFACF-style moves in FCC/BCC; up to 500 chains × 10⁷ states per knot type, lengths up to 500–700; minimal polygons sieved and hashed. See [algorithms/bfacf-and-gas](../algorithms/bfacf-and-gas.md).

**Reliability stated by the authors** ([JvRR11] §3.1.2): "very sure" if P_K ≲ 1000; reasonably certain 1000–10 000; less certain 10 000–100 000; **P_K is only a lower bound if P_K ≳ 100 000**.

## SC lattice, prime knots — [JvRR11] Table 3

Right-handed chirality simulated, so W_K ≥ 0. Fractions are mixed numbers (`3 735/1664` = 3 + 735/1664). Page image: [figures/JvRR11/p15.png](../figures/JvRR11/p15.png). **All 42 rows checked against a 130-dpi render of p. 15 (11 Nov 2026): no discrepancies.**

| K | n_K | P_K | S_K | classes | W_K | \|W\|_K | K_K (×2π) |
|---|---|---|---|---|---|---|---|
| 0_1 | 4 | 3 | 1 | 3^1 | 0 | 0 | 1 |
| 3_1 | 24 | 3328 | 142 | 24^137 8^5 | 3 735/1664 | = | 3 801/1664 |
| 4_1 | 30 | 3648 | 152 | 24^152 | 0 | 33/152 | 4 1/152 |
| 5_1 | 34 | 6672 | 278 | 24^278 | 6 127/556 | = | 4 459/556 |
| 5_2 | 36 | 114912 | 4788 | 24^4788 | 4 5057/9576 | = | 5 61/9576 |
| 6_1 | 40 | 6144 | 258 | 24^254 12^4 | 1 49/512 | = | 5 223/512 |
| 6_2 | 40 | 32832 | 1368 | 24^1368 | 2 1079/1368 | = | 5 65/456 |
| 6_3 | 40 | 3552 | 148 | 24^148 | 0 | 29/148 | 4 36/37 |
| 7_1 | 44 | 33960 | 1415 | 24^1415 | 9 61/283 | = | 6 322/1415 |
| 7_2 | 46 | 336360 | 14016 | 24^14014 12^2 | 5 10539/14015 | = | 6 811/28030 |
| 7_3 | 44 | 480 | 20 | 24^20 | 7 19/40 | = | 5 31/40 |
| 7_4 | 44 | 168 | 7 | 24^7 | 5 4/7 | = | 5 2/7 |
| 7_5 | 46 | 9456 | 394 | 24^394 | 7 107/394 | = | 6 83/394 |
| 7_6 | 46 | 34032 | 1418 | 24^1418 | 3 625/1418 | = | 5 614/709 |
| 7_7 | 44 | 504 | 21 | 24^21 | 43/84 | = | 5 1/12 |
| 8_1 | 50 | 23736 | 990 | 24^988 12^2 | 2 813/1978 | = | 6 514/989 |
| 8_2 | 50 | 91680 | 3820 | 24^3820 | 5 2081/3820 | = | 6 1259/3820 |
| 8_3 | 48 | 12 | 1 | 12^1 | 0 | 0 | 5 91/97 |
| 8_4 | 50 | 47856 | 1994 | 24^1994 | 1 2613/3988 | = | 6 1675/3988 |
| 8_5 | 50 | 1152 | 48 | 24^48 | 5 5/8 | = | 6 5/24 |
| 8_6 | 50 | 11040 | 460 | 24^460 | 4 7/920 | = | 6 273/920 |
| 8_7 | 48 | 48 | 2 | 24^2 | 2 3/4 | = | 5 3/4 |
| 8_8 | 50 | 3120 | 130 | 24^130 | 1 21/260 | = | 6 89/260 |
| 8_9 | 50 | 35280 | 1470 | 24^1470 | 0 | 527/2940 | 6 307/980 |
| 8_10 | 50 | 1680 | 70 | 24^70 | 3 1/140 | = | 5 121/140 |
| 8_11 | 50 | 192 | 8 | 24^8 | 4 1/8 | = | 6 3/8 |
| 8_12 | 52 | 2592 | 108 | 24^108 | 71/216 | = | 6 187/216 |
| 8_13 | 50 | 26112 | 1088 | 24^1088 | 1 399/2176 | = | 5 2099/2176 |
| 8_14 | 50 | 720 | 30 | 24^30 | 3 59/60 | = | 6 29/60 |
| 8_15 | 52 | 80208 | 3342 | 24^3342 | 7 2957/3342 | = | 6 549/1114 |
| 8_16 | 50 | 96 | 4 | 24^4 | 2 5/8 | = | 5 7/8 |
| 8_17 | 52 | 53184 | 2216 | 24^2216 | 0 | 1099/4432 | 6 321/4432 |
| 8_18 | 52 | 3552 | 148 | 24^148 | 0 | 10/37 | 5 71/148 |
| 8_19 | 42 | 13992 | 592 | 24^574 12^18 | 8 885/1166 | = | 5 267/583 |
| 8_20 | 44 | 240 | 10 | 24^10 | 2 1/10 | = | 4 9/10 |
| 8_21 | 46 | 56040 | 2335 | 24^2335 | 4 2499/4670 | = | 5 373/467 |
| 9_1 | 54 | 345960 | 14417 | 24^14414 8^3 | 12 283/4805 | = | 7 5763/9610 |
| 9_2 | 56 | 3281304 | 136721 | 24^136721 | 6 105057/136721 | = | 7 96676/136721 |
| 9_42 | 48 | 27744 | 1156 | 24^1156 | 1 953/2312 | = | 5 1939/2312 |
| 9_47 | 50 | 13680 | 570 | 24^570 | 2 4/5 | = | 5 47/95 |
| 10_1 | 60 | 462576 | 19298 | 24^19250 12^48 | 3 12507/38548 | = | 8 5341/38548 |
| 10_2 | 60 | 871296 | 36304 | 24^36304 | 8 42761/72608 | = | 7 56813/72608 |

"=" means |W|_K = W_K as printed. *Transcription notes:* (i) 8_12 is listed with nonzero W_K = 71/216 although 8_12 is amphichiral — printed that way in the source; (ii) the text of [JvRR11] §1 writes K_{3_1} once as 3 801/1664 (table) and once as "6 801/832 π" (same number).

Additional SC minimal lengths without census data ([JvRR11] Table 1): **11_1: 64, 11_2: 66, 12_1: 70, 12_2: 70**.

### SC trefoils just above minimal length — [JvRR11] Table 4

| n | p_n(3_1) | S | classes | W | K (×2π) |
|---|---|---|---|---|---|
| 24 | 3328 | 142 | 24^137 8^5 | 3 735/1664 ≈ 3.4417 | 3 801/1664 |
| 26 | 281208 | 11721 | 24^11713 12^8 | 3 10773/23434 ≈ 3.4597 | 3 23017/23434 |
| 28 | 14398776 | 599949 | 24^599949 | 3 40144/85707 ≈ 3.4685 | 4 267364/599949 |

Mean writhe of the trefoil is nearly independent of length (≈3.44).

### SC composite knots — [JvRR11] Tables 2 and 11

Image: [figures/JvRR11/p28.png](../figures/JvRR11/p28.png). Authors consider these less secure than the prime data; (3_1^+)^4, (3_1^+)^5, (4_1)^3 counts are lower bounds "within a few percent".

| K | n_K | P_K | S_K | W_K | \|W\|_K | K_K |
|---|---|---|---|---|---|---|
| 3_1^+ | 24 | 3328 | 142 | 3 735/1664 | = | 3 801/1664 |
| (3_1^+)^2 | 40 | 30576 | 1275 | 6 45/49 | = | 5 278/637 |
| (3_1^+)^3 | 56 | 288816 | 12034 | 10 1711/4376 | = | 7 13603/48136 |
| (3_1^+)^4 | 72 | 5582160 | 232606 | 13 799403/930360 | 13 799503/930360 ⚠ | 9 410101/930360 |
| (3_1^+)^5 | 88 | 71561664 | 2981736 | 17 4051667/11926944 | = | 11 2709893/3975648 |
| 3_1^+ # 3_1^- | 40 | 143904 | 6058 | 0 | 1085/5996 | 5 1749/11992 |
| 4_1 # 3_1 | 46 | 359712 | 14988 | 3 4259/9992 | = | 5 22693/29976 |
| 5_1^+ # 3_1^+ | 50 | 200976 | 8374 | 9 10169/16748 | = | 6 10715/16748 |
| 5_1^+ # 3_1^- | 50 | 568752 | 23698 | 2 9174/11849 | = | 6 12351/23698 |
| 5_2^+ # 3_1^+ | 52 | 7357008 | 306542 | 7 305199/306542 | = | 6 246067/306542 |
| 5_2^+ # 3_1^- | 50 | 5280 | 220 | 1 7/88 | = | 6 87/440 |
| (3_1^+)^2 # 3_1^- | 56 | 8893152 | 370548 | 3 57571/123516 | = | 6 167021/185274 |
| 4_1 | 30 | 3648 | 152 | 0 | 33/152 | 4 1/152 |
| (4_1)^2 | 52 | 334824 | 14144 | 0 | 3450/13951 | 6 13089/27902 |
| (4_1)^3 | 74 | 31415592 | 1308983 | 0 | 3384343/1308983 | 8 2294775/2617966 |

Table 11 checked against a 130-dpi render of p. 28 (11 Nov 2026); all n_K, P_K, S_K, W_K, K_K cells agree. ⚠ For (3_1^+)^4 the printed |W| numerator (799503) differs from W (799403) — confirmed at 300 dpi; probably a typo, since for the other chiral composites |W| = W. Class decompositions printed there: (3_1^+)^2 = 24^1273 12^2; (3_1^+)^4 = 24^232582 8^24; 3_1^+#3_1^- = 24^5934 12^124 (= 6058 classes; [JvRRgas] Table 1 gives 6056); (4_1)^2 = 24^13758 12^386 (= 14144 classes; [JvRRgas] Table 1 gives 13987, and the |W| denominator 13951 matches neither).

Lengths only ([JvRR11] Table 2): (3_1^+)^6: 104; (4_1)^4: 96; (4_1)^5: 118; (4_1)^6: 140.

**Observed patterns (unproved, [JvRR11] §3.1.1):**
* n_{(3_1)^N} = 24 + 16(N−1) for N ≤ 6 (i.e. 24, 40, 56, 72, 88, 104) ⇒ if it persists α_{3_1} = 16; from data α_{3_1^+} ≤ 104/6 = 17 1/3, which does not beat the proven α ≤ 17.
* n_{(4_1)^N} = 30 + 22(N−1) for N ≤ 6 ⇒ suggests α_{4_1} = 22; best bound from data 140/6 = 23 1/3.
* Prime families step by 10: T(2,N): 3_1,5_1,7_1,9_1,11_1 = 24,34,44,54,64; twist knots 4_1,6_1,8_1,10_1,12_1 = 30,…,70; 5_2,7_2,9_2,11_2 = 36,46,56,66; 4_1,6_2,8_2,10_2,12_2 = 30,…,70.
* Estimates of γ_{3_1} from (3_1)^N, N=1..5: 8.1101, 5.1639, 4.1912, 3.8838, 3.4424 (not converged). Writhe per component ζ_{3_1} ≈ 3.47; curvature per component β_{3_1} ≈ 2.3 (×2π).
* (3_1^+)^2 # (3_1^-)^2 could not be completed (>7 000 000 symmetry classes found before memory ran out).

### Growth of the number of knot types Q_n = #{K : n_K ≤ n} ([JvRR11] §3.1.1)

1 ≤ lim sup Q_n^{1/n} =: Q ≤ μ. Data: SC Q_30=4, Q_40=16, Q_50 ≥ 74 ⇒ Q ≳ 1.0899; FCC Q_35 ≥ 37 ⇒ ≳ 1.1055; BCC Q_38 ≥ 35 ⇒ ≳ 1.0929. Suggests Q_SC < Q_BCC < Q_FCC.

### Entropy per edge E_K (SC) ([JvRR11] §3.1.2)

E_{0_1} = 0.2747, E_{3_1^+} = 0.3090, E_{4_1} = 0.2733, E_{5_1} = 0.2386, E_{5_2} = 0.3223 (text; elsewhere in the same paragraph the twist family lists 0.3044 for 5_2). Very tight (low E): 7_3 0.1246, 7_4 0.1007, 7_7 0.1257, 8_3 0.0807, 8_7 0.0662, 8_11 0.0913, 8_16 0.0774, 8_20 0.1088. Only eight listed prime types admit a symmetric minimal embedding. Ranking of knots by E_K differs completely between the three lattices ([JvRR11] Table 12): 3_1 ranks 1st in SC, 26th in FCC, 2nd in BCC.

## FCC lattice — [JvRR11] Tables 5, 6

Checked cell by cell against a 130-dpi render of p. 20 ([figures/JvRR11/p20.png](../figures/JvRR11/p20.png)), 11 Nov 2026. Writhes are irrational in FCC and printed as decimals; K_K in units of 2π.

| K | n_K | P_K | S_K | classes | W_K | \|W\|_K | K_K |
|---|---|---|---|---|---|---|---|
| 0_1 | 3 | 8 | 1 | 8^1 | 0 | 0 | 1 |
| 3_1 | 15 | 64 | 4 | 24^2 8^2 | 3.3245203 | 3.3245203 | 2 3/4 |
| 4_1 | 20 | 2796 | 130 | 24^106 12^18 6^6 | 0 | 0.0649554 | 3 175/699 |
| 5_1 | 22 | 96 | 4 | 24^4 | 6.04086733 | 6.04086733 | 3 1/2 |
| 5_2 | 23 | 768 | 32 | 24^32 | 4.58773994 | 4.58773994 | 3 3/4 |
| 6_1 | 27 | 19008 | 792 | 24^792 | 1.30062599 | 1.30062599 | 4 449/1188 |
| 6_2 | 27 | 5040 | 210 | 24^210 | 2.68566969 | 2.68566969 | 4 199/630 |
| 6_3 | 28 | 102720 | 4280 | 24^4280 | 0 | 0.10145467 | 4 11519/25680 |
| 7_1 | 29 | 4080 | 170 | 24^170 | 8.83566369 | 8.83566369 | 4 919/1020 |
| 7_2 | 30 | 4128 | 172 | 24^172 | 5.94373229 | 5.94373229 | 4 37/43 |
| 7_3 | 30 | 960 | 40 | 24^40 | 7.30408669 | 7.30408669 | 4 3/5 |
| 7_4 | 30 | 96 | 4 | 24^4 | 6.17547989 | 6.17547989 | 4 5/6 |
| 7_5 | 31 | 27456 | 1144 | 24^1144 | 7.31767838 | 7.31767838 | 4 853/858 |
| 7_6 | 31 | 4896 | 204 | 24^204 | 3.29853635 | 3.29853635 | 5 2/17 |
| 7_7 | 32 ‡ | 1296 | 54 | 24^54 | 0.66279311 | 0.66279311 | 5 35/162 |
| 8_1 | 34 | 447816 | 18696 | 24^18622 12^74 | 2.51971823 | 2.51971823 | 5 11155/18659 |
| 8_2 | 34 | 116016 | 4834 | 24^4834 | 5.39777682 | 5.39777682 | 5 7991/14502 |
| 8_3 | 34 | 19200 | 800 | 24^800 | 0 | 0.06471143 | 5 73/240 |
| 8_4 | 34 | 41088 | 1712 | 24^1712 | 1.39528958 | 1.39528958 | 5 863/1712 |
| 8_5 | 34 | 2976 | 130 | 24^118 12^12 | 5.40078543 | 5.40078543 | 5 12/31 |
| 8_6 | 34 | 9408 | 392 | 24^392 | 3.94736084 | 3.94736084 | 5 10/21 |
| 8_7 | 34 | 1258 † | 52 | 24^52 | 2.70284845 | 2.70284845 | 5 21/52 |
| 8_8 | 34 | 3024 | 126 | 24^126 | 1.28153619 | 1.28153619 | 5 9/14 |
| 8_9 | 34 | 5184 | 216 | 24^216 | 0 | 0.0808692 | 5 20/81 |
| 8_10 | 34 | 1728 | 72 | 24^72 | 2.82452035 | 2.82452035 | 5 5/18 |
| 8_11 | 35 | 298128 | 12422 | 24^12422 | 3.97223690 | 3.97223690 | 5 11713/18633 |
| 8_12 | 35 | 16416 | 684 | 24^684 | 0.13164234 | 0.13164234 | 5 173/229 |
| 8_13 | 35 | 274320 | 11430 | 24^11430 | 1.30541189 | 1.30541189 | 5 9256/17145 |
| 8_14 | 35 | 27360 | 1140 | 24^1140 | 4.00297606 | 4.00297606 | 5 1109/1710 |
| 8_15 | 35 | 36432 | 1518 | 24^1518 | 7.98074463 | 7.98074463 | 5 215/414 |
| 8_16 | 35 | 15552 | 648 | 24^648 | 2.66666668 | 2.66666668 | 5 17/36 |
| 8_17 | 35 | 5184 | 216 | 24^216 | 0 | 0.08782937 | 5 35/108 |
| 8_18 | 36 | 41196 | 1776 | 24^1662 12^104 6^10 | 0 | 0.12891984 | 5 1817/3433 |
| 8_19 | 28 | 276 | 12 | 24^11 12^1 | 8.45506005 | 8.45506005 | 4 |
| 8_20 | 30 | 74088 | 3087 | 24^3087 | 2.04596806 | 2.04596806 | 4 3137/6174 |
| 8_21 | 31 | 17856 | 744 | 24^744 | 4.66448881 | 4.66448881 | 4 2039/2232 |
| 9_1 | 35 | 192 | 8 | 24^8 | 11.58173466 | 11.58173466 | 5 3/4 |
| 9_2 | 37 | 229824 | 9576 | 24^9576 | 7.13091283 | 7.13091283 | 6 2/21 |
| 9_42 | 32 | 96 | 4 | 24^4 | 1.02043366 | 1.02043366 | 4 5/12 |
| 9_47 | 35 | 3072 | 128 | 24^128 | 2.62349866 | 2.62349866 | 5 19/48 |
| 10_1 | 40 | 77688 | 3246 | 24^3228 12^18 | 3.74646905 | 3.74646905 | 6 11237/19422 |
| 10_2 | 40 | 8928 | 372 | 24^372 | 8.14499622 | 8.14499622 | 6 671/1116 |

† printed 1258 with 24^52 classes (52·24 = 1248) — internal inconsistency in the source. ‡ [JvRR11] Table 5 lists 7_7 under n=31 but Table 6 gives 32 — internal inconsistency in the source; check Rechnitzer's data files before using.

FCC trefoils ([JvRR11] Table 7): p_15=64, p_16=3672, p_17=104376; mean writhe 3.3245, 3.3471, 3.3610. FCC step patterns (T(2,N) +7, twist +7) break down by 9_1 / 10_1, unlike SC.

## BCC lattice — [JvRR11] Tables 8, 9

Checked cell by cell against the page image [figures/JvRR11/p24.png](../figures/JvRR11/p24.png) (11 Nov 2026). Mean curvature = B_K·arccos(1/√3) + 2π·K_K; the last column is "B_K, K_K" as printed. "=" means |W|_K = W_K.

| K | n_K | P_K | S_K | classes | W_K | \|W\|_K | B_K, K_K |
|---|---|---|---|---|---|---|---|
| 0_1 | 4 | 12 | 2 | 6^2 | 0 | 0 | −2, 3/2 |
| 3_1 | 18 | 1584 | 66 | 24^66 | 3 40/99 | = | 11 4/33, 21/22 |
| 4_1 | 20 | 12 | 2 | 6^2 | 0 | 0 | 16, 0 |
| 5_1 | 26 | 14832 | 618 | 24^618 | 6 83/1854 | = | 19 38/103, 177/206 |
| 5_2 | 26 | 4872 | 203 | 24^203 | 4 129/203 | = | 17 23/203, 164/203 |
| 6_1 | 28 | 72 | 4 | 24^2 12^2 | 1 1/3 | = | 24, 0 |
| 6_2 | 30 | 8256 | 344 | 24^344 | 2 30/43 | = | 20 21/43, 35/43 |
| 6_3 | 30 | 3312 | 138 | 24^138 | 0 | 4/69 | 19 35/69, 56/69 |
| 7_1 | 32 | 1464 | 61 | 24^61 | 9 | = | 24 38/61, 1 |
| 7_2 | 32 | 24 | 1 | 24^1 | 6 | = | 28, 0 |
| 7_3 | 34 | 22488 | 937 | 24^937 | 7 919/2811 | = | 25/55 937 ⚠, 745/937 |
| 7_4 | 34 | 11208 | 468 | 24^466 12^2 | 5 464/467 | = | 24 394/467, 340/467 |
| 7_5 | 34 | 8784 | 366 | 24^366 | 7 196/549 | = | 22 24/61, 47/61 |
| 7_6 | 32 | 48 | 2 | 24^2 | 3 1/3 | = | 26, 0 |
| 7_7 | 32 | 24 | 1 | 24^1 | 2/3 | = | 24, 0 |
| 8_1 | 36 | 744 | 32 | 24^30 12^2 | 2 2/3 | = | 32, 0 |
| 8_2 | 38 | 118080 | 4920 | 24^4920 | 5 782/1845 | = | 28 153/410, 431/492 |
| 8_3 | 36 | 108 | 6 | 24^4 6^2 | 0 | 0 | 32, 0 |
| 8_4 | 38 | 93984 | 3916 | 24^3916 | 1 4715/11748 | = | 27 955/1958, 3849/3916 |
| 8_5 | 38 | 7392 | 318 | 24^298 12^20 | 5 331/924 | = | 29 11/14, 195/308 |
| 8_6 | 38 | 9024 | 376 | 24^376 | 4 1/282 | = | 28 87/94, 117/188 |
| 8_7 | 38 | 47856 | 1994 | 24^1994 | 2 2035/2991 | = | 27 59/997, 784/997 |
| 8_8 | 38 | 34656 | 1444 | 24^1444 | 1 112/361 | = | 26 177/361, 280/361 |
| 8_9 | 38 | 5712 | 238 | 24^238 | 0 | 1/14 | 26 55/119, 185/238 |
| 8_10 | 38 | 11088 | 462 | 24^462 | 2 313/462 | = | 25 6/7, 125/154 |
| 8_11 | 38 | 15888 | 662 | 24^662 | 4 49/1986 | = | 27 198/331, 425/662 |
| 8_12 | 36 | 12 | 2 | 6^2 | 0 | 0 | 24, 0 |
| 8_13 | 38 | 17616 | 734 | 24^734 | 1 241/734 | = | 25 180/367, 561/734 |
| 8_14 | 38 | 16944 | 706 | 24^706 | 4 1/353 | = | 25 205/353, 253/353 |
| 8_15 | 38 | 4272 | 180 | 24^176 12^4 | 8 1/89 | = | 24 52/89, 71/89 |
| 8_16 | 38 | 1056 | 44 | 24^44 | 2 29/44 | = | 27 15/22, 23/44 |
| 8_17 | 38 | 912 | 38 | 24^38 | 0 | 7/114 | 24 9/19, 31/38 |
| 8_18 | 40 | 8820 | 384 | 24^354 12^24 6^6 | 0 | 94/735 | 24 116/735, 1 81/245 |
| 8_19 | 32 | 1110 | 48 | 24^45 12^2 6^1 | 8 102/185 | = | 23 29/185, 64/185 |
| 8_20 | 34 | 117096 | 4879 | 24^4879 | 2 372/4879 | = | 19 4575/4879, 1 614/4879 |
| 8_21 | 34 | 696 | 30 | 24^28 12^2 | 4 43/87 | = | 23 23/29, 14/29 |
| 9_1 | 40 | 80928 | 3372 | 24^3372 | 11 14113/20232 | = | 32 3287/3372, 1 2719/3372 |
| 9_2 | 40 | 13824 | 576 | 24^576 | 7 1/192 | = | 29 211/288, 1 77/96 |
| 9_42 | 36 | 2736 | 114 | 24^114 | 1 29/171 | = | 24 5/57, 56/57 |
| 9_47 | 40 | 68208 | 2842 | 24^2842 | 2 2033/2842 | = | 22 1/49, 3 296/1421 |
| 10_1 | 42 | 288 | 12 | 24^12 | 3 2/3 | = | 38, 0 |
| 10_2 | 44 | 9816 | 409 | 24^409 | 8 136/409 | = | 34 150/409, 1 299/409 |

⚠ 7_3: the B_K cell prints as "25/55 937" in the image (garbled typesetting); not interpretable. ⚠ 8_19 classes 24^45 12^2 6^1 sum to 1110 polygons but 45+2+1 = 48 = S_K (consistent).

BCC trefoils ([JvRR11] Table 10): p_18 = 1584 (printed 1583 in Table 10), p_20 = 236928, p_22 = 21116472. BCC curvature has the form B·arccos(1/√3) + 2π·K with rational B, K; mean trefoil curvature 16.62 < 6π (the SC minimum).

## Cross-lattice conclusions ([JvRR11] §4)

Properties of minimal lattice knots are **not universal** across SC/FCC/BCC: the ordering of knot types by n_K, the entropy ranking, and writhe details all change (e.g. n_{6_1}=n_{6_2}=n_{6_3}=40 in SC, but 6_3 is longer in FCC and 6_1 shorter in BCC; |W|_{8_3} = 0 in SC and BCC but not FCC; |W|_{4_1} = 0 in BCC only).

Open questions raised: is γ_K > 0 for every non-trivial K? Do chiral knots with |W| < 1 exist at every crossing number ≥ 6? Do the step-10 / step-16 / step-22 patterns persist?

## Other analyses of the minimal polygons

* [Croll18]: binary encodings of NEWSUD words of minimal SC polygons (trefoil and knots ≤ 10 crossings, from [Scharein09]) have high BiEntropy (they look like disordered strings); entropy rises slightly with crossing number and encoding length, and non-alternating 9- and 10-crossing knots are more disordered than alternating ones. Mostly of information-theoretic interest.
* [MannML]: minimal *cube* knots are exactly twice as long as minimal lattice polygons — see [lower-bounds](lower-bounds.md#4a-equivalent-formulation-cube-knots-mannml).
