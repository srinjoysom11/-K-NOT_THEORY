/-
  Len52.Statement — the hypotheses of the main theorem, stated once so that every part of the proof
  works towards the same target.

  The main theorem (Len52/Main.lean) reads:

    theorem no_short (T : List Nat → Prop) (hT : KnotClass T) (hTop : TopHyp T)
        (hComp : CompCert) : ∀ w, T w → 36 ≤ w.length

  * `KnotClass T` (Spec.lean): T is closed under the elementary moves.  True for
      T w := IsPolygon w ∧ (the knot type of the polygon of w is 5_2 or its mirror image)
    by PROOF_RIGOROUS.md section 2.
  * `TopHyp T` (below): every regular diagram of a polygon in T has a non-constant Fox 7-colouring.
    True for that T by Fox's theorem (the number of p-colourings of a diagram is a knot invariant and
    is the same for a knot and its mirror image) and the computation c_7(5_2) = 49 > 7
    (PROOF_RIGOROUS.md section 6).
  * `CompCert` (Cert.lean): the finite computation.  It is equivalent to `checkPart n r = true` for every
    needed length n and part r (`compCert_of_checks`), and each of these closed Boolean terms is evaluated
    by the executable `checkpart` (PROOF_RIGOROUS.md section 8).

  The statement consists of Spec.lean, Diagram.lean, this file, Cert.lean (the definitions of `lengths`,
  `parts`, `CompCert`, `checkPart`) and the theorem `no_short` in Main.lean; Search.lean and Coloring.lean
  define the programs that `CompCert` talks about.
-/
import Len52.Diagram

namespace Len52

def TopHyp (T : List Nat → Prop) : Prop :=
  ∀ D w, T w → (diagram D w).isSome → HasNontrivialColoring D w

end Len52
