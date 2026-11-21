# lean_dmon: Lean proofs about the new search devices

Separate Lake package (Lean 4.25.0, no Mathlib). It imports only `Len52.Spec` from the frozen development
`../lean` (definitions of words, polygons, `countAxis`, `KnotClass`) and changes nothing there.
Built by `.github/workflows/dmon-lean.yml` (official toolchain, digest checked).

| File | What it proves |
|---|---|
| `Dmon/Walk.lean` | A walk changes the coordinate along axis A by at most one per letter along A, with matching parity. |
| `Dmon/AxisTravel.lean` | **D2 (axis-ordered travel), `aot_sound`.** The test `AotOk` (`aot_ok` / `axis_need` of `enum_bidir.cpp`, flags `-aot -aotm -aotc`, head and tail ends) never rejects a prefix of a polygon word that passes the axis rule and whose middle part visits the sites. |
| `Dmon/Nodup.lean` | Distinct vertices of a word are the same as pairwise different vertices by index. |
| `Dmon/GC.lean` | **D1 (generalized curtain).** `gc_polygon`: the shortened word `mid ++ rest` is a polygon (closed, self-avoiding, n-2 edges) when the window is not closed up. `gc_shortest`: a shortest word of a class that is closed under rotation (`KnotClass`) and under the GC replacement (`GCStep`) passes the GC test at every cyclic window. |
| `tests/` | Differential test: Lean `AotOk` against a literal Python port of the C++ test, 400 random cases per seed. |

## What is hypothesis, not proof

* D2: that every single site and one site of every multi-site obligation is visited by the middle part, and
  that the middle part has at least `cdef A` letters along A. These are the invariants of the obligation
  machinery of the search (PROOF.md, DMON_RESULTS.md E9 section 2); with `-aotc`, `cdef` is the plane-crossing
  debt of Lemma 3, a topological statement for `-prime` / `-stair`.
* D1: `GCStep T`, i.e. that replacing a polygon by the shortened polygon keeps its knot type (the isotopy of
  DMON_RESULTS.md D1). It has the same status as the `flip` and `uturn` fields of `KnotClass`.

## Not covered

`-aotx`, `-aott`, `-slab` variants of the test; the two-ended search order itself (E9: that every word is
visited once and that the other tests apply to two-ended prefixes); the `-stair` rule; the D5 arc gluing;
the identification of knot types. The faithfulness of the Lean definitions to the C++ is checked by reading
(the definitions follow the C++ line by line) and by the differential test; it is not a proof.
