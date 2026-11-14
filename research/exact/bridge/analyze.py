# Merge Len data (3-10 crossings CSV + 11-crossing v3 table) with KnotInfo bridge indices.
# Run: python3 -I analyze.py   (requires database_knotinfo)
import csv, collections
from database_knotinfo import link_list

BASE = '/home/user/-K-NOT_THEORY'
OUT = BASE + '/research/exact/bridge/'

ki = {r['name']: r for r in link_list()[1:]}

recs = []  # (knot_name, source_name, crossings, Len, source_file)
for r in csv.DictReader(open(BASE + '/data/rechnitzer_SC_minimal.csv')):
    recs.append((r['knot'], r['knot'], int(r['crossings']), int(r['best_known_length']),
                 'rechnitzer_SC_minimal.csv'))
for r in csv.DictReader(open(OUT + 'table11_v3.csv')):
    src = r['knot']                                  # e.g. K11a1
    name = '11' + src[3] + '_' + src[4:]             # -> 11a_1
    vals = [int(r[k]) for k in ('len_round1', 'len_round2', 'len_round3') if r[k].strip()]
    L = min(vals)
    assert L == int(r['len_round3']) == len(r['word']), src
    recs.append((name, src, 11, L, 'table_11_crossings_v3.csv'))

rows, unmatched = [], []
for knot, src, cr, L, f in recs:
    k = ki.get(knot)
    if k is None or not k['bridge_index'].strip():
        unmatched.append((src, knot, f)); continue
    if int(k['crossing_number']) != cr:
        raise SystemExit('crossing mismatch ' + knot)
    b = int(k['bridge_index'])
    rows.append(dict(knot=knot, source_name=src, crossings=cr, bridge_index=b, Len=L,
                     slack16=L - (16 * b - 8), slack12=L - 12 * b, len_source=f))

with open(OUT + 'len_vs_bridge.csv', 'w', newline='') as fh:
    w = csv.DictWriter(fh, fieldnames=list(rows[0].keys()))
    w.writeheader(); w.writerows(rows)

print('total Len records', len(recs), 'matched', len(rows), 'unmatched', len(unmatched))
print('unmatched', unmatched)

print('\n== count per bridge index')
cnt = collections.Counter(r['bridge_index'] for r in rows)
for b in sorted(cnt):
    sub = [r for r in rows if r['bridge_index'] == b]
    m = min(r['Len'] for r in sub)
    att = sorted(r['knot'] for r in sub if r['Len'] == m)
    print('b=%d count=%d minLen=%d attained_by(%d)=%s' % (b, cnt[b], m, len(att), att if len(att) <= 40 else att[:40] + ['...']))

print('\n== slack16 smallest 10')
s16 = sorted(rows, key=lambda r: (r['slack16'], r['knot']))
print('min slack16 =', s16[0]['slack16'])
for r in s16[:10]:
    print(r['knot'], r['bridge_index'], r['Len'], r['slack16'])
print('count slack16<0 :', sum(r['slack16'] < 0 for r in rows))
print('count slack16==0:', sum(r['slack16'] == 0 for r in rows))
print('count slack16<=2:', sum(r['slack16'] <= 2 for r in rows))
print('slack16<=2 list:')
for r in s16:
    if r['slack16'] > 2: break
    print('  ', r['knot'], r['bridge_index'], r['Len'], r['slack16'])

print('\n== slack12')
s12 = sorted(rows, key=lambda r: (r['slack12'], r['knot']))
print('min slack12 =', s12[0]['slack12'])
print('count slack12<0 :', sum(r['slack12'] < 0 for r in rows))
print('count slack12==0:', sum(r['slack12'] == 0 for r in rows))
print('slack12 smallest 10:', [(r['knot'], r['bridge_index'], r['Len'], r['slack12']) for r in s12[:10]])

print('\n== knots with b>=4')
big = [r for r in rows if r['bridge_index'] >= 4]
print('count', len(big))
for r in sorted(big, key=lambda r: (r['bridge_index'], r['Len'], r['knot'])):
    print(r['knot'], r['bridge_index'], r['Len'], r['slack16'])

print('\n== composite data points (hand-entered, not in csv)')
comp = [('3_1 (trefoil)', 2, 24)] + [('%d trefoils' % n, n + 1, L) for n, L in
        zip(range(2, 7), [40, 56, 72, 88, 104])] + [('3_1#4_1', 3, 46), ('4_1#4_1', 3, 52)]
for name, b, L in comp:
    print(name, 'b=%d Len=%d slack16=%d slack12=%d' % (b, L, L - (16 * b - 8), L - 12 * b))
