/-
  Len52.Spec — definitions for the proof that no lattice polygon of the knot type 5_2 has fewer than
  36 edges.  Plain Lean 4 (no Mathlib).  Everything a reader must trust about the *statement* is in this
  file; every other file only proves things about these definitions.

  Conventions.
  * A direction is a natural number 0..5 standing for e, w, n, s, u, d = +x, -x, +y, -y, +z, -z.
  * A word `w : List Nat` describes the closed walk that starts at the origin and takes the unit steps
    `w[0], w[1], ...`.  Its vertices are `v_0 = 0, v_1, ..., v_n` (`n = w.length`).
  * `IsPolygon w`: n >= 4, every letter is a direction, the walk returns to the origin and
    v_0, ..., v_{n-1} are pairwise distinct.  Such a word is a simple closed lattice polygon (the union of
    its unit edges is a tame knot in R^3).
-/

namespace Len52

/-! ## Points of Z^3 -/

structure V3 where
  x : Int
  y : Int
  z : Int
deriving DecidableEq, Repr

instance : Add V3 := ⟨fun a b => ⟨a.x + b.x, a.y + b.y, a.z + b.z⟩⟩
instance : Sub V3 := ⟨fun a b => ⟨a.x - b.x, a.y - b.y, a.z - b.z⟩⟩
instance : OfNat V3 0 := ⟨⟨0, 0, 0⟩⟩

@[simp] theorem V3.add_x (a b : V3) : (a + b).x = a.x + b.x := rfl
@[simp] theorem V3.add_y (a b : V3) : (a + b).y = a.y + b.y := rfl
@[simp] theorem V3.add_z (a b : V3) : (a + b).z = a.z + b.z := rfl
@[simp] theorem V3.sub_x (a b : V3) : (a - b).x = a.x - b.x := rfl
@[simp] theorem V3.sub_y (a b : V3) : (a - b).y = a.y - b.y := rfl
@[simp] theorem V3.sub_z (a b : V3) : (a - b).z = a.z - b.z := rfl
@[simp] theorem V3.zero_x : (0 : V3).x = 0 := rfl
@[simp] theorem V3.zero_y : (0 : V3).y = 0 := rfl
@[simp] theorem V3.zero_z : (0 : V3).z = 0 := rfl

/-! ## Directions -/

/-- the unit vector of direction `d` (e w n s u d) -/
def unit : Nat → V3
  | 0 => ⟨1, 0, 0⟩
  | 1 => ⟨-1, 0, 0⟩
  | 2 => ⟨0, 1, 0⟩
  | 3 => ⟨0, -1, 0⟩
  | 4 => ⟨0, 0, 1⟩
  | _ => ⟨0, 0, -1⟩

/-- the axis of a direction: 0 = x, 1 = y, 2 = z -/
def axis (d : Nat) : Nat := d / 2

/-- the opposite direction -/
def rev (d : Nat) : Nat := if d % 2 = 0 then d + 1 else d - 1

/-! ## Words and their vertices -/

/-- the vertices of the walk that starts at v and takes the steps of the word -/
def vertsFrom (v : V3) : List Nat → List V3
  | [] => [v]
  | d :: ds => v :: vertsFrom (v + unit d) ds

/-- the vertices v_0, ..., v_n of the walk (length n + 1) -/
def verts (w : List Nat) : List V3 := vertsFrom 0 w

/-- vertex number i (v_i), for i <= n -/
def vtx (w : List Nat) (i : Nat) : V3 := (verts w).getD i 0

/-- the vertex set v_0, ..., v_{n-1} -/
def vset (w : List Nat) : List V3 := (verts w).take w.length

/-- letter number i (only used with i < n) -/
def dir (w : List Nat) (i : Nat) : Nat := w.getD i 0

def IsPolygon (w : List Nat) : Prop :=
  4 ≤ w.length ∧ (∀ d ∈ w, d < 6) ∧ vtx w w.length = 0 ∧ (vset w).Nodup

/-! ## The conditions satisfied by the chosen shortest polygon (PROOF, sections 3-5) -/

/-- v is greater than the origin in the order (z, then y, then x) -/
def LexPos (v : V3) : Prop := v.z > 0 ∨ (v.z = 0 ∧ (v.y > 0 ∨ (v.y = 0 ∧ v.x > 0)))

/-- the number of letters of w along axis A -/
def countAxis (A : Nat) (w : List Nat) : Nat := (w.filter (fun d => axis d == A)).length

