/-
  Len52.SP.Update — along a word with Survive, `update` never discards the prefix, and the
  obligations it returns satisfy invariant (I) (PROOF_RIGOROUS.md section 5).
-/
import Len52.SP.Obl

namespace Len52.SP
open Len52 Len52.Search

/-- the packed vertex v_m -/
def P (w : List Nat) (m : Nat) : Nat := pk (vtx w m)

/-- invariant (I) for one obligation: it contains a vertex v_m with k ≤ m < N -/
def Gd (w : List Nat) (k : Nat) (ob : Ob) : Prop := ∃ m, k ≤ m ∧ m < w.length ∧ P w m ∈ ob

/-- the occupancy array holds exactly v_0, ..., v_k (on the faithful range of the packing) -/
def OccOK (w : List Nat) (occ : Array Bool) (k : Nat) : Prop :=
  ∀ v, InB v → (occAt occ (pk v) = true ↔ ∃ t, t ≤ k ∧ vtx w t = v)

theorem vset_P {v : V3} (hv : v ∈ vset w) : ∃ m, m < w.length ∧ pk v = P w m := by
  obtain ⟨m, hm, rfl⟩ := mem_vset.1 hv
  exact ⟨m, hm, rfl⟩

section
variable {w : List Nat} (hS : Survive w) (hN : w.length ≤ 34)
include hS hN

theorem vtx_inB {m : Nat} (hm : m ≤ w.length) : InB (vtx w m) := (vtx_VB hS hN hm).inB

/-- a vertex is either occupied, or a later vertex that is free and allowed -/
theorem vsite {occ : Array Bool} {k : Nat} (hocc : OccOK w occ k) (hk : 1 ≤ k) {m : Nat}
    (hm : m < w.length) :
    occAt occ (P w m) = true ∨ (k + 1 ≤ m ∧ occAt occ (P w m) = false ∧ allowed (P w m) = true) := by
  by_cases hmk : m ≤ k
  · left; exact (hocc _ (vtx_inB hS hN (by omega))).2 ⟨m, hmk, rfl⟩
  · right
    refine ⟨by omega, ?_, allowed_vtx hS hN (by omega) hm⟩
    cases h : occAt occ (P w m) with
    | false => rfl
    | true =>
      obtain ⟨t, ht, he⟩ := (hocc _ (vtx_inB hS hN (by omega))).1 h
      rcases vtx_eq_idx hS (a := t) (b := m) (by omega) hm he with h' | h' <;> omega

