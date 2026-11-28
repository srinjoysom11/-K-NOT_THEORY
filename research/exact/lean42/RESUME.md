# RESUME: how to continue the Lean proof (Phase 3 next)

Read in this order: this file, `STATUS.md`, `PHASE3_PLAN.md`, `PLAN.md`, the repository `CLAUDE.md`
(proofs not outlines, define before use). Branch: `claude/great-einstein-snvnnb`.

## 1. Toolchain from scratch (fresh container)
* Lean `leanprover/lean4:v4.25.2`, Mathlib tag `v4.25.2` as a **git dependency** (see
  `lakefile.toml`: `git = "https://github.com/leanprover-community/mathlib4.git"`, `rev = "v4.25.2"`).
* Blocked hosts (agent proxy answers HTTP 403), and the workarounds used:
  * `lakecache.blob.core.windows.net` (Mathlib cache): `lake exe cache get` FAILS. Mathlib is built from
    source; only the modules reachable from `Lean42/Prelude.lean` are built (about 1300 jobs).
  * `reservoir.lean-lang.org`: `lake update` with the scope form fails, hence the git URL in the lakefile.
  * elan's own download host for toolchains: the archive was fetched with `curl` from
    `https://github.com/leanprover/lean4/releases/download/v4.25.2/lean-4.25.2-linux.tar.zst`
    (works), unpacked (no `zstd` binary: `pip install zstandard` and extract with Python's `tarfile`)
    into `~/.elan/toolchains/leanprover--lean4---v4.25.2`, then `elan default leanprover/lean4:v4.25.2`.
  * elan itself: `curl -sSfL https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh`, run
    with `sh elan-init.sh -y --default-toolchain none` (works). `git clone` of github repos works.
* Steps:
  ```
  export PATH=$HOME/.elan/bin:$PATH
  cd research/exact/lean42
  lake update            # about 40 s, clones Mathlib and its dependencies into .lake/packages
  lake build             # about 70 minutes on 4 cores the first time (Mathlib from source)
  ```
  `.lake/` is git-ignored: never commit it. Never commit the PDF books.
* Build time and size: first full build about 70-80 min (4 cores); afterwards `lake build` about
  1 min if only Lean42 files changed. Expected result: `Build completed successfully (1263 jobs)`
  (the count moves by a few when files are added). Fast iteration on one file:
  `lake env lean Lean42/File.lean` (needs the imports built: `lake build Lean42.Dep`).
* Long commands in this environment move to the background after 120 s: use
  `lake build ... > /tmp/log 2>&1 &` and a Monitor `until grep -q ... ; do sleep 5; done`.

## 2. What is done (all in `research/exact/lean42/Lean42/`, no sorry)
See the table in `STATUS.md` ("What is proved, file by file"). Key names:
* Phase 1: `seg`, `tri`, `mem_seg`, `mem_tri` (Geom); `Simple`, `edges`, `pset` (Polygon); `DeltaMove`,
  `Equiv` (Delta-moves + rotation + reversal + translation), `Equiv.map`, `mirror` (Delta);
  `simple_iff`, `deltaMove_iff`, `feasible_iff` (Decide, FM): decidable versions with proofs;
  `latPoly_simple`, `simple_wpoly` (Lat, Words); the word-to-polygon embedding `wpoly`.
* Phase 2: **`knotClass : KnotClass (KnotType P)`** (Knot) with `flip_equiv`, `uturn_equiv` (Moves),
  `lat_edge_square` (Square). Class is saturated under the 48 lattice symmetries (decision recorded in
  `STATUS.md`; Phase 4 must compute invariants on the 48 images of each target).
* Phase 3/4 so far: `Diagram.lean` (projection, `genericB`, events, `col`, `inv`, `inv_reverse`,
  `inv_translate`, `AlexQ`); `Gauss.lean`: `colG` (trace formulation), `colG_rotate`, `colG_rename`, `R1`,
  `R2`, `R3a`, `R3b` for any `Quandle`; `DiagramCheck.lean` (`#guard` checks against Python).
* Phase 4a (quandle choice): `STATUS.md` section "Phase 4a": A(15,2), A(7,6), A(5,4), A(7,2),
  A(13,12), A(9,2), A(11,3), A(13,2); scripts in `tools/` (Python; they read `research/data/seeds.json`,
  `research/exact/out/witness40.txt`, `witness42_8_19.txt`, and the survivor list
  `research/exact/dmon2/bench/ci/r6_n42_F/F_n42.words.txt`; `tools/quandle_family.py` makes the pickle that
  `quandle_cover.py` and `quandle_table.py` read).
* Which word is P_K: seeds.json words for 7_1..7_7, 8_19, 8_20; `out/witness40.txt` for 6_1, 6_2, 6_3,
  3_1#3_1, 3_1#-3_1; `out/witness42_8_19.txt`. (The 44-edge witnesses of 7_x, 8_20 do not exist in the repo.)

## 3. Exact next step (about 200 lines, `Lean42/Diagram.lean` or a new `Lean42/PolyGauss.lean`)
Build the Gauss code of a polygon with **intrinsic crossing names** so that rotation and translation of
the vertex list become `colG_rotate` and `colG_rename`:
1. For an edge `e : Pt × Pt` of `es = edges L` define `evsOn es e : List (GEv ((Pt×Pt)×(Pt×Pt)))`: the
   events on `e` of the crossings with the non-adjacent edges `e'` (adjacent = shares an endpoint), sorted by
   the parameter along `e`; cid = `(over edge, under edge)`; reuse `pdata`, `params`, `pairEvents` logic.
2. `gauss L := (edges L).flatMap (evsOn (edges L))` and `colP Q L := colG Q (gauss L)`,
   `inv Q L := colP Q L ::ₘ {colP Q L.reverse}` (the reverse needs `gauss L.reverse`; check
   `inv_reverse`).
3. Prove `edges (L.rotate 1) = (edges L).rotate 1` (from `edges_cons_cons` and `chain_append_pair`),
   `evsOn` independent of the order of `es` under distinct keys (genericity: `genericB`), then
   `gauss (L.rotate 1) = (gauss L).rotate k` (`List.rotate_append_length_eq`), hence `inv` rotation
   invariance; translation: `gauss (L.map (· + t)) = (gauss L).map (GEv.rename σ)` with `σ` translating the
   edge pairs (injective), using the existing `pdata_translate` lemmas.
4. Check `#guard colP ... = 9` etc. against `DiagramCheck.lean` (lazy matrix products make larger
   `#guard`s slow; use small examples).

## 4. Then C2: Delta-move to R-moves on Gauss codes
Case list (every case its own lemma, comment at the top of the file first) is in `PHASE3_PLAN.md` section
C2c (about 15 cases; Lemma H on heights; subdivision of the triangle). The **direction choice is open**:
* symbolic direction `d(eps) = (eps, eps^3, 1)`: every simple polygon is generic (monomials have
  distinct powers of eps), so Step 4 (perturbing intermediate polygons) disappears; cost: feature
  clusters add cases to C2c (+1000-1500 lines) and ordered-field infrastructure on Q[eps] (~400 lines).
* one rational direction per chain (a rational point of that curve avoiding finitely many bad roots,
  decidable), generic for all polygons of the chain; then every Delta-move is between generic polygons
  and subdivision points are chosen generic over Q; price: direction independence for a polygon that is
  generic for two directions by wall crossing along a segment of directions (~800-1200 lines, reusing
  `R1`, `R2`, `R3a/b`).
**Recommendation:** the rational direction per chain plus wall crossing (same cost, stays over Q, no
clusters). Details: `PHASE3_PLAN.md`, section "Update: Gauss codes (done) and the verdict".
Without either: Step 4 as in `PHASE3_PLAN.md` C3 (~1500 lines).
Total remaining for Phase 3: about 4000-6000 lines of Lean.

## 5. Rules
* No `sorry`, `axiom`, `native_decide` or `implemented_by` in `Lean42/` (grep before committing).
  `#print axioms` of main theorems must show only `propext`, `Classical.choice`, `Quot.sound`
  (`Lean42/Check.lean` and the end of `Gauss.lean`).
* Do not touch `research/exact/lean/` (frozen) or `.github/workflows/`; commit only `research/exact/lean42`
  (other agents share the working tree): `git add research/exact/lean42 && git commit -m "..." -- research/exact/lean42`.
  Commit messages end with the two trailer lines given in the task; no model names in files.
* Commit after each file that builds; files that do not build yet go to `research/exact/lean42/wip/`
  (outside the library). Before a push: `git fetch origin claude/great-einstein-snvnnb && git merge --no-edit FETCH_HEAD`;
  never force-push.
* Writing rules of `CLAUDE.md`: proofs not outlines, every definition before use with intuition, header
  comment in each file saying what it proves and which book section it follows; cite Burde-Zieschang
  (Def. 1.6, 1.7, 1.11) for Delta-moves and regular projections. Books are local only
  (`/root/.claude/uploads/...`), read at most 20 pages at a time, never commit them.

## 6. Scratch files
All useful scratch scripts were copied to `tools/`: `quandle_counts.py` (diagram + counts, Smith normal form
mod prime powers), `quandle_cover.py`, `quandle_family.py`, `quandle_table.py`, `quandle_survivors.py`,
`quandle_sample.py`, `quandle_invariance_test.py`, `mathlib_import_closure.py` (counts the Mathlib modules a
root import needs; edit the `base` path inside). They are Python, run with `python3`, from a directory that
contains `qd.py` under the name `quandle_counts.py` (the scripts import it as `qd`; copy it to `qd.py` in a
scratch directory first).
