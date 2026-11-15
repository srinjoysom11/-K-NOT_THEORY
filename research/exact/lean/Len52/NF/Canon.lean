import Len52.NF.Potential

set_option linter.unusedSimpArgs false

namespace Len52

/-! ## parity -/

theorem unit_sum (d : Nat) (hd : d < 6) :
    (unit d).x + (unit d).y + (unit d).z = 1 ∨ (unit d).x + (unit d).y + (unit d).z = -1 := by
  match d, hd with
  | 0, _ => decide
  | 1, _ => decide
  | 2, _ => decide
  | 3, _ => decide
  | 4, _ => decide
  | 5, _ => decide

theorem isPolygon_length_even' (w : List Nat) (h : IsPolygon w) : w.length % 2 = 0 := by
  obtain ⟨_, h6, hc, _⟩ := h
  have key : ∀ j, j ≤ w.length → ((vtx w j).x + (vtx w j).y + (vtx w j).z + j) % 2 = 0 := by
    intro j
    induction j with
    | zero => intro _; simp
    | succ j ih =>
      intro hj
      have := ih (by omega)
      rw [vtx_succ w j (by omega)]
      have := unit_sum (dir w j) (dir_lt w h6 j (by omega))
      simp only [V3.add_x, V3.add_y, V3.add_z]
      omega
  have := key w.length (Nat.le_refl _)
  rw [hc] at this
  simp at this
  omega

/-! ## minimisation -/

theorem exists_min {α : Type} (P : α → Prop) (f : α → Nat) (x0 : α) (h0 : P x0) :
    ∃ x, P x ∧ ∀ y, P y → f x ≤ f y := by
  suffices H : ∀ n, ∀ x, P x → f x ≤ n → ∃ x, P x ∧ ∀ y, P y → f x ≤ f y from
    H _ x0 h0 (Nat.le_refl _)
  intro n
  induction n with
  | zero => intro x hx h; exact ⟨x, hx, fun y _ => by omega⟩
  | succ n ih =>
    intro x hx h
    by_cases c : ∃ y, P y ∧ f y < f x
    · obtain ⟨y, hy, hlt⟩ := c
      exact ih y hy (by omega)
    · refine ⟨x, hx, fun y hy => ?_⟩
      apply Classical.byContradiction
      intro hn
      exact c ⟨y, hy, by omega⟩

/-! ## the lowest vertex -/

theorem lexPos_trans (a b c : V3) (h1 : LexPos (a - b)) (h2 : LexPos (b - c)) : LexPos (a - c) := by
  unfold LexPos at *; simp only [V3.sub_x, V3.sub_y, V3.sub_z] at *; omega

theorem lexPos_trichotomy (a b : V3) : a = b ∨ LexPos (a - b) ∨ LexPos (b - a) := by
  rw [V3.eq_iff]; unfold LexPos; simp only [V3.sub_x, V3.sub_y, V3.sub_z]; omega

theorem exists_lowest (g : Nat → V3) (n : Nat) (hn : 1 ≤ n) :
    ∃ t, t < n ∧ ∀ s, s < n → g s = g t ∨ LexPos (g s - g t) := by
  induction n with
  | zero => omega
  | succ n ih =>
    by_cases h0 : n = 0
    · subst h0; exact ⟨0, by omega, fun s hs => Or.inl (by rw [show s = 0 by omega])⟩
    obtain ⟨t, ht, hmin⟩ := ih (by omega)
    rcases lexPos_trichotomy (g n) (g t) with c | c | c
    · exact ⟨t, by omega, fun s hs => by
        by_cases e : s = n
        · subst e; exact Or.inl c
        · exact hmin s (by omega)⟩
    · exact ⟨t, by omega, fun s hs => by
        by_cases e : s = n
        · subst e; exact Or.inr c
        · exact hmin s (by omega)⟩
    · refine ⟨n, by omega, fun s hs => ?_⟩
      by_cases e : s = n
      · subst e; exact Or.inl rfl
      · rcases hmin s (by omega) with d | d
        · rw [d]; exact Or.inr c
        · exact Or.inr (lexPos_trans _ _ _ d c)

