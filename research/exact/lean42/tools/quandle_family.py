from qd import *
from math import gcd
import itertools, pickle
W=load_words()
names=['0_1','3_1','4_1','5_1','5_2','6_1','6_2','6_3','3_1#3_1_w40','3_1#-3_1_w40','8_19','8_20','7_1','7_2','7_3','7_4','7_5','7_6','7_7']
D={}
for k in names:
    D[k]=diagram(W[k])
Q=[(n,t) for n in range(2,31) for t in range(2,n) if gcd(t,n)==1]
C={}
for k in names:
    na,rels=D[k]
    C[k]={q:count(na,rels,*q) for q in Q}
pickle.dump((names,Q,C),open('fam.pkl','wb'))
def inv(n,t): return pow(t,-1,n)
def vec(k,qs): return tuple(C[k][q] for q in qs)
surv=['0_1','3_1','4_1','5_1','5_2','6_1','6_2','6_3','3_1#3_1_w40','3_1#-3_1_w40','8_19']
targets=['7_1','7_2','7_3','7_4','7_5','7_6','7_7','8_20','8_19']
# pairwise single-quandle separation (sets disjoint)
def sep(K,tau,q):
    qi=(q[0],inv(*q[::1])) 
    a={C[K][q],C[K][qi]}; b={C[tau][q],C[tau][qi]}
    return a.isdisjoint(b)
for K in targets:
    for tau in surv:
        if tau==K: continue
        good=[q for q in Q if sep(K,tau,q)]
        print(K,tau,len(good),good[:4])
