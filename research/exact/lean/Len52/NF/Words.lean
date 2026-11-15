import Len52.NF.Basic
import Len52.NF.Sum

set_option linter.unusedSimpArgs false

namespace Len52

/-! ## rotate1 -/

@[simp] theorem length_rotate1 (w : List Nat) : (rotate1 w).length = w.length := by
  cases w <;> simp [rotate1]

theorem dir_rotate1 (w : List Nat) (j : Nat) (hj : j < w.length) :
    dir (rotate1 w) j = if j + 1 < w.length then dir w (j + 1) else dir w 0 := by
  cases w with
  | nil => simp at hj
  | cons d ds =>
    simp only [rotate1, dir, List.length_cons] at *
    simp only [List.getD_eq_getElem?_getD]
    by_cases h : j < ds.length
    · rw [List.getElem?_append_left h]; simp [h]
    · have : j = ds.length := by omega
      subst this; simp

theorem vtx_rotate1_gen (w : List Nat) (hn : 1 ≤ w.length) :
    ∀ j, j ≤ w.length → vtx (rotate1 w) j =
      if j < w.length then vtx w (j + 1) - vtx w 1 else vtx w w.length := by
  have hl := length_rotate1 w
  intro j0 hj0
  refine vtx_eq_of_rec (rotate1 w)
    (fun j => if j < w.length then vtx w (j + 1) - vtx w 1 else vtx w w.length) ?_ ?_ j0 (by omega)
  · simp only [if_pos (show 0 < w.length by omega)]
    apply V3.ext' <;> simp
  · intro j hj
    rw [hl] at hj
    rw [dir_rotate1 w j hj]
    by_cases h : j + 1 < w.length
    · simp only [h, hj, if_true]
      rw [vtx_succ w (j + 1) h]
      apply V3.ext' <;> simp <;> omega
    · have : j + 1 = w.length := by omega
      simp only [h, hj, if_true, if_false, this, Nat.lt_irrefl]
      rw [vtx_one w hn]
      apply V3.ext' <;> simp

theorem vtx_rotate1 (w : List Nat) (hn : 1 ≤ w.length) (j : Nat) (hj : j < w.length) :
    vtx (rotate1 w) j = vtx w (j + 1) - vtx w 1 := by
  rw [vtx_rotate1_gen w hn j (by omega)]; simp [hj]

theorem vtx_rotate1_end (w : List Nat) (hn : 1 ≤ w.length) :
    vtx (rotate1 w) (rotate1 w).length = vtx w w.length := by
  rw [length_rotate1, vtx_rotate1_gen w hn _ (Nat.le_refl _)]; simp

def Closed (w : List Nat) : Prop := vtx w w.length = 0

theorem vtx_rotate1_mod (w : List Nat) (hn : 1 ≤ w.length) (hc : Closed w) (j : Nat)
    (hj : j < w.length) :
    vtx (rotate1 w) j = vtx w (if j + 1 < w.length then j + 1 else 0) - vtx w 1 := by
  rw [vtx_rotate1 w hn j hj]
  by_cases h : j + 1 < w.length
  · simp [h]
  · have : j + 1 = w.length := by omega
    simp only [h, if_false]; rw [this, hc, vtx_zero]

theorem closed_rotate1 (w : List Nat) (hn : 1 ≤ w.length) (hc : Closed w) : Closed (rotate1 w) := by
  unfold Closed; rw [vtx_rotate1_end w hn]; exact hc

theorem mem_vset_rotate1 (w : List Nat) (hn : 1 ≤ w.length) (hc : Closed w) (p : V3) :
    p ∈ vset (rotate1 w) ↔ p + vtx w 1 ∈ vset w := by
  rw [mem_vset, mem_vset, length_rotate1]
  constructor
  · rintro ⟨j, hj, e⟩
    rw [vtx_rotate1_mod w hn hc j hj] at e
    refine ⟨if j + 1 < w.length then j + 1 else 0, by split <;> omega, ?_⟩
    rw [← e]; apply V3.ext' <;> simp
  · rintro ⟨j, hj, e⟩
    by_cases h0 : j = 0
    · subst h0
      refine ⟨w.length - 1, by omega, ?_⟩
      rw [vtx_rotate1_mod w hn hc _ (by omega), if_neg (by omega), e]
      apply V3.ext' <;> simp
    · refine ⟨j - 1, by omega, ?_⟩
      rw [vtx_rotate1_mod w hn hc _ (by omega), if_pos (by omega), Nat.sub_add_cancel (by omega), e]
      apply V3.ext' <;> simp

/-! ## iterated rotation -/

def rotN : Nat → List Nat → List Nat
  | 0, w => w
  | t + 1, w => rotate1 (rotN t w)

