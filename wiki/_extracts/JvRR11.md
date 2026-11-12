# JvRR11 — Minimal Knotted Polygons in Cubic Lattices
- **Authors:** E J Janse van Rensburg, A Rechnitzer
- **Venue / year / identifiers:** arXiv:1107.2162v1 [cond-mat.stat-mech], 11 Jul 2011 (published J. Stat. Mech. 2011 P09008 — not printed on the arXiv copy)
- **File:** papers/1_core_lattice_length/JvR-Rechnitzer_2011_Minimal_knotted_polygons_cubic_lattices_1107.2162.pdf   **Pages:** 32
- **Text layer:** ok (tables garbled in text layer; Table 9 checked against image)

## Abstract
An implementation of BFACF-style algorithms [1, 2, 5] on knotted polygons in the simple cubic, face centered cubic and body centered cubic lattice [31, 32] is used to estimate the statistics and writhe of minimal length knotted polygons in each of the lattices. Data are collected and analysed on minimal length knotted polygons, their entropy, and their lattice curvature and writhe.

## Notation and conventions
- Polygons counted **modulo translation** ("unrooted"); p_n(K) = number of length-n polygons of knot type K (p. 2–3).
- n_K = minimal length: p_{n_K}(K) > 0, p_n(K) = 0 for n < n_K (p. 5).
- P_K = p_{n_K}(K), total over **both chiralities** for chiral K (P_{3_1} = 3328, P_{3_1^+} = 1664) (p. 6).
- S_K = number of symmetry classes under the 24-element octahedral group; notation 24^a 12^b 8^c … (p. 6, 14).
- α_K = lim n_{K^p}/p, minimal lattice edge index (eq. 10, p. 5). γ_K = limsup (log P_{K^m})/m, entropic index per component (eq. 14, p. 6).
- W_K, |W|_K: mean writhe / mean absolute writhe over minimal polygons (eq. 20, p. 8). SC writhe via 4 push-offs (eq. 17), FCC via eq. 21 (irrational in general), BCC via 12 projection directions (eq. 22; 12·Wr integer).
- K_K = mean total curvature in units of 2π (eq. 23); BCC curvature = B_K arccos(1/√3) + 2πK_K (eq. 24, p. 9).
- E_K = log P_K / n_K, entropy per unit length (eq. 31, p. 16).
- Q_n = number of knot types with n_K ≤ n (p. 6, 12).

