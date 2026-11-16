import Len52.NF.Words

set_option linter.unusedSimpArgs false

namespace Len52

/-- the potential of a word for a height function `f` (z or y): the sum over the vertices of the
    height above the lowest vertex -/
def psiW (f : V3 → Int) (w : List Nat) : Nat := psiOf w.length (fun j => f (vtx w j))

/-- `f` is a coordinate function -/
def IsCoord (f : V3 → Int) : Prop := ∀ a b : V3, f (a - b) = f a - f b ∧ f (a + b) = f a + f b

theorem isCoord_z : IsCoord (fun v => v.z) := fun _ _ => ⟨rfl, rfl⟩
theorem isCoord_y : IsCoord (fun v => v.y) := fun _ _ => ⟨rfl, rfl⟩

theorem psiW_rotate1 (f : V3 → Int) (hf : IsCoord f) (w : List Nat) (hn : 1 ≤ w.length)
    (hc : Closed w) : psiW f (rotate1 w) = psiW f w := by
  unfold psiW
  rw [length_rotate1]
  rw [psiOf_congr _ _ (fun j => (fun j => if j + 1 < w.length then f (vtx w (j + 1)) else f (vtx w 0)) j
      + (- f (vtx w 1))) (fun j hj => by
        rw [vtx_rotate1_mod w hn hc j hj, (hf _ _).1]
        by_cases h : j + 1 < w.length <;> simp [h] <;> omega)]
  rw [psiOf_translate]
  exact psiOf_rot1 w.length (fun j => f (vtx w j)) hn

theorem psiW_revWord (f : V3 → Int) (w : List Nat) (h6 : ∀ d ∈ w, d < 6) (hc : Closed w) :
    psiW f (revWord w) = psiW f w := by
  unfold psiW
  rw [length_revWord]
  rw [psiOf_congr _ _ (fun j => if j = 0 then f (vtx w 0) else f (vtx w (w.length - j)))
    (fun j hj => by
      rw [vtx_revWord_closed w h6 hc j (by omega)]
      by_cases h : j = 0
      · subst h; simp only [Nat.sub_zero, if_true]; rw [hc]; simp
      · simp [h])]
  exact psiOf_reflect0 w.length (fun j => f (vtx w j))

theorem psiW_swapAt_same (f : V3 → Int) (w : List Nat) (i : Nat) (hi1 : 1 ≤ i) (hi : i < w.length)
    (hq : f (vtx w (i - 1) + unit (dir w i)) = f (vtx w i)) :
    psiW f (swapAt w i) = psiW f w := by
  unfold psiW
  rw [length_swapAt]
  apply psiOf_congr
  intro j hj
  rw [vtx_swapAt w i hi1 hi j (by omega)]
  by_cases h : j = i
  · subst h; simp [hq]
  · simp [h]

theorem psiW_swapAt_drop (f : V3 → Int) (w : List Nat) (i k : Nat) (hi1 : 1 ≤ i) (hi : i < w.length)
    (hk : k < w.length) (hki : k ≠ i)
    (hq1 : f (vtx w (i - 1) + unit (dir w i)) = f (vtx w i) - 1)
    (hq2 : f (vtx w (i - 1) + unit (dir w i)) = f (vtx w k)) :
    psiW f (swapAt w i) + 1 = psiW f w := by
  unfold psiW
  rw [length_swapAt]
  have e : ∀ j, j < w.length → f (vtx (swapAt w i) j) =
      if j = i then f (vtx w (i - 1) + unit (dir w i)) else f (vtx w j) := by
    intro j hj
    rw [vtx_swapAt w i hi1 hi j (by omega)]
    by_cases h : j = i <;> simp [h]
  rw [psiOf_congr _ _ _ e]
  apply psiOf_drop w.length (fun j => f (vtx w j)) _ i k hi hk hki
  · intro j _ hji; simp [hji]
  · simp [hq1]
  · simp [hq2]

end Len52
