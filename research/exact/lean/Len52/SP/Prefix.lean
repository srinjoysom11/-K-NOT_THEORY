/-
  Len52.SP.Prefix — the canonical values of the search state along a fixed word, and the
  elementary consequences of Survive used by the tests (S1, S2 and their cyclic forms).
-/
import Len52.SP.Walk

namespace Len52.SP
open Len52 Len52.Search

/-! ## Last and first letter on each axis -/

def lastAx (w : List Nat) : Nat → Nat → AxI
  | 0, _ => none
  | i + 1, A => if axis (dir w i) = A then some (i, dir w i) else lastAx w i A

def firstAx (w : List Nat) : Nat → Nat → AxI
  | 0, _ => none
  | i + 1, A =>
    match firstAx w i A with
    | none => if axis (dir w i) = A then some (i, dir w i) else none
    | some p => some p

theorem lastAx_spec (w : List Nat) : ∀ i A j a, lastAx w i A = some (j, a) →
    j < i ∧ a = dir w j ∧ axis a = A ∧ ∀ t, j < t → t < i → axis (dir w t) ≠ A
  | 0, _, _, _, h => by simp [lastAx] at h
  | i + 1, A, j, a, h => by
    simp only [lastAx] at h
    split at h
    · rename_i hA
      simp only [Option.some.injEq, Prod.mk.injEq] at h
      obtain ⟨rfl, rfl⟩ := h
      exact ⟨by omega, rfl, hA, fun t h1 h2 => by omega⟩
    · rename_i hA
      obtain ⟨h1, h2, h3, h4⟩ := lastAx_spec w i A j a h
      refine ⟨by omega, h2, h3, fun t ht1 ht2 => ?_⟩
      by_cases ht : t = i
      · subst ht; exact hA
      · exact h4 t ht1 (by omega)

theorem firstAx_none (w : List Nat) (A : Nat) : ∀ k, firstAx w k A = none →
    ∀ t, t < k → axis (dir w t) ≠ A
  | 0, _, t, ht => by omega
  | k + 1, hk, t, ht => by
    simp only [firstAx] at hk
    split at hk
    · rename_i hn'
      split at hk
      · exact absurd hk (by simp)
      · rename_i hA'
        by_cases htk : t = k
        · subst htk; exact hA'
        · exact firstAx_none w A k hn' t (by omega)
    · exact absurd hk (by simp)

theorem firstAx_spec (w : List Nat) : ∀ i A j a, firstAx w i A = some (j, a) →
    j < i ∧ a = dir w j ∧ axis a = A ∧ ∀ t, t < j → axis (dir w t) ≠ A
  | 0, _, _, _, h => by simp [firstAx] at h
  | i + 1, A, j, a, h => by
    simp only [firstAx] at h
    split at h
    · rename_i hn
      split at h
      · rename_i hA
        simp only [Option.some.injEq, Prod.mk.injEq] at h
        obtain ⟨rfl, rfl⟩ := h
        exact ⟨by omega, rfl, hA, firstAx_none w A _ hn⟩
      · exact absurd h (by simp)
    · rename_i p hp
      simp only [Option.some.injEq] at h
      subst h
      obtain ⟨h1, h2, h3, h4⟩ := firstAx_spec w i A j a hp
      exact ⟨by omega, h2, h3, h4⟩

/-- an `Axes` record from a function of the axis -/
def axesOf (g : Nat → AxI) : Axes := ⟨g 0, g 1, g 2⟩

theorem three_cases {A : Nat} (h : A < 3) : A = 0 ∨ A = 1 ∨ A = 2 := by omega

theorem axesOf_get (g : Nat → AxI) {A : Nat} (h : A < 3) : (axesOf g).get A = g A := by
  rcases three_cases h with rfl | rfl | rfl <;> rfl

