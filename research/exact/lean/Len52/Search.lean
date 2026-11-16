/-
  Len52.Search — the enumerator.  For an even length N it visits, in depth-first order, every walk from
  the origin that could be a prefix of a word satisfying `Survive` (Spec.lean), and returns the closed
  words that pass the final tests.  Completeness (every word with `Survive` is returned) is proved in
  SearchProof.lean.  The program is a line-by-line equivalent of research/exact/enum.cpp run with
  `-tourcap 0 -nomst -noreduce` (same tests in the same order: identical node counts and outputs).

  Points are packed into natural numbers: (x, y, z) with |x|, |y| <= 31, -3 <= z <= 28 is stored as
  (x + 32) + 64 (y + 32) + 4096 (z + 3).
-/
import Len52.Spec

namespace Len52.Search

def NS : Nat := 64 * 64 * 32
def ORG : Nat := 32 + 64 * 32 + 4096 * 3

@[inline] def cx (p : Nat) : Int := ((p % 64 : Nat) : Int) - 32
@[inline] def cy (p : Nat) : Int := (((p / 64) % 64 : Nat) : Int) - 32
@[inline] def cz (p : Nat) : Int := ((p / 4096 : Nat) : Int) - 3

/-- one unit step in direction d (0..5 = e w n s u d) -/
@[inline] def mv (p d : Nat) : Nat :=
  match d with
  | 0 => p + 1 | 1 => p - 1 | 2 => p + 64 | 3 => p - 64 | 4 => p + 4096 | _ => p - 4096

/-- one unit step against direction d -/
@[inline] def back (p d : Nat) : Nat := mv p (Len52.rev d)

@[inline] def absd (a b : Nat) : Nat := if a ≤ b then b - a else a - b

/-- Manhattan distance of two packed points -/
@[inline] def mdist (a b : Nat) : Nat :=
  absd (a % 64) (b % 64) + absd ((a / 64) % 64) ((b / 64) % 64) + absd (a / 4096) (b / 4096)

@[inline] def dist0 (p : Nat) : Nat := mdist p ORG

/-- the points a vertex other than the origin may occupy: greater than the origin in (z, y, x) order,
    and inside the box |x|, |y| <= 24, z <= 24 (every vertex of a polygon of length <= 48 through the
    origin lies in it) -/
def allowedB (p : Nat) : Bool :=
  decide (p < NS) &&
  (decide (cz p > 0) || (decide (cz p = 0) && (decide (cy p > 0) || (decide (cy p = 0) && decide (cx p > 0))))) &&
  decide ((cx p).natAbs ≤ 24) && decide ((cy p).natAbs ≤ 24) && decide (cz p ≤ 24)

def allowedTab : Array Bool := Array.ofFn (n := NS) fun i => allowedB i.val

@[inline] def allowed (p : Nat) : Bool := allowedTab.getD p false

@[inline] def occAt (occ : Array Bool) (p : Nat) : Bool := occ.getD p false

/-- information about the last (or first) letter along one axis: (index, direction) -/
abbrev AxI := Option (Nat × Nat)

structure Axes where
  a0 : AxI
  a1 : AxI
  a2 : AxI

@[inline] def Axes.get (x : Axes) (A : Nat) : AxI := match A with | 0 => x.a0 | 1 => x.a1 | _ => x.a2
@[inline] def Axes.set (x : Axes) (A : Nat) (v : AxI) : Axes :=
  match A with | 0 => { x with a0 := v } | 1 => { x with a1 := v } | _ => { x with a2 := v }

structure Cnt where
  x : Nat
  y : Nat
  z : Nat

@[inline] def Cnt.inc (c : Cnt) (A : Nat) : Cnt :=
  match A with | 0 => { c with x := c.x + 1 } | 1 => { c with y := c.y + 1 } | _ => { c with z := c.z + 1 }

/-- an obligation: a list of sites, one of which must become a vertex -/
abbrev Ob := List Nat

/-- Curtain obligation.  `sites` are the points v_j - a for the interior vertices of the curtain.
    Result: `none` = some site is already a vertex (satisfied); `some []` = no site may ever become a
    vertex (the prefix is dead); `some l` = pending, l = the sites that may still become vertices. -/
def curtainOb (occ : Array Bool) (a : Nat) : List Nat → Option Ob
  | [] => some []
  | q :: qs =>
    let s := back q a
    if occAt occ s then none
    else match curtainOb occ a qs with
      | none => none
      | some l => some (if allowed s then s :: l else l)

