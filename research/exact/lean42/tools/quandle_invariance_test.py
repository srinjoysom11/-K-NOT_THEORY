from qd import *
from fractions import Fraction as F
W=load_words()
dirs=[(F(4142,10000),F(2360,10000)),(F(-3,7)+F(1,1000),F(5,11)+F(1,997)),(F(123,1000),F(-731,1000))]
Qs=[(3,2),(5,4),(5,2),(7,3),(7,6),(9,8),(9,2),(8,3),(15,14)]
for k in ['3_1','6_1_w40','8_19_w42','8_19','3_1#3_1_w40','3_1#-3_1_w40']:
    w=W[k]
    res=set()
    for (a,b) in dirs:
        for rev in (False,True):
            try:
                na,rels=diagram(w,a,b,rev)
            except ValueError as e:
                print(k,'bad dir',e); continue
            res.add(tuple(count(na,rels,n,t) for n,t in Qs))
    print(k,len(res),sorted(res)[:2])
