# MA498 knots wiki — index and build status

Topic-organised knowledge base distilled from the PDFs under `papers/`. Every claim carries a `[Key]` citation; keys resolve in [SOURCES.md](SOURCES.md) (generated). Read [00-notation.md](00-notation.md) first.

## Topic pages

| page | state |
|---|---|
| [00-notation.md](00-notation.md) — names of the invariant, ropelength conventions, status vocabulary | written |
| **Lattice length** | |
| [lattice-length/exact-values-and-proofs.md](lattice-length/exact-values-and-proofs.md) — what is proved (24, 30, 34), Diao's proof, 3496 vs 3328, Scharein refinement | written; Scharein Props 1–4 image-checked |
| [lattice-length/lower-bounds.md](lattice-length/lower-bounds.md) — braid index, alternating 4Len + 6 ≥ c, bridge index, via ropelength | written |
| [lattice-length/upper-bounds-crossing-number.md](lattice-length/upper-bounds-crossing-number.md) — quadratic and linear bounds, constructions, link growth exponents | written |
| [lattice-length/tables-minimal-length.md](lattice-length/tables-minimal-length.md) — all 249 prime knots ≤ 10 crossings (generated) | written |
| [lattice-length/minimal-polygon-census.md](lattice-length/minimal-polygon-census.md) — counts, symmetry classes, writhe, curvature in SC/FCC/BCC; composites | written; **all JvRR11 tables image-verified** |
| [lattice-length/confinement-slabs.md](lattice-length/confinement-slabs.md) — minimal lengths in slabs of width L | written |
| lattice-length/compressibility.md | pending [JvRR12comp] |
| **Invariants** | |
| [invariants/lattice-stick-number.md](invariants/lattice-stick-number.md) — s_L exact values, bounds, arc index | written; links section pending [HNO14links], [KN18], [NPP18] |
| **Ropelength** | |
| [ropelength/lower-bounds.md](ropelength/lower-bounds.md) — constants, growth laws, links; R/D convention table | written |
| ropelength/upper-bounds.md, ropelength/numerics.md | pending [DEPZ09], [KM21], [KT25], [Klotz26llm], [ACPR10] |
| **Algorithms / stat-mech** | |
| [algorithms/bfacf-and-gas.md](algorithms/bfacf-and-gas.md) — BFACF moves, ergodicity, GAS, minimal-polygon search | written; FCC/BCC and Ozawa sections pending |
| [statmech/knot-probabilities.md](statmech/knot-probabilities.md) — scaling ansatz, crossover lengths, universality | written; confinement sections pending |
| links/, ml-search/, open-problems.md | pending (extracts in progress) |

Links from written pages to pending pages may dangle until those exist.

## Supporting material

* `_extracts/<Key>.md` — faithful per-paper parses (abstract, every numbered statement, tables, figure captions) following `tools/EXTRACT_SPEC.md`. Raw material, not the wiki.
* `figures/<Key>/pNN.png` — page images of figures/tables.
* `data/` — tables as CSV ([Scharein09] Tables A1–A3 so far).
* `tools/manifest.py` — tracking: `python wiki/tools/manifest.py status` lists new/changed PDFs and everything not yet integrated; `sync` picks up newly added PDFs; `set KEY extracted|integrated`. New PDFs need a key row in `tools/sources.tsv`.
* `tools/page_text.sh KEY first last` — per-page text with true PDF page numbers; `tools/render_pages.sh KEY p…` — 80-dpi page renders into `figures/KEY/`.
* `tools/build_tables.py` — regenerates the minimal-length table page; `tools/build_sources.py` — regenerates SOURCES.md.

## Processing state (11 Nov 2026, in progress)

66 PDFs registered (CFM02 = `papers/0210245v2.pdf` and SSW92 = `papers/soteros1992.pdf` added today). Extraction is running in three batches; each new extract is reviewed against its PDF (statement/table/figure coverage script plus a read of the statements, with image checks of key constants) before it is used in a topic page.
