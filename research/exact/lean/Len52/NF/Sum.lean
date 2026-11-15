import Len52.Spec

namespace Len52

/-- `sumI n g = g 0 + ... + g (n-1)` -/
def sumI : Nat → (Nat → Int) → Int
  | 0, _ => 0
  | n + 1, g => sumI n g + g n

/-- `lowI n g = min (g 0, ..., g n)` -/
def lowI : Nat → (Nat → Int) → Int
  | 0, g => g 0
  | n + 1, g => min (lowI n g) (g (n + 1))

theorem sumI_congr (n : Nat) (g h : Nat → Int) (e : ∀ j, j < n → g j = h j) :
    sumI n g = sumI n h := by
  induction n with
  | zero => rfl
  | succ n ih => simp only [sumI]; rw [ih (fun j hj => e j (by omega)), e n (by omega)]

theorem sumI_succ' (n : Nat) (g : Nat → Int) : sumI (n + 1) g = g 0 + sumI n (fun j => g (j + 1)) := by
  induction n with
  | zero => simp [sumI]
  | succ n ih => simp only [sumI] at *; rw [ih]; omega

theorem sumI_add (n : Nat) (g h : Nat → Int) :
    sumI n (fun j => g j + h j) = sumI n g + sumI n h := by
  induction n with
  | zero => simp [sumI]
  | succ n ih => simp only [sumI]; rw [ih]; omega

theorem sumI_const (n : Nat) (c : Int) : sumI n (fun _ => c) = n * c := by
  induction n with
  | zero => simp [sumI]
  | succ n ih => simp only [sumI]; rw [ih]; push_cast; rw [Int.add_mul]; omega

theorem sumI_change (n : Nat) (g h : Nat → Int) (i : Nat) (hi : i < n)
    (e : ∀ j, j < n → j ≠ i → h j = g j) : sumI n h = sumI n g + (h i - g i) := by
  induction n with
  | zero => omega
  | succ n ih =>
    simp only [sumI]
    by_cases hin : i = n
    · subst hin
      rw [sumI_congr i h g (fun j hj => e j (by omega) (by omega))]; omega
    · rw [ih (by omega) (fun j hj hji => e j (by omega) hji), e n (by omega) (by omega)]; omega

