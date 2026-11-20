#!/usr/bin/env python3
"""Sum the paired dmon-bench logs in a directory: nodes/seconds of enum (base) and enum_dmon (new)
per (n, tag), the output verdicts, and the ratios.  Writes SUMMARY.md next to the logs."""
import glob, os, re, sys
d = sys.argv[1]
rows = {}
for f in sorted(glob.glob(d + "/n*_*.part*_*.new.log")):
    g = re.match(r"n(\d+)_(\w+)\.part(\d+)_(\d+)\.new\.log$", os.path.basename(f))
    if not g: continue
    n, tag, r, m = int(g[1]), g[2], int(g[3]), int(g[4])
    new, base = open(f).read(), open(f.replace(".new.log", ".base.log")).read()
    def num(k, t): 
        x = re.search(k + r"=([0-9.]+)", t); return float(x[1]) if x else 0.0
    e = rows.setdefault((n, tag, m), dict(parts=0, bn=0, nn=0, bs=0, ns=0, bw=0, nw=0, ident=0, surv_b=0, surv_n=0))
    e["parts"] += 1; e["bn"] += num("nodes", base); e["nn"] += num("nodes", new)
    e["bs"] += num("seconds", base); e["ns"] += num("seconds", new)
    e["surv_b"] += num("survivors", base); e["surv_n"] += num("survivors", new)
    e["ident"] += "output=IDENTICAL" in new
out = ["| n | tag | parts (of m) | nodes enum | nodes new | node ratio | seconds enum | seconds new | time ratio | survivors enum | survivors new | outputs identical |", "|---|---|---|---|---|---|---|---|---|---|---|---|"]
for (n, tag, m), e in sorted(rows.items()):
    out.append(f"| {n} | {tag} | {e['parts']} of {m} | {e['bn']:.4g} | {e['nn']:.4g} | {e['nn']/max(e['bn'],1):.3f} | {e['bs']:.0f} | {e['ns']:.0f} | {e['ns']/max(e['bs'],1):.3f} | {e['surv_b']:.0f} | {e['surv_n']:.0f} | {e['ident']} of {e['parts']} |")
open(d + "/SUMMARY.md", "w").write("\n".join(out) + "\n")
print("\n".join(out))
