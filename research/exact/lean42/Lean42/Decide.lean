/-
  Lean42.Decide -- decidable versions of the intersection conditions.

  Phase 1 of PLAN.md.  The geometric conditions of `Simple` and of `DeltaMove` quantify over points
  of Q^3 (`PairOK`: "every common point of two edges is an endpoint of both"; "the triangle meets the
  polygon only in the edge").  Here they are turned into programs.

  Method.  A common point of two segments has parameters (t, s); a point of a segment and a triangle
  has parameters (t, u, v).  "There is a bad point" is then "there are parameters satisfying finitely
  many linear equalities and strict or non-strict inequalities", decided by `feasible` (FM.lean).
  * Two edges (p,q), (p',q') with p ≠ q, p' ≠ q' have a common point that is not an endpoint of both
    iff there are t, s ∈ [0,1] with p + t(q-p) = p' + s(q'-p') and 0 < t < 1, or the same with
    0 < s < 1: a point x = p + t(q-p) is an endpoint of [p,q] iff t ∈ {0,1}, because p ≠ q.
    (`not_pairOK_iff`, `pairOKb`, `simple_iff`.)
  * A point x of the triangle abc and of an edge e lies outside {a, b} iff for some coordinates i, j
    and signs x_i ≠ a_i and x_j ≠ b_j strictly; that is 36 linear systems in (t,u,v)
    (`freeB`, `freeB_iff`, `deltaMove_iff`).  For a simple polygon this is the condition of the
    Delta-move, because another edge meets the edge [a,b] only in a common endpoint.
-/
import Lean42.Polygon
import Lean42.FM
import Lean42.Lat
import Lean42.Delta

namespace Lean42

/-! ## Two segments -/

/-- the constraint `a t + b s + c ≤ 0` (`< 0` if `st`) in the two variables (t, s) -/
def c2 (a b c : ℚ) (st : Bool) : Con 2 := ⟨![a, b], c, st⟩

theorem c2_holds (a b c : ℚ) (st : Bool) (v : Fin 2 → ℚ) :
    (c2 a b c st).Holds v ↔
      (if st then a * v 0 + b * v 1 + c < 0 else a * v 0 + b * v 1 + c ≤ 0) := by
  unfold Con.Holds Con.val c2
  simp [Fin.sum_univ_two]

/-- the parameters (t, s) of a common point of two segments: 0 ≤ t, s ≤ 1 and the coordinates agree -/
def segSegSys (p q p' q' : Pt) : List (Con 2) :=
  [c2 (-1) 0 0 false, c2 1 0 (-1) false, c2 0 (-1) 0 false, c2 0 1 (-1) false] ++
  (List.finRange 3).flatMap fun i =>
    [c2 (q i - p i) (-(q' i - p' i)) (p i - p' i) false,
     c2 (-(q i - p i)) (q' i - p' i) (-(p i - p' i)) false]

theorem segSegSys_holds (p q p' q' : Pt) (v : Fin 2 → ℚ) :
    (∀ c ∈ segSegSys p q p' q', c.Holds v) ↔
      (0 ≤ v 0 ∧ v 0 ≤ 1 ∧ 0 ≤ v 1 ∧ v 1 ≤ 1 ∧
        ∀ i, p i + v 0 * (q i - p i) = p' i + v 1 * (q' i - p' i)) := by
  simp only [segSegSys, List.forall_mem_append, List.mem_cons, List.mem_flatMap,
    List.mem_finRange, true_and, forall_eq_or_imp, List.not_mem_nil, or_false,
    forall_exists_index, and_imp]
  have key : ∀ a b c : ℚ, (c2 a b c false).Holds v ↔ a * v 0 + b * v 1 + c ≤ 0 := by
    intro a b c; rw [c2_holds]; simp
  constructor
  · rintro ⟨⟨h1, h2, h3, h4⟩, h5⟩
    have h4' := h4 _ rfl
    rw [key] at h1 h2 h3 h4'
    refine ⟨by linarith, by linarith, by linarith, by linarith, fun i => ?_⟩
    have a := h5 _ i (Or.inl rfl)
    have b := h5 _ i (Or.inr rfl)
    rw [key] at a b
    linarith
  · rintro ⟨h1, h2, h3, h4, h5⟩
    refine ⟨⟨?_, ?_, ?_, ?_⟩, ?_⟩
    · rw [key]; linarith
    · rw [key]; linarith
    · rw [key]; linarith
    · intro a ha; subst ha; rw [key]; linarith
    · intro x i hx
      have := h5 i
      rcases hx with rfl | rfl <;> rw [key] <;> linarith

end Lean42
