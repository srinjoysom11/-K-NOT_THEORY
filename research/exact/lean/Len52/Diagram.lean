/-
  Len52.Diagram — the knot diagram of a lattice polygon under a linear projection, and its Fox
  7-colourings.  Part of the trusted statement: the topological hypothesis `TopHyp` (Main.lean) is a
  statement about exactly these definitions.  Exact integer arithmetic only.

  Projection.  Fix D = (Dx, Dy, Dz) with all three coordinates non-zero.  The viewer looks along -D.
  A point p = (x, y, z) is drawn at  pi(p) = (Dz*x - Dx*z, Dz*y - Dy*z)  (pi(D) = 0, rank 2) and has height
  h(p) = Dx*x + Dy*y + Dz*z; at a crossing the strand of larger height is the over-strand.

  Regular projection (Burde-Zieschang, Knots, Ch. 1; Lickorish, An Introduction to Knot Theory, Ch. 1): the image of the polygon has only
  finitely many multiple points, all of them double points, and no vertex is mapped onto a double point.
  For straight edges this is checked pair by pair below:
  * no edge is mapped to a point (D has no zero coordinate, so pi(unit d) != 0);
  * two edges that share a vertex have images that meet only in the image of that vertex;
  * two edges that do not share a vertex have disjoint images, or images that cross in one point that is
    interior to both, and the two edges have different heights there;
  * no two such crossing points coincide (no triple points).

  Arcs.  Walk along the polygon from v_0.  Every crossing is passed twice, once on the under-strand.
  Sort the under-passages by (edge index, position on the edge): u_0 < u_1 < ... < u_{c-1}.  Arc number e
  runs from u_e to u_{e+1} (indices mod c).  A point of the polygon that is not an under-passage lies on
  arc (#{under-passages before it} - 1) mod c.  Crossing with under-passage u_e has incoming arc e-1,
  outgoing arc e and over-arc (the arc of its over-passage); its Fox equation is
  2*x_over - x_{e-1} - x_e = 0 (mod 7).
-/
import Len52.Spec

namespace Len52

structure P2 where
  a : Int
  b : Int
deriving DecidableEq, Repr

def proj (D v : V3) : P2 := ⟨D.z * v.x - D.x * v.z, D.z * v.y - D.y * v.z⟩
def height (D v : V3) : Int := D.x * v.x + D.y * v.y + D.z * v.z

def cross2 (r s : P2) : Int := r.a * s.b - r.b * s.a
def dot2 (r s : P2) : Int := r.a * s.a + r.b * s.b
def sub2 (p q : P2) : P2 := ⟨p.a - q.a, p.b - q.b⟩

/-- a point on edge `e` at parameter `num / den` (den > 0) -/
structure EPt where
  e : Nat
  num : Int
  den : Int
deriving DecidableEq, Repr

/-- strict order of positions along the walk -/
def EPt.lt (p q : EPt) : Bool := p.e < q.e || (p.e == q.e && p.num * q.den < q.num * p.den)

structure Crossing where
  under : EPt
  over : EPt
  /-- the crossing point, as (X, Y) / den with den > 0 -/
  X : Int
  Y : Int
  den : Int
deriving Repr

/-- result of examining two edges: they do not meet, they cross (with data), or the projection is
    not regular -/
inductive PairRes where
  | none
  | crossing (c : Crossing)
  | bad

/-- examine the images of edge i (p1 -> p2, heights h1 -> h2) and edge j (q1 -> q2, heights g1 -> g2)
    of two edges that share no vertex -/
def examine (i j : Nat) (p1 p2 q1 q2 : P2) (h1 h2 g1 g2 : Int) : PairRes :=
  let r := sub2 p2 p1
  let s := sub2 q2 q1
  let qp := sub2 q1 p1
  let den0 := cross2 r s
  if den0 = 0 then
    -- parallel images: regular only if they are disjoint
    if cross2 qp r ≠ 0 then .none
    else
      -- collinear: positions of q1, q2 along r, in units of dot2 r r (> 0)
      let rr := dot2 r r
      let t0 := dot2 qp r
      let t1 := dot2 (sub2 q2 p1) r
      let lo := min t0 t1
      let hi := max t0 t1
      if hi < 0 ∨ lo > rr then .none else .bad
  else
    let sg : Int := if den0 > 0 then 1 else -1
    let den := den0 * sg
    let tn := cross2 qp s * sg     -- t = tn / den on edge i
    let un := cross2 qp r * sg     -- u = un / den on edge j
    if tn < 0 ∨ tn > den ∨ un < 0 ∨ un > den then .none
    else if tn = 0 ∨ tn = den ∨ un = 0 ∨ un = den then .bad
    else
      let hi := h1 * den + tn * (h2 - h1)      -- den * (height of edge i at the crossing)
      let hj := g1 * den + un * (g2 - g1)
      let X := p1.a * den + tn * r.a
      let Y := p1.b * den + tn * r.b
      if hi = hj then .bad
      else if hi < hj then .crossing ⟨⟨i, tn, den⟩, ⟨j, un, den⟩, X, Y, den⟩
      else .crossing ⟨⟨j, un, den⟩, ⟨i, tn, den⟩, X, Y, den⟩

/-- the images of the n edges: edge i runs from vertex i to vertex i+1 (mod n) -/
def edgeData (D : V3) (w : List Nat) : List (P2 × P2 × Int × Int) :=
  let vs := vset w
  let n := vs.length
  (List.range n).map fun i =>
    let a := vs.getD i 0
    let b := vs.getD ((i + 1) % n) 0
    (proj D a, proj D b, height D a, height D b)

/-- all pairs (i, j), i < j, of edges that share no vertex -/
def nonAdjPairs (n : Nat) : List (Nat × Nat) :=
  (List.range n).flatMap fun i =>
    ((List.range n).filter fun j => i < j ∧ j ≠ i + 1 ∧ ¬ (i = 0 ∧ j = n - 1)).map fun j => (i, j)

def samePoint (c d : Crossing) : Bool := c.X * d.den == d.X * c.den && c.Y * d.den == d.Y * c.den

/-- the crossings of the diagram, or `none` if the projection is not regular -/
def diagram (D : V3) (w : List Nat) : Option (List Crossing) := Id.run do
  if D.x = 0 ∨ D.y = 0 ∨ D.z = 0 then return none
  let ed := edgeData D w
  let n := ed.length
  -- edges sharing a vertex: consecutive edges i, i+1 (mod n) must not have opposite images
  for i in List.range n do
    let (p1, p2, _, _) := ed.getD i (⟨0,0⟩, ⟨0,0⟩, 0, 0)
    let (q1, q2, _, _) := ed.getD ((i + 1) % n) (⟨0,0⟩, ⟨0,0⟩, 0, 0)
    let r := sub2 p2 p1
    let s := sub2 q2 q1
    if r = ⟨0, 0⟩ ∨ (cross2 r s = 0 ∧ dot2 r s ≤ 0) then return none
  let mut cs : List Crossing := []
  for (i, j) in nonAdjPairs n do
    let (p1, p2, h1, h2) := ed.getD i (⟨0,0⟩, ⟨0,0⟩, 0, 0)
    let (q1, q2, g1, g2) := ed.getD j (⟨0,0⟩, ⟨0,0⟩, 0, 0)
    match examine i j p1 p2 q1 q2 h1 h2 g1 g2 with
    | .none => pure ()
    | .bad => return none
    | .crossing c =>
      if cs.any (samePoint c) then return none
      cs := cs ++ [c]
  return some cs

/-- under-passages sorted along the walk -/
def underSorted (cs : List Crossing) : List EPt :=
  (cs.map (·.under)).mergeSort (fun p q => !(EPt.lt q p))

/-- index of an under-passage in the sorted list -/
def idxOf (us : List EPt) (p : EPt) : Nat := us.findIdx (· == p)

/-- arc containing a point that is not an under-passage -/
def arcAt (us : List EPt) (p : EPt) : Nat :=
  let k := (us.filter (fun q => EPt.lt q p)).length
  (k + us.length - 1) % us.length

/-- coefficient vector of length c with value v added at position a -/
def bump (c a : Nat) (v : Int) (row : List Int) : List Int :=
  (List.range c).map fun k => row.getD k 0 + (if k = a then v else 0)

/-- the Fox equations, one row (of length c = number of arcs = number of crossings) per crossing -/
def foxRows (cs : List Crossing) : List (List Int) :=
  let us := underSorted cs
  let c := cs.length
  cs.map fun cr =>
    let e := idxOf us cr.under
    let o := arcAt us cr.over
    bump c o 2 (bump c ((e + c - 1) % c) (-1) (bump c e (-1) (List.replicate c 0)))

def dotI (r : List Int) (x : List Nat) : Int :=
  (List.zipWith (fun (a : Int) (b : Nat) => a * (b : Int)) r x).foldl (· + ·) 0

/-- the diagram of w under D is regular and has a Fox 7-colouring that is not constant -/
def HasNontrivialColoring (D : V3) (w : List Nat) : Prop :=
  ∃ cs, diagram D w = some cs ∧
    ∃ x : List Nat, x.length = cs.length ∧ (∀ a ∈ x, a < 7) ∧
      (∀ r ∈ foxRows cs, dotI r x % 7 = 0) ∧
      ∃ i j, ∃ (hi : i < x.length) (hj : j < x.length), x[i] ≠ x[j]

end Len52
