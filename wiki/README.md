# MA498 knots wiki — index and build status

Topic-organised knowledge base distilled from the PDFs under `papers/`. Every claim carries a `[Key]` citation; keys resolve in [SOURCES.md](SOURCES.md) (generated). Read [00-notation.md](00-notation.md) first.

## Topic pages

| page | contents |
|---|---|
| [00-notation.md](00-notation.md) | names of the invariant, ropelength conventions, status vocabulary — read first |
| [open-problems.md](open-problems.md) | open questions from all sources, grouped by theme, with suggested targets |
| **Lattice length** | |
| [lattice-length/exact-values-and-proofs.md](lattice-length/exact-values-and-proofs.md) | what is proved (24, 30, 34), Diao's proof, 3496 vs 3328, Scharein refinement |
| [lattice-length/lower-bounds.md](lattice-length/lower-bounds.md) | braid index, alternating 4·Len + 6 ≥ c, bridge index and minimal edge index, cube knots, via ropelength |
| [lattice-length/upper-bounds-crossing-number.md](lattice-length/upper-bounds-crossing-number.md) | quadratic and linear bounds, constructions, link growth exponents |
| [lattice-length/tables-minimal-length.md](lattice-length/tables-minimal-length.md) | all 249 prime knots ≤ 10 crossings (generated) |
| [lattice-length/minimal-polygon-census.md](lattice-length/minimal-polygon-census.md) | counts, symmetry classes, writhe, curvature in SC/FCC/BCC; composites (all tables image-verified) |
| [lattice-length/confinement-slabs.md](lattice-length/confinement-slabs.md) | minimal lengths in slabs and minimal counts in cubes |
| [lattice-length/compressibility.md](lattice-length/compressibility.md) | pressure ensembles on minimal polygons |
| **Invariants** | |
| [invariants/lattice-stick-number.md](invariants/lattice-stick-number.md) | s_L exact values and bounds, off-lattice stick numbers, arc index |
| **Ropelength** | |
| [ropelength/README.md](ropelength/README.md) | index and the radius/diameter trap |
| [ropelength/lower-bounds.md](ropelength/lower-bounds.md) | constants, c^{3/4} law, alternating knots, links |
| [ropelength/upper-bounds.md](ropelength/upper-bounds.md) | quadratic, O(c ln⁵ c), linear families, torus constructions |
| [ropelength/numerics.md](ropelength/numerics.md) | tight values, 12-crossing census, satellites, pearl necklaces, LLM-assisted claims |
| **Links** | |
| [links/README.md](links/README.md) | lattice stick numbers of links, lifting lattice diagrams, spatial graphs |
| **Algorithms, statistics, ML** | |
| [algorithms/bfacf-and-gas.md](algorithms/bfacf-and-gas.md) | BFACF moves and ergodicity (SC/FCC/BCC), GAS, minimal-polygon search, merge trees and excursions |
| [statmech/knot-probabilities.md](statmech/knot-probabilities.md) | scaling ansatz, crossover lengths, universality, pattern theorems, confinement |
| [ml-search/README.md](ml-search/README.md) | RL, PatternBoost, AlphaEvolve, knot recognition, HP-model folding, lessons for search |

## Supporting material

* `_extracts/<Key>.md` — faithful per-paper parses (abstract, every numbered statement, tables, figure captions) following `tools/EXTRACT_SPEC.md`. Raw material, not the wiki.
* `figures/<Key>/pNN.png` — page images of figures/tables.
* `data/` — tables as CSV ([Scharein09] Tables A1–A3 so far).
* `tools/manifest.py` — tracking: `python wiki/tools/manifest.py status` lists new/changed PDFs and everything not yet integrated; `sync` picks up newly added PDFs; `set KEY extracted|integrated`. New PDFs need a key row in `tools/sources.tsv`.
* `tools/page_text.sh KEY first last` — per-page text with true PDF page numbers; `tools/render_pages.sh KEY p…` — 80-dpi page renders into `figures/KEY/`.
* `tools/build_tables.py` — regenerates the minimal-length table page; `tools/build_sources.py` — regenerates SOURCES.md.

## Processing state (12 Nov 2026)

All 66 PDFs registered in `manifest.json` have a reviewed extract in `_extracts/` and are cited from at least one topic page (`manifest.py status`: 66 `integrated`). Agent-produced extracts were checked with a statement/table/figure coverage script against the PDF text and read in full during integration; key constants and table cells were spot-checked against page images (findings recorded as ⚠ in each extract's "Extraction notes").

Known caveats: `papers/5_ml_rl/Georgiev-…AlphaEvolve_2511.02864.pdf` (GGTW25) is truncated on disk (re-download from arXiv); `wiki/figures/` is gitignored (page renders of copyrighted papers) — regenerate with `tools/render_pages.sh`.

Adding a paper: drop the PDF under `papers/`, add a `key<TAB>batch<TAB>path` row to `tools/sources.tsv`, run `python wiki/tools/manifest.py sync`, write `_extracts/<Key>.md` per `tools/EXTRACT_SPEC.md`, cite it from a topic page, run `python wiki/tools/build_sources.py`, then `manifest.py set <Key> integrated`.
