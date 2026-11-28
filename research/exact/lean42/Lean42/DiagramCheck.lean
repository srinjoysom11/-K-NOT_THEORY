/-
  Lean42.DiagramCheck -- checks of the definitions of `Lean42.Diagram` against an independent
  computation (Python, Smith normal form over Z/n; see STATUS.md): the lattice words of the
  trefoil and the figure-eight knot from research/data/seeds.json, with the Alexander quandles
  A(3,2), A(5,4) and the trivial quandle A(3,1).  `#guard` evaluates the statements when the file is
  compiled.
-/
import Lean42.Diagram
import Lean42.Words
import Lean42.Gauss

namespace Lean42

def w31 : List ℕ := strWord "nnwwwwsussdseennnunndnwwwwsssseeeueede"
def w41 : List ℕ := strWord "nnnneeeesussdssussdseeeennnnnnwwwwwwsussdseeeennwuwwdwww"

instance : NeZero 3 := ⟨by decide⟩
instance : NeZero 5 := ⟨by decide⟩

#guard genericB (wpoly w31) = true
#guard (evs (wpoly w31)).length = 6
#guard col (AlexQ 3 2 2 (by decide)) (wpoly w31) = 9
#guard col (AlexQ 3 1 1 (by decide)) (wpoly w31) = 3
#guard col (AlexQ 5 4 4 (by decide)) (wpoly w41) = 25
#guard col (AlexQ 5 4 4 (by decide)) (wpoly w41).reverse = 25
#guard col (AlexQ 5 2 3 (by decide)) (wpoly w41) = 5

/-- the signed Gauss code of the diagram of a polygon (from the globally sorted events) -/
def gaussOf (L : List Pt) : List (GEv (ℕ × ℕ)) :=
  (evs L).map fun e => ⟨e.cid, e.over, e.pos⟩

-- the trace formulation of the count agrees with the piece count (3_1; the product of matrices
-- is evaluated lazily, larger examples are too slow for `#guard`)
#guard colG (AlexQ 3 2 2 (by decide)) (gaussOf (wpoly w31)).reverse = 9
#guard colG (AlexQ 3 2 2 (by decide)) (gaussOf (wpoly w31)) = 9
#guard colG (AlexQ 3 1 1 (by decide)) (gaussOf (wpoly w31)) = 3

end Lean42
