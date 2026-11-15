/-
  Len52.Main — the main theorem.

  For every class T of polygon words that is closed under the elementary moves (KnotClass) and whose
  members have a non-constant Fox 7-colouring in every regular diagram (TopHyp), the finite computation
  CompCert implies that every word of T has at least 36 letters.

  Applied to T = {polygon words whose polygon has knot type 5_2 or its mirror image}, for which
  KnotClass and TopHyp are standard facts of knot theory (PROOF_RIGOROUS.md §2 and §6), this says that
  every lattice polygon of type 5_2 has at least 36 edges.  Together with the 36-edge polygon w52
  (Coloring.lean; PROOF_RIGOROUS.md §9) this gives Len(5_2) = 36.
-/
import Len52.Statement
import Len52.NormalForm
import Len52.Cert
import Len52.SearchProof

namespace Len52

open Len52.Search

theorem no_short (T : List Nat → Prop) (hT : KnotClass T) (hTop : TopHyp T) (hComp : CompCert) :
    ∀ w, T w → 36 ≤ w.length := by
  intro w0 h0
  -- a word with Survive (or a unit square) in T, not longer than w0
  obtain ⟨w, hw, hlen, hsq⟩ := exists_survivor T hT w0 h0
  -- a word of T can never pass colorCheck
  have hno : ∀ v, T v → colorCheck v = true → False := by
    intro v hv hc
    obtain ⟨D, hD, hnot⟩ := colorCheck_sound v hc
    exact hnot (hTop D v hv hD)
  have hpoly := hT.polygon w hw
  have heven := isPolygon_length_even w hpoly
  refine Nat.le_of_not_lt fun hlt => ?_
  rcases hsq with h4 | hS
  · exact hno w hw (square_ok w h4 hpoly)
  · have hN : w.length ≤ 34 := by omega
    have h4 : 4 ≤ w.length := hpoly.1
    have hmem : w.length ∈ lengths := by
      simp only [lengths, List.mem_cons, List.not_mem_nil, or_false]
      omega
    have hP : 0 < parts w.length := parts_pos _
    let r := key ((w.take 9).reverse) % parts w.length
    have hr : r < parts w.length := Nat.mod_lt _ hP
    have hin := search_complete w hS hN (parts w.length) r hP (Or.inr rfl)
    exact hno w hw (hComp w.length hmem r hr w hin)

/-- The 36-edge word w52 (Coloring.lean) is a polygon word of length 36 whose diagram along D52 has a
    non-constant Fox 7-colouring; PROOF_RIGOROUS.md §9 shows its polygon is the knot 5_2. -/
theorem w52_facts : w52.length = 36 ∧ IsPolygon w52 ∧ HasNontrivialColoring D52 w52 :=
  ⟨w52_length, w52_polygon, w52_coloring⟩

end Len52