/-- Curtain condition (cyclic).  If letter i has direction a, the next k >= 1 letters (cyclically) are
    perpendicular to a and the letter after them is -a, then one of the points v_{i+j} - a,
    2 <= j <= k, is a vertex. -/
def CurtainOK (w : List Nat) : Prop :=
  ∀ i k, i < w.length → 1 ≤ k → k + 2 ≤ w.length →
    (∀ t, 1 ≤ t → t ≤ k → axis (dir w ((i + t) % w.length)) ≠ axis (dir w i)) →
    dir w ((i + k + 1) % w.length) = rev (dir w i) →
    ∃ j, 2 ≤ j ∧ j ≤ k ∧ vtx w ((i + j) % w.length) - unit (dir w i) ∈ vset w

/-- Corner conditions at the vertices v_1, ..., v_{n-1} (pushed-down normal form). -/
def CornerOK (w : List Nat) : Prop :=
  ∀ i, 1 ≤ i → i < w.length →
    (dir w (i - 1) = 4 → dir w i < 4 → vtx w (i - 1) + unit (dir w i) ∈ vset w) ∧
    (dir w i = 5 → dir w (i - 1) < 4 → vtx w (i + 1) - unit (dir w (i - 1)) ∈ vset w) ∧
    (dir w (i - 1) = 2 → dir w i < 2 → vtx w (i - 1) + unit (dir w i) ∈ vset w) ∧
    (dir w i = 3 → dir w (i - 1) < 2 → vtx w (i + 1) - unit (dir w (i - 1)) ∈ vset w)

def Survive (w : List Nat) : Prop :=
  IsPolygon w ∧
  (∀ i, 1 ≤ i → i < w.length → LexPos (vtx w i)) ∧
  dir w 0 < rev (dir w (w.length - 1)) ∧
  (countAxis 2 w ≤ countAxis 1 w ∧ countAxis 1 w ≤ countAxis 0 w) ∧
  CurtainOK w ∧
  CornerOK w

/-! ## Elementary moves -/

/-- start the same cycle at v_1 (the polygon is translated by -v_1) -/
def rotate1 : List Nat → List Nat
  | [] => []
  | d :: ds => ds ++ [d]

/-- the same cycle traversed backwards from v_0 -/
def revWord (w : List Nat) : List Nat := (w.map rev).reverse

/-- a lattice symmetry acting on direction codes: a bijection of {0..5} commuting with `rev`.
    (These are exactly the 48 signed permutation matrices.) -/
def IsSym (f : Nat → Nat) : Prop :=
  (∀ d, d < 6 → f d < 6) ∧ (∀ a b, a < 6 → b < 6 → f a = f b → a = b) ∧
  (∀ d, d < 6 → f (rev d) = rev (f d))

/-- corner flip at vertex i (1 <= i < n): exchange letters i-1 and i -/
def swapAt (w : List Nat) (i : Nat) : List Nat :=
  (w.set (i - 1) (dir w i)).set i (dir w (i - 1))

/-- removal of a U-turn a, b, -a at letters i, i+1, i+2: the three letters become b -/
def removeUturn (w : List Nat) (i : Nat) : List Nat :=
  w.take i ++ [dir w (i + 1)] ++ w.drop (i + 3)

/-- The properties of the class of words whose polygons have one of the knot types in question
    (5_2 or its mirror image).  Each field is a standard fact of knot theory, proved in PROOF_RIGOROUS.md
    section 2 (they say: rotation, reversal and translation do not change the polygon; a lattice symmetry
    maps a knot to itself or its mirror image; a corner flip and a U-turn removal are isotopies across a
    unit square that meets the polygon only in the replaced edges). -/
structure KnotClass (T : List Nat → Prop) : Prop where
  polygon : ∀ w, T w → IsPolygon w
  rot : ∀ w, T w → T (rotate1 w)
  reverse : ∀ w, T w → T (revWord w)
  sym : ∀ f w, IsSym f → T w → T (w.map f)
  flip : ∀ w i, T w → 1 ≤ i → i < w.length → axis (dir w (i - 1)) ≠ axis (dir w i) →
    vtx w (i - 1) + unit (dir w i) ∉ vset w → T (swapAt w i)
  uturn : ∀ w i, T w → 6 ≤ w.length → i + 3 ≤ w.length →
    axis (dir w (i + 1)) ≠ axis (dir w i) → dir w (i + 2) = rev (dir w i) → T (removeUturn w i)

end Len52
