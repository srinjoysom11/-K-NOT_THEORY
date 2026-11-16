"""Check that kernel/pass preserves the knot: exact, chirality-sensitive HOMFLY-PT before vs after.

    kernel/pass [options] < in.txt > out.txt
    python census/ml/check_pass.py in.txt out.txt

in.txt lines: name n pd...   out.txt lines: name n_in n_out pd...   (n_out = 0 means the unknot)
Prints the number of HOMFLY mismatches (must be 0) and how many diagrams got smaller."""
import sys, regina

def link(tok, n):
    if n == 0:
        return regina.Link(1)
    v = list(map(int, tok))
    return regina.Link.fromPD([tuple(v[4 * i:4 * i + 4]) for i in range(n)])

ins = [l.split() for l in open(sys.argv[1])]
outs = [l.split() for l in open(sys.argv[2])]
assert len(ins) == len(outs), "input/output length differ"
bad = smaller = same = larger = 0
for a, b in zip(ins, outs):
    n_in, n_out = int(a[1]), int(b[2])
    if str(link(a[2:], n_in).homfly()) != str(link(b[3:], n_out).homfly()):
        bad += 1
    smaller += n_out < n_in; same += n_out == n_in; larger += n_out > n_in
print(f"{len(ins)} diagrams | HOMFLY mismatches: {bad} | fewer crossings: {smaller}, same: {same}, more: {larger}")
sys.exit(1 if bad else 0)
