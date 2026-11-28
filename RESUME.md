# RESUME index: where paused work is handed off

Each file below describes one paused line of work: its state, the exact commands to resume it, and the context it
needs. Read the one you are resuming first, then the files it points to. Branch: `claude/great-einstein-snvnnb`
(the DMON benchmark session works on `claude/dmon-experiments`).

| Line of work | Handoff file |
|---|---|
| Lean 4 proof of the knot invariant (Phase 3 next) | `research/exact/lean42/RESUME.md` (and `STATUS.md`, `PHASE3_PLAN.md`, `PLAN.md` there); the n = 42 search in Lean: `research/exact/lean42/N42_PLAN.md` |
| Search speedup U2 (`enum_u.cpp`), agent J | `research/exact/dmon2/wip_J/RESUME.md` |
| Primeness-free replacement for `-stair` (Lemmas 3*, 5*, M), agent K | `research/exact/dmon2/wip_K/RESUME.md` |
| Doom ceiling of bounds (how much a stronger bound can still cut) | `research/exact/dmon2/wip_doom/RESUME.md` |
| Full n = 42, 44, 46 runs on Actions (DMON experiments session) | on branch `claude/dmon-experiments`, see the RESUME file it names in `research/exact/` |

Overview of all search leads with results: `research/exact/dmon2/LEADS3.md`. The lead-9 specification (multi-gap
search): `research/exact/dmon2/MULTIGAP.md`.
