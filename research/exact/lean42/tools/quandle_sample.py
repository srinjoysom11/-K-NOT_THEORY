import random, pickle, time
from qd import *
from math import gcd
names,Q,C=pickle.load(open('fam.pkl','rb'))
chosen=[(15,2),(7,6),(5,4),(7,2),(13,12),(9,2),(11,3),(13,2)]
def inv(n,t): return pow(t,-1,n)
full=chosen+[(n,inv(n,t)) for n,t in chosen if (n,inv(n,t)) not in chosen]
surv=['0_1','3_1','4_1','5_1','5_2','6_1','6_2','6_3','3_1#3_1_w40','3_1#-3_1_w40','8_19']
known={}
for k in surv:
    v=tuple(C[k][q] for q in full)
    known[v]=k
    vm=tuple(C[k][(q[0],inv(*q))] for q in full)
    known.setdefault(vm,k+'*')
print(len(known))
words=[l.strip() for l in open('/home/user/-K-NOT_THEORY/research/exact/dmon2/bench/ci/r6_n42_F/F_n42.words.txt') if l.strip()]
random.seed(1); samp=random.sample(words,1500)
t0=time.time(); from collections import Counter; cnt=Counter(); unk=[]
for w in samp:
    try:
        na,rels=diagram(w)
    except ValueError as e:
        cnt['bad:'+str(e)]+=1; continue
    v=tuple(count(na,rels,*q) for q in full)
    k=known.get(v)
    cnt[k]+=1
    if k is None: unk.append((w,v))
print(time.time()-t0,cnt); print(unk[:3])
