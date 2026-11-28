import pickle, time
from qd import *
from collections import Counter
names,Q,C=pickle.load(open('fam.pkl','rb'))
chosen=[(15,2),(7,6),(5,4),(7,2),(13,12),(9,2),(11,3),(13,2)]
def inv(n,t): return pow(t,-1,n)
full=chosen+[(n,inv(n,t)) for n,t in chosen if (n,inv(n,t)) not in chosen]
tv={}
for k in ['7_1','7_2','7_3','7_4','7_5','7_6','7_7','8_20','8_19']:
    tv[k]=set([tuple(C[k][q] for q in full), tuple(C[k][(q[0],inv(*q))] for q in full)])
words=[l.strip() for l in open('/home/user/-K-NOT_THEORY/research/exact/dmon2/bench/ci/r6_n42_F/F_n42.words.txt') if l.strip()]
vecs=Counter(); bad=0
t0=time.time()
for w in words:
    try: na,rels=diagram(w)
    except ValueError: bad+=1; continue
    vecs[tuple(count(na,rels,*q) for q in full)]+=1
print(time.time()-t0,'bad',bad,'distinct vectors',len(vecs))
for v,c in vecs.items(): print(c,v)
for k,s in tv.items():
    print(k,'collides with survivors' if any(v in vecs for v in s) else 'separated from all survivors')
print('hit 8_19 vecs (K=8_19 excluded since it is a survivor type at n=42):')
