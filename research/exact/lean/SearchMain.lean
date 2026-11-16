import Len52.Search
open Len52.Search

def letters (w : List Nat) : String := String.mk (w.map fun d => "ewnsud".toList.getD d '?')

/-- usage: search N SPLIT M R  — prints the node count to stderr and the surviving words to stdout -/
def main (args : List String) : IO Unit := do
  match args.map String.toNat! with
  | [N, sp, M, r] =>
    let acc := searchPart N sp M r
    IO.eprintln s!"N={N} split={sp} part={r}/{M} nodes={acc.nodes} candidates={acc.out.length}"
    let ws := (acc.out.map letters).toArray.qsort (· < ·)
    for w in ws do IO.println w
  | _ => IO.eprintln "usage: search N SPLIT M R"