theorem mod_ne_self (n j t : Nat) (hj1 : 1 ≤ j) (hj : j < n) (ht : t < n) : (j + t) % n ≠ t := by
  by_cases h : j + t < n
  · rw [Nat.mod_eq_of_lt h]; omega
  · rw [Nat.mod_eq_sub_mod (by omega), Nat.mod_eq_of_lt (by omega)]; omega

theorem mod_lt' (a n : Nat) (hn : 1 ≤ n) : a % n < n := Nat.mod_lt _ (by omega)

/-- canonical position: the first vertex is the lowest and the orientation is fixed -/
theorem canonical (G : List Nat → Prop) (hpoly : ∀ w, G w → IsPolygon w)
    (hrot : ∀ w, G w → G (rotate1 w)) (hrev : ∀ w, G w → G (revWord w)) (w : List Nat)
    (hw : G w) :
    ∃ w', G w' ∧ (∀ i, 1 ≤ i → i < w'.length → LexPos (vtx w' i)) ∧
      dir w' 0 < rev (dir w' (w'.length - 1)) := by
  have hp := hpoly w hw
  obtain ⟨hn4, h6, hc, hnd⟩ := hp
  rw [nodup_vset] at hnd
  obtain ⟨t, ht, hlow⟩ := exists_lowest (vtx w) w.length (by omega)
  have hGt : ∀ s, G (rotN s w) := by
    intro s; induction s with
    | zero => exact hw
    | succ s ih => exact hrot _ ih
  let u := rotN t w
  have hGu : G u := hGt t
  have hlu : u.length = w.length := length_rotN t w
  have hlex : ∀ i, 1 ≤ i → i < u.length → LexPos (vtx u i) := by
    intro i hi1 hi
    rw [hlu] at hi
    rw [vtx_rotN t w (by omega) hc i hi, Nat.mod_eq_of_lt ht]
    have hne := mod_ne_self w.length i t hi1 hi ht
    rcases hlow ((i + t) % w.length) (mod_lt' _ _ (by omega)) with e | e
    · exact absurd (hnd _ _ (mod_lt' _ _ (by omega)) ht e) hne
    · exact e
  by_cases hor : dir u 0 < rev (dir u (u.length - 1))
  · exact ⟨u, hGu, hlex, hor⟩
  · refine ⟨revWord u, hrev u hGu, ?_, ?_⟩
    · obtain ⟨_, h6u, hcu, _⟩ := hpoly u hGu
      intro i hi1 hi
      rw [length_revWord] at hi
      rw [vtx_revWord_closed u h6u hcu i (by omega)]
      exact hlex _ (by omega) (by omega)
    · obtain ⟨hn4u, h6u, hcu, hndu⟩ := hpoly u hGu
      rw [nodup_vset] at hndu
      rw [length_revWord, dir_revWord u 0 (by omega), dir_revWord u _ (by omega),
        show u.length - 1 - (u.length - 1) = 0 by omega, rev_rev, Nat.sub_zero]
      have hne : dir u 0 ≠ rev (dir u (u.length - 1)) := by
        intro e
        have v1 := vtx_one u (by omega)
        have vn := vtx_succ u (u.length - 1) (by omega)
        rw [show u.length - 1 + 1 = u.length by omega, hcu] at vn
        have hd := dir_lt u h6u (u.length - 1) (by omega)
        have : vtx u 1 = vtx u (u.length - 1) := by
          rw [v1, e, unit_rev _ hd]
          have := (V3.eq_iff _ _).1 vn
          simp only [V3.zero_x, V3.zero_y, V3.zero_z, V3.add_x, V3.add_y, V3.add_z] at this
          apply V3.ext' <;> simp <;> omega
        have := hndu 1 (u.length - 1) (by omega) (by omega) this
        omega
      have := (show ∀ a b : Nat, ¬ a < b → a ≠ b → b < a by intros; omega) _ _ hor hne
      exact this

/-! ## sorting the axes by a symmetry -/

/-- the symmetry sending axis 0, 1, 2 to axis s0, s1, s2 (directions keep their sign) -/
def axf (s0 s1 s2 : Nat) (d : Nat) : Nat :=
  if d < 2 then 2 * s0 + d % 2 else if d < 4 then 2 * s1 + d % 2 else if d < 6 then 2 * s2 + d % 2
  else d

theorem isSym_of (f : Nat → Nat) (h1 : ∀ d, d < 6 → f d < 6)
    (h2 : ∀ a, a < 6 → ∀ b, b < 6 → f a = f b → a = b) (h3 : ∀ d, d < 6 → f (rev d) = rev (f d)) :
    IsSym f := ⟨h1, fun a b ha hb => h2 a ha b hb, h3⟩

theorem countAxis_map (f : Nat → Nat) (A B : Nat) (h : ∀ d, d < 6 → (axis (f d) = B ↔ axis d = A))
    (w : List Nat) (hw : ∀ d ∈ w, d < 6) : countAxis B (w.map f) = countAxis A w := by
  induction w with
  | nil => rfl
  | cons d ds ih =>
    have hd := h d (hw d (by simp))
    have ih' := ih (fun d hd => hw d (by simp [hd]))
    simp only [countAxis, List.map_cons, List.filter_cons] at ih' ⊢
    by_cases c : axis d = A
    · have c' : axis (f d) = B := hd.2 c
      simp [c, c', ih']
    · have c' : ¬ axis (f d) = B := fun e => c (hd.1 e)
      simp [c, c', ih']

theorem sort_axes (T : List Nat → Prop) (hT : KnotClass T) (w : List Nat) (hw : T w) :
    ∃ w', T w' ∧ w'.length = w.length ∧
      countAxis 2 w' ≤ countAxis 1 w' ∧ countAxis 1 w' ≤ countAxis 0 w' := by
  have h6 := (hT.polygon w hw).2.1
  have go : ∀ s0 s1 s2 : Nat, IsSym (axf s0 s1 s2) →
      (∀ d, d < 6 → (axis (axf s0 s1 s2 d) = s0 ↔ axis d = 0)) →
      (∀ d, d < 6 → (axis (axf s0 s1 s2 d) = s1 ↔ axis d = 1)) →
      (∀ d, d < 6 → (axis (axf s0 s1 s2 d) = s2 ↔ axis d = 2)) →
      T (w.map (axf s0 s1 s2)) ∧ (w.map (axf s0 s1 s2)).length = w.length ∧
      countAxis s0 (w.map (axf s0 s1 s2)) = countAxis 0 w ∧
      countAxis s1 (w.map (axf s0 s1 s2)) = countAxis 1 w ∧
      countAxis s2 (w.map (axf s0 s1 s2)) = countAxis 2 w := by
    intro s0 s1 s2 hs a0 a1 a2
    exact ⟨hT.sym _ _ hs hw, by simp, countAxis_map _ _ _ a0 w h6, countAxis_map _ _ _ a1 w h6,
      countAxis_map _ _ _ a2 w h6⟩
  by_cases o1 : countAxis 1 w ≤ countAxis 0 w <;> by_cases o2 : countAxis 2 w ≤ countAxis 1 w <;>
    by_cases o3 : countAxis 2 w ≤ countAxis 0 w
  · exact ⟨w, hw, rfl, o2, o1⟩
  · omega
  · obtain ⟨h1, h2, h3, h4, h5⟩ := go 0 2 1 (isSym_of _ (by decide) (by decide) (by decide)) (by decide) (by decide) (by decide)
    exact ⟨_, h1, h2, by omega, by omega⟩
  · obtain ⟨h1, h2, h3, h4, h5⟩ := go 1 2 0 (isSym_of _ (by decide) (by decide) (by decide)) (by decide) (by decide) (by decide)
    exact ⟨_, h1, h2, by omega, by omega⟩
  · obtain ⟨h1, h2, h3, h4, h5⟩ := go 1 0 2 (isSym_of _ (by decide) (by decide) (by decide)) (by decide) (by decide) (by decide)
    exact ⟨_, h1, h2, by omega, by omega⟩
  · obtain ⟨h1, h2, h3, h4, h5⟩ := go 2 0 1 (isSym_of _ (by decide) (by decide) (by decide)) (by decide) (by decide) (by decide)
    exact ⟨_, h1, h2, by omega, by omega⟩
  · omega
  · obtain ⟨h1, h2, h3, h4, h5⟩ := go 2 1 0 (isSym_of _ (by decide) (by decide) (by decide)) (by decide) (by decide) (by decide)
    exact ⟨_, h1, h2, by omega, by omega⟩

end Len52