@[simp] theorem length_rotN (t : Nat) (w : List Nat) : (rotN t w).length = w.length := by
  induction t with
  | zero => rfl
  | succ t ih => simp [rotN, ih]

theorem closed_rotN (t : Nat) (w : List Nat) (hn : 1 ≤ w.length) (hc : Closed w) :
    Closed (rotN t w) := by
  induction t with
  | zero => exact hc
  | succ t ih => exact closed_rotate1 _ (by simp; omega) ih

theorem mod_step (n j t : Nat) (hj : j < n) :
    ((if j + 1 < n then j + 1 else 0) + t) % n = (j + (t + 1)) % n := by
  by_cases h : j + 1 < n
  · simp only [h, if_true]; congr 1; omega
  · simp only [h, if_false]
    have : j + (t + 1) = t + n := by omega
    rw [this, Nat.add_mod_right]; simp

theorem dir_rotN (t : Nat) (w : List Nat) (j : Nat) (hj : j < w.length) :
    dir (rotN t w) j = dir w ((j + t) % w.length) := by
  induction t generalizing j with
  | zero => simp [rotN, Nat.mod_eq_of_lt hj]
  | succ t ih =>
    simp only [rotN]
    rw [dir_rotate1 _ j (by simp; omega)]
    simp only [length_rotN]
    have := mod_step w.length j t hj
    by_cases h : j + 1 < w.length
    · simp only [h, if_true] at this ⊢; rw [ih _ h, this]
    · simp only [h, if_false] at this ⊢; rw [ih _ (by omega), this]

theorem vtx_rotN (t : Nat) (w : List Nat) (hn : 2 ≤ w.length) (hc : Closed w) (j : Nat)
    (hj : j < w.length) :
    vtx (rotN t w) j = vtx w ((j + t) % w.length) - vtx w (t % w.length) := by
  induction t generalizing j with
  | zero => simp [rotN, Nat.mod_eq_of_lt hj, Nat.zero_mod]; apply V3.ext' <;> simp
  | succ t ih =>
    simp only [rotN]
    rw [vtx_rotate1_mod _ (by simp; omega) (closed_rotN t w (by omega) hc) j (by simp; omega)]
    simp only [length_rotN]
    rw [ih _ (by split <;> omega), ih 1 (by omega), mod_step w.length j t hj]
    have : (1 + t) % w.length = (t + 1) % w.length := by rw [Nat.add_comm]
    rw [this]
    len52_v3_ext

theorem mem_vset_rotN (t : Nat) (w : List Nat) (hn : 2 ≤ w.length) (hc : Closed w) (p : V3) :
    p ∈ vset (rotN t w) ↔ p + vtx w (t % w.length) ∈ vset w := by
  induction t generalizing p with
  | zero =>
    simp only [rotN, Nat.zero_mod, vtx_zero]
    have : p + 0 = p := by apply V3.ext' <;> simp
    rw [this]
  | succ t ih =>
    simp only [rotN]
    rw [mem_vset_rotate1 _ (by simp; omega) (closed_rotN t w (by omega) hc), ih,
      vtx_rotN t w hn hc 1 (by omega)]
    have : (1 + t) % w.length = (t + 1) % w.length := by rw [Nat.add_comm]
    rw [this]
    have : p + (vtx w ((t + 1) % w.length) - vtx w (t % w.length)) + vtx w (t % w.length) =
      p + vtx w ((t + 1) % w.length) := by len52_v3_ext
    rw [this]

/-! ## reversal -/

@[simp] theorem length_revWord (w : List Nat) : (revWord w).length = w.length := by
  simp [revWord]

theorem dir_revWord (w : List Nat) (j : Nat) (hj : j < w.length) :
    dir (revWord w) j = rev (dir w (w.length - 1 - j)) := by
  simp only [revWord, dir, List.getD_eq_getElem?_getD]
  rw [List.getElem?_reverse (by simp; omega)]
  simp only [List.length_map, List.getElem?_map]
  rw [List.getElem?_eq_getElem (by omega)]; rfl

theorem unit_rev (d : Nat) (hd : d < 6) : unit (rev d) = ⟨-(unit d).x, -(unit d).y, -(unit d).z⟩ := by
  match d, hd with
  | 0, _ => rfl
  | 1, _ => rfl
  | 2, _ => rfl
  | 3, _ => rfl
  | 4, _ => rfl
  | 5, _ => rfl

theorem axis_rev (d : Nat) : axis (rev d) = axis d := by
  unfold axis rev; split <;> omega

theorem rev_rev (d : Nat) : rev (rev d) = d := by
  unfold rev; split <;> split <;> omega

