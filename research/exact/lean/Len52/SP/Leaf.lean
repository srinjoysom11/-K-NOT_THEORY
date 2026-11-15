/-
  Len52.SP.Leaf — the final tests `leafOk` (L1-L3) pass for a word with Survive.
-/
import Len52.SP.Update

namespace Len52.SP
open Len52 Len52.Search

section
variable {w : List Nat} (hS : Survive w) (hN : w.length ≤ 34)
include hS hN

/-- the wrap-around curtain on axis A has an occupied site (C6 at the last letter on A) -/
theorem wrap_ok {occ : Array Bool} (hocc : OccOK w occ (w.length - 1)) {A jl al jf af : Nat}
    (hl : lastAx w w.length A = some (jl, al)) (hf : firstAx w w.length A = some (jf, af))
    (hr : al = rev af) :
    curtainOb occ al (List.map (fun t => (rpos (P w) (w.length - 1)).reverse.getD ((jl + t + 2) % w.length) 0)
      (List.range (w.length - jl - 1 + jf - 1))) = none := by
  have h6 := S_six hS
  have hN4 := S_len hS
  obtain ⟨hl1, hl2, hl3, hl4⟩ := lastAx_spec w _ _ _ _ hl
  obtain ⟨hf1, hf2, hf3, hf4⟩ := firstAx_spec w _ _ _ _ hf
  have hfl : jf ≤ jl := by
    by_cases h : jf ≤ jl
    · exact h
    · exact absurd (hf2 ▸ hf3) (hl4 jf (by omega) hf1)
  have hfl' : jf ≠ jl := by
    intro h; subst h
    rw [hl2] at hr; rw [hf2] at hr
    exact rev_ne hr.symm
  have hk : 1 ≤ w.length - jl - 1 + jf := by
    by_cases h : 1 ≤ w.length - jl - 1 + jf
    · exact h
    · exfalso
      have e1 : jl = w.length - 1 := by omega
      have e2 : jf = 0 := by omega
      apply S1c hS (j := jl) hl1
      rw [e1, show w.length - 1 + 1 = w.length by omega, Nat.mod_self, ← e2, ← hf2, ← e1, ← hl2, hr,
        rev_rev]
  have hC := hS.2.2.2.2.1 jl (w.length - jl - 1 + jf) hl1 hk (by omega)
    (fun t ht1 ht2 => by
      rw [← hl2, hl3]
      by_cases ht : jl + t < w.length
      · rw [Nat.mod_eq_of_lt ht]; exact hl4 _ (by omega) ht
      · rw [mod_two (by omega) (by omega)]; exact hf4 _ (by omega))
    (by
      rw [show jl + (w.length - jl - 1 + jf) + 1 = jf + w.length by omega, Nat.add_mod_right,
        Nat.mod_eq_of_lt hf1, ← hf2, ← hl2, hr, rev_rev])
  obtain ⟨t, ht2, htk, hmem⟩ := hC
  obtain ⟨m, hm, hpk⟩ := vset_P hmem
  have hmod : (jl + t) % w.length < w.length := Nat.mod_lt _ (by omega)
  apply curtainOb_none occ al _ (P w ((jl + t) % w.length))
  · rw [List.mem_map]
    refine ⟨t - 2, List.mem_range.2 (by omega), ?_⟩
    rw [show jl + (t - 2) + 2 = jl + t by omega, rpos_reverse_getD _ _ _ (by omega)]
  · unfold P
    rw [back_pk (vtx_inB hS hN (by omega)) (by rw [hl2]; exact dir_lt h6 _), hl2, hpk]
    exact (hocc _ (vtx_inB hS hN (by omega))).2 ⟨m, by omega, rfl⟩

theorem leaf_ok {occ : Array Bool} (hocc : OccOK w occ (w.length - 1)) :
    leafOk occ w.length (rpos (P w) (w.length - 1)).reverse w (axesOf (lastAx w w.length))
      (axesOf (firstAx w w.length)) (cntOf w w.length) = true := by
  have hN4 := S_len hS
  unfold leafOk
  lift_lets
  intro dd wrap
  have hw : ∀ A, A < 3 → wrap A = true := by
    intro A hA
    simp only [wrap]
    rw [axesOf_get _ hA, axesOf_get _ hA]
    split
    · rename_i jl al jf af hl hf
      split
      · rename_i hr
        rw [wrap_ok hS hN hocc hl hf (by simpa using hr)]
      · rfl
    · rfl
  have l1 : (dd 0 == rev (dd (w.length - 2))) = false := by
    have := S2c hS (j := w.length - 2) (by omega)
    rw [show w.length - 2 + 2 = w.length by omega, Nat.mod_self] at this
    simpa [dd] using this
  have l2 : (dd 1 == rev (dd (w.length - 1))) = false := by
    have := S2c hS (j := w.length - 1) (by omega)
    rw [show w.length - 1 + 2 = 1 + w.length by omega, Nat.add_mod_right,
      Nat.mod_eq_of_lt (show 1 < w.length by omega)] at this
    simpa [dd] using this
  have c5 := hS.2.2.2.1
  rw [l1, l2, hw 0 (by omega), hw 1 (by omega), hw 2 (by omega)]
  simp only [cntOf, cntA, List.take_length]
  simp [c5.1, c5.2]

end

end Len52.SP
