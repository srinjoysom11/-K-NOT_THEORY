import Len52.NF.Canon

set_option linter.unusedSimpArgs false

namespace Len52

theorem closed_of_poly (w : List Nat) (h : IsPolygon w) : Closed w := h.2.2.1

/-! ## curtains -/

/-- a curtain starting at letter 0 can be swept away by k-1 flips and one U-turn removal -/
theorem curtain0 (T : List Nat → Prop) (hT : KnotClass T) : ∀ k w, T w → 6 ≤ w.length → 1 ≤ k →
    k + 2 ≤ w.length →
    (∀ t, 1 ≤ t → t ≤ k → axis (dir w t) ≠ axis (dir w 0)) → dir w (k + 1) = rev (dir w 0) →
    (∀ j, 2 ≤ j → j ≤ k → vtx w j - unit (dir w 0) ∉ vset w) →
    ∃ w', T w' ∧ w'.length + 2 = w.length := by
  intro k
  induction k with
  | zero => intro w _ _ h; omega
  | succ k ih =>
    intro w hw h6 _ hk hax hlast hfree
    by_cases k0 : k = 0
    · subst k0
      refine ⟨removeUturn w 0, hT.uturn w 0 hw h6 (by omega) ?_ hlast, length_removeUturn w 0 (by omega)⟩
      exact hax 1 (by omega) (by omega)
    have hp := hT.polygon w hw
    have hc := closed_of_poly w hp
    have hnd := (nodup_vset w).1 hp.2.2.2
    -- the flip at vertex 1
    have hq : vtx w (1 - 1) + unit (dir w 1) = vtx w 2 - unit (dir w 0) := by
      rw [vtx_succ w 1 (by omega), vtx_one w (by omega)]; simp; len52_v3_ext
    have hw1 : T (swapAt w 1) := by
      apply hT.flip w 1 hw (Nat.le_refl _) (by omega)
      · exact fun e => hax 1 (by omega) (by omega) e.symm
      · rw [hq]; exact hfree 2 (by omega) (by omega)
    let w1 := swapAt w 1
    have hl1 : w1.length = w.length := length_swapAt w 1
    have hc1 : Closed w1 := closed_swapAt w 1 (Nat.le_refl _) (by omega) hc
    have dir1 : ∀ j, 2 ≤ j → j < w.length → dir w1 j = dir w j := by
      intro j hj1 hj
      rw [dir_swapAt w 1 (Nat.le_refl _) (by omega) j hj, if_neg (by omega), if_neg (by omega)]
    have dir11 : dir w1 1 = dir w 0 := by
      rw [dir_swapAt w 1 (Nat.le_refl _) (by omega) 1 (by omega), if_neg (by omega), if_pos rfl]
    have vtx1 : ∀ j, j ≤ w.length → j ≠ 1 → vtx w1 j = vtx w j := by
      intro j hj hj1
      rw [vtx_swapAt w 1 (Nat.le_refl _) (by omega) j hj, if_neg hj1]
    have vtx11 : vtx w1 1 = vtx w 2 - unit (dir w 0) := by
      rw [vtx_swapAt w 1 (Nat.le_refl _) (by omega) 1 (by omega), if_pos rfl, hq]
    -- then rotate by one
    let w2 := rotate1 w1
    have hw2 : T w2 := hT.rot _ hw1
    have hl2 : w2.length = w.length := by simp [w2, w1]
    have dir2 : ∀ j, j + 1 < w.length → dir w2 j = dir w1 (j + 1) := by
      intro j hj
      rw [dir_rotate1 w1 j (by omega), if_pos (by omega)]
    have d20 : dir w2 0 = dir w 0 := by rw [dir2 0 (by omega), dir11]
    obtain ⟨w', hw', hl'⟩ := ih w2 hw2 (by omega) (by omega) (by omega)
      (fun t ht1 htk => by
        rw [dir2 t (by omega), dir1 (t + 1) (by omega) (by omega), d20]
        exact hax (t + 1) (by omega) (by omega))
      (by rw [dir2 (k + 1) (by omega), dir1 (k + 2) (by omega) (by omega), d20]; exact hlast)
      (fun j hj2 hjk hmem => by
        rw [d20] at hmem
        rw [mem_vset_rotate1 w1 (by omega) hc1, vtx_rotate1 w1 (by omega) j (by omega),
          vtx1 (j + 1) (by omega) (by omega)] at hmem
        have e : vtx w (j + 1) - vtx w1 1 - unit (dir w 0) + vtx w1 1 = vtx w (j + 1) - unit (dir w 0) := by
          len52_v3_ext
        rw [e, mem_vset] at hmem
        obtain ⟨s, hs, es⟩ := hmem
        by_cases s1 : s = 1
        · subst s1
          rw [vtx11] at es
          have : vtx w 2 = vtx w (j + 1) := by
            have := (V3.eq_iff _ _).1 es
            simp only [V3.sub_x, V3.sub_y, V3.sub_z] at this
            len52_v3_ext
          have := hnd 2 (j + 1) (by omega) (by omega) this
          omega
        · rw [vtx1 s (by omega) s1] at es
          exact hfree (j + 1) (by omega) (by omega) (by rw [← es]; exact vtx_mem_vset w s (by omega)))
    exact ⟨w', hw', by omega⟩