/-- the walk visits all the single-site obligations: the span bound -/
theorem go_le (a : Nat) (ha : a ≤ w.length) : ∀ (pl : List Ob) (lx hx ly hy lz hz : Int),
    Att (fun t => (vtx w t).x) a w.length lx → Att (fun t => (vtx w t).x) a w.length hx →
    Att (fun t => (vtx w t).y) a w.length ly → Att (fun t => (vtx w t).y) a w.length hy →
    Att (fun t => (vtx w t).z) a w.length lz → Att (fun t => (vtx w t).z) a w.length hz →
    (∀ ob ∈ pl, ∀ s, ob = [s] → ∃ m, a ≤ m ∧ m ≤ w.length ∧ s = P w m) →
    spanNeed.go (P w a) pl lx hx ly hy lz hz ≤ w.length - a
  | [], lx, hx, ly, hy, lz, hz, h1, h2, h3, h4, h5, h6, _ => by
    rw [go_nil]
    have hia := vtx_inB hS hN ha
    have hc := S_close hS
    have e : a + (w.length - a) = w.length := by omega
    have sx := spanF_le (fun t => (vtx w t).x) a (w.length - a) (by simp only [e, hc]; rfl)
      (by rw [e]; exact h1) (by rw [e]; exact h2)
    have sy := spanF_le (fun t => (vtx w t).y) a (w.length - a) (by simp only [e, hc]; rfl)
      (by rw [e]; exact h3) (by rw [e]; exact h4)
    have sz := spanF_le (fun t => (vtx w t).z) a (w.length - a) (by simp only [e, hc]; rfl)
      (by rw [e]; exact h5) (by rw [e]; exact h6)
    have hsum := tv_sum (w := w) a (w.length - a) (by omega)
    unfold P
    rw [cx_pk hia, cy_pk hia, cz_pk hia]
    simp only at sx sy sz
    omega
  | ob :: rest, lx, hx, ly, hy, lz, hz, h1, h2, h3, h4, h5, h6, hp => by
    have hp' : ∀ ob ∈ rest, ∀ s, ob = [s] → ∃ m, a ≤ m ∧ m ≤ w.length ∧ s = P w m :=
      fun ob h => hp ob (List.mem_cons_of_mem _ h)
    match ob, hp with
    | [], _ => rw [spanNeed.go.eq_3 _ _ _ _ _ _ _ _ _ (by simp)]; exact go_le a ha rest _ _ _ _ _ _ h1 h2 h3 h4 h5 h6 hp'
    | s :: t :: u, _ =>
      rw [spanNeed.go.eq_3 _ _ _ _ _ _ _ _ _ (by simp)]; exact go_le a ha rest _ _ _ _ _ _ h1 h2 h3 h4 h5 h6 hp'
    | [s], hp =>
      rw [spanNeed.go.eq_2]
      obtain ⟨m, hm1, hm2, rfl⟩ := hp [s] List.mem_cons_self s rfl
      have him := vtx_inB hS hN hm2
      have ax : Att (fun t => (vtx w t).x) a w.length (cx (P w m)) := ⟨m, hm1, hm2, (cx_pk him).symm⟩
      have ay : Att (fun t => (vtx w t).y) a w.length (cy (P w m)) := ⟨m, hm1, hm2, (cy_pk him).symm⟩
      have az : Att (fun t => (vtx w t).z) a w.length (cz (P w m)) := ⟨m, hm1, hm2, (cz_pk him).symm⟩
      exact go_le a ha rest _ _ _ _ _ _ (h1.min ax) (h2.max ax) (h3.min ay) (h4.max ay) (h5.min az)
        (h6.max az) hp'

theorem spanNeed_le (a : Nat) (ha : a ≤ w.length) (pl : List Ob)
    (hp : ∀ ob ∈ pl, ∀ s, ob = [s] → ∃ m, a ≤ m ∧ m ≤ w.length ∧ s = P w m) :
    spanNeed (P w a) pl ≤ w.length - a := by
  have hc := S_close hS
  have z : ∀ (g : Nat → Int), g w.length = 0 → Att g a w.length 0 :=
    fun g hg => ⟨w.length, ha, Nat.le_refl _, hg⟩
  exact go_le hS hN a ha pl 0 0 0 0 0 0 (z _ (by simp [hc])) (z _ (by simp [hc])) (z _ (by simp [hc]))
    (z _ (by simp [hc])) (z _ (by simp [hc])) (z _ (by simp [hc])) hp

