import json, sys
from fractions import Fraction as F
from math import gcd

DIRS = {'e':(1,0,0),'w':(-1,0,0),'n':(0,1,0),'s':(0,-1,0),'u':(0,0,1),'d':(0,0,-1)}

def verts(word):
    p=(0,0,0); vs=[]
    for c in word:
        vs.append(p); d=DIRS[c]; p=(p[0]+d[0],p[1]+d[1],p[2]+d[2])
    assert p==(0,0,0), "not closed"
    assert len(set(vs))==len(vs), "not simple"
    # keep only the corner vertices (merge straight runs)
    n=len(word)
    keep=[vs[i] for i in range(n) if word[i-1]!=word[i]]
    return keep

def diagram(word, a=F(4142,10000), b=F(2360,10000), reverse=False):
    vs=verts(word)
    if reverse: vs=vs[::-1]
    n=len(vs)
    P=[(v[0]+a*v[2], v[1]+b*v[2]) for v in vs]
    Z=[v[2] for v in vs]
    ev=[[] for _ in range(n)]
    cross=[]
    for i in range(n):
        i2=(i+1)%n
        di=(P[i2][0]-P[i][0],P[i2][1]-P[i][1])
        for j in range(i+1,n):
            j2=(j+1)%n
            if j2==i or j==i2: continue
            dj=(P[j2][0]-P[j][0],P[j2][1]-P[j][1])
            den=di[0]*dj[1]-di[1]*dj[0]
            w=(P[j][0]-P[i][0],P[j][1]-P[i][1])
            if den==0:
                if w[0]*di[1]-w[1]*di[0]==0:
                    # collinear projections: overlap?
                    L=di[0]*di[0]+di[1]*di[1]
                    a0=(w[0]*di[0]+w[1]*di[1])/L
                    a1=a0+(dj[0]*di[0]+dj[1]*di[1])/L
                    lo,hi=min(a0,a1),max(a0,a1)
                    if hi>0 and lo<1: raise ValueError("collinear overlapping edges")
                continue
            s=F(w[0]*dj[1]-w[1]*dj[0])/den
            t=F(w[0]*di[1]-w[1]*di[0])/den
            if 0<=s<=1 and 0<=t<=1:
                if s in (0,1) or t in (0,1): raise ValueError("vertex on edge")
                zi=Z[i]+s*(Z[i2]-Z[i]); zj=Z[j]+t*(Z[j2]-Z[j])
                if zi==zj: raise ValueError("equal height")
                cid=len(cross)
                if zi>zj:
                    cross.append((i,j,di,dj)); ev[i].append((s,cid,'o')); ev[j].append((t,cid,'u'))
                else:
                    cross.append((j,i,dj,di)); ev[j].append((t,cid,'o')); ev[i].append((s,cid,'u'))
    cur=0; inarc={}; outarc={}; overarc={}
    for i in range(n):
        for (s,cid,r) in sorted(ev[i]):
            if r=='u':
                inarc[cid]=cur; cur+=1; outarc[cid]=cur
            else:
                overarc[cid]=cur
    if cur==0:
        return 1,[]
    last=cur
    def fix(x): return 0 if x==last else x
    rels=[]
    for cid,(oe,ue,do,du) in enumerate(cross):
        sg = do[0]*du[1]-do[1]*du[0]
        sg = 1 if sg>0 else -1
        rels.append((fix(inarc[cid]),fix(outarc[cid]),fix(overarc[cid]),sg))
    return cur,rels

def factor(n):
    m=n; p=2; fac=[]
    while m>1:
        while m%p: p+=1
        k=0
        while m%p==0: m//=p; k+=1
        fac.append((p,k))
    return fac

def count(narcs, rels, n, t):
    res=1
    for (p,k) in factor(n):
        res*=count_pk(narcs,rels,p,k,t)
    return res

def count_pk(narcs,rels,p,k,t):
    q=p**k
    tt=t%q
    M=[]
    for (a,b,o,s) in rels:
        r=[0]*narcs
        if s>0:
            r[b]=(r[b]+1)%q; r[a]=(r[a]-tt)%q; r[o]=(r[o]-(1-tt))%q
        else:
            r[a]=(r[a]+1)%q; r[b]=(r[b]-tt)%q; r[o]=(r[o]-(1-tt))%q
        M.append(r)
    def val(x):
        x%=q
        if x==0: return k
        v=0
        while x%p==0: x//=p; v+=1
        return v
    cols=narcs; size=1; used=0
    while True:
        best=None
        for i,r in enumerate(M):
            for j,x in enumerate(r):
                if x%q:
                    v=val(x)
                    if best is None or v<best[0]:
                        best=(v,i,j)
                        if v==0: break
            if best and best[0]==0: break
        if best is None: break
        v,i,j=best
        piv=M[i][j]
        u=(piv%q)//(p**v); inv=pow(u,-1,q)
        for r2 in range(len(M)):
            if r2==i: continue
            x=M[r2][j]%q
            if x:
                f=(x//(p**v))*inv%q
                M[r2]=[(M[r2][c]-f*M[i][c])%q for c in range(cols)]
        M.pop(i)
        size*=p**v
        used+=1
        for r2 in range(len(M)): M[r2][j]=0
    return size*(q**(cols-used))

def load_words():
    W={}
    seeds=json.load(open('/home/user/-K-NOT_THEORY/research/data/seeds.json'))
    for k,v in seeds.items():
        if k in ('3_1','4_1','5_1','5_2','6_1','6_2','6_3','7_1','7_2','7_3','7_4','7_5','7_6','7_7','8_19','8_20'):
            W[k]=v
    for line in open('/home/user/-K-NOT_THEORY/research/exact/out/witness40.txt'):
        if line.startswith('#') or not line.strip(): continue
        k,w=line.split(); W[k+'_w40']=w
    for line in open('/home/user/-K-NOT_THEORY/research/exact/out/witness42_8_19.txt'):
        k,n,w=line.split(); W['8_19_w42']=w
    W['0_1']='eennwwss'
    return W
if __name__=='__main__':
    W=load_words()
    for k,w in W.items():
        na,rels=diagram(w)
        print(k,len(w),'arcs',na,'crossings',len(rels))
