/-
  Len52.PD — the upper-bound certificate, checked by the kernel: the regular projection of the 36-edge
  polygon `w52` along `D52 = (1, -19, 40)` has the PD code of the standard 5_2 diagram, up to relabelling
  of the edges (rotation, reversal of the orientation) and mirror image.  This is a line-by-line
  re-implementation of `research/exact/formal/pd_certificate.py` (`pd_code`, `variants`, `mirror`).

  PD convention (Knot Atlas / KnotInfo).  The 2c passages of the walk through the c crossings (over- and
  under-passages together) are sorted along the walk by (edge index, parameter on the edge):
  P_0 < P_1 < ... < P_{2c-1}.  Edge number e+1 (labels 1..2c) is the piece of the polygon from P_e to
  P_{e+1} (indices mod 2c); so the edge arriving at P_e has label ((e - 1) mod 2c) + 1 and the edge leaving
  it has label (e mod 2c) + 1.  A crossing is written X[a, b, c, d] where a is the incoming and c the
  outgoing edge of the under-strand, and a, b, c, d are the four edge ends at the crossing in
  counter-clockwise order; b and d are the two edges of the over-strand.  Counter-clockwise refers to the
  (a, b)-coordinates of `proj` with the standard orientation of Z^2: around the crossing the under
  edge-ends point to -du (edge a) and +du (edge c), the over edge-ends to -dov (incoming over edge) and
  +dov (outgoing over edge), where du, dov are the projected direction vectors of the under and over
  lattice edges; turning counter-clockwise from -du, the next of these is +dov iff
  cross2(-du, dov) > 0.  Hence X = [a, outOver, c, inOver] if cross2(-du, dov) > 0 and
  X = [a, inOver, c, outOver] otherwise.

  Orientation remark.  The viewer looks from +D (heights `height D` grow towards the viewer).  If
  p1, p2 are lifts of the unit vectors of the (a,b)-plane, p1 = (1/Dz, 0, 0), p2 = (0, 1/Dz, 0), then
  (p1 × p2) · D = 1/Dz, so the (a, b)-plane with its standard orientation is seen counter-clockwise by
  the viewer iff Dz > 0 (Dz = 40 here).  Reading a PD code with the opposite rotational convention (as
  happens if a table lists its tuples clockwise) describes the mirror diagram; since the comparison below
  is up to mirror image, the conclusion "5_2 or its mirror image" does not depend on these conventions.

  Equivalences.
  * Rotation: x ↦ ((x - 1 + s) mod m) + 1 (another choice of the starting point of the labelling).
  * Reversal: x ↦ ((s - (x - 1)) mod m) + 1; the incoming under-strand of each crossing becomes the old c,
    and the counter-clockwise order starting there is c, d, a, b, so X[a,b,c,d] becomes
    X[f c, f d, f a, f b].
  * Mirror (all crossings switched): the new under-strand is the old over-strand b–d, whose incoming
    edge is the one whose successor (mod m) is the other: if d ≡ b + 1 the new crossing is X[b, c, d, a],
    otherwise (b ≡ d + 1) it is X[d, a, b, c] (counter-clockwise order unchanged).  (For m = 2c ≥ 4
    exactly one case applies.)
  Relabellings form the dihedral group of order 2m, so "P relabelled equals Q" (as multisets of
  4-tuples) for some relabelling is the same test as pd_certificate.py's `variants P ∩ variants Q ≠ ∅`.
-/
import Len52.Coloring

namespace Len52
namespace PD

open Col

/-- the 2c passages: (position on the walk, crossing number, 0 = under / 1 = over) -/
def passages (cs : List Crossing) : List (EPt × Nat × Nat) :=
  (cs.zipIdx.map fun (cr, k) => [(cr.under, k, 0), (cr.over, k, 1)]).flatten

/-- the passages sorted along the walk (kernel-evaluable merge sort `msF`, = `List.mergeSort`) -/
def sortedPassages (cs : List Crossing) : List (EPt × Nat × Nat) :=
  msF (fun p q => !(EPt.lt q.1 p.1)) (2 * cs.length) (passages cs)

/-- index of the passage of crossing k of kind o in the sorted list -/
def posOf (ev : List (EPt × Nat × Nat)) (k o : Nat) : Nat :=
  ev.findIdx (fun p => p.2.1 == k && p.2.2 == o)

def labIn (m e : Nat) : Nat := (e + m - 1) % m + 1
def labOut (m e : Nat) : Nat := e % m + 1

/-- the projected direction of edge i -/
def dirOf (ed : List (P2 × P2 × Int × Int)) (i : Nat) : P2 :=
  let (p1, p2, _, _) := ed.getD i (⟨0, 0⟩, ⟨0, 0⟩, 0, 0)
  sub2 p2 p1

/-- the PD code of the crossings `cs` of the diagram of w under D (crossings in the order of `cs`) -/
def pdOfCs (D : V3) (w : List Nat) (cs : List Crossing) : List (List Nat) :=
  let ed := edgeData D w
  let m := 2 * cs.length
  let ev := sortedPassages cs
  cs.zipIdx.map fun (cr, k) =>
    let eu := posOf ev k 0
    let eo := posOf ev k 1
    let a := labIn m eu
    let c := labOut m eu
    let b := labIn m eo
    let d := labOut m eo
    let du := dirOf ed cr.under.e
    let dov := dirOf ed cr.over.e
    let crs := (-du.a) * dov.b - (-du.b) * dov.a
    if crs > 0 then [a, d, c, b] else [a, b, c, d]

