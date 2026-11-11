import json, sys, warnings; warnings.filterwarnings('ignore')
import os; sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))  # run from MA498-Knots root: python code/validate_rechnitzer.py
import latticeknot as lk, numpy as np
raw = json.load(open('data/rechnitzer_SC_raw.json'))
from database_knotinfo import link_list
ki = {r['name']: r for r in link_list()}
rows=[]; bad=[]
for name,s in raw.items():
    start, w = s.split(':')
    v=[tuple(map(int,start.split(',')))]
    for ch in w[:-1]:
        v.append(tuple(np.add(v[-1], lk.DIRS[ch])))
    ok = lk.is_lattice_polygon([v]) and tuple(np.add(v[-1], lk.DIRS[w[-1]]))==v[0]
    if not ok: bad.append((name,'not a closed SAP')); continue
    r = lk.identify([v])
    c = int(name.split('_')[0])
    exp = ki.get(name, {})
    g_exp = exp.get('three_genus')
    flag=[]
    if r['crossings'] < c: flag.append(f"simplified to {r['crossings']} crossings")
    if r.get('genus') is not None and g_exp not in (None,'') and str(r['genus'])!=str(g_exp): flag.append(f"genus {r['genus']} vs {g_exp}")
    ids = r.get('snappy_identify',[])
    if ids and not any(x.startswith(name+'(') or x.startswith(f"K{c}") for x in ids):
        # census names like K8a1 aren't Rolfsen; check Rolfsen form present when c<=10
        if not any('_' in x and x.split('(')[0]==name for x in ids): flag.append('identify:'+','.join(ids[:3]))
    if flag: bad.append((name,'; '.join(flag)))
    rows.append((name, len(w), r['crossings'], r.get('genus'), ';'.join(ids[:2])))
print(len(rows),'ok;', len(bad),'flagged'); [print(b) for b in bad]
json.dump({n:{'length':L,'start':raw[n].split(':')[0],'word':raw[n].split(':')[1]} for n,L,*_ in rows}, open('data/rechnitzer_SC_minimal.json','w'), indent=0)
import collections; print(sorted(collections.Counter(L for _,L,*_ in rows).items()))