theorem axesOf_set_last {w : List Nat} (h6 : ∀ d ∈ w, d < 6) (i : Nat) :
    (axesOf (lastAx w i)).set (axis (dir w i)) (some (i, dir w i)) = axesOf (lastAx w (i + 1)) := by
  have hA := axis_lt (dir_lt h6 i)
  unfold axesOf
  simp only [lastAx]
  rcases three_cases hA with h | h | h <;> rw [h] <;> simp [Axes.set]

theorem axesOf_set_first {w : List Nat} (h6 : ∀ d ∈ w, d < 6) (i : Nat) :
    (match (axesOf (firstAx w i)).get (axis (dir w i)) with
      | none => (axesOf (firstAx w i)).set (axis (dir w i)) (some (i, dir w i))
      | _ => axesOf (firstAx w i)) = axesOf (firstAx w (i + 1)) := by
  have hA := axis_lt (dir_lt h6 i)
  rw [axesOf_get _ hA]
  unfold axesOf
  simp only [firstAx]
  rcases three_cases hA with h | h | h <;> rw [h] <;>
    cases h0 : firstAx w i 0 <;> cases h1 : firstAx w i 1 <;> cases h2 : firstAx w i 2 <;>
    simp [Axes.set]

/-! ## Letter counts -/

def cntA (w : List Nat) (i A : Nat) : Nat := countAxis A (w.take i)

def cntOf (w : List Nat) (i : Nat) : Cnt := ⟨cntA w i 0, cntA w i 1, cntA w i 2⟩

theorem getElem?_dir {w : List Nat} {i : Nat} (h : i < w.length) : w[i]? = some (dir w i) := by
  unfold dir; rw [List.getD_eq_getElem?_getD, List.getElem?_eq_getElem h]; rfl

theorem take_succ_dir {w : List Nat} {i : Nat} (h : i < w.length) :
    w.take (i + 1) = w.take i ++ [dir w i] := by
  rw [List.take_succ, getElem?_dir h]; rfl

theorem cntA_succ {w : List Nat} {i : Nat} (h : i < w.length) (A : Nat) :
    cntA w (i + 1) A = cntA w i A + if axis (dir w i) = A then 1 else 0 := by
  unfold cntA countAxis
  rw [take_succ_dir h, List.filter_append, List.length_append]
  by_cases hA : axis (dir w i) = A <;> simp [hA]

theorem cntOf_succ {w : List Nat} (h6 : ∀ d ∈ w, d < 6) {i : Nat} (h : i < w.length) :
    (cntOf w i).inc (axis (dir w i)) = cntOf w (i + 1) := by
  have hA := axis_lt (dir_lt h6 i)
  unfold cntOf
  rw [cntA_succ h, cntA_succ h, cntA_succ h]
  rcases three_cases hA with h' | h' | h' <;> rw [h'] <;> simp [Cnt.inc]

theorem cntOf_zero_inc (w : List Nat) (h6 : ∀ d ∈ w, d < 6) (h : 0 < w.length) :
    (⟨0, 0, 0⟩ : Cnt).inc (axis (dir w 0)) = cntOf w 1 := by
  rw [← cntOf_succ h6 h]; rfl

theorem countAxis_split (A : Nat) (w : List Nat) (i : Nat) :
    countAxis A w = cntA w i A + countAxis A (w.drop i) := by
  unfold cntA countAxis
  conv => lhs; rw [← List.take_append_drop i w]
  rw [List.filter_append, List.length_append]

theorem countAxis_sum : ∀ (l : List Nat), (∀ d ∈ l, d < 6) →
    countAxis 0 l + countAxis 1 l + countAxis 2 l = l.length
  | [], _ => rfl
  | d :: l, h => by
    have ih := countAxis_sum l (fun x hx => h x (List.mem_cons_of_mem _ hx))
    have hd := axis_lt (h d (List.mem_cons_self))
    unfold countAxis at *
    simp only [List.filter_cons, List.length_cons]
    rcases three_cases hd with h' | h' | h' <;> simp [h'] <;> omega

