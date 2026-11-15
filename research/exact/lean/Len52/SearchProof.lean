/-
  Len52.SearchProof — completeness of the search program (PROOF_RIGOROUS.md, Theorem 5.1):
  every word with `Survive` of length at most 34 is in the output of the part of the search that
  its 9-letter prefix belongs to.

  The proof follows section 5: along such a word w no test of `dfs` fails.  The auxiliary files are
    SP/Basic   packing of points, the allowed table, the occupancy array
    SP/Walk    steps, distances and total variation of the walk of w
    SP/Prefix  canonical values of the search state (last/first letters, counts, positions); S1, S2
    SP/Code    equation lemmas for dfs/searchPart; dfs returns its array unchanged, outputs only grow
    SP/Obl     curtainOb, cornerSite, avail, fine, spanNeed
    SP/Update  `update` returns the obligations of invariant (I) (curtains S9, corners S10, S11, S12)
    SP/Leaf    the final tests L1-L3
    SP/Main    the induction over the depth-first search and the top-level loop
-/
import Len52.SP.Main

namespace Len52.Search

theorem search_complete (w : List Nat) (hS : Survive w) (hN : w.length ≤ 34)
    (M r : Nat) (hM : 0 < M)
    (hr : w.length ≤ 9 ∨ r = key ((w.take 9).reverse) % M) :
    w ∈ (searchPart w.length 9 M r).out :=
  Len52.SP.search_complete_aux hS hN M r hr

/-- every word with Survive is found by one of the parts r = 0, ..., M-1 -/
theorem search_complete_parts (w : List Nat) (hS : Survive w) (hN : w.length ≤ 34) (M : Nat)
    (hM : 0 < M) : ∃ r, r < M ∧ w ∈ (searchPart w.length 9 M r).out :=
  ⟨key ((w.take 9).reverse) % M, Nat.mod_lt _ hM,
    search_complete w hS hN M _ hM (Or.inr rfl)⟩

end Len52.Search