/-- the walk from `fr` to the origin through all single-site obligations must cover, on each axis, the
    span of those sites, the start and the origin -/
def spanNeed (fr : Nat) (pl : List Ob) : Nat :=
  let rec go (pl : List Ob) (lx hx ly hy lz hz : Int) : Nat :=
    match pl with
    | [] =>
      let f := fun (c lo hi : Int) =>
        let l := min lo c
        let h := max hi c
        min ((c - l) + (h - l) + h) ((h - c) + (h - l) + (0 - l))
      (f (cx fr) lx hx + f (cy fr) ly hy + f (cz fr) lz hz).toNat
    | [s] :: rest => go rest (min lx (cx s)) (max hx (cx s)) (min ly (cy s)) (max hy (cy s))
                          (min lz (cz s)) (max hz (cz s))
    | _ :: rest => go rest lx hx ly hy lz hz
  go pl 0 0 0 0 0 0

/-- number of neighbours of s that are free and allowed, or the head, or the origin -/
@[inline] def usable (occ : Array Bool) (nx w : Nat) : Nat :=
  if w == nx || w == ORG || (!occAt occ w && allowed w) then 1 else 0

def avail (occ : Array Bool) (nx s : Nat) : Nat :=
  usable occ nx (mv s 0) + usable occ nx (mv s 1) + usable occ nx (mv s 2) +
  usable occ nx (mv s 3) + usable occ nx (mv s 4) + usable occ nx (mv s 5)

/-- an obligation can still be met: one of its sites is within reach and has two usable neighbours -/
def fine (occ : Array Bool) (nx R1 : Nat) (ob : Ob) : Bool :=
  ob.any fun s => decide (mdist nx s + dist0 s ≤ R1) && decide (2 ≤ avail occ nx s)

/-- the corner site created by the letters p (previous) and d (current) at the head `nx`, whose
    previous position is `pp` -/
def cornerSite (p d pp nx : Nat) : Option Nat :=
  if p == 4 && d < 4 then some (mv pp d)
  else if d == 5 && p < 4 then some (back nx p)
  else if p == 2 && d < 2 then some (mv pp d)
  else if d == 3 && p < 2 then some (back nx p)
  else none

/-- The obligations after step i (direction d, new head nx, `occ` already contains nx).
    `revPos` = positions v_{i+1} (= nx), v_i, ..., v_0; `prev` = the letter before d (if i >= 1);
    `sl` = the last letter on the axis of d before this one.  `none` = the prefix is dead. -/
def update (occ : Array Bool) (pend : List Ob) (i d nx : Nat) (revPos : List Nat) (prev : Option Nat)
    (sl : AxI) (R1 : Nat) : Option (List Ob) :=
  let nw0 := pend.filter fun ob => !(ob.contains nx)
  let r1 : Option (List Ob) :=
    match sl with
    | some (j, a) =>
      if a == Len52.rev d then
        match curtainOb occ a ((revPos.drop 2).take (i - j - 1 - 1)) with
        | none => some nw0
        | some [] => none
        | some l => some (nw0 ++ [l])
      else some nw0
    | none => some nw0
  match r1 with
  | none => none
  | some nw1 =>
    let r2 : Option (List Ob) :=
      match prev with
      | none => some nw1
      | some p =>
        match cornerSite p d (revPos.getD 2 0) nx with
        | none => some nw1
        | some s => if occAt occ s then some nw1 else if allowed s then some (nw1 ++ [[s]]) else none
    match r2 with
    | none => none
    | some nw =>
      if nw.all (fine occ nx R1) then
        if 2 ≤ nw.length && R1 < spanNeed nx nw then none else some nw
      else none

/-- tests at a closed walk; `pos` = v_0, ..., v_{N-1} and `ds` = all N letters -/
def leafOk (occ : Array Bool) (N : Nat) (pos ds : List Nat) (last first : Axes) (c : Cnt) : Bool :=
  let dd := fun j => ds.getD j 0
  let wrap := fun (A : Nat) =>
    match last.get A, first.get A with
    | some (jl, al), some (jf, af) =>
      if al == Len52.rev af then
        let k := (N - jl - 1) + jf
        -- sites v_{jl+t} - a, t = 2..k (indices mod N)
        let qs := (List.range (k - 1)).map fun t => pos.getD ((jl + t + 2) % N) 0
        match curtainOb occ al qs with
        | none => true
        | _ => false
      else true
    | _, _ => true
  !(dd 0 == Len52.rev (dd (N - 2))) && !(dd 1 == Len52.rev (dd (N - 1))) &&
  wrap 0 && wrap 1 && wrap 2 && decide (c.z ≤ c.y) && decide (c.y ≤ c.x)