/-! ## The list of positions v_k, ..., v_0 -/

def rpos (f : Nat → Nat) : Nat → List Nat
  | 0 => [f 0]
  | k + 1 => f (k + 1) :: rpos f k

theorem rpos_length (f : Nat → Nat) : ∀ k, (rpos f k).length = k + 1
  | 0 => rfl
  | k + 1 => by simp [rpos, rpos_length f k]

theorem rpos_headD (f : Nat → Nat) (k : Nat) : (rpos f k).headD 0 = f k := by cases k <;> rfl

theorem rpos_getD (f : Nat → Nat) : ∀ k t, t ≤ k → (rpos f k).getD t 0 = f (k - t)
  | 0, t, h => by rw [show t = 0 by omega]; rfl
  | k + 1, 0, _ => rfl
  | k + 1, t + 1, h => by
    simp only [rpos, List.getD_cons_succ]
    rw [rpos_getD f k t (by omega)]; congr 1; omega

theorem rpos_drop (f : Nat → Nat) : ∀ k t, t ≤ k → (rpos f k).drop t = rpos f (k - t)
  | k, 0, _ => rfl
  | 0, t + 1, h => by omega
  | k + 1, t + 1, h => by
    simp only [rpos, List.drop_succ_cons]
    rw [rpos_drop f k t (by omega), show k + 1 - (t + 1) = k - t by omega]

theorem mem_rpos_take (f : Nat → Nat) : ∀ k n t, t ≤ k → k < t + n → f t ∈ (rpos f k).take n
  | 0, n, t, h1, h2 => by
    obtain ⟨n, rfl⟩ : ∃ m, n = m + 1 := ⟨n - 1, by omega⟩
    rw [show t = 0 by omega]; simp [rpos]
  | k + 1, n, t, h1, h2 => by
    obtain ⟨n, rfl⟩ : ∃ m, n = m + 1 := ⟨n - 1, by omega⟩
    simp only [rpos, List.take_succ_cons, List.mem_cons]
    by_cases ht : t = k + 1
    · left; rw [ht]
    · right; exact mem_rpos_take f k n t (by omega) (by omega)

theorem rpos_reverse_getD (f : Nat → Nat) : ∀ k t, t ≤ k → (rpos f k).reverse.getD t 0 = f t
  | 0, t, h => by rw [show t = 0 by omega]; rfl
  | k + 1, t, h => by
    simp only [rpos, List.reverse_cons]
    rw [List.getD_eq_getElem?_getD]
    by_cases ht : t ≤ k
    · rw [List.getElem?_append_left (by simp [rpos_length]; omega), ← List.getD_eq_getElem?_getD,
        rpos_reverse_getD f k t ht]
    · rw [List.getElem?_append_right (by simp [rpos_length]; omega)]
      simp [rpos_length, show t = k + 1 by omega]

/-! ## The reversed prefix of letters -/

theorem take_rev_succ {w : List Nat} {i : Nat} (h : i < w.length) :
    (w.take (i + 1)).reverse = dir w i :: (w.take i).reverse := by
  rw [take_succ_dir h]; simp

/-! ## Consequences of Survive -/

theorem mod_two {x N : Nat} (h : x < 2 * N) (hN : N ≤ x) : x % N = x - N := by
  rw [Nat.mod_eq_sub_mod hN, Nat.mod_eq_of_lt (by omega)]

section
variable {w : List Nat} (hS : Survive w)
include hS

theorem S_len : 4 ≤ w.length := hS.1.1
theorem S_six : ∀ d ∈ w, d < 6 := hS.1.2.1
theorem S_close : vtx w w.length = 0 := hS.1.2.2.1
theorem S_nodup : (vset w).Nodup := hS.1.2.2.2

