/-
  Lean42.Flip -- corner flips and U-turn removals on words.

  Phase 2 of PLAN.md.  A word `w = pre ++ [a, b] ++ post` with `ax a ≠ ax b` (perpendicular
  steps) has the vertices  X ++ [A, B] ++ Y  with  X = vertices of `pre`, A = the end of `pre`,
  B = A + a, C = B + b, Y = the walk of `post` from C.  Exchanging a and b replaces B by D = A + b
  (`flip_wpoly`); the polygons are equivalent by `flip_equiv`.  Because a polygon is a cyclic list,
  we first rotate it so that A comes first (`flip_cyc`); the two cases are `post ≠ []` (then C
  is the first vertex of Y) and `post = []` (then C = v_0 is the first vertex of X).
  A word `pre ++ [a, b, rev a] ++ post` loses two vertices when the U-turn is removed
  (`uturn_wpoly`), by `uturn_equiv`.
-/
import Lean42.Ops

namespace Lean42
open Lean42.Spec

theorem nodup_replace {α : Type*} [DecidableEq α] (X Y : List α) (A B D : α)
    (hn : (X ++ A :: B :: Y).Nodup) (hD : D ∉ X ++ A :: B :: Y) : (X ++ A :: D :: Y).Nodup := by
  have hs : (X ++ A :: Y).Sublist (X ++ A :: B :: Y) :=
    List.Sublist.append_left ((List.sublist_cons_self B Y).cons₂ A) X
  have h2 : (X ++ A :: D :: Y).Perm (D :: (X ++ A :: Y)) := by
    have := List.perm_middle (a := D) (l₁ := X ++ [A]) (l₂ := Y)
    simpa [List.append_assoc] using this
  rw [h2.nodup_iff, List.nodup_cons]
  exact ⟨fun h => hD (hs.subset h), hn.sublist hs⟩

theorem flip_cyc {F : Frame} (hF : F.Ok) {X Y : List Pt} (R : List Pt)
    (hrot : (X ++ F.A :: F.B :: Y).rotate X.length = F.A :: F.B :: F.C :: R ∧
            (X ++ F.A :: F.D :: Y).rotate X.length = F.A :: F.D :: F.C :: R)
    (hP : LatPoly (X ++ F.A :: F.B :: Y)) (hD : F.D ∉ X ++ F.A :: F.B :: Y) :
    Equiv (X ++ F.A :: F.B :: Y) (X ++ F.A :: F.D :: Y) := by
  have hP' := hP.rotate X.length
  rw [hrot.1] at hP'
  have hD' : F.D ∉ F.A :: F.B :: F.C :: R := by
    rw [← hrot.1]; exact fun h => hD (List.mem_rotate.1 h)
  have h := flip_equiv hF hP' hD'
  refine (Equiv.rotate _ X.length).trans ?_
  rw [hrot.1]
  refine h.trans ?_
  rw [← hrot.2]
  exact (Equiv.rotate _ _).symm

theorem uturn_cyc {F : Frame} (hF : F.Ok) {X Y : List Pt} (R : List Pt)
    (hrot : (X ++ F.A :: F.B :: F.C :: Y).rotate X.length = F.A :: F.B :: F.C :: F.D :: R ∧
            (X ++ F.A :: Y).rotate X.length = F.A :: F.D :: R)
    (hP : LatPoly (X ++ F.A :: F.B :: F.C :: Y)) (h6 : 6 ≤ (X ++ F.A :: F.B :: F.C :: Y).length) :
    Equiv (X ++ F.A :: F.B :: F.C :: Y) (X ++ F.A :: Y) := by
  have hP' := hP.rotate X.length
  rw [hrot.1] at hP'
  have hR : R ≠ [] := by
    intro h
    have := congrArg List.length hrot.1
    rw [List.length_rotate, h] at this
    simp at this h6; omega
  have h := uturn_equiv hF hR hP'
  refine (Equiv.rotate _ X.length).trans ?_
  rw [hrot.1]
  refine h.trans ?_
  rw [← hrot.2]
  exact (Equiv.rotate _ _).symm

/-- the frame of a perpendicular pair of steps `a`, `b` at the point `usum pre` -/
theorem frame_of_steps {a b : ℕ} (ha : a < 6) (hb : b < 6) (hax : ax a ≠ ax b) (A : Pt)
    (hA : IsLat A) :
    ∃ F : Frame, F.Ok ∧ F.A = A ∧ F.B = A + upt a ∧ F.D = A + upt b ∧
      F.C = A + upt a + upt b := by
  obtain ⟨s1, hs1, ea⟩ := upt_eq ha
  obtain ⟨s2, hs2, eb⟩ := upt_eq hb
  refine ⟨⟨A, ax a, ax b, s1, s2⟩, ⟨hax, hs1, hs2, hA⟩, rfl, ?_, ?_, ?_⟩
  · simp only [Frame.B]; rw [ea]
  · simp only [Frame.D]; rw [eb]
  · simp only [Frame.C]; rw [ea, eb]