## Numbered statements
The paper has no numbered theorems. Displayed claims with status:
- **eq. (5) (p. 4)** SC: p_n(K) p_m(L) ≤ 2 p_{n+m}(K#L). Proved (concatenation, Fig. 2).
- **eq. (6) (p. 4)** FCC: p_n(K) p_m(L) ≤ 36 p_{n+m+N}(K#L), N = 2 suffices. Argued in text.
- **eq. (7) (p. 5)** BCC: p_n(K) p_m(L) ≤ 16 p_{n+m+N}(K#L), N = 2.
- **eq. (8)–(9) (p. 5)** SC: n_{K#K} ≤ 2n_K, n_{K#L} ≤ n_K + n_L, n_{K^p} ≤ p n_K.
- **eq. (10)–(12) (p. 5–6)** α_K exists; α_K ≥ 4(b_K − 1) SC (quoted [27, 20, 23]); α_K ≥ 3(b_K − 1) FCC and ≥ 2(b_K − 1) BCC ("one may present arguments similar to … [21]"). 4 ≤ α_{3_1^+} ≤ 17 quoted [27, 20].
- **eq. (29)–(30) (p. 12)** 1 ≤ Q := limsup Q_n^{1/n} ≤ μ; Q_n ≥ 2^{n/m} construction.
- Quoted (p. 9) from [28]: "it is known that C_{0_1} = 2π while C_{3_1} = 6π in the SC lattice [28]" (minimal lattice curvature C_K, as opposed to the average curvature); "C_K ≥ max{ (3 + √(9 + 8C_K)) π/4 , 3π b_K }", where b_K is the bridge number and, in this bound, C_K on the right is the minimal crossing number (the paper uses C_K for both; verified against the page image 2026-11-12, p. 9, so the earlier ⚠ "garbled" flag is cleared); "these bounds are in particular good enough to prove that C_{9_47} = 9π" (p. 9). Minimal lattice curvature index: "a minimal lattice curvature index ν_K is also proven to exist in reference [28]": lim_{n→∞} C_{K^n}/n = ν_K (eq. 25), with C_{K^n} ≥ n ν_K. "It is known that ν_{0_1} = 0 but that 2π ≤ ν_{3_1} ≤ 3π in the SC lattice, and one expect that 2πK_{K^n} ≥ C_{K^n} ≥ 2πn in the SC lattice. This shows that K_{K^n} increases at least as fast as n in the SC lattice." (p. 9; the last two inequalities are stated by the authors as an expectation, "one expect".) Footnote ¶ (p. 9): "Observe that the minimal lattice curvature of a lattice knot does not necessarily occur at minimal length.")
- Open question (p. 6): show γ_K > 0 for all non-trivial K.
- Open question (p. 17): do chiral knot types with mean absolute writhe < 1 exist for all crossing numbers C ≥ 6?

## Key equations and quantitative claims outside numbered statements
- p. 2–5 (numerical except SC): SC p_4(0_1) = 3, n_{3_1} = 24 [10], p_24(3_1) = 3328 [43 ⚠ cited as Portillo et al.; elsewhere [45] Scharein]; FCC p_3(0_1) = 8, n_{3_1} = 15, p_15(3_1) = 64; BCC p_4(0_1) = 12, n_{3_1} = 18, p_18(3_1) = 1584.
- p. 12: runs to lengths n ≤ M, 500 ≤ M ≤ 700; up to 500 GAS sequences × 10^7 states per knot type. (3_1^+)^5 and (4_1)^3 needed weeks of CPU; (3_1^+)^2(3_1^-)^2 exceeded memory.
- p. 13: Q_30 = 4, Q_40 = 16, Q_50 ≥ 74 (SC) ⇒ Q ≈ 1.0899 (lower-bound-like estimates). FCC Q_35 ≥ 37 ⇒ 1.10550; BCC Q_38 ≥ 35 ⇒ 1.0929.
- p. 13: SC families step by 10 (T(2,N): 24, 34, 44, 54, 64; twist 4_1…12_1: 30…70; 5_2…11_2: 36…66; 4_1,6_2,8_2,10_2,12_2: 30…70). No proofs.
- p. 13–14: n_{(3_1^+)^N} = 24 + 16(N−1), N ≤ 6 ⇒ α_{3_1^+} ≤ 17 1/3 from data; would give 16 if it persisted. n_{(4_1)^N} = 30 + 22(N−1), N ≤ 6 ⇒ best data bound 23 2/3 ⚠ (printed "23 2/3"; 140/6 = 23 1/3).
- p. 14: data reliability: very sure if P_K ≲ 1000; reasonably certain 1000–10 000; less certain 10 000–100 000; only a lower bound if P_K ≳ 100 000 (same statement for FCC p. 19 and BCC p. 25).
- p. 16 (SC): E_{0_1} = (log 3)/4 = 0.27467; E_{3_1^+} = (log 1664)/24 = 0.3090; E_{4_1} = (log 3648)/30 = 0.2733; E_{5_1^+} = 0.2386; E_{5_2^+} = 0.3223. Families: T(2,N) {0.3090, 0.2386, 0.2214, 0.2234}; twist {3_1,5_2,7_2,9_2} {0.3090, 0.3044, 0.2616, 0.2555}; {6_1,8_1,10_1} {0.2008, 0.1876, 0.2059}; {6_2,8_2,10_2} {0.2427, 0.2147, 0.2164}. Low-E: 7_3 0.1246, 7_4 0.1007, 7_7 0.1257, 8_3 0.08065, 8_7 0.06621, 8_11 0.09129, 8_16 0.07742, 8_20 0.1088.
- p. 17: W_{3_1^+} = 3 735/1664 ≈ 3.4417 at n = 24; 3.45971 at 26; 3.46848 at 28. K_K/n_K for T(2,N): {0.25, 0.141, 0.142, 0.141}; twist {0.145, 0.136, 0.131, 0.136}. Mean SC trefoil curvature 6 801/832 π ≈ 6.96274π.
- p. 18: K_{9_47} = 10 94/95 π (SC mean) — minimal-length polygons achieving minimal curvature exist for 3_1 and 9_47 (text p. 18).
- p. 19 (FCC): E_{0_1} = (log 8)/3 = 0.693147; E_{3_1^+} = (log 32)/15 = 0.2310; E_{4_1} = (log 2796)/20 = 0.3968; E_{5_1^+} = 0.1760, E_{5_2^+} = 0.2587. Families p. 21: T(2,N) {0.2310, 0.1760, 0.2628, 0.1304}; twist {0.2310, 0.2587, 0.2544, 0.3149}; {6_1,8_1,10_1} {0.3392, 0.3623, 0.2642}; {6_2,8_2,10_2} {0.2901, 0.3226, 0.2101}. Low-E: 7_4 0.1290, 9_1 0.1106, 9_42 0.1210. FCC step patterns +7 break at 9_1 (+6) and 10_1 (+6).
- p. 21–22 (FCC): mean trefoil curvature 2 3/4 (2π) = 5 1/2 π < 6π (SC minimum). W_{8_16} ≈ 8/3 (41472.00002289/15552); W_{4_1}-related |W| ≈ 13/200. No minimal-length FCC 9_47 has curvature below 10 1/6 π; mean 10 19/24 π. K_K/n_K T(2,N) {0.183, 0.159, 0.169, 0.164}; twist {0.163, 0.162, 0.165, 0.164}.
- p. 23 (BCC): T(2,N) increments {8, 6, 8} from 18; twist 4_1,6_1,8_1 +8 then 10_1 +6.
- p. 25 (BCC): E_{0_1} = (log 12)/4 = 0.621226; E_{3_1^+} = (log 792)/18 = 0.37080; E_{4_1} = (log 12)/20 = 0.12424; E_{5_1^+} = 0.34274, E_{5_2^+} = 0.29992. Families: T(2,N) {0.3708, 0.3427, 0.2061, 0.2652}; twist {0.3708, 0.3000, 0.0777, 0.2210}; {6_1,8_1,10_1} {0.1280, 0.1644, 0.1183}; {6_2,8_2,10_2} {0.2775, 0.2891, 0.1932}. Low-E: 4_1 0.1242, 6_1 0.1280, 7_2 0.0777, 7_6 0.0993, 7_7 0.0777, 8_12 0.0498. BCC unknot: 2 classes of 6 (6^2); trefoil 24^66.
- §4 (p. 29–30): ranking by E_K differs across lattices (3_1: 1st SC, 26th FCC, 2nd BCC); |W|_{8_3} = 0 in SC and BCC but not FCC; |W|_{4_1} = 0 in BCC only; data suggest Q_SC < Q_BCC < Q_FCC.

## Methods / algorithms
1. GAS (generalised atmospheric sampling) [30, 31]: sample ω_0, ω_1, … by atmospheric moves chosen with Pr(+) ∝ β_ℓ a_+(ω), Pr(0) ∝ a_0(ω), Pr(−) ∝ a_−(ω) (eq. 26, p. 10); β_ℓ ≈ ⟨a_+⟩_ℓ/⟨a_−⟩_ℓ ⚠ as printed ("flat sampling").
2. Weight W(ω_n) per eq. (27); ⟨W⟩_n/⟨W⟩_m → p_n(K)/p_m(K) (eq. 28).
3. Moves: SC BFACF Type I (±2 edges) and Type II (neutral) (Fig. 4); BCC analogous Types Ia/Ib/IIa/IIb, irreducible on fixed knot type [32, 33] (Fig. 5); FCC single positive move and inverse, no neutral move, irreducible [32] (Fig. 6).
4. Hash-coded O(1) updates; minimal polygons sieved from the stream and hashed to avoid duplicates; then symmetry classes, writhe and curvature computed (p. 11). Data posted at [51] (Rechnitzer's UBC page).

## Tables
All tables are transcribed in [../lattice-length/minimal-polygon-census.md](../lattice-length/minimal-polygon-census.md) (not duplicated here):
- **Table 1 (p. 13)** Minimal Length of Prime Knots in the SC lattice. Text-layer content: 4: 0_1; 24: 3_1; 30: 4_1; 34: 5_1; 36: 5_2; 40: 6_1, 6_2, 6_3; 42: 8_19; 44: 7_1, 7_3, 7_4, 7_7, 8_20; 46: 7_2, 7_5, 7_6, 8_21; 48: 8_3, 8_7, 9_42; 50: 8_1, 8_2, 8_4, 8_5, 8_6, 8_8, 8_9, 8_10, 8_11, 8_13, 8_14, 8_16, 9_47; 52: 8_12, 8_15, 8_17, 8_18; 54: 9_1; 56: 9_2; 60: 10_1, 10_2; 64: 11_1; 66: 11_2; 70: 12_1, 12_2.
- **Table 2 (p. 14)** Minimal Length of Compound Knots in the SC lattice: 40: (3_1^+)^2, 3_1^+3_1^-; 46: 3_1^+4_1; 50: 5_1^+3_1^+, 5_1^+3_1^-, 5_2^+3_1^-; 52: (4_1)^2, 5_2^+3_1^+; 56: (3_1^+)^3, (3_1^+)^2 3_1^-; 72: (3_1^+)^4; 74: (4_1)^3 ⚠ printed "(4_1^+)^3"; 88: (3_1^+)^5; 96: (4_1)^4; 104: (3_1^+)^6; 118: (4_1)^5; 140: (4_1)^6.
- **Table 3 (p. 15)** Data on prime knot types in the SC Lattice — census page, SC section.
- **Table 4 (p. 17)** SC Lattice Trefoils of lengths 24, 26 and 26 [sic: 28] — census page.
- **Table 5 (p. 18)** Minimal Length of knot types in the FCC lattice: 3: 0_1; 15: 3_1; 20: 4_1; 22: 5_1; 23: 5_2; 27: 6_1, 6_2; 28: 6_3, 8_19; 29: 7_1; 30: 7_2, 7_3, 7_4, 8_20; 31: 7_5, 7_6, 7_7, 8_21; 32: 9_42; 34: 8_1–8_10; 35: 8_11–8_17, 9_1, 9_47; 36: 8_18; 37: 9_2; 40: 10_1, 10_2. ⚠ 7_7 is 31 here but 32 in Table 6.
- **Table 6 (p. 20)** Data on prime knot types in the FCC Lattice — census page (n, P, S only; W/K columns see image p20.png).
- **Table 7 (p. 21)** Data on trefoils of lengths 15, 16 and 17 in the FCC lattice — census page.
- **Table 8 (p. 23)** Minimal Length of Knots types in the BCC lattice: 4: 0_1; 18: 3_1; 20: 4_1; 26: 5_1, 5_2; 28: 6_1; 30: 6_2, 6_2 ⚠ [sic, = 6_2, 6_3]; 32: 7_1, 7_2, 7_6, 7_7, 8_19; 34: 7_3, 7_4, 7_5, 8_20, 8_21; 36: 8_1, 8_3, 8_12; 38: 8_2, 8_4–8_10; 38 ⚠ [sic] 8_11, 8_13–8_17; 40: 8_18, 9_1, 9_2; 42: 10_1; 44: 10_2. ⚠ 9_42 (36) and 9_47 (40) appear in Table 9 but not in Table 8.
- **Table 9 (p. 24)** Data on knots in the BCC lattice — census page, verified cell by cell against image.
- **Table 10 (p. 26)** Data on trefoils of lengths 18, 20 and 22 in the BCC lattice — census page (summary).
- **Table 11 (p. 28)** Data on knots in the SC Lattice (composites) — census page.
- **Table 12 (p. 29)** Ranking by entropy per unit length in SC, FCC, BCC — text layer too garbled to transcribe; see image (not rendered).

## Figures
- **Fig. 1 (p. 1–2)** — Lattice trefoils (3_1^+) in SC, FCC, BCC. Image: ../figures/JvRR11/p01.png
- **Fig. 2 (p. 4)** — Concatenating polygons in the SC lattice (top edge / bottom edge, insert a unit square, delete doubled edges ⇒ p_n(K)p_m(L) ≤ 2p_{n+m}(K#L)). Image: ../figures/JvRR11/p04.png
- **Fig. 3 (p. 7)** — Negative and positive crossings (right-hand rule).
- **Fig. 4 (p. 10)** — BFACF elementary moves (Type I ±2 edges; Type II neutral). Image: ../figures/JvRR11/p10.png
- **Fig. 5 (p. 11)** — BCC elementary moves Ia, Ib, IIa, IIb. Image: ../figures/JvRR11/p11.png
- **Fig. 6 (p. 12)** — The single FCC elementary move; no neutral moves. Image: ../figures/JvRR11/p12.png

## Stated limitations, open problems, future work
- p. 6: "Showing that γ_K > 0 for all non-trivial knot types K is an open question."
- p. 13: "There are no proofs that these patterns will persist indefinitely" (step-10 families); p. 14 "no firm theoretical argument" for α_{3_1} = 16.
- p. 16, 21, 25: extending P_K estimates to more complicated knots is beyond available computing resources.
- p. 17: whether chiral knot types with |W| < 1 exist for all C ≥ 6.

## References worth following
- [10] Diao Y 1993 Minimal Knotted Polygons on the Cubic Lattice, JKTR 2 413–425.
- [21] Janse van Rensburg E J 1999 Minimal Lattice Knots, in *Ideal Knots*.
- [27] Janse van Rensburg E J, Promislow S D 1995 Minimal Knots in the Cubic Lattice, JKTR 4 115–130.
- [28] Janse van Rensburg E J, Promislow S D 1999 The Curvature of Lattice Knots, JKTR 8 463–490.
- [31] JvR, Rechnitzer 2010 Generalised Atmospheric Sampling of Knotted Polygons, JKTR.
- [32] JvR, Rechnitzer 2011 BFACF-style Algorithms for Polygons in the BCC and FCC Lattices, J Phys A 44 165001.
- [39] Liang C, Sumners D W 2006 Computing the Writhe on Lattices, J Phys A 39 3535.
- [45] Scharein R et al. 2009 Bounds for Minimal Step Number of Knots in the Simple Cubic Lattice, J Phys A 42 475006.

## Extraction notes
- Written by the wiki author directly (no parsing agent). Tables 3, 4, 6, 7, 11 were transcribed earlier into the census page from the text layer; **Table 9 verified against a 130-dpi render of p. 24** on 11 Nov 2026 (all n_K, P_K, S_K cells agree; W, |W|, B/K columns added to the census page from the image). Table 3 also verified against a 130-dpi render of p. 15 (all rows agree); Table 6 verified against p. 20 and its W/|W|/K columns added to the census page. Table 11 verified against p. 28 (one |W| cell differs from W as printed — see census page).
- ⚠ Internal inconsistencies kept as printed: Table 4 caption "24, 26 and 26"; Table 5 vs 6 for 7_7; Table 8 "6_2, 6_2" and a repeated "38" row, missing 9_42/9_47; Table 10 prints 1583 for p_18(3_1); FCC 8_7 P = 1258 vs classes 24^52 = 1248.
- The minimal-curvature lower bound formula on p. 9 was checked against the page image on 2026-11-12 and transcribed above (flag cleared).
- Figure descriptions taken from captions; images rendered for pp. 1, 4, 10, 11, 12, 15, 20, 24, 26, 28, 30.
