import pickle
from math import gcd
names,Q,C=pickle.load(open('fam.pkl','rb'))
def inv(n,t): return pow(t,-1,n)
def sep(K,tau,q):
    qi=(q[0],inv(*q))
    a={C[K][q],C[K][qi]}; b={C[tau][q],C[tau][qi]}
    return a.isdisjoint(b)
surv=['0_1','3_1','4_1','5_1','5_2','6_1','6_2','6_3','3_1#3_1_w40','3_1#-3_1_w40','8_19']
pairs=[]
for K in ['7_1','7_2','7_3','7_4','7_5','7_6','7_7','8_20']:
    for t in surv: pairs.append((K,t))
for t in surv:
    if t!='8_19': pairs.append(('8_19',t))
cov={q:{p for p in pairs if sep(p[0],p[1],q)} for q in Q}
rem=set(pairs); chosen=[]
while rem:
    best=max(Q,key=lambda q:(len(cov[q]&rem),-q[0]))
    chosen.append(best); rem-=cov[best]
    print(best,len(cov[best]),len(rem))
print(chosen)
# also try exhaustive small covers of size 3,4 with n<=15
import itertools
Qs=[q for q in Q if q[0]<=21 and q[1]<=inv(*q) ]   # one per inverse pair
for r in (2,3,4):
    found=None
    for comb in itertools.combinations(Qs,r):
        if set().union(*[cov[q] for q in comb])>=set(pairs):
            found=comb;break
    print(r,found)
    if found: break
print('---')
allp=set(pairs)
Qs=[q for q in Q if q[0]<=26 and q[1]<=inv(*q)]
# hard pairs: those covered by few quandles
cnt={p:[q for q in Qs if p in cov[q]] for p in pairs}
hard=min(pairs,key=lambda p:len(cnt[p])); print('hardest',hard,cnt[hard])
best=None
def search(rem,chosen,limit):
    global best
    if not rem:
        best=list(chosen); return True
    if len(chosen)>=limit: return False
    p=min(rem,key=lambda p:len([q for q in cnt[p]]))
    for q in sorted(cnt[p],key=lambda q:-len(cov[q]&rem)):
        chosen.append(q)
        if search(rem-cov[q],chosen,limit): return True
        chosen.pop()
    return False
for lim in range(3,9):
    best=None
    if search(set(pairs),[],lim): print(lim,best); break