theorem dir_lt (w : List Nat) (h : ∀ d ∈ w, d < 6) (j : Nat) (hj : j < w.length) : dir w j < 6 := by
  apply h
  simp only [dir, List.getD_eq_getElem?_getD, List.getElem?_eq_getElem hj, Option.getD_some]
  exact List.getElem_mem hj

theorem vtx_revWord (w : List Nat) (h6 : ∀ d ∈ w, d < 6) :
    ∀ j, j ≤ w.length → vtx (revWord w) j = vtx w (w.length - j) - vtx w w.length := by
  intro j0 hj0
  refine vtx_eq_of_rec (revWord w) (fun j => vtx w (w.length - j) - vtx w w.length) ?_ ?_ j0
    (by simp; omega)
  · simp; apply V3.ext' <;> simp
  · intro j hj
    simp only [length_revWord] at hj
    rw [dir_revWord w j hj, unit_rev _ (dir_lt w h6 _ (by omega))]
    have := vtx_succ w (w.length - 1 - j) (by omega)
    have e : w.length - 1 - j + 1 = w.length - j := by omega
    rw [e] at this
    dsimp only
    rw [this]
    have e2 : w.length - (j + 1) = w.length - 1 - j := by omega
    rw [e2]
    len52_v3_ext

theorem closed_revWord (w : List Nat) (h6 : ∀ d ∈ w, d < 6) (hc : Closed w) :
    Closed (revWord w) := by
  unfold Closed at *; rw [length_revWord, vtx_revWord w h6 _ (Nat.le_refl _), hc]
  simp; len52_v3_ext

theorem vtx_revWord_closed (w : List Nat) (h6 : ∀ d ∈ w, d < 6) (hc : Closed w) (j : Nat)
    (hj : j ≤ w.length) : vtx (revWord w) j = vtx w (w.length - j) := by
  rw [vtx_revWord w h6 j hj, hc]; apply V3.ext' <;> simp

theorem mem_vset_revWord (w : List Nat) (h6 : ∀ d ∈ w, d < 6) (hc : Closed w) (p : V3) :
    p ∈ vset (revWord w) ↔ p ∈ vset w := by
  rw [mem_vset, mem_vset, length_revWord]
  constructor
  · rintro ⟨j, hj, e⟩
    rw [vtx_revWord_closed w h6 hc j (by omega)] at e
    by_cases h0 : j = 0
    · subst h0; refine ⟨0, by omega, ?_⟩; rw [← e]; simp at hc ⊢; rw [hc]
    · exact ⟨w.length - j, by omega, e⟩
  · rintro ⟨j, hj, e⟩
    by_cases h0 : j = 0
    · subst h0; refine ⟨0, by omega, ?_⟩
      rw [vtx_revWord_closed w h6 hc 0 (by omega)]; simp only [Nat.sub_zero]; rw [hc, ← e]; simp
    · refine ⟨w.length - j, by omega, ?_⟩
      rw [vtx_revWord_closed w h6 hc _ (by omega)]
      rw [show w.length - (w.length - j) = j by omega]; exact e

/-! ## corner flip -/

@[simp] theorem length_swapAt (w : List Nat) (i : Nat) : (swapAt w i).length = w.length := by
  simp [swapAt]

theorem dir_swapAt (w : List Nat) (i : Nat) (hi1 : 1 ≤ i) (hi : i < w.length) (j : Nat)
    (hj : j < w.length) :
    dir (swapAt w i) j = if j = i - 1 then dir w i else if j = i then dir w (i - 1) else dir w j := by
  simp only [swapAt, dir, List.getD_eq_getElem?_getD, List.getElem?_set, List.length_set]
  by_cases a : j = i - 1
  · subst a
    simp only [show ¬ i = i - 1 by omega, if_false, if_true, show i - 1 < w.length by omega]
    rfl
  · by_cases b : j = i
    · subst b; simp [a, hi]
    · simp only [a, b, if_false, show ¬ i = j by omega, show ¬ i - 1 = j by omega]

theorem vtx_swapAt (w : List Nat) (i : Nat) (hi1 : 1 ≤ i) (hi : i < w.length) :
    ∀ j, j ≤ w.length →
      vtx (swapAt w i) j = if j = i then vtx w (i - 1) + unit (dir w i) else vtx w j := by
  intro j0 hj0
  refine vtx_eq_of_rec (swapAt w i)
    (fun j => if j = i then vtx w (i - 1) + unit (dir w i) else vtx w j) ?_ ?_ j0 (by simp; omega)
  · simp [show ¬ 0 = i by omega]
  · intro j hj
    simp only [length_swapAt] at hj
    rw [dir_swapAt w i hi1 hi j hj]
    by_cases a : j = i - 1
    · subst a
      simp only [show i - 1 + 1 = i by omega, if_true, show ¬ i - 1 = i by omega, if_false]
    · by_cases b : j = i
      · subst b
        simp only [a, if_true, if_false, show ¬ j + 1 = j by omega]
        rw [vtx_succ w j hj]
        have := vtx_succ w (j - 1) (by omega)
        rw [show j - 1 + 1 = j by omega] at this
        rw [this]
        apply V3.ext' <;> simp <;> omega
      · simp only [a, b, if_false, show ¬ j + 1 = i by omega]
        exact vtx_succ w j hj

