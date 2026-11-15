/-
  Len52.Cert — the finite computation, stated as one Boolean per part.

  `checkPart n r` runs the search for length n, part r of `parts n`, and checks every returned word with
  the verified colour test.  The executable `checkpart` (CheckMain.lean) evaluates exactly this term
  (`checkPart_eq` shows the expression it computes), prints the verdict, and exits with status 0 only if
  it is `true`.  `compCert_of_checks` shows that the truth of all these Booleans is the statement
  `CompCert` used by the main theorem.
-/
import Len52.Search
import Len52.Coloring

namespace Len52

open Len52.Search

/-- the lengths that need a search: every even length from 4 to 34 -/
def lengths : List Nat := [4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34]

/-- the number of parts each length was split into for the computation -/
def parts (n : Nat) : Nat :=
  if n = 34 then 1024 else if n = 32 then 256 else if n = 30 then 64 else if n = 28 then 2 else 1

theorem parts_pos (n : Nat) : 0 < parts n := by
  unfold parts; split <;> (try split) <;> (try split) <;> (try split) <;> omega

/-- The finite computation: every word that the search returns, for every needed length and every
    part, passes the verified colour test. -/
def CompCert : Prop :=
  ∀ n ∈ lengths, ∀ r, r < parts n → ∀ w ∈ (searchPart n 9 (parts n) r).out, colorCheck w = true

/-- one part of the computation, as a closed Boolean term -/
def checkPart (n r : Nat) : Bool := (searchPart n 9 (parts n) r).out.all colorCheck

theorem checkPart_eq (n r : Nat) :
    checkPart n r = (searchPart n 9 (parts n) r).out.all colorCheck := rfl

theorem compCert_of_checks (h : ∀ n ∈ lengths, ∀ r, r < parts n → checkPart n r = true) :
    CompCert := by
  intro n hn r hr w hw
  have := h n hn r hr
  unfold checkPart at this
  exact (List.all_eq_true.mp this) w hw

theorem checks_of_compCert (h : CompCert) :
    ∀ n ∈ lengths, ∀ r, r < parts n → checkPart n r = true := by
  intro n hn r hr
  unfold checkPart
  exact List.all_eq_true.mpr (h n hn r hr)

end Len52