/-- the curtain started by the last letter on the axis of `dir w i` has a site that is a vertex -/
theorem curt_site {i j a : Nat} (hi1 : 1 ≤ i) (hiN : i + 1 ≤ w.length)
    (hsl : lastAx w i (axis (dir w i)) = some (j, a)) (ha : a = rev (dir w i)) :
    ∃ q ∈ List.take (i - j - 1 - 1) (List.drop 2 (rpos (P w) (i + 1))),
      ∃ m, m < w.length ∧ back q a = P w m := by
  have h6 := S_six hS
  obtain ⟨hj, ha', hax, hbt⟩ := lastAx_spec w i _ j a hsl
  have hji : j ≠ i - 1 := by
    intro hc
    apply S1 hS (m := i) hi1 (by omega)
    rw [← hc, ← ha', ha, rev_rev]
  have hC := hS.2.2.2.2.1 j (i - j - 1) (by omega) (by omega) (by omega)
    (fun t ht1 ht2 => by
      rw [Nat.mod_eq_of_lt (by omega), ← ha', hax]
      exact hbt (j + t) (by omega) (by omega))
    (by rw [show j + (i - j - 1) + 1 = i by omega, Nat.mod_eq_of_lt (by omega), ← ha', ha, rev_rev])
  obtain ⟨t, ht2, htk, hmem⟩ := hC
  rw [Nat.mod_eq_of_lt (by omega)] at hmem
  obtain ⟨m, hm, hpk⟩ := vset_P hmem
  refine ⟨P w (j + t), ?_, m, hm, ?_⟩
  · rw [rpos_drop _ _ 2 (by omega)]
    exact mem_rpos_take _ _ _ _ (by omega) (by omega)
  · unfold P
    rw [back_pk (vtx_inB hS hN (by omega)) (by rw [ha']; exact dir_lt h6 j), ← ha'] at *
    exact hpk

/-- the corner site, when there is one, is a vertex -/
theorem corner_site {i s : Nat} (hi1 : 1 ≤ i) (hiN : i + 1 ≤ w.length)
    (h : cornerSite (dir w (i - 1)) (dir w i) (P w (i - 1)) (P w (i + 1)) = some s) :
    ∃ m, m < w.length ∧ s = P w m := by
  have h6 := S_six hS
  obtain ⟨c1, c2, c3, c4⟩ := hS.2.2.2.2.2 i hi1 (by omega)
  have i1 := vtx_inB hS hN (m := i - 1) (by omega)
  have i2 := vtx_inB hS hN (m := i + 1) hiN
  unfold cornerSite at h
  split at h
  · rename_i hc
    simp only [Bool.and_eq_true, beq_iff_eq, decide_eq_true_eq] at hc
    obtain ⟨m, hm, hpk⟩ := vset_P (c1 hc.1 hc.2)
    refine ⟨m, hm, ?_⟩
    rw [← Option.some.inj h, ← hpk]; exact mv_pk i1 (dir_lt h6 i)
  · split at h
    · rename_i _ hc
      simp only [Bool.and_eq_true, beq_iff_eq, decide_eq_true_eq] at hc
      obtain ⟨m, hm, hpk⟩ := vset_P (c2 hc.1 hc.2)
      refine ⟨m, hm, ?_⟩
      rw [← Option.some.inj h, ← hpk]; exact back_pk i2 (dir_lt h6 _)
    · split at h
      · rename_i _ _ hc
        simp only [Bool.and_eq_true, beq_iff_eq, decide_eq_true_eq] at hc
        obtain ⟨m, hm, hpk⟩ := vset_P (c3 hc.1 hc.2)
        refine ⟨m, hm, ?_⟩
        rw [← Option.some.inj h, ← hpk]; exact mv_pk i1 (dir_lt h6 i)
      · split at h
        · rename_i _ _ _ hc
          simp only [Bool.and_eq_true, beq_iff_eq, decide_eq_true_eq] at hc
          obtain ⟨m, hm, hpk⟩ := vset_P (c4 hc.1 hc.2)
          refine ⟨m, hm, ?_⟩
          rw [← Option.some.inj h, ← hpk]; exact back_pk i2 (dir_lt h6 _)
        · exact absurd h (by simp)

/-- every obligation satisfying (I) passes `fine` -/
theorem fine_ok {i : Nat} (hi1 : 1 ≤ i) (hiN : i + 1 ≤ w.length) {occ : Array Bool}
    (hocc : OccOK w occ (i + 1)) {ob : Ob} (hob : Gd w (i + 2) ob) :
    fine occ (P w (i + 1)) (w.length - i - 1) ob = true := by
  have h6 := S_six hS
  obtain ⟨m, hm1, hm2, hm3⟩ := hob
  have im := vtx_inB hS hN (m := m) (by omega)
  have ii := vtx_inB hS hN (m := i + 1) hiN
  apply fine_of hm3
  · unfold P dist0
    rw [mdist_pk ii im, ORG_eq, mdist_pk im (by unfold InB; simp)]
    have d1 := vtx_dist' (w := w) (a := i + 1) (b := m) (by omega) (by omega)
    have d2 := vtx_dist' (w := w) (a := m) (b := w.length) (by omega) (Nat.le_refl _)
    rw [S_close hS] at d2
    simp only [V3.zero_x, V3.zero_y, V3.zero_z, Int.sub_zero, Int.zero_sub, Int.natAbs_neg] at d2 ⊢
    have hs : ∀ a b : Int, (a - b).natAbs = (b - a).natAbs := fun a b => by omega
    rw [hs (vtx w (i + 1)).x, hs (vtx w (i + 1)).y, hs (vtx w (i + 1)).z]
    generalize ((vtx w m).x - (vtx w (i + 1)).x).natAbs = A1 at *
    generalize ((vtx w m).y - (vtx w (i + 1)).y).natAbs = A2 at *
    generalize ((vtx w m).z - (vtx w (i + 1)).z).natAbs = A3 at *
    generalize (vtx w m).x.natAbs = B1 at *
    generalize (vtx w m).y.natAbs = B2 at *
    generalize (vtx w m).z.natAbs = B3 at *
    omega
  · have e1 := vtx_succ (w := w) (j := m - 1) (by omega)
    rw [show m - 1 + 1 = m by omega] at e1
    have e2 := vtx_succ (w := w) (j := m) (by omega)
    apply avail_two (d1 := rev (dir w (m - 1))) (d2 := dir w m) (rev_lt (dir_lt h6 _)) (dir_lt h6 _)
      (fun h => S1 hS (m := m) (by omega) (by omega) h.symm)
    · apply usable_one
      have : mv (P w m) (rev (dir w (m - 1))) = P w (m - 1) := by
        unfold P
        rw [mv_pk im (rev_lt (dir_lt h6 _)), unit_rev _ (dir_lt h6 _), e1, add_sub_unit]
      rw [this]
      by_cases hm' : m - 1 = i + 1
      · left; rw [hm']
      · right; right
        rcases vsite hS hN hocc (by omega) (m := m - 1) (by omega) with h | ⟨_, h1, h2⟩
        · exfalso
          obtain ⟨t, ht, he⟩ := (hocc _ (vtx_inB hS hN (m := m - 1) (by omega))).1 h
          rcases vtx_eq_idx hS (a := t) (b := m - 1) (by omega) (by omega) he with h' | h' <;> omega
        · exact ⟨h1, h2⟩
    · apply usable_one
      have : mv (P w m) (dir w m) = P w (m + 1) := by
        unfold P; rw [mv_pk im (dir_lt h6 _), e2]
      rw [this]
      by_cases hm' : m + 1 = w.length
      · right; left; rw [hm', ORG_eq]; unfold P; rw [S_close hS]
      · right; right
        rcases vsite hS hN hocc (by omega) (m := m + 1) (by omega) with h | ⟨_, h1, h2⟩
        · exfalso
          obtain ⟨t, ht, he⟩ := (hocc _ (vtx_inB hS hN (m := m + 1) (by omega))).1 h
          rcases vtx_eq_idx hS (a := t) (b := m + 1) (by omega) (by omega) he with h' | h' <;> omega
        · exact ⟨h1, h2⟩

theorem update_ok (i : Nat) (hi1 : 1 ≤ i) (hiN : i + 1 ≤ w.length) (occ : Array Bool)
    (hocc : OccOK w occ (i + 1)) (pend : List Ob) (hpend : ∀ ob ∈ pend, Gd w (i + 1) ob) :
    ∃ nw, update occ pend i (dir w i) (P w (i + 1)) (rpos (P w) (i + 1)) (some (dir w (i - 1)))
      (lastAx w i (axis (dir w i))) (w.length - i - 1) = some nw ∧ ∀ ob ∈ nw, Gd w (i + 2) ob := by
  have g0 : ∀ ob ∈ List.filter (fun ob => !List.contains ob (P w (i + 1))) pend, Gd w (i + 2) ob := by
    intro ob hob
    rw [List.mem_filter] at hob
    obtain ⟨m, hm1, hm2, hm3⟩ := hpend ob hob.1
    refine ⟨m, ?_, hm2, hm3⟩
    by_cases hc : i + 2 ≤ m
    · exact hc
    · have : m = i + 1 := by omega
      subst this
      have := hob.2
      simp [hm3] at this
  unfold update
  dsimp only
  split
  · rename_i heq
    exfalso
    split at heq
    · rename_i j a hsl
      split at heq
      · rename_i hrev
        have ha : a = rev (dir w i) := by simpa using hrev
        obtain ⟨q, hq, m, hm, hqm⟩ := curt_site hS hN hi1 hiN hsl ha
        split at heq
        · exact absurd heq (by simp)
        · rename_i hco
          rcases vsite hS hN hocc (by omega) hm with ho | ⟨_, _, hal⟩
          · rw [← hqm] at ho; rw [curtainOb_none occ a _ q hq ho] at hco; exact absurd hco (by simp)
          · have := (curtainOb_some occ a _ q [] hq hco).2 (by rw [hqm]; exact hal); simp at this
        · exact absurd heq (by simp)
      · exact absurd heq (by simp)
    · exact absurd heq (by simp)
  · rename_i _ nw1 heq
    have g1 : ∀ ob ∈ nw1, Gd w (i + 2) ob := by
      split at heq
      · rename_i j a hsl
        split at heq
        · rename_i hrev
          have ha : a = rev (dir w i) := by simpa using hrev
          obtain ⟨q, hq, m, hm, hqm⟩ := curt_site hS hN hi1 hiN hsl ha
          split at heq
          · rw [← Option.some.inj heq]; exact g0
          · exact absurd heq (by simp)
          · rename_i l _ hco
            rw [← Option.some.inj heq]
            intro ob hob
            rcases List.mem_append.1 hob with hob | hob
            · exact g0 ob hob
            · rw [List.mem_singleton.1 hob]
              rcases vsite hS hN hocc (by omega) hm with ho | ⟨hm', _, hal⟩
              · rw [← hqm] at ho; rw [curtainOb_none occ a _ q hq ho] at hco; exact absurd hco (by simp)
              · exact ⟨m, hm', hm, by rw [← hqm]; exact (curtainOb_some occ a _ q l hq hco).2 (by rw [hqm]; exact hal)⟩
        · rw [← Option.some.inj heq]; exact g0
      · rw [← Option.some.inj heq]; exact g0
    rw [rpos_getD _ _ _ (by omega), show i + 1 - 2 = i - 1 by omega]
    split
    · rename_i heq2
      exfalso
      split at heq2
      · exact absurd heq2 (by simp)
      · rename_i s hcs
        obtain ⟨m, hm, rfl⟩ := corner_site hS hN hi1 hiN hcs
        split at heq2
        · exact absurd heq2 (by simp)
        · rename_i ho
          split at heq2
          · exact absurd heq2 (by simp)
          · rename_i hal
            rcases vsite hS hN hocc (by omega) hm with h | ⟨_, _, h⟩
            · exact ho h
            · exact hal h
    · rename_i _ nw heq2
      have g2 : ∀ ob ∈ nw, Gd w (i + 2) ob := by
        split at heq2
        · rw [← Option.some.inj heq2]; exact g1
        · rename_i s hcs
          obtain ⟨m, hm, rfl⟩ := corner_site hS hN hi1 hiN hcs
          split at heq2
          · rw [← Option.some.inj heq2]; exact g1
          · rename_i ho
            split at heq2
            · rw [← Option.some.inj heq2]
              intro ob hob
              rcases List.mem_append.1 hob with hob | hob
              · exact g1 ob hob
              · rw [List.mem_singleton.1 hob]
                rcases vsite hS hN hocc (by omega) hm with h | ⟨hm', _, _⟩
                · exact absurd h ho
                · exact ⟨m, hm', hm, List.mem_singleton_self _⟩
            · exact absurd heq2 (by simp)
      have hf : nw.all (fine occ (P w (i + 1)) (w.length - i - 1)) = true := by
        rw [List.all_eq_true]
        exact fun ob hob => fine_ok hS hN hi1 hiN hocc (g2 ob hob)
      have hsp : spanNeed (P w (i + 1)) nw ≤ w.length - (i + 1) := by
        apply spanNeed_le hS hN (i + 1) hiN
        intro ob hob s hs
        obtain ⟨m, hm1, hm2, hm3⟩ := g2 ob hob
        rw [hs, List.mem_singleton] at hm3
        exact ⟨m, by omega, by omega, hm3.symm⟩
      rw [if_pos hf, if_neg (by simp only [Bool.and_eq_true, decide_eq_true_eq, not_and]; omega)]
      exact ⟨nw, rfl, g2⟩
end

end Len52.SP