theorem closed_swapAt (w : List Nat) (i : Nat) (hi1 : 1 ≤ i) (hi : i < w.length) (hc : Closed w) :
    Closed (swapAt w i) := by
  unfold Closed; rw [length_swapAt, vtx_swapAt w i hi1 hi _ (Nat.le_refl _), if_neg (by omega)]
  exact hc

/-! ## U-turn removal -/

theorem length_removeUturn (w : List Nat) (i : Nat) (hi : i + 3 ≤ w.length) :
    (removeUturn w i).length + 2 = w.length := by
  simp [removeUturn]; omega

/-! ## axis counts -/

theorem countAxis_eq (A : Nat) (w : List Nat) :
    (countAxis A w : Int) = sumI w.length (fun j => if axis (dir w j) = A then 1 else 0) := by
  induction w with
  | nil => simp [countAxis, sumI]
  | cons d ds ih =>
    simp only [List.length_cons]
    rw [sumI_succ']
    have e1 : countAxis A (d :: ds) = (if axis d = A then 1 else 0) + countAxis A ds := by
      simp only [countAxis, List.filter_cons]
      split <;> simp_all [Nat.add_comm]
    rw [e1]; push_cast; rw [ih]
    congr 1
    · simp [dir]; split <;> simp

theorem countAxis_rotate1 (A : Nat) (w : List Nat) : countAxis A (rotate1 w) = countAxis A w := by
  cases w with
  | nil => rfl
  | cons d ds =>
    have := countAxis_eq A (rotate1 (d :: ds))
    have h2 := countAxis_eq A (d :: ds)
    have h3 := sumI_rot1 (d :: ds).length (fun j => if axis (dir (d :: ds) j) = A then 1 else 0)
      (by simp)
    rw [length_rotate1] at this
    rw [sumI_congr _ _ (fun j => if j + 1 < (d :: ds).length
        then (fun j => if axis (dir (d :: ds) j) = A then (1 : Int) else 0) (j + 1)
        else (fun j => if axis (dir (d :: ds) j) = A then (1 : Int) else 0) 0) (fun j hj => by
          rw [dir_rotate1 _ j hj]; by_cases h : j + 1 < (d :: ds).length <;> simp only [h, if_true, if_false])] at this
    omega

theorem countAxis_revWord (A : Nat) (w : List Nat) : countAxis A (revWord w) = countAxis A w := by
  have h1 := countAxis_eq A (revWord w)
  have h2 := countAxis_eq A w
  have h3 : sumI w.length (fun j => if axis (dir w (w.length - 1 - j)) = A then (1 : Int) else 0) =
      sumI w.length (fun j => if axis (dir w j) = A then 1 else 0) :=
    sumI_reflect w.length (fun j => if axis (dir w j) = A then 1 else 0)
  rw [length_revWord] at h1
  rw [sumI_congr _ _ (fun j => if axis (dir w (w.length - 1 - j)) = A then (1 : Int) else 0)
      (fun j hj => by rw [dir_revWord w j hj, axis_rev])] at h1
  omega

theorem countAxis_swapAt (A : Nat) (w : List Nat) (i : Nat) (hi1 : 1 ≤ i) (hi : i < w.length) :
    countAxis A (swapAt w i) = countAxis A w := by
  have h1 := countAxis_eq A (swapAt w i)
  have h2 := countAxis_eq A w
  rw [length_swapAt] at h1
  have d1 : dir (swapAt w i) (i - 1) = dir w i := by
    rw [dir_swapAt w i hi1 hi (i - 1) (by omega), if_pos rfl]
  have d2 : dir (swapAt w i) i = dir w (i - 1) := by
    rw [dir_swapAt w i hi1 hi i (by omega), if_neg (by omega), if_pos rfl]
  have h3 := sumI_swap w.length (fun j => if axis (dir w j) = A then (1 : Int) else 0)
    (fun j => if axis (dir (swapAt w i) j) = A then (1 : Int) else 0) i hi1 hi
    (fun j hj a b => by dsimp only; rw [dir_swapAt w i hi1 hi j hj, if_neg a, if_neg b])
    (by dsimp only; rw [d1]) (by dsimp only; rw [d2])
  omega

end Len52
