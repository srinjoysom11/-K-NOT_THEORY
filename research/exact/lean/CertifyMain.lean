import Len52.Coloring

/-- usage: certify FILE...  — reads words (letters e w n s u d, one per line) and runs the verified
    `Len52.colorCheck` on each; prints `FAIL <word>` for every failure and a summary line. -/
def letterCode (c : Char) : Nat :=
  match c with | 'e' => 0 | 'w' => 1 | 'n' => 2 | 's' => 3 | 'u' => 4 | 'd' => 5 | _ => 99

def main (files : List String) : IO UInt32 := do
  let mut total := 0
  let mut fails := 0
  for f in files do
    let s ← IO.FS.readFile f
    for line in s.splitOn "\n" do
      let t := line.trim
      if t.isEmpty then continue
      total := total + 1
      let w := t.toList.map letterCode
      if !(Len52.colorCheck w) then
        fails := fails + 1
        IO.println s!"FAIL {t}"
  IO.println s!"certify: words={total} pass={total - fails} fail={fails}"
  return (if fails == 0 then 0 else 1)