/-- two vertices with indices at most N are equal only if the indices agree (mod N) -/
theorem vtx_eq_idx {a b : Nat} (ha : a ≤ w.length) (hb : b < w.length) (h : vtx w a = vtx w b) :
    a = b ∨ (a = w.length ∧ b = 0) := by
  by_cases haN : a = w.length
  · right; refine ⟨haN, ?_⟩
    rw [haN, S_close hS, ← vtx_zero w] at h
    exact (vtx_inj (S_nodup hS) (by have := S_len hS; omega) hb h).symm
  · left; exact vtx_inj (S_nodup hS) (by omega) hb h

/-- S1: no immediate reversal -/
theorem S1 {m : Nat} (h1 : 1 ≤ m) (h2 : m < w.length) : dir w m ≠ rev (dir w (m - 1)) := by
  intro h
  have h6 := S_six hS
  have e1 := vtx_succ (w := w) (j := m) h2
  have e2 := vtx_succ (w := w) (j := m - 1) (by omega)
  rw [show m - 1 + 1 = m by omega] at e2
  rw [h, unit_rev _ (dir_lt h6 _), e2, add_sub_unit] at e1
  rcases vtx_eq_idx hS (a := m + 1) (b := m - 1) (by omega) (by omega) e1 with h' | h'
  · omega
  · have := S_len hS; omega

theorem S1c {j : Nat} (hj : j < w.length) : dir w ((j + 1) % w.length) ≠ rev (dir w j) := by
  have hN := S_len hS
  by_cases hj' : j + 1 < w.length
  · rw [Nat.mod_eq_of_lt hj']
    have := S1 hS (m := j + 1) (by omega) hj'
    simpa using this
  · rw [show j + 1 = w.length by omega, Nat.mod_self]
    intro h
    have h6 := S_six hS
    have e1 := vtx_succ (w := w) (j := 0) (by omega)
    have e2 := vtx_succ (w := w) (j := w.length - 1) (by omega)
    rw [show w.length - 1 + 1 = w.length by omega, S_close hS] at e2
    rw [vtx_zero, h, show j = w.length - 1 by omega, unit_rev _ (dir_lt h6 _)] at e1
    have e3 : vtx w (w.length - 1) = 0 - unit (dir w (w.length - 1)) := by
      rw [e2, add_sub_unit]
    rw [← e3] at e1
    have := vtx_inj (S_nodup hS) (a := 1) (b := w.length - 1) (by omega) (by omega)
      (by rw [e1])
    omega

theorem S2c {j : Nat} (hj : j < w.length) : dir w ((j + 2) % w.length) ≠ rev (dir w j) := by
  have hN := S_len hS
  have h6 := S_six hS
  have j1lt : (j + 1) % w.length < w.length := Nat.mod_lt _ (by omega)
  have hmod : ((j + 1) % w.length + 1) % w.length = (j + 2) % w.length := by
    by_cases a : j + 2 < w.length
    · rw [Nat.mod_eq_of_lt (show j + 1 < w.length by omega)]
    · by_cases b : j + 1 < w.length
      · rw [Nat.mod_eq_of_lt b, show j + 1 + 1 = j + 2 by omega]
      · rw [show j + 1 = w.length by omega, Nat.mod_self, show j + 2 = 1 + w.length by omega,
          Nat.add_mod_right]
  intro h
  by_cases hax : axis (dir w ((j + 1) % w.length)) = axis (dir w j)
  · rcases axis_eq hax with e | e
    · apply S1c hS j1lt
      rw [hmod, h, e]
    · exact S1c hS hj e
  · have := hS.2.2.2.2.1 j 1 hj (Nat.le_refl _) (by omega)
      (fun t ht1 ht2 => by rw [show t = 1 by omega]; exact hax)
      (by rw [show j + 1 + 1 = j + 2 by omega]; exact h)
    obtain ⟨t, ht1, ht2, _⟩ := this
    omega

end

end Len52.SP
