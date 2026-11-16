/-
  Len52.NormalForm — every class `T` satisfying `KnotClass` contains, at its minimal length, either a
  square (length 4) or a word satisfying `Survive` (PROOF_RIGOROUS.md, sections 3-5).

  Outline.
  1. `isPolygon_length_even`: a closed walk has as many e as w, n as s, u as d letters.
  2. Take a word of least length m in T; sort its axis counts by an axis permutation (`sort_axes`).
  3. Among the words of T of length m with sorted axis counts, minimise the potential
     Psi = sum of the heights z above the lowest vertex, then Psi2 (the same for y) (`psiW`).
     Both are invariant under rotation and reversal, so the minimisers form a class `G` closed under
     these moves; `canonical` puts a word of `G` in canonical position (lowest vertex first,
     orientation fixed).
  4. Curtain condition (`curtainOK_of_min`): otherwise k-1 flips and a U-turn removal give a word of T
     of length m - 2.
  5. Corner conditions (`cornerOK_of_min`): otherwise a flip lowers Psi, or keeps Psi and lowers Psi2.
-/
import Len52.NF.Moves

namespace Len52

theorem isPolygon_length_even (w : List Nat) (h : IsPolygon w) : w.length % 2 = 0 :=
  isPolygon_length_even' w h

theorem exists_survivor (T : List Nat → Prop) (hT : KnotClass T) (w0 : List Nat) (h0 : T w0) :
    ∃ w, T w ∧ w.length ≤ w0.length ∧ (w.length = 4 ∨ Survive w) := by
  -- a word of least length
  obtain ⟨w1, hT1, hmin1⟩ := exists_min T List.length w0 h0
  have hle1 : w1.length ≤ w0.length := hmin1 w0 h0
  have hp1 := hT.polygon w1 hT1
  by_cases h4 : w1.length = 4
  · exact ⟨w1, hT1, hle1, Or.inl h4⟩
  have h6 : 6 ≤ w1.length := by
    have := isPolygon_length_even w1 hp1; have := hp1.1; omega
  -- sorted axis counts
  let Ord : List Nat → Prop := fun w =>
    countAxis 2 w ≤ countAxis 1 w ∧ countAxis 1 w ≤ countAxis 0 w
  obtain ⟨w2, hT2, hl2, ho2⟩ := sort_axes T hT w1 hT1
  -- minimise the potentials
  let A : List Nat → Prop := fun w => T w ∧ w.length = w1.length ∧ Ord w
  obtain ⟨w3, hA3, hmin3⟩ := exists_min A (psiW (fun v => v.z)) w2 ⟨hT2, hl2, ho2⟩
  let B : List Nat → Prop := fun w => A w ∧ psiW (fun v => v.z) w = psiW (fun v => v.z) w3
  obtain ⟨w4, hB4, hmin4⟩ := exists_min B (psiW (fun v => v.y)) w3 ⟨hA3, rfl⟩
  let G : List Nat → Prop := fun w => B w ∧ psiW (fun v => v.y) w = psiW (fun v => v.y) w4
  have hGpoly : ∀ w, G w → IsPolygon w := fun w hw => hT.polygon w hw.1.1.1
  have hGrot : ∀ w, G w → G (rotate1 w) := by
    intro w ⟨⟨⟨hTw, hlw, how⟩, hzw⟩, hyw⟩
    have hp := hT.polygon w hTw
    have hn : 1 ≤ w.length := by have := hp.1; omega
    have hc : Closed w := hp.2.2.1
    refine ⟨⟨⟨hT.rot w hTw, by rw [length_rotate1]; exact hlw, ?_⟩, ?_⟩, ?_⟩
    · show countAxis 2 (rotate1 w) ≤ countAxis 1 (rotate1 w) ∧
        countAxis 1 (rotate1 w) ≤ countAxis 0 (rotate1 w)
      rw [countAxis_rotate1, countAxis_rotate1, countAxis_rotate1]; exact how
    · rw [psiW_rotate1 _ isCoord_z w hn hc]; exact hzw
    · rw [psiW_rotate1 _ isCoord_y w hn hc]; exact hyw
  have hGrev : ∀ w, G w → G (revWord w) := by
    intro w ⟨⟨⟨hTw, hlw, how⟩, hzw⟩, hyw⟩
    have hp := hT.polygon w hTw
    have hc : Closed w := hp.2.2.1
    refine ⟨⟨⟨hT.reverse w hTw, by rw [length_revWord]; exact hlw, ?_⟩, ?_⟩, ?_⟩
    · show countAxis 2 (revWord w) ≤ countAxis 1 (revWord w) ∧
        countAxis 1 (revWord w) ≤ countAxis 0 (revWord w)
      rw [countAxis_revWord, countAxis_revWord, countAxis_revWord]; exact how
    · rw [psiW_revWord _ w hp.2.1 hc]; exact hzw
    · rw [psiW_revWord _ w hp.2.1 hc]; exact hyw
  -- canonical position
  obtain ⟨w, hG, hlex, hor⟩ := canonical G hGpoly hGrot hGrev w4 ⟨hB4, rfl⟩
  obtain ⟨⟨⟨hTw, hlw, how⟩, hzw⟩, hyw⟩ := hG
  refine ⟨w, hTw, by omega, Or.inr ⟨hT.polygon w hTw, hlex, hor, how, ?_, ?_⟩⟩
  · exact curtainOK_of_min T hT w hTw (by omega) (fun y hy => by rw [hlw]; exact hmin1 y hy)
  · apply cornerOK_of_min T hT w hTw how
    · intro y hy hly hoy
      rw [hzw]; exact hmin3 y ⟨hy, by omega, hoy⟩
    · intro y hy hly hoy hzy
      rw [hyw]; exact hmin4 y ⟨⟨hy, by omega, hoy⟩, by omega⟩

end Len52