structure Acc where
  nodes : Nat
  out : List (List Nat)

/-- the key of a prefix, used to split the search into parts -/
def key (revDirs : List Nat) : Nat := revDirs.foldr (fun d acc => acc * 6 + d) 0

structure Cfg where
  N : Nat
  split : Nat
  M : Nat
  r : Nat

/-- Depth-first search below a prefix of length i >= 1, argument fuel = N - i (remaining steps).
    `revPos` = v_i, ..., v_0 (packed), `revDirs` = letters i-1, ..., 0.
    Returns the occupancy array (restored to its input value) and the accumulator. -/
def dfs (cfg : Cfg) : (fuel : Nat) → (occ : Array Bool) → (i : Nat) → (revPos revDirs : List Nat) →
    (last first : Axes) → (c : Cnt) → (pend : List Ob) → (acc : Acc) → Array Bool × Acc
  | 0, occ, _, _, _, _, _, _, _, acc => (occ, acc)
  | fuel + 1, occ, i, revPos, revDirs, last, first, c, pend, acc =>
    let cur := revPos.headD 0
    let p1 := Len52.rev (revDirs.headD 0)
    let p2 : Option Nat := match revDirs with | _ :: q :: _ => some (Len52.rev q) | _ => none
    [0, 1, 2, 3, 4, 5].foldl (fun (sa : Array Bool × Acc) (d : Nat) =>
      let occ := sa.1
      let acc := sa.2
      if d == p1 || p2 == some d then (occ, acc)
      else
        let nx := mv cur d
        let A := axis d
        if fuel == 0 then
          -- last step: must close the walk at the origin
          if nx != ORG || Len52.rev d ≤ revDirs.getLast?.getD 0 then (occ, acc)
          else
            let acc := { acc with nodes := acc.nodes + 1 }
            let revDirs' := d :: revDirs
            let last' := last.set A (some (i, d))
            let first' := match first.get A with | none => first.set A (some (i, d)) | _ => first
            match update occ pend i d nx (nx :: revPos) revDirs.head? (last.get A) 0 with
            | none => (occ, acc)
            | some _ =>
              if leafOk occ cfg.N revPos.reverse revDirs'.reverse last' first' (c.inc A) then
                (occ, { acc with out := revDirs'.reverse :: acc.out })
              else (occ, acc)
        else if occAt occ nx || !allowed nx || fuel < dist0 nx then (occ, acc)
        else
          let c' := c.inc A
          if cfg.N < 2 * max c'.y c'.z + c'.z || c'.y + fuel < c'.z || c'.x + fuel < c'.y then (occ, acc)
          else
            let acc := { acc with nodes := acc.nodes + 1 }
            let occ1 := occ.set! nx true
            let revPos' := nx :: revPos
            let revDirs' := d :: revDirs
            let last' := last.set A (some (i, d))
            let first' := match first.get A with | none => first.set A (some (i, d)) | _ => first
            let res :=
              match update occ1 pend i d nx revPos' revDirs.head? (last.get A) fuel with
              | none => (occ1, acc)
              | some nw =>
                if i + 1 == cfg.split && key revDirs' % cfg.M != cfg.r then (occ1, acc)
                else dfs cfg fuel occ1 (i + 1) revPos' revDirs' last' first' c' nw acc
            (res.1.set! nx false, res.2)) (occ, acc)

/-- the whole search for length N, part r of M (split at prefix length `split`) -/
def searchPart (N split M r : Nat) : Acc := Id.run do
  let cfg : Cfg := ⟨N, split, M, r⟩
  let occ0 := (Array.replicate NS false).set! ORG true
  let mut occ := occ0
  let mut acc : Acc := ⟨0, []⟩
  for d in [0, 1, 2, 3, 4, 5] do
    let nx := mv ORG d
    if !allowed nx || d == 4 then continue
    acc := { acc with nodes := acc.nodes + 1 }
    let A := axis d
    let e : Axes := ⟨none, none, none⟩
    let ax := e.set A (some (0, d))
    let c : Cnt := (⟨0, 0, 0⟩ : Cnt).inc A
    let (o, a) := dfs cfg (N - 1) (occ.set! nx true) 1 [nx, ORG] [d] ax ax c [] acc
    occ := o.set! nx false
    acc := a
  return acc

end Len52.Search