theorem curtainOK_of_min (T : List Nat → Prop) (hT : KnotClass T) (w : List Nat) (hw : T w)
    (h6 : 6 ≤ w.length) (hmin : ∀ y, T y → w.length ≤ y.length) : CurtainOK w := by
  intro i k hi hk1 hk hax hlast
  apply Classical.byContradiction
  intro hno
  have hp := hT.polygon w hw
  have hc := closed_of_poly w hp
  have hTr : ∀ s, T (rotN s w) := by
    intro s; induction s with
    | zero => exact hw
    | succ s ih => exact hT.rot _ ih
  let u := rotN i w
  have hlu : u.length = w.length := length_rotN i w
  have du : ∀ t, t < w.length → dir u t = dir w ((i + t) % w.length) := by
    intro t ht; rw [dir_rotN i w t ht, Nat.add_comm]
  have du0 : dir u 0 = dir w i := by rw [du 0 (by omega), Nat.add_zero, Nat.mod_eq_of_lt hi]
  obtain ⟨w', hw', hl'⟩ := curtain0 T hT k u (hTr i) (by omega) hk1 (by omega)
    (fun t ht1 htk => by rw [du t (by omega), du0]; exact hax t ht1 htk)
    (by rw [du (k + 1) (by omega), du0, ← Nat.add_assoc]; exact hlast)
    (fun j hj2 hjk hmem => by
      rw [du0, mem_vset_rotN i w (by omega) hc, vtx_rotN i w (by omega) hc j (by omega),
        Nat.mod_eq_of_lt hi] at hmem
      have e : vtx w ((j + i) % w.length) - vtx w i - unit (dir w i) + vtx w i =
          vtx w ((i + j) % w.length) - unit (dir w i) := by
        rw [Nat.add_comm j i]; len52_v3_ext
      rw [e] at hmem
      exact hno ⟨j, hj2, hjk, hmem⟩)
  have := hmin w' hw'
  omega

/-! ## corners -/

theorem vtx_next_sub (w : List Nat) (i : Nat) (hi1 : 1 ≤ i) (hi : i < w.length) :
    vtx w (i + 1) - unit (dir w (i - 1)) = vtx w (i - 1) + unit (dir w i) := by
  rw [vtx_succ w i hi]
  have := vtx_succ w (i - 1) (by omega)
  rw [show i - 1 + 1 = i by omega] at this
  rw [this]; len52_v3_ext

theorem unit_z_lt4 (d : Nat) (h : d < 4) : (unit d).z = 0 := by
  rw [unit_z]; rw [if_neg (by omega), if_neg (by omega)]

