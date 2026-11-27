# Lean42 status (Phases 0-2)

Last update: setup stage.

## Environment decisions
* Toolchain `leanprover/lean4:v4.25.2`, Mathlib pinned to tag `v4.25.2` (git dependency; the Reservoir
  host is blocked, so the lakefile uses the git URL).
* The toolchain archive was downloaded from github.com releases and unpacked by hand into
  `~/.elan/toolchains/leanprover--lean4---v4.25.2` (elan's own download host is blocked).
* `lake exe cache get` FAILS: host `lakecache.blob.core.windows.net` is refused by the agent proxy
  (HTTP 403, "no rule or network setting allows this host"). Mathlib is therefore built from source,
  only the modules reachable from `Lean42/Prelude.lean` (about 1300 modules).
  Command running: `cd research/exact/lean42 && lake build Lean42 > /tmp/claude-0/build1.log`.

## Files
* `wip/Geom.lean`, `wip/FM.lean`, `wip/Polygon.lean`: written, NOT yet compiled (Mathlib build
  still running). Move them to `Lean42/` once they build.

## Decisions (see PLAN.md and the files' headers)
* Delta-move as Burde-Zieschang Def. 1.6 with degenerate triangles (Remark); Equiv = EqvGen of
  Delta-moves, cyclic rotation, reversal, translation (translation justified in Delta.lean).
* Knot class T_K is saturated under the 48 lattice symmetries (avoids proving that 90-degree
  rotations are Delta-equivalent to the identity).

## Next step
Wait for the Mathlib build, compile `wip/Geom.lean`, then FM, Polygon; then Delta.lean, Lat.lean,
Words.lean, KnotClass.lean.
