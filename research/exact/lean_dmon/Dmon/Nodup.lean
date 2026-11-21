/-
  Dmon.Nodup — the vertex list of a word is duplicate-free iff the vertices are pairwise different by index.
-/
import Dmon.Walk

namespace Dmon
open Len52

theorem length_vertsFrom (v : V3) (w : List Nat) : (vertsFrom v w).length = w.length + 1 := by
  induction w generalizing v with
  | nil => simp [vertsFrom]
  | cons d ds ih => simp [vertsFrom, ih]

theorem vtx_eq_getElem (w : List Nat) (i : Nat) (hi : i < (verts w).length) : vtx w i = (verts w)[i] := by
  simp [vtx, List.getD_eq_getElem?_getD, List.getElem?_eq_getElem hi]

theorem vset_nodup_iff (w : List Nat) :
    (vset w).Nodup ↔ ∀ i j, i < j → j < w.length → vtx w i ≠ vtx w j := by
  have hlen : (verts w).length = w.length + 1 := length_vertsFrom 0 w
  unfold vset List.Nodup
  rw [List.pairwise_iff_getElem]
  constructor
  · intro h i j hij hj
    have hi : i < ((verts w).take w.length).length := by simp [List.length_take, hlen]; omega
    have hj' : j < ((verts w).take w.length).length := by simp [List.length_take, hlen]; omega
    have := h i j hi hj' hij
    rw [List.getElem_take, List.getElem_take] at this
    rw [vtx_eq_getElem w i (by omega), vtx_eq_getElem w j (by omega)]
    exact this
  · intro h i j hi hj hij
    have hjn : j < w.length := by simp [List.length_take, hlen] at hj; omega
    have := h i j hij hjn
    rw [vtx_eq_getElem w i (by omega), vtx_eq_getElem w j (by omega)] at this
    rw [List.getElem_take, List.getElem_take]
    exact this

end Dmon
