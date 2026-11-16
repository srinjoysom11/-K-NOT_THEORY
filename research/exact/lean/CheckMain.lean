import Len52.Cert
open Len52 Len52.Search

def letters (w : List Nat) : String := String.mk (w.map fun d => "ewnsud".toList.getD d '?')

/-- usage: checkpart N R
    Evaluates `Len52.checkPart N R` = `(searchPart N 9 (parts N) R).out.all colorCheck`, i.e. part R of
    `parts N` of the search for length N followed by the verified colour test of every returned word.
    Prints the returned words (for cross-checks), then the line
      RESULT n=N r=R m=M nodes=X words=K ok=B
    and exits with status 0 if and only if B = true. -/
def main (args : List String) : IO UInt32 := do
  match args.map String.toNat! with
  | [N, R] =>
    let acc := searchPart N 9 (parts N) R
    let ok := acc.out.all colorCheck          -- = checkPart N R  (checkPart_eq)
    for w in acc.out do IO.println (letters w)
    let line := s!"RESULT n={N} r={R} m={parts N} nodes={acc.nodes} words={acc.out.length} ok={ok}"
    IO.println line
    IO.eprintln line
    return (if ok then 0 else 1)
  | _ => IO.eprintln "usage: checkpart N R"; return 2
