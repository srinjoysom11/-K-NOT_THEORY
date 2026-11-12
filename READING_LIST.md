# MA498 — Minimal lattice length of knots and links: reading list & state of the art

Compiled 11 Nov 2026. Notation: **Len(K)** = minimum number of unit edges of a polygon in the simple cubic (SC) lattice Z³ representing K (also called *minimum step number*, *minimal edge number*, *minimum lattice length*; the project brief calls it c(K) — beware, most papers use c(K) for **crossing number**, so below c = crossing number). s_L(K) = lattice stick number.

* Free papers: run `download_papers.ps1` (59 PDFs → `papers\<topic>\`). All arXiv IDs were checked against the arXiv API.
* Paywalled papers: section 7 (get via your institute library, interlibrary loan, or by emailing the authors).
* Data: `data/rechnitzer_SC_minimal.csv` — best-known SC polygons for all 249 prime knots ≤ 10 crossings, each re-verified by us (see section 1).

---

## 0. State of the art in one page

**Exact values.** Len(3₁)=24 (Diao 1993, proof). Len(4₁)=30, Len(5₁)=34 (Scharein et al. 2009 / Ishihara–Shimokawa; quoted as exact by later papers). Nothing else is proven. Trefoil in a 1-slab needs 26 (Ishihara et al. 2012). Borromean rings: 36 (Uberti et al. 1998; short proof in Eppstein's blog).

**Best-known upper bounds, ≤10 crossings** (Scharein et al. 2009 KnotPlot search; JvR–Rechnitzer 2011 minimised ≤7 crossings by BFACF/GAS). Distribution of the 249 values: 24, 30, 34, 36, 40×3, 42, 44×5, 46×4, 48×4, 50×18, 52×9, 54×25, 56×45, 58×11, 60×45, 62×69, 64×6. **No table exists at all for ≥11 crossings.**

**General upper bounds in c = crossing number.**
| bound | source |
|---|---|
| Len ≤ 136 c^{3/2} + 84c + 22c^{1/2} + 11 | Diao–Ernst–Yu, Topol. Appl. 2004 |
| Len ≤ 1.5c² + 2c + 0.5 (non-trefoil); 1.5c² − 4c + 2.5 (non-alt. prime); 6c + 2√(c+1) + 6 for T(n+1,n) | Hong–No–Oh, arXiv 1411.1849 |
| Len ≤ min{ ¾c² + 5c + 17/4 , ⅝c² + 7.5c + 71/8 } | Hong–Kim–No–Oh, arXiv 1411.1845 (JKTR 2014) |
| Len ≤ 8c + 2, 2-bridge **knots and links** | Huh–Hong–Kim–No–Oh, arXiv 1411.1840 (JMP 2014) |
| Len ≤ 6c + 2m + 2h + 8, 2-bridge with all-positive/all-negative integer tangles | H. Kim, Topol. Appl. 2025 |
| Ropelength O(c log⁵ c) (no explicit constants; lattice-type construction) | Diao–Ernst–Por–Ziegler, arXiv 0912.3282 (JKTR 2019) |
| s_L(K) ≤ 3c + 2 | Hong–No–Oh, arXiv 1209.0048 |

**Lower bounds.** Lattice polygon of length n has thickness radius ½, so Rop ≤ 2·Len (radius convention) ⇒ every ropelength lower bound transfers. Buck–Simon: Rop ≥ 1.105 c^{3/4}; **Klotz, 10 Nov 2026 (arXiv 2611.14234): Rop ≥ 2.0996 c^{3/4} and Rop ≥ π(s−1)** with s = stick number — brand new, not yet transferred to the lattice anywhere. (Check Klotz's thickness convention before dividing by 2.) Denne–Diao–Sullivan: Rop ≥ 15.66 for any nontrivial knot ⇒ Len ≥ 8 — useless vs. the true 24, i.e. **lower bounds are extremely weak**. Huh–No–Oh–Rawdon 2015: for links the c^{3/4} exponent is sharp, with families realising every growth exponent r ∈ [¾, 1].

---

## 1. Data we already have (in this folder)

`data/rechnitzer_SC_minimal.csv` / `.json` — from A. Rechnitzer's page <https://personal.math.ubc.ca/~andrewr/knots/minimal_knots.html> (SC/FCC/BCC minimal polygons). 3₁–7₇ were hand-built by Janse van Rensburg and BFACF-minimised; **8+ crossings are Scharein et al.'s 2009 SC embeddings** (Rechnitzer only re-minimised them after mapping to FCC/BCC). Stored as start vertex + `nsewud` direction word (same alphabet as `BTP/knotmaker.cpp`).
Verification we ran (`code/latticeknot.py`): all 249 are closed self-avoiding polygons; diagrams simplify to ≥ c crossings; Seifert genus (knot Floer homology) matches KnotInfo; SnapPy's census identifies every hyperbolic one by its exact name. The 6 non-hyperbolic ones are exactly the torus knots 3₁ 5₁ 7₁ 8₁₉ 9₁ 10₁₂₄. Note 10₁₆₂…10₁₆₅ use KnotInfo numbering (SnapPy/old Rolfsen = 10₁₆₃…10₁₆₆, Perko pair).

Other data: OEIS **A366190** (set of minimal lengths 4, 24, 30, 34, …, 64; conjecture every even n ≥ 40 occurs). KnotPlot coordinates page <https://knotplot.com/EquiLat/coords.html>.

---

## 2. Must-read core (priority A)

| # | paper | why |
|---|---|---|
| A1 | Janse van Rensburg & Rechnitzer, *Minimal knotted polygons in cubic lattices*, J. Stat. Mech. (2011) P09008, arXiv 1107.2162 | The numerical reference: GAS algorithm, minimal lengths **and counts** of minimal polygons on SC/FCC/BCC (e.g. 3₁: 24 (3328), 4₁: 30 (3648), 5₁: 34 (6672), 5₂: 36 (114912), 8₁₉: 42, 9₄₂: 48); composites 24+16n pattern (unproved). |
| A2 | Scharein, Ishihara, Arsuaga, Diao, Shimokawa, Vazquez, *Bounds for the minimum step number of knots in the simple cubic lattice*, J. Phys. A 42 (2009) 475006, doi 10.1088/1751-8113/42/47/475006 — **paywalled** | The table everything is compared to (all prime knots ≤ 10 crossings, lengths 24–64; only 3 entries proven). |
| A3 | Hong, No, Oh, arXiv 1411.1849; Hong, Kim, No, Oh, arXiv 1411.1845 | Best general quadratic upper bounds; constructions via arc presentations / grid diagrams. **Knots only.** |
| A4 | Huh, Hong, Kim, No, Oh, arXiv 1411.1840 (J. Math. Phys. 55, 2014) and H. Kim, Topol. Appl. 2025 (paywalled) | Linear bounds for 2-bridge; the only Len results that already cover links. |
| A5 | Diao, *Minimal knotted polygons on the cubic lattice*, JKTR 2(4) (1993) 413–425 — **paywalled** | Proof that 24 is minimal; the template for any exact-value proof. |
| A6 | Diao–Ernst–Yu 2004 (paywalled); Diao–Ernst–Por–Ziegler arXiv 0912.3282 | Sub-quadratic upper bounds; the c log⁵ c construction has no explicit constant — an explicit-constant lattice version would be new. |
| A7 | Klotz, *LLM-Assisted Advances in the Ropelength Problem*, arXiv 2611.14234 (yesterday) | Improved universal lower bound 2.0996 c^{3/4}, and Rop ≥ π(s−1). Direct input for goal 2; also a model of LLM-assisted proofs (ancillary code `GPTintegral.py`). |
| A8 | Ishihara et al., *Bounds for minimum step number of knots confined to slabs in the SC lattice*, J. Phys. A 45 (2012) — free tech report in script; Gasumova–JvR–Rechnitzer arXiv 1204.6674 | Confined versions; slab 26 for trefoil is a fully proven nontrivial value — a good model proof. |
| A9 | Cantarella, Rechnitzer, Schumacher, Shonkwiler, *New upper bounds for stick numbers*, arXiv 2508.18263 | Modern simulated-annealing pipeline that beat decades-old tables — exactly the playbook for goal 1. |
| A10 | Ozawa 2026, arXiv 2605.25322 (+ 2605.29160) | Very recent: BFACF move graphs filtered by length, merge scales for 4₁, 6₃ — the only current work on SC lattice-knot spaces; check for overlap. |

## 3. Analytic bounds (goal 2), priority B

* Cantarella–Kusner–Sullivan, *On the minimum ropelength of knots and links*, Invent. Math. 150 (2002), arXiv math/0103224 — c^{3/4} lower bound, links, sharpness.
* Buck & Simon, *Thickness and crossing number of knots*, Topol. Appl. 91 (1999) — paywalled. The original 1.105 c^{3/4}.
* Diao & Ernst, *The complexity of lattice knots*, Topol. Appl. 90 (1998) 1–9 — paywalled. Lattice-based crossing-number vs length (n-edge lattice polygon has c = O(n^{4/3})).
* Diao, *The lower bounds of the lengths of thick knots*, JKTR 12 (2003) — paywalled. Better constants for c < 1850.
* Diao & Ernst, *Total curvature, ropelength and crossing number of thick knots*, Math. Proc. Camb. 143 (2007) — paywalled. For lattice polygons total curvature = (π/2)·#corners: route to bounds on corners/sticks.
* Denne–Diao–Sullivan, arXiv math/0408026 (Geom. Topol. 2006) — quadrisecants, Rop ≥ 15.66.
* Diao, *Braid index bounds ropelength from below*, arXiv 1901.10663 (JKTR 2020); Diao, *The ropelength conjecture of alternating knots*, arXiv 2208.00123 (Math. Proc. Camb. 2024) — linear lower bounds for alternating knots; transfer to Len unexamined.
* Klotz–Maldonado arXiv 2108.01857; Klotz–Thompson arXiv 2504.00861 (helices, torus knots T(P,Q) ~ 7.83 Q^{3/2} — no lattice analogue yet); Klotz–Anderson arXiv 2305.17204.
* Diao–Ernst family, ropelength **linear** in c for Conway algebraic knots, closed braids, etc. (JKTR 2006, Topol. Appl. 2007, Kobe J. Math 2011) — paywalled; list at <https://pages.charlotte.edu/ydiao/?p=55>. Lattice-length versions not written down.
* Cantarella–Faber–Mullikin, *Upper bounds for ropelength as a function of crossing number*, Topol. Appl. (2004) — Rop ≤ 1.64c² + 7.69c + 6.74 (paywalled).
* Lattice stick numbers: Hong–No–Oh arXiv 1209.0048; Huh–Oh arXiv 1512.03582 (only 3₁, 4₁ have s_L < 15); Huh–Oh, *Lattice stick numbers of small knots*, JKTR 14 (2005) — paywalled.
* Arc index machinery: Bae–Park, *An upper bound of arc index of links*, Math. Proc. Camb. 129 (2000) (paywalled); Jin–Lee arXiv 1106.2723.

## 4. Links (goal 3)

* **Uberti, Janse van Rensburg, Orlandini, Tesi, Whittington, *Minimal links in the cubic lattice*, in Topology and Geometry in Polymer Science, IMA Vol. Math. Appl. 103 (Springer 1998)** — paywalled, *the* key missing source (Table 2: minimal lengths of small links found by computer).
* Eppstein, *Lattice Borromean rings* (2021 blog) <https://11011110.github.io/blog/2021/02/16/lattice-borromean-rings.html> — Len(Borromean)=36 with a short proof.
* Hong–No–Oh, *Links with small lattice stick numbers*, arXiv 1402.1642 (J. Phys. A 2014): s_L(Hopf)=8, Hopf#Hopf, 6³₂, 6³₃ = 12, 4²₁ = 13, 5²₁ = 14, all others ≥ 15.
* Adams et al., arXiv 1205.5256 (JKTR 2012); Kim–No arXiv 1805.00213; Yoo–Lee–Oh arXiv 1806.09720 (spatial graphs).
* Allardice–Bloch arXiv 1803.03685 and Naimi–Pavelescu–Pavelescu arXiv 1804.04724 — which lattice diagrams lift to lattice links (Escher squares): a tool for lower-bound case analysis.
* Huh, No, Oh, Rawdon, *Link lengths and their growth powers*, J. Phys. A 48 (2015) 035202 — paywalled; growth exponents r ∈ [¾,1] for links.
* Blair–Pongtanapaisan–Soteros arXiv 2601.11481 (2026, spanning link pairs in tubes); Soteros–Sumners–Whittington, *Entanglement complexity of graphs in Z³*, Math. Proc. Camb. 1992 (paywalled); Orlandini–Tesi–Whittington 2021 (linking of constrained ring pairs, free PDF).
* Ropelength of links: Cantarella–Kusner–Sullivan (Hopf = 8π); Klotz arXiv 2603.02416 (T(Q,Q)); Komendarczyk–Michaelides arXiv 1604.03870 (lower bounds via Milnor invariants — template for linking-number-based Len bounds).

**Knot results with no link analogue yet (candidate theorems):**
| knot result | link status | comment |
|---|---|---|
| Len ≤ ¾c²+…, 1.5c²+… (1411.1845/1849) | **none** (knots only) | arc-presentation construction should extend componentwise; need care with split/non-split |
| s_L ≤ 3c+2 (1209.0048) | **none** | same |
| 3328 minimal trefoils (Diao 1994 / JvR–R) | **none** | count minimal Hopf / Whitehead / Solomon links — computable |
| Table of best-known Len up to 10 crossings | **none** (only Uberti 1998, small) | a link table up to ~8 crossings via a 2-component BFACF is feasible and new |
| Len(trefoil)=24 proof | Borromean done; Hopf presumably in Uberti | write a clean proof for Hopf, Whitehead, T(2,4) |
| Len vs \|lk\| | **open** | no lattice result found |
| Slab bounds | unknown | |

## 5. ML / RL / search methods (goal 1)

No paper applies RL, deep learning or LLM program search to minimal lattice knots — the niche is open. Closest analogues:
* Lattice protein folding (3D HP model, cubic lattice): Espitia–Pang–Gumbart arXiv 2412.20329 (deep RL); Yang et al. arXiv 2211.14939; Roucairol–Cazenave arXiv 2301.09533 (nested MC — note: classical MC still wins); Wüst–Landau arXiv 1207.3974 (Wang–Landau, state of the art); Thachuk–Shmygelska–Hoos BMC Bioinf. 8:342 (2007, replica exchange, open access).
* Construction search: Wagner arXiv 2104.14516 (cross-entropy RL — cheapest baseline); PatternBoost arXiv 2411.00566 (local search + transformer — natural fit to `nsewud` words); FunSearch (Romera-Paredes et al., Nature 625, 2023, open access); AlphaEvolve arXiv 2506.13131; Georgiev–Gómez-Serrano–Tao–Wagner arXiv 2511.02864.
* Knots + RL/ML: Gukov et al. *Learning to unknot* arXiv 2010.16263; Applebaum et al. arXiv 2409.09032; Davies et al. arXiv 2111.15323 (Nature 2021); Halverson–Ruehle arXiv 2504.12390; Cantarella–Schumacher–Shonkwiler arXiv 2607.28772.
* Fast knot-type screening of lattice coordinates: Vandans et al. PRE 101 (2020) 022502; Braghetto et al. arXiv 2212.11822 (LSTM on bond-direction sequences — exactly our words); Zhang–Zhu–Dai arXiv 2501.12780.

## 6. Software decision

**SnapPy 3.3 is sufficient** (installed in the working environment; `pip install snappy database_knotinfo`). Our `code/latticeknot.py` turns lattice polygons/links into PD codes by a generic projection, then uses spherogram simplification, `exterior().identify()` (hyperbolic knots/links, census incl. Rolfsen names ≤ 10 and K11/K12 names), and knot Floer homology (genus, fiberedness — distinguishes torus knots). Optional later, only if needed: **Topoly** (pip, coordinates-in HOMFLY/Yamada, links; non-commercial licence) as an independent cross-check; **Regina** for exhaustive simplification. Skip pyknotid, KnotPlot (GUI only), SONO/RidgeRunner (continuous tightening).

## 7. Paywalled — get through the library (DOIs where known)

Status 12 Nov 2026 (arXiv checked via its API). **Already in `papers/`:** Diao 1993, Diao 1994, Janse van Rensburg–Promislow 1995, Janse van Rensburg–Whittington 1991, Scharein et al. 2009, Huh–No–Oh–Rawdon 2015, Soteros–Sumners–Whittington 1992, Cantarella–Faber–Mullikin (arXiv math/0210245, now in `download_papers.ps1`).

**Still needed — no arXiv version found:**
1. Uberti et al. 1998, *Minimal links in the cubic lattice*, IMA Vol. 103, Springer, doi 10.1007/978-1-4612-1712-1_9 — the only source for minimal lattice lengths of links (Borromean rings 36).
2. Diao 2003, *The lower bounds of the lengths of thick knots*, JKTR 12, doi 10.1142/S0218216503002275 — the 16π·c ≤ L(L − 17.334) bound; settles KA23's "34.7" quote.
3. Diao, Ernst & Janse van Rensburg, *Thicknesses of knots*, Math. Proc. Camb. Phil. Soc. 126 (1999) 293–310 — source of Len < 14·Rop, used by Diao 2019/2022 for the lattice lower bounds.
4. Buck & Simon 1999, *Thickness and crossing number of knots*, Topol. Appl. 91, doi 10.1016/S0166-8641(97)00211-3 — the c^{3/4} law constant.
5. Diao, Ernst & Yu 2004, *Hamiltonian knot projections and lengths of thick knots*, Topol. Appl. 136, doi 10.1016/S0166-8641(03)00182-2 — Len ≤ 136c^{3/2} + ….
6. Diao & Ernst 1998, *The complexity of lattice knots*, Topol. Appl. 90, doi 10.1016/S0166-8641(97)00178-8 — s_L ≥ 3√(c + 1) + 3.
7. Diao & Ernst 2007, *Total curvature, ropelength and crossing number of thick knots*, Math. Proc. Camb. 143, doi 10.1017/S0305004107000151.
8. Huh & Oh 2005, *Lattice stick numbers of small knots*, JKTR 14 859–867 — s_L(3_1) = 12, s_L(4_1) = 14.
9. Bae & Park 2000, *An upper bound of arc index of links*, Math. Proc. Camb. 129 491–500 — a(K) ≤ c(K) + 2, behind every arc-presentation construction.
10. H. Kim 2025, *Minimum lattice length of 2-bridge knots and links*, Topol. Appl., ScienceDirect pii S0166864125001518 — Len ≤ 6c + 2m + 2h + 8.
11. Janse van Rensburg & Promislow 1999, *The curvature of lattice knots*, JKTR 8 463–490 — minimal lattice curvature, s_L(9_47) = 18.
12. Janse van Rensburg 1999, *Minimal lattice knots*, in *Ideal Knots* (World Scientific, Series on Knots and Everything 19) — step-10 families, α_{3_1} ≤ 17.
13. Ishihara et al. 2012, full paper on minimal step numbers in slabs (`papers/` has only the technical-report cover page) — the proof that the trefoil needs 26 edges in a 1-slab.
14. Litherland, Simon, Durumeric & Rawdon 1999, *Thickness of knots*, Topol. Appl. 91 233–244 — the polygonal-approximation lemma behind Rop ≥ π(stick − 1).
15. Diao, Ernst & Ziegler 2011, *The linearity of the ropelengths of Conway algebraic knots…*, Kobe J. Math. 28 (may be free on the journal site).

**Unpublished, ask the authors:** Ishihara 2009 preprint and Ishihara, Shimokawa & Yamaguchi 2009 preprint (refs [16, 17] of Scharein 2009) — the full proofs that Len(4_1) = 30 and Len(5_1) = 34; Schoen 2026 preprint "Endpoint tangents and a new universal lower bound…" (cited by Klotz 2026; not on arXiv).

**Free after all:** Jin & Park 2010, *Prime knots with arc index up to 11…*, JKTR 19 = arXiv 1010.3005 (not yet in `papers/`).

## 8. Open gaps — where original results look reachable

**Goal 1 (numerical upper bounds)**
* **11- and 12-crossing knots have no SC table at all** (552 + 2176 knots). Any verified polygon is a new upper bound. Pipeline: KnotInfo diagram/grid → lattice embedding → BFACF + length-reducing moves under simulated annealing → verify with SnapPy (`identify` names K11/K12 knots).
* The 8–10 crossing SC values come from a 2009 search and haven't been re-attacked on SC; a modern annealing / parallel-tempering run seeded from our 249 polygons may lower some (the 62s and 64s first).
* Composite knots (24+16n for #ⁿ3₁ is unproved) and links: nothing tabulated.
* RL/PatternBoost on `nsewud` words is untried in this problem.

**Goal 2 (analytic bounds)**
* Transfer Klotz's new 2.0996 c^{3/4} and π(s−1) bounds to Len (and to s_L); look for a lattice-specific improvement (corner counting, layer arguments).
* No improvement of the 0.625c² constant since 2014; DEPZ near-linear bound has no explicit lattice constant.
* Linear Len bounds for Montesinos / 3-bridge / closed-braid families (ropelength versions exist).
* Torus knots: only T(n+1,n) has a linear lattice bound; lattice version of Klotz–Thompson helices.

**Goal 3 (links)**
* Quadratic crossing-number bounds and s_L ≤ 3c+2 → links.
* Exact Len of Hopf (we already have a verified 16-edge Hopf link), Whitehead, Solomon, T(2,6), with proofs by exhaustive search — and counts of minimal ones (link analogue of Diao 1994). Your existing SAP enumerator is the right starting point: two components of length 8 each is tiny.
* Len vs linking number.