theorem unit_y_lt2 (d : Nat) (h : d < 2) : (unit d).y = 0 := by
  rw [unit_y]; rw [if_neg (by omega), if_neg (by omega)]

theorem axis_lt4 (d : Nat) (h : d < 4) : axis d ≠ 2 := by unfold axis; omega
theorem axis_lt2 (d : Nat) (h : d < 2) : axis d = 0 := by unfold axis; omega

/-- the corner conditions for a word that minimises the two potentials -/
theorem cornerOK_of_min (T : List Nat → Prop) (hT : KnotClass T) (w : List Nat) (hw : T w)
    (hord : countAxis 2 w ≤ countAxis 1 w ∧ countAxis 1 w ≤ countAxis 0 w)
    (hminz : ∀ y, T y → y.length = w.length →
      (countAxis 2 y ≤ countAxis 1 y ∧ countAxis 1 y ≤ countAxis 0 y) →
      psiW (fun v => v.z) w ≤ psiW (fun v => v.z) y)
    (hminy : ∀ y, T y → y.length = w.length →
      (countAxis 2 y ≤ countAxis 1 y ∧ countAxis 1 y ≤ countAxis 0 y) →
      psiW (fun v => v.z) y = psiW (fun v => v.z) w →
      psiW (fun v => v.y) w ≤ psiW (fun v => v.y) y) : CornerOK w := by
  have hp := hT.polygon w hw
  have hc := closed_of_poly w hp
  have hn : 4 ≤ w.length := hp.1
  intro i hi1 hi
  -- facts about the flipped word
  have flipT : axis (dir w (i - 1)) ≠ axis (dir w i) → vtx w (i - 1) + unit (dir w i) ∉ vset w →
      T (swapAt w i) := fun hax hq => hT.flip w i hw hi1 hi hax hq
  have hlen : (swapAt w i).length = w.length := length_swapAt w i
  have hord' : countAxis 2 (swapAt w i) ≤ countAxis 1 (swapAt w i) ∧
      countAxis 1 (swapAt w i) ≤ countAxis 0 (swapAt w i) := by
    rw [countAxis_swapAt _ w i hi1 hi, countAxis_swapAt _ w i hi1 hi, countAxis_swapAt _ w i hi1 hi]
    exact hord
  have vi : vtx w i = vtx w (i - 1) + unit (dir w (i - 1)) := by
    have := vtx_succ w (i - 1) (by omega)
    rw [show i - 1 + 1 = i by omega] at this; exact this
  -- the cyclic successor of i
  obtain ⟨k, hk, hki, ek⟩ : ∃ k, k < w.length ∧ k ≠ i ∧ vtx w k = vtx w (i + 1) := by
    by_cases h : i + 1 < w.length
    · exact ⟨i + 1, h, by omega, rfl⟩
    · refine ⟨0, by omega, by omega, ?_⟩
      rw [show i + 1 = w.length by omega, hc, vtx_zero]
  have vnext : vtx w (i + 1) = vtx w i + unit (dir w i) := vtx_succ w i hi
  have viz : (vtx w i).z = (vtx w (i - 1)).z + (unit (dir w (i - 1))).z := by rw [vi]; rfl
  have viy : (vtx w i).y = (vtx w (i - 1)).y + (unit (dir w (i - 1))).y := by rw [vi]; rfl
  have vnz : (vtx w (i + 1)).z = (vtx w i).z + (unit (dir w i)).z := by rw [vnext]; rfl
  have vny : (vtx w (i + 1)).y = (vtx w i).y + (unit (dir w i)).y := by rw [vnext]; rfl
  have ekz : (vtx w k).z = (vtx w (i + 1)).z := by rw [ek]
  have eky : (vtx w k).y = (vtx w (i + 1)).y := by rw [ek]
  have qz : (vtx w (i - 1) + unit (dir w i)).z = (vtx w (i - 1)).z + (unit (dir w i)).z := rfl
  have qy : (vtx w (i - 1) + unit (dir w i)).y = (vtx w (i - 1)).y + (unit (dir w i)).y := rfl
  refine ⟨?_, ?_, ?_, ?_⟩
  · -- (u, h)
    intro hp4 hd4
    apply Classical.byContradiction
    intro hq
    have hT' := flipT (by rw [hp4]; exact fun e => axis_lt4 _ hd4 (by rw [← e]; rfl)) hq
    have u1 : (unit (dir w (i - 1))).z = 1 := by rw [hp4]; rfl
    have u2 := unit_z_lt4 _ hd4
    have hdrop := psiW_swapAt_drop (fun v => v.z) w i (i - 1) hi1 hi (by omega) (by omega)
      (by show (vtx w (i - 1) + unit (dir w i)).z = (vtx w i).z - 1; omega)
      (by show (vtx w (i - 1) + unit (dir w i)).z = (vtx w (i - 1)).z; omega)
    have := hminz _ hT' hlen hord'
    omega
  · -- (h, d)
    intro hd5 hp4
    rw [vtx_next_sub w i hi1 hi]
    apply Classical.byContradiction
    intro hq
    have hT' := flipT (by rw [hd5]; exact fun e => axis_lt4 _ hp4 (by rw [e]; rfl)) hq
    have u1 : (unit (dir w i)).z = -1 := by rw [hd5]; rfl
    have u2 := unit_z_lt4 _ hp4
    have hdrop := psiW_swapAt_drop (fun v => v.z) w i k hi1 hi hk hki
      (by show (vtx w (i - 1) + unit (dir w i)).z = (vtx w i).z - 1; omega)
      (by show (vtx w (i - 1) + unit (dir w i)).z = (vtx w k).z; omega)
    have := hminz _ hT' hlen hord'
    omega
  · -- (n, x)
    intro hp2 hd2
    apply Classical.byContradiction
    intro hq
    have hT' := flipT (by rw [hp2, axis_lt2 _ hd2]; decide) hq
    have u1 : (unit (dir w (i - 1))).z = 0 := by rw [hp2]; rfl
    have u2 : (unit (dir w (i - 1))).y = 1 := by rw [hp2]; rfl
    have u3 := unit_z_lt4 _ (show dir w i < 4 by omega)
    have u4 := unit_y_lt2 _ hd2
    have hz := psiW_swapAt_same (fun v => v.z) w i hi1 hi
      (by show (vtx w (i - 1) + unit (dir w i)).z = (vtx w i).z; omega)
    have hdrop := psiW_swapAt_drop (fun v => v.y) w i (i - 1) hi1 hi (by omega) (by omega)
      (by show (vtx w (i - 1) + unit (dir w i)).y = (vtx w i).y - 1; omega)
      (by show (vtx w (i - 1) + unit (dir w i)).y = (vtx w (i - 1)).y; omega)
    have := hminy _ hT' hlen hord' hz
    omega
  · -- (x, s)
    intro hd3 hp2
    rw [vtx_next_sub w i hi1 hi]
    apply Classical.byContradiction
    intro hq
    have hT' := flipT (by rw [hd3, axis_lt2 _ hp2]; decide) hq
    have u1 : (unit (dir w i)).z = 0 := by rw [hd3]; rfl
    have u2 : (unit (dir w i)).y = -1 := by rw [hd3]; rfl
    have u3 := unit_z_lt4 _ (show dir w (i - 1) < 4 by omega)
    have u4 := unit_y_lt2 _ hp2
    have hz := psiW_swapAt_same (fun v => v.z) w i hi1 hi
      (by show (vtx w (i - 1) + unit (dir w i)).z = (vtx w i).z; omega)
    have hdrop := psiW_swapAt_drop (fun v => v.y) w i k hi1 hi hk hki
      (by show (vtx w (i - 1) + unit (dir w i)).y = (vtx w i).y - 1; omega)
      (by show (vtx w (i - 1) + unit (dir w i)).y = (vtx w k).y; omega)
    have := hminy _ hT' hlen hord' hz
    omega

end Len52