theorem sumI_swap (n : Nat) (g h : Nat → Int) (i : Nat) (hi1 : 1 ≤ i) (hi : i < n)
    (e : ∀ j, j < n → j ≠ i - 1 → j ≠ i → h j = g j) (e1 : h (i - 1) = g i) (e2 : h i = g (i - 1)) :
    sumI n h = sumI n g := by
  let g1 : Nat → Int := fun j => if j = i then h i else g j
  have s1 : sumI n g1 = sumI n g + (g1 i - g i) :=
    sumI_change n g g1 i hi (fun j _ hji => by simp [g1, hji])
  have s2 : sumI n h = sumI n g1 + (h (i - 1) - g1 (i - 1)) :=
    sumI_change n g1 h (i - 1) (by omega) (fun j hj hji => by
      by_cases hj' : j = i
      · subst hj'; simp [g1]
      · simp only [g1, hj', if_false]; exact e j hj hji hj')
  have : g1 i = h i := by simp [g1]
  have : g1 (i - 1) = g (i - 1) := by simp [g1]; omega
  omega

/-- rotation by one place -/
theorem sumI_rot1 (n : Nat) (g : Nat → Int) (hn : 1 ≤ n) :
    sumI n (fun j => if j + 1 < n then g (j + 1) else g 0) = sumI n g := by
  obtain ⟨n, rfl⟩ : ∃ k, n = k + 1 := ⟨n - 1, by omega⟩
  rw [sumI_succ' n g]
  simp only [sumI]
  rw [sumI_congr n _ (fun j => g (j + 1)) (fun j hj => by simp; omega)]
  simp; omega

theorem sumI_reflect (n : Nat) (h : Nat → Int) : sumI n (fun j => h (n - 1 - j)) = sumI n h := by
  induction n generalizing h with
  | zero => rfl
  | succ n ih =>
    rw [sumI_succ']
    have := ih h
    simp only [sumI]
    rw [sumI_congr n (fun j => h (n + 1 - 1 - (j + 1))) (fun j => h (n - 1 - j)) (fun j hj => by
      dsimp only; congr 1; omega)]
    simp only [Nat.add_sub_cancel, Nat.sub_zero]; omega

/-- reflection fixing 0 -/
theorem sumI_reflect0 (n : Nat) (g : Nat → Int) :
    sumI n (fun j => if j = 0 then g 0 else g (n - j)) = sumI n g := by
  cases n with
  | zero => rfl
  | succ n =>
    rw [sumI_succ', sumI_succ' n g]
    simp only [if_true]
    rw [sumI_congr n _ (fun j => (fun k => g (k + 1)) (n - 1 - j)) (fun j hj => by
      simp only [Nat.add_one_ne_zero, if_false]; congr 1; omega)]
    rw [sumI_reflect n (fun k => g (k + 1))]

theorem lowI_le (n : Nat) (g : Nat → Int) : ∀ j, j ≤ n → lowI n g ≤ g j := by
  induction n with
  | zero => intro j hj; have : j = 0 := by omega
            subst this; simp [lowI]
  | succ n ih =>
    intro j hj
    simp only [lowI]
    by_cases h : j = n + 1
    · subst h; omega
    · have := ih j (by omega); omega

theorem lowI_attained (n : Nat) (g : Nat → Int) : ∃ j, j ≤ n ∧ g j = lowI n g := by
  induction n with
  | zero => exact ⟨0, by omega, rfl⟩
  | succ n ih =>
    obtain ⟨j, hj, e⟩ := ih
    simp only [lowI]
    by_cases h : lowI n g ≤ g (n + 1)
    · exact ⟨j, by omega, by omega⟩
    · exact ⟨n + 1, by omega, by omega⟩

theorem lowI_eq (n : Nat) (g : Nat → Int) (c : Int) (h1 : ∀ j, j ≤ n → c ≤ g j)
    (h2 : ∃ j, j ≤ n ∧ g j = c) : lowI n g = c := by
  obtain ⟨j, hj, e⟩ := h2
  obtain ⟨k, hk, e'⟩ := lowI_attained n g
  have := lowI_le n g j hj
  have := h1 k hk
  omega

theorem lowI_same_values (n : Nat) (g h : Nat → Int)
    (hgh : ∀ j, j ≤ n → ∃ k, k ≤ n ∧ g j = h k) (hhg : ∀ j, j ≤ n → ∃ k, k ≤ n ∧ h j = g k) :
    lowI n g = lowI n h := by
  apply lowI_eq
  · intro j hj
    obtain ⟨k, hk, e⟩ := hgh j hj
    rw [e]; exact lowI_le n h k hk
  · obtain ⟨j, hj, e⟩ := lowI_attained n h
    obtain ⟨k, hk, e'⟩ := hhg j hj
    exact ⟨k, hk, by omega⟩

/-- the potential: sum of heights above the lowest one (over indices `0 .. n-1`) -/
def psiOf (n : Nat) (g : Nat → Int) : Nat := (sumI n g - n * lowI (n - 1) g).toNat

theorem psiOf_congr (n : Nat) (g h : Nat → Int) (e : ∀ j, j < n → g j = h j) :
    psiOf n g = psiOf n h := by
  unfold psiOf
  rw [sumI_congr n g h e]
  cases n with
  | zero => simp
  | succ n =>
    simp only [Nat.add_sub_cancel]
    rw [lowI_same_values n g h (fun j hj => ⟨j, hj, e j (by omega)⟩)
      (fun j hj => ⟨j, hj, (e j (by omega)).symm⟩)]

theorem psiOf_translate (n : Nat) (g : Nat → Int) (c : Int) :
    psiOf n (fun j => g j + c) = psiOf n g := by
  unfold psiOf
  rw [sumI_add, sumI_const]
  cases n with
  | zero => simp [sumI]
  | succ n =>
    have : lowI (n + 1 - 1) (fun j => g j + c) = lowI (n + 1 - 1) g + c := by
      apply lowI_eq
      · intro j hj; have := lowI_le _ g j hj; omega
      · obtain ⟨j, hj, e⟩ := lowI_attained (n + 1 - 1) g
        exact ⟨j, hj, by omega⟩
    rw [this, Int.mul_add]
    congr 1; omega

theorem psiOf_rot1 (n : Nat) (g : Nat → Int) (hn : 1 ≤ n) :
    psiOf n (fun j => if j + 1 < n then g (j + 1) else g 0) = psiOf n g := by
  unfold psiOf
  rw [sumI_rot1 n g hn]
  congr 3
  apply lowI_same_values
  · intro j hj
    by_cases h : j + 1 < n
    · exact ⟨j + 1, by omega, by simp [h]⟩
    · exact ⟨0, by omega, by simp [h]⟩
  · intro j hj
    by_cases h : j = 0
    · subst h; exact ⟨n - 1, by omega, by simp; omega⟩
    · refine ⟨j - 1, by omega, ?_⟩
      have : j - 1 + 1 < n := by omega
      simp only [this, if_true]; congr 1; omega

theorem psiOf_reflect0 (n : Nat) (g : Nat → Int) :
    psiOf n (fun j => if j = 0 then g 0 else g (n - j)) = psiOf n g := by
  unfold psiOf
  rw [sumI_reflect0 n g]
  congr 3
  apply lowI_same_values
  · intro j hj
    by_cases h : j = 0
    · exact ⟨0, by omega, by simp [h]⟩
    · exact ⟨n - j, by omega, by simp [h]⟩
  · intro j hj
    by_cases h : j = 0
    · exact ⟨0, by omega, by simp [h]⟩
    · exact ⟨n - j, by omega, by rw [if_neg (by omega)]; congr 1; omega⟩

theorem psiOf_swap (n : Nat) (g h : Nat → Int) (i : Nat) (hi1 : 1 ≤ i) (hi : i < n)
    (e : ∀ j, j < n → j ≠ i - 1 → j ≠ i → h j = g j) (e1 : h (i - 1) = g i) (e2 : h i = g (i - 1)) :
    psiOf n h = psiOf n g := by
  unfold psiOf
  rw [sumI_swap n g h i hi1 hi e e1 e2]
  congr 3
  apply lowI_same_values
  · intro j hj
    by_cases a : j = i - 1
    · exact ⟨i, by omega, by rw [a, e1]⟩
    · by_cases b : j = i
      · exact ⟨i - 1, by omega, by rw [b, e2]⟩
      · exact ⟨j, hj, e j (by omega) a b⟩
  · intro j hj
    by_cases a : j = i - 1
    · exact ⟨i, by omega, by rw [a, e2]⟩
    · by_cases b : j = i
      · exact ⟨i - 1, by omega, by rw [b, e1]⟩
      · exact ⟨j, hj, (e j (by omega) a b).symm⟩

theorem sumI_mono (n : Nat) (g h : Nat → Int) (e : ∀ j, j < n → g j ≤ h j) :
    sumI n g ≤ sumI n h := by
  induction n with
  | zero => simp [sumI]
  | succ n ih =>
    simp only [sumI]
    have := ih (fun j hj => e j (by omega)); have := e n (by omega); omega

theorem sumI_ge (n : Nat) (g : Nat → Int) (L : Int) (hL : ∀ j, j < n → L ≤ g j) (i : Nat) (hi : i < n) :
    n * L + (g i - L) ≤ sumI n g := by
  have h1 := sumI_change n (fun _ => L) (fun j => if j = i then g i else L) i hi
    (fun j _ hji => by simp [hji])
  rw [sumI_const] at h1
  simp only [if_true] at h1
  have h2 := sumI_mono n (fun j => if j = i then g i else L) g (fun j hj => by
    by_cases hji : j = i
    · subst hji; simp
    · simp only [hji, if_false]; exact hL j hj)
  omega

/-- lowering one value by one, to a value already attained elsewhere, lowers the potential by one -/
theorem psiOf_drop (n : Nat) (g h : Nat → Int) (i k : Nat) (hi : i < n) (hk : k < n) (hki : k ≠ i)
    (e : ∀ j, j < n → j ≠ i → h j = g j) (ei : h i = g i - 1) (ek : h i = g k) :
    psiOf n h + 1 = psiOf n g := by
  unfold psiOf
  rw [sumI_change n g h i hi e]
  have hl : lowI (n - 1) h = lowI (n - 1) g := by
    apply lowI_eq
    · intro j hj
      by_cases hji : j = i
      · subst hji; rw [ei]
        have := lowI_le (n - 1) g k (by omega); omega
      · rw [e j (by omega) hji]; exact lowI_le _ g j hj
    · obtain ⟨j, hj, ej⟩ := lowI_attained (n - 1) g
      by_cases hji : j = i
      · subst hji
        have := lowI_le (n - 1) g k (by omega); omega
      · exact ⟨j, hj, by rw [e j (by omega) hji]; exact ej⟩
  rw [hl]
  have := lowI_le (n - 1) g k (by omega)
  have := sumI_ge n g (lowI (n - 1) g) (fun j hj => lowI_le _ g j (by omega)) i hi
  omega

end Len52
