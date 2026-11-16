/-
  Len52.SP.Obl — lemmas about the obligation machinery of the search (curtainOb, cornerSite,
  usable/avail/fine, spanNeed), independent of the word.
-/
import Len52.SP.Prefix

namespace Len52.SP
open Len52 Len52.Search

theorem curtainOb_cons (occ : Array Bool) (a q : Nat) (qs : List Nat) :
    curtainOb occ a (q :: qs) =
      if occAt occ (back q a) = true then none
      else match curtainOb occ a qs with
        | none => none
        | some l => some (if allowed (back q a) = true then back q a :: l else l) := by
  rw [curtainOb.eq_2]; exact rfl

theorem curtainOb_none (occ : Array Bool) (a : Nat) : ∀ (qs : List Nat) (q : Nat), q ∈ qs →
    occAt occ (back q a) = true → curtainOb occ a qs = none
  | [], _, h, _ => absurd h List.not_mem_nil
  | q' :: qs, q, h, ho => by
    rw [curtainOb_cons]
    by_cases ho' : occAt occ (back q' a) = true
    · rw [if_pos ho']
    · rw [if_neg ho']
      rcases List.mem_cons.1 h with rfl | h'
      · exact absurd ho ho'
      · rw [curtainOb_none occ a qs q h' ho]

theorem curtainOb_some (occ : Array Bool) (a : Nat) : ∀ (qs : List Nat) (q : Nat) (l : Ob), q ∈ qs →
    curtainOb occ a qs = some l → occAt occ (back q a) = false ∧
      (allowed (back q a) = true → back q a ∈ l)
  | [], _, _, h, _ => absurd h List.not_mem_nil
  | q' :: qs, q, l, h, hc => by
    rw [curtainOb_cons] at hc
    by_cases ho' : occAt occ (back q' a) = true
    · rw [if_pos ho'] at hc; exact absurd hc (by simp)
    · rw [if_neg ho'] at hc
      split at hc
      · exact absurd hc (by simp)
      · rename_i l' hl'
        have hc' := Option.some.inj hc
        rcases List.mem_cons.1 h with rfl | h'
        · refine ⟨by simpa using ho', fun hal => ?_⟩
          rw [if_pos hal] at hc'; rw [← hc']; exact List.mem_cons_self
        · obtain ⟨h1, h2⟩ := curtainOb_some occ a qs q l' h' hl'
          refine ⟨h1, fun hal => ?_⟩
          by_cases hs : allowed (back q' a) = true
          · rw [if_pos hs] at hc'; rw [← hc']; exact List.mem_cons_of_mem _ (h2 hal)
          · rw [if_neg hs] at hc'; rw [← hc']; exact h2 hal

theorem usable_one {occ : Array Bool} {nx x : Nat}
    (h : x = nx ∨ x = ORG ∨ (occAt occ x = false ∧ allowed x = true)) : usable occ nx x = 1 := by
  unfold usable
  rw [if_pos]
  rcases h with h | h | ⟨h1, h2⟩
  · simp [h]
  · simp [h]
  · simp [h1, h2]

theorem avail_two {occ : Array Bool} {nx s d1 d2 : Nat} (h1 : d1 < 6) (h2 : d2 < 6) (hne : d1 ≠ d2)
    (u1 : usable occ nx (mv s d1) = 1) (u2 : usable occ nx (mv s d2) = 1) : 2 ≤ avail occ nx s := by
  unfold avail
  rcases six_cases h1 with rfl | rfl | rfl | rfl | rfl | rfl <;>
  rcases six_cases h2 with rfl | rfl | rfl | rfl | rfl | rfl <;> omega

theorem fine_of {occ : Array Bool} {nx R1 : Nat} {ob : Ob} {s : Nat} (hs : s ∈ ob)
    (hd : mdist nx s + dist0 s ≤ R1) (ha : 2 ≤ avail occ nx s) : fine occ nx R1 ob = true := by
  unfold fine
  rw [List.any_eq_true]
  exact ⟨s, hs, by simp [hd, ha]⟩

/-! ## spanNeed -/

def spanF (c lo hi : Int) : Int :=
  min ((c - min lo c) + (max hi c - min lo c) + max hi c)
    ((max hi c - c) + (max hi c - min lo c) + (0 - min lo c))

theorem go_nil (fr : Nat) (lx hx ly hy lz hz : Int) :
    spanNeed.go fr [] lx hx ly hy lz hz =
      (spanF (cx fr) lx hx + spanF (cy fr) ly hy + spanF (cz fr) lz hz).toNat := by
  rw [spanNeed.go.eq_1]; rfl

/-- a value is attained by coordinate g at a time in [a, b] -/
def Att (g : Nat → Int) (a b : Nat) (v : Int) : Prop := ∃ t, a ≤ t ∧ t ≤ b ∧ g t = v

theorem Att.min {g : Nat → Int} {a b : Nat} {u v : Int} (hu : Att g a b u) (hv : Att g a b v) :
    Att g a b (min u v) := by
  by_cases h : u ≤ v
  · rw [Int.min_eq_left h]; exact hu
  · rw [Int.min_eq_right (by omega)]; exact hv

theorem Att.max {g : Nat → Int} {a b : Nat} {u v : Int} (hu : Att g a b u) (hv : Att g a b v) :
    Att g a b (max u v) := by
  by_cases h : u ≤ v
  · rw [Int.max_eq_right h]; exact hv
  · rw [Int.max_eq_left (by omega)]; exact hu

theorem spanF_le (g : Nat → Int) (a n : Nat) (hend : g (a + n) = 0) {lo hi : Int}
    (hl : Att g a (a + n) lo) (hh : Att g a (a + n) hi) : spanF (g a) lo hi ≤ tv g a n := by
  have hc : Att g a (a + n) (g a) := ⟨a, Nat.le_refl _, by omega, rfl⟩
  obtain ⟨tl, htl1, htl2, htl⟩ := hl.min hc
  obtain ⟨th, hth1, hth2, hth⟩ := hh.max hc
  unfold spanF
  by_cases ho : tl ≤ th
  · have := tv_path g htl1 ho hth2
    rw [htl, hth, hend] at this
    omega
  · have := tv_path g hth1 (Nat.le_of_lt (Nat.lt_of_not_le ho)) htl2
    rw [htl, hth, hend] at this
    omega

end Len52.SP
