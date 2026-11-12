# Handoff — state of the wiki build (11 Nov 2026, evening)

For whoever continues. Read [README.md](README.md) and [tools/EXTRACT_SPEC.md](tools/EXTRACT_SPEC.md) first.

## What happened

1. Extracts were produced by the wiki author (JvRR11, Scharein09, HHKNO14, HNOR15) and by three parallel parsing agents (batches below). All three agents stopped at ≈22:12 on a network error (API unreachable), **between papers**: every extract file on disk is complete (has its final "Extraction notes" section); no partial files were left.
2. **53 of 66 papers have extracts** (`manifest.py status`: 53 `extracted`, 13 `todo`). None is marked `integrated` yet — flip a key to `integrated` once a topic page cites its results.
3. Review done on agent output: a coverage script (every Theorem/Lemma/Table/Figure label in the PDF text must appear in the extract) was run on all agent extracts, and statements were read in full for HNO12stick, HO15, CFM02, CKS01, DDS04, KM16, JL11, BPS26, GHRS20. Reviewer fixes: KM16 (⚠ sign error d₀ in the source), BPS26 (Definitions 3, 5, 7 added). All remaining coverage flags were checked and are citations of other papers' numbering, "TABLE I" vs "Table 1" naming, or OCR renumbering (SSW92 "Conjecture 36" = Conj. 3.6).

## Not yet extracted (13) — restart these

| key | batch | notes |
|---|---|---|
| JvROT25, JvROT26 | 1 (B1) | knot probabilities / thermodynamics under confinement → `statmech/` |
| ACPR10 | 1 (B1) | ridgerunner tightening, 45 pp → `ropelength/numerics` |
| CRSS25 | 1 (B1) | stick-number upper bounds |
| HNO14links, NPP18, KN18 | 1 (D) | lattice stick numbers of links → `links/`, `invariants/lattice-stick-number` |
| Ozawa26density, Ozawa26rope, Ozawa26merge | 2 (B2) | merge trees / BFACF state spaces, 25–50 pp → `algorithms/` |
| WL12, Novikov25 | 3 (E3, E2) | Wang–Landau HP model; AlphaEvolve → `ml-search/` |
| GGTW25 | 3 (E3) | **PDF fails in pdfinfo/pdftotext** (12 MB) — try `qpdf --check`, `mutool`, or the Read tool with page ranges; re-download from arXiv 2511.02864 if corrupt |

Command per paper: follow `tools/EXTRACT_SPEC.md`; text via `bash wiki/tools/page_text.sh KEY a b`, renders via `bash wiki/tools/render_pages.sh KEY p…`.

## Extracts awaiting a careful read (coverage-checked only)

JvRR12comp, MannML, Croll18, JvRW91, JvRP95 (scan; read from images by the agent), SSW92, JvRR10bfacf, KM21, KT25, DEPZ09, Klotz26llm, Ozawa26geom, HR25, CSS26, CEWW24, Wagner21, DJLT21, BKBO22, ZZD25, EPG24, Yang22, YLO18, Klotz26tqq. Each carries its own ⚠ list in "Extraction notes" (highest counts: EPG24 17, Klotz26llm 16, KT25 12, ZZD25 11). Klotz26llm contains LLM-claimed results the author marks unverified — keep that status in topic pages.

## Topic pages

Written: `00-notation`, `lattice-length/{exact-values-and-proofs, lower-bounds, upper-bounds-crossing-number, tables-minimal-length, minimal-polygon-census, confinement-slabs}`, `invariants/lattice-stick-number`, `ropelength/lower-bounds`, `algorithms/bfacf-and-gas`, `statmech/knot-probabilities`, `SOURCES.md` (generated).

Still to write, with the extracts that feed them (all available unless listed above as missing):

| page | sources |
|---|---|
| `lattice-length/compressibility.md` | JvRR12comp |
| `ropelength/upper-bounds.md` | CFM02, CKS01 Thm 23, HKNO14, HHKNO14, DEPZ09, KT25, Klotz26tqq |
| `ropelength/numerics.md` | KA23, KM21, KT25, Klotz26pearl, Klotz26llm, (ACPR10) |
| `links/README.md` | Adams12 §6, AB18, BPS26, YLO18, KM16, Klotz26tqq, HNOR15, (HNO14links, NPP18, KN18) |
| `ml-search/README.md` | Applebaum24, GHRS20, HR25, CSS26, CEWW24, Wagner21, DJLT21, BKBO22, Vandans20, ZZD25, RC23, EPG24, Yang22, Klotz26llm, (WL12, Novikov25, GGTW25) |
| `open-problems.md` | "Stated limitations" sections of all extracts |
| extend `algorithms/bfacf-and-gas.md` | JvRR10bfacf, JvRW91, Ozawa26geom, (Ozawa ×3, ACPR10, CRSS25) |
| extend `statmech/knot-probabilities.md` | SSW92, BPS26, JvRW91, (JvROT25, JvROT26) |
| extend `lattice-length/lower-bounds.md` §4 | JvRP95 (full bridge-index statement) |
| extend `invariants/lattice-stick-number.md` | Croll18?, MannML (check relevance) |

## Findings worth carrying forward

* All JvRR11 tables (3, 6, 9, 11) are image-verified; the source has a few internal inconsistencies, listed on the census page.
* Diao19 uses the length/radius ropelength convention (its 31.32 = 2 × DDS04's 15.66).
* Adams12's proved lattice stick numbers (18 for 8_19, 8_21, 9_46) beat Scharein09's search bounds.
* GJvRR12 improves Ishihara12's 1-slab length of 8_18 from 72 to 70.

## Repository

Pushed to GitHub (`main`). `.gitignore` excludes `papers/`, all PDFs, `wiki/figures/` (page renders of copyrighted papers), binaries and local settings. Figure links in pages therefore dangle on GitHub; regenerate locally with `render_pages.sh`.
