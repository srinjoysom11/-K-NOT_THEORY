/-
  Dmon.Walk — elementary facts about walks on Z^3 used by the soundness proofs of the new search
  tests (Dmon.AxisTravel, test D2) and of the generalized curtain (Dmon.GC, D1).  Plain Lean 4, no Mathlib.

  `endpt h q` is the end point of the walk that starts at h and takes the steps q; `vertsFrom h q` (Len52.Spec)
  lists its vertices.  `coord A v` is the coordinate of v along axis A (0 = x, 1 = y, 2 = z).
-/
import Len52.Spec

namespace Dmon
open Len52

def coord (A : Nat) (v : V3) : Int := if A = 0 then v.x else if A = 1 then v.y else v.z

def endpt (h : V3) : List Nat → V3
  | [] => h
  | d :: ds => endpt (h + unit d) ds

theorem endpt_append (h : V3) (a b : List Nat) : endpt h (a ++ b) = endpt (endpt h a) b := by
  induction a generalizing h with
  | nil => rfl
  | cons d ds ih => exact ih (h + unit d)

theorem endpt_add (h t : V3) (q : List Nat) : endpt (h + t) q = endpt h q + t := by
  induction q generalizing h with
  | nil => rfl
  | cons d ds ih =>
    show endpt (h + t + unit d) ds = endpt (h + unit d) ds + t
    have : h + t + unit d = (h + unit d) + t := by
      generalize unit d = u
      rcases h with ⟨a, b, c⟩; rcases t with ⟨e, f, g⟩; rcases u with ⟨i, j, k⟩
      show V3.mk (a + e + i) (b + f + j) (c + g + k) = V3.mk (a + i + e) (b + j + f) (c + k + g)
      congr 1 <;> omega
    rw [this, ih]

theorem countAxis_append (A : Nat) (a b : List Nat) :
    countAxis A (a ++ b) = countAxis A a + countAxis A b := by
  simp [countAxis, List.filter_append]

theorem countAxis_cons (A d : Nat) (ds : List Nat) :
    countAxis A (d :: ds) = (if axis d = A then 1 else 0) + countAxis A ds := by
  simp only [countAxis, List.filter_cons]
  by_cases h : axis d = A <;> simp [h, Nat.add_comm]

/-- one unit step changes coordinate A by one exactly when the direction is along A -/
theorem coord_unit (A d : Nat) (hA : A < 3) (hd : d < 6) :
    (axis d = A → coord A (unit d) = 1 ∨ coord A (unit d) = -1) ∧
    (axis d ≠ A → coord A (unit d) = 0) := by
  have h6 : d = 0 ∨ d = 1 ∨ d = 2 ∨ d = 3 ∨ d = 4 ∨ d = 5 := by omega
  have h3 : A = 0 ∨ A = 1 ∨ A = 2 := by omega
  rcases h6 with rfl | rfl | rfl | rfl | rfl | rfl <;> rcases h3 with rfl | rfl | rfl <;>
    simp [coord, unit, axis]

theorem coord_add (A : Nat) (u v : V3) : coord A (u + v) = coord A u + coord A v := by
  by_cases h0 : A = 0 <;> by_cases h1 : A = 1 <;> simp [coord, h0, h1]

theorem coord_sub (A : Nat) (u v : V3) : coord A (u - v) = coord A u - coord A v := by
  by_cases h0 : A = 0 <;> by_cases h1 : A = 1 <;> simp [coord, h0, h1]

/-- a walk moves along axis A at most once per letter along A (total variation) -/
theorem coord_bound (A : Nat) (hA : A < 3) :
    ∀ (q : List Nat) (h : V3), (∀ d ∈ q, d < 6) →
      coord A (endpt h q) - coord A h ≤ countAxis A q ∧
      coord A h - coord A (endpt h q) ≤ countAxis A q ∧
      (coord A (endpt h q) - coord A h) % 2 = (countAxis A q : Int) % 2 := by
  intro q
  induction q with
  | nil => intro h _; simp [endpt, countAxis]
  | cons d ds ih =>
    intro h hq
    have hd : d < 6 := hq d (List.mem_cons_self ..)
    have hds : ∀ e ∈ ds, e < 6 := fun e he => hq e (List.mem_cons_of_mem _ he)
    obtain ⟨i1, i2, i3⟩ := ih (h + unit d) hds
    obtain ⟨c1, c2⟩ := coord_unit A d hA hd
    rw [coord_add] at i1 i2 i3
    have e : endpt h (d :: ds) = endpt (h + unit d) ds := rfl
    rw [e, countAxis_cons]
    by_cases hax : axis d = A
    · have := c1 hax; simp only [hax, if_true]; omega
    · have := c2 hax; simp only [hax, if_false]; omega

end Dmon