/-- the PD code of the regular diagram of w under D (`none` if the projection is not regular) -/
def pdOf (D : V3) (w : List Nat) : Option (List (List Nat)) :=
  (diagram D w).map (pdOfCs D w)

/-! ## Equivalence of PD codes -/

/-- relabelling by rotation (rev = false) or reversal (rev = true) of the numbering, labels 1..m -/
def relabel (m s : Nat) (rev : Bool) (x : Nat) : Nat :=
  if rev then (s % m + m - (x - 1) % m) % m + 1 else (x - 1 + s) % m + 1

def applyRelabel (m s : Nat) (rev : Bool) (P : List (List Nat)) : List (List Nat) :=
  let f := relabel m s rev
  P.map fun t =>
    match t with
    | [a, b, c, d] => if rev then [f c, f d, f a, f b] else [f a, f b, f c, f d]
    | t => t.map f

/-- mirror image: every crossing switched -/
def mirror (P : List (List Nat)) : List (List Nat) :=
  let m := 2 * P.length
  P.map fun t =>
    match t with
    | [a, b, c, d] => if (d + m - b) % m == 1 then [b, c, d, a] else [d, a, b, c]
    | t => t

/-- lexicographic order on tuples -/
def lexLe : List Nat → List Nat → Bool
  | [], _ => true
  | _ :: _, [] => false
  | x :: xs, y :: ys => x < y || (x == y && lexLe xs ys)

def insertT (t : List Nat) : List (List Nat) → List (List Nat)
  | [] => [t]
  | u :: us => if lexLe t u then t :: u :: us else u :: insertT t us

/-- insertion sort of the crossing tuples (to compare PD codes as multisets) -/
def sortT : List (List Nat) → List (List Nat)
  | [] => []
  | t :: ts => insertT t (sortT ts)

/-- P becomes Q (as multisets of crossing tuples) after an optional mirror image followed by a
    relabelling by rotation or reversal -/
def pdEquiv (P Q : List (List Nat)) : Bool :=
  let m := 2 * P.length
  let Qs := sortT Q
  P.length == Q.length &&
    [P, mirror P].any fun P' =>
      (List.range m).any fun s =>
        [false, true].any fun rev => sortT (applyRelabel m s rev P') == Qs

/-! ## The certificate -/

/-- KnotInfo PD code of 5_2 -/
def std52 : List (List Nat) := [[1, 5, 2, 4], [3, 9, 4, 8], [5, 1, 6, 10], [7, 3, 8, 2], [9, 7, 10, 6]]

/-- KnotInfo PD code of 5_1 (control) -/
def std51 : List (List Nat) := [[2, 8, 3, 7], [4, 10, 5, 9], [6, 2, 7, 1], [8, 4, 9, 3], [10, 6, 1, 5]]

/-- the PD code printed by pd_certificate.py for w52 along D52 -/
def pyPD : List (List Nat) := [[10, 3, 1, 4], [6, 1, 7, 2], [2, 7, 3, 8], [4, 9, 5, 10], [8, 5, 9, 6]]

/-- the Lean computation reproduces the Python PD code exactly (same crossing order) -/
theorem w52_pd_eq : pdOf D52 w52 = some pyPD := by decide +kernel

/-- the upper-bound certificate: the projection of w52 along D52 is the standard 5_2 diagram up to
    relabelling and mirror image -/
theorem w52_pd : (pdOf D52 w52).map (fun P => pdEquiv P std52) = some true := by decide +kernel

/-- controls -/
theorem std52_self : pdEquiv std52 std52 = true := by decide +kernel
theorem std52_mirror : pdEquiv (mirror std52) std52 = true := by decide +kernel
theorem std51_not : pdEquiv std52 std51 = false := by decide +kernel
theorem w52_pd_not51 : (pdOf D52 w52).map (fun P => pdEquiv P std51) = some false := by
  decide +kernel

/-! ## Sanity checks of the conventions: chirality is detected when the mirror is not allowed -/

/-- relabelling only (no mirror image) -/
def pdRelabelEquiv (P Q : List (List Nat)) : Bool :=
  let m := 2 * P.length
  P.length == Q.length &&
    (List.range m).any fun s => [false, true].any fun rev => sortT (applyRelabel m s rev P) == sortT Q

/-- KnotInfo PD codes of 3_1 and 4_1 -/
def std31 : List (List Nat) := [[1, 5, 2, 4], [3, 1, 4, 6], [5, 3, 6, 2]]
def std41 : List (List Nat) := [[4, 2, 5, 1], [8, 6, 1, 5], [6, 3, 7, 4], [2, 7, 3, 8]]

/-- the chiral knots 3_1, 5_1, 5_2: their standard diagrams are not relabellings of their mirrors;
    the amphichiral 4_1: its standard diagram is -/
theorem chirality_controls :
    pdRelabelEquiv std31 (mirror std31) = false ∧ pdRelabelEquiv std51 (mirror std51) = false ∧
    pdRelabelEquiv std52 (mirror std52) = false ∧ pdRelabelEquiv std41 (mirror std41) = true ∧
    mirror (mirror std52) = std52 := by
  decide +kernel

/-- with the conventions of this file, the projection of w52 along D52 is the mirror of the KnotInfo
    diagram of 5_2 (and not a relabelling of it) -/
theorem w52_pd_mirror :
    pdRelabelEquiv (mirror pyPD) std52 = true ∧ pdRelabelEquiv pyPD std52 = false := by
  decide +kernel

end PD
end Len52