theorem flip_rot_data (X Y : List Pt) (A B C D : Pt)
    (hY : (∃ Y'', Y = C :: Y'') ∨ (Y = [] ∧ ∃ X', X = C :: X')) :
    ∃ R, (X ++ A :: B :: Y).rotate X.length = A :: B :: C :: R ∧
         (X ++ A :: D :: Y).rotate X.length = A :: D :: C :: R := by
  rcases hY with ⟨Y'', rfl⟩ | ⟨rfl, X', rfl⟩
  · refine ⟨Y'' ++ X, ?_, ?_⟩ <;> (rw [List.rotate_append_length_eq]; simp)
  · refine ⟨X', ?_, ?_⟩
    · have := List.rotate_append_length_eq (C :: X') [A, B]
      simpa using this
    · have := List.rotate_append_length_eq (C :: X') [A, D]
      simpa using this

theorem uturn_rot_data (X Y : List Pt) (A B C D : Pt)
    (hY : (∃ Y'', Y = D :: Y'') ∨ (Y = [] ∧ ∃ X', X = D :: X')) :
    ∃ R, (X ++ A :: B :: C :: Y).rotate X.length = A :: B :: C :: D :: R ∧
         (X ++ A :: Y).rotate X.length = A :: D :: R := by
  rcases hY with ⟨Y'', rfl⟩ | ⟨rfl, X', rfl⟩
  · refine ⟨Y'' ++ X, ?_, ?_⟩ <;> (rw [List.rotate_append_length_eq]; simp)
  · refine ⟨X', ?_, ?_⟩
    · have := List.rotate_append_length_eq (D :: X') [A, B, C]
      simpa using this
    · have := List.rotate_append_length_eq (D :: X') [A]
      simpa using this

theorem flip_wpoly (pre post : List ℕ) (a b : ℕ) (hw : IsPolygon (pre ++ a :: b :: post))
    (hax : ax a ≠ ax b) (hD : usum pre + upt b ∉ wpoly (pre ++ a :: b :: post)) :
    IsPolygon (pre ++ b :: a :: post) ∧
      Equiv (wpoly (pre ++ a :: b :: post)) (wpoly (pre ++ b :: a :: post)) := by
  have hlat := latPoly_wpoly hw
  have hw' := (isPolygon_iff _).1 hw
  obtain ⟨h4, hl, hc, hnd⟩ := hw'
  have ha : a < 6 := hl a (by simp)
  have hb : b < 6 := hl b (by simp)
  have e1 : wpoly (pre ++ a :: b :: post) =
      ptwalk 0 pre ++ usum pre :: (usum pre + upt a) ::
        ptwalk (usum pre + upt a + upt b) post := by
    simp [wpoly, ptwalk_append]
  have e2 : wpoly (pre ++ b :: a :: post) =
      ptwalk 0 pre ++ usum pre :: (usum pre + upt b) ::
        ptwalk (usum pre + upt a + upt b) post := by
    simp [wpoly, ptwalk_append, add_right_comm]
  obtain ⟨F, hF, hFA, hFB, hFD, hFC⟩ := frame_of_steps ha hb hax (usum pre) (isLat_usum pre)
  rw [e1] at hlat hD hnd
  rw [e2]
  have hnd' := nodup_replace _ _ _ (usum pre + upt a) _ hnd hD
  refine ⟨?_, ?_⟩
  · rw [isPolygon_iff, e2]
    refine ⟨by simp at h4 ⊢; omega, ?_, ?_, hnd'⟩
    · intro d hd
      apply hl
      simp only [List.mem_append, List.mem_cons] at hd ⊢
      tauto
    · have := hc
      simp only [usum_append, usum_cons] at this ⊢
      rw [← this]; abel
  · rw [e1]
    have hY : (∃ Y'', ptwalk (usum pre + upt a + upt b) post = F.C :: Y'') ∨
        (ptwalk (usum pre + upt a + upt b) post = [] ∧ ∃ X', ptwalk 0 pre = F.C :: X') := by
      cases post with
      | cons d post' => left; exact ⟨ptwalk (usum pre + upt a + upt b + upt d) post', by simp [hFC]⟩
      | nil =>
        right
        refine ⟨by simp, ?_⟩
        have hC0 : F.C = 0 := by
          rw [hFC]
          have := hc
          simp only [usum_append, usum_cons, usum_nil, add_zero] at this
          rw [← this]; abel
        cases pre with
        | nil => simp at h4
        | cons d pre' => exact ⟨ptwalk (0 + upt d) pre', by simp [hC0]⟩
    obtain ⟨R, hR⟩ := flip_rot_data (ptwalk 0 pre) (ptwalk (usum pre + upt a + upt b) post)
      F.A F.B F.C F.D hY
    have key := flip_cyc hF R hR (by rw [hFA, hFB]; exact hlat) (by rw [hFA, hFB, hFD]; exact hD)
    rw [hFA, hFB, hFD] at key
    exact key

theorem uturn_wpoly (pre post : List ℕ) (a b : ℕ) (hw : IsPolygon (pre ++ a :: b :: rev a :: post))
    (hax : ax a ≠ ax b) (h6 : 6 ≤ (pre ++ a :: b :: rev a :: post).length) :
    IsPolygon (pre ++ b :: post) ∧
      Equiv (wpoly (pre ++ a :: b :: rev a :: post)) (wpoly (pre ++ b :: post)) := by
  have hlat := latPoly_wpoly hw
  have hw' := (isPolygon_iff _).1 hw
  obtain ⟨h4, hl, hc, hnd⟩ := hw'
  have ha : a < 6 := hl a (by simp)
  have hb : b < 6 := hl b (by simp)
  have hD : usum pre + upt a + upt b + upt (rev a) = usum pre + upt b := by
    rw [upt_rev ha]; abel
  have e1 : wpoly (pre ++ a :: b :: rev a :: post) =
      ptwalk 0 pre ++ usum pre :: (usum pre + upt a) :: (usum pre + upt a + upt b) ::
        ptwalk (usum pre + upt b) post := by
    simp [wpoly, ptwalk_append, hD]
  have e2 : wpoly (pre ++ b :: post) = ptwalk 0 pre ++ usum pre :: ptwalk (usum pre + upt b) post := by
    simp [wpoly, ptwalk_append]
  obtain ⟨F, hF, hFA, hFB, hFD, hFC⟩ := frame_of_steps ha hb hax (usum pre) (isLat_usum pre)
  rw [e1] at hlat hnd
  have hsub : (ptwalk 0 pre ++ usum pre :: ptwalk (usum pre + upt b) post).Sublist
      (ptwalk 0 pre ++ usum pre :: (usum pre + upt a) :: (usum pre + upt a + upt b) ::
        ptwalk (usum pre + upt b) post) :=
    List.Sublist.append_left
      ((((List.sublist_cons_self _ _).trans (List.sublist_cons_self _ _))).cons₂ _) _
  refine ⟨?_, ?_⟩
  · rw [isPolygon_iff, e2]
    refine ⟨by simp at h4 h6 ⊢; omega, ?_, ?_, hnd.sublist hsub⟩
    · intro d hd
      apply hl
      simp only [List.mem_append, List.mem_cons] at hd ⊢
      tauto
    · have := hc
      simp only [usum_append, usum_cons] at this ⊢
      rw [← this, upt_rev ha]; abel
  · rw [e1, e2]
    have hY : (∃ Y'', ptwalk (usum pre + upt b) post = F.D :: Y'') ∨
        (ptwalk (usum pre + upt b) post = [] ∧ ∃ X', ptwalk 0 pre = F.D :: X') := by
      cases post with
      | cons d post' => left; exact ⟨ptwalk (usum pre + upt b + upt d) post', by simp [hFD]⟩
      | nil =>
        right
        refine ⟨by simp, ?_⟩
        have hD0 : F.D = 0 := by
          rw [hFD]
          have := hc
          simp only [usum_append, usum_cons, usum_nil, add_zero] at this
          rw [← this, upt_rev ha]; abel
        cases pre with
        | nil => simp at h4
        | cons d pre' => exact ⟨ptwalk (0 + upt d) pre', by simp [hD0]⟩
    obtain ⟨R, hR⟩ := uturn_rot_data (ptwalk 0 pre) (ptwalk (usum pre + upt b) post)
      F.A F.B F.C F.D hY
    have h6' : 6 ≤ (ptwalk 0 pre ++ usum pre :: (usum pre + upt a) :: (usum pre + upt a + upt b) ::
        ptwalk (usum pre + upt b) post).length := by
      rw [← e1]; unfold wpoly; rw [ptwalk_length]; exact h6
    have key := uturn_cyc hF R hR (by rw [hFA, hFB, hFC]; exact hlat)
      (by rw [hFA, hFB, hFC]; exact h6')
    rw [hFA, hFB, hFC] at key
    exact key

end Lean42
