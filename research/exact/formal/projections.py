#!/usr/bin/env python3
"""Search integer projection directions D for a lattice polygon (word in e w n s u d) and report the
regular projections with the fewest crossings.  Exact integer/rational arithmetic only."""
import sys, itertools
from fractions import Fraction as Fr
U = {'e':(1,0,0),'w':(-1,0,0),'n':(0,1,0),'s':(0,-1,0),'u':(0,0,1),'d':(0,0,-1)}
def verts(word):
    v=[(0,0,0)]
    for c in word:
        a=U[c]; p=v[-1]; v.append((p[0]+a[0],p[1]+a[1],p[2]+a[2]))
    assert v[-1]==(0,0,0) and len(set(v[:-1]))==len(word)
    return v[:-1]
def proj(D,p):
    Dx,Dy,Dz=D; x,y,z=p
    return (Dz*x-Dx*z, Dz*y-Dy*z)
def height(D,p): return D[0]*p[0]+D[1]*p[1]+D[2]*p[2]
def cross2(o,a,b): return (a[0]-o[0])*(b[1]-o[1])-(a[1]-o[1])*(b[0]-o[0])
def seg_inter(p1,p2,q1,q2):
    """parameters (t,u) in [0,1]^2 of the unique intersection of two non-parallel segments, or None;
    'bad' if parallel and touching"""
    r=(p2[0]-p1[0],p2[1]-p1[1]); s=(q2[0]-q1[0],q2[1]-q1[1])
    den=r[0]*s[1]-r[1]*s[0]
    qp=(q1[0]-p1[0],q1[1]-p1[1])
    if den==0:
        if qp[0]*r[1]-qp[1]*r[0]!=0: return None
        # collinear: overlapping?
        rr=r[0]*r[0]+r[1]*r[1]
        t0=Fr(qp[0]*r[0]+qp[1]*r[1],rr); t1=t0+Fr(s[0]*r[0]+s[1]*r[1],rr)
        lo,hi=max(min(t0,t1),Fr(0)),min(max(t0,t1),Fr(1))
        if hi<lo: return None
        if hi>lo: return 'bad'                         # overlap of positive length
        t=lo                                           # a single common point
        # parameter on the second segment
        ss=s[0]*s[0]+s[1]*s[1]
        u=Fr((p1[0]+t*r[0]-q1[0])*s[0]+(p1[1]+t*r[1]-q1[1])*s[1],ss)
        return (t,u)
    t=Fr(qp[0]*s[1]-qp[1]*s[0],den); u=Fr(qp[0]*r[1]-qp[1]*r[0],den)
    if 0<=t<=1 and 0<=u<=1: return (t,u)
    return None
def diagram(word,D):
    """returns None if the projection is not regular, else list of crossings (i,t,j,u,over) with edge i
    under at parameter t and edge j over at parameter u"""
    V=verts(word); n=len(V)
    P=[proj(D,v) for v in V]; H=[height(D,v) for v in V]
    cr=[]; pts={}
    for i in range(n):
        for j in range(i+1,n):
            adj = (j==i+1) or (i==0 and j==n-1)
            r=seg_inter(P[i],P[(i+1)%n],P[j],P[(j+1)%n])
            if r is None: continue
            if r=='bad': return None
            t,u=r
            if adj:
                # must meet only at the shared vertex
                shared_ok = (j==i+1 and t==1 and u==0) or (i==0 and j==n-1 and t==0 and u==1)
                if not shared_ok: return None
                continue
            if t in (0,1) or u in (0,1): return None      # a vertex on another edge's image
            hi=H[i]+t*(H[(i+1)%n]-H[i]); hj=H[j]+u*(H[(j+1)%n]-H[j])
            if hi==hj: return None
            X=P[i][0]+t*(P[(i+1)%n][0]-P[i][0]); Y=P[i][1]+t*(P[(i+1)%n][1]-P[i][1])
            if (X,Y) in pts: return None                    # triple point
            pts[(X,Y)]=1
            if hi<hj: cr.append((i,t,j,u))
            else: cr.append((j,u,i,t))
    return cr
def colorings(word,D,p=7):
    cr=diagram(word,D)
    if cr is None: return None
    c=len(cr)
    if c==0: return p
    ev=sorted((i,t) for (i,t,j,u) in cr)
    idx={e:k for k,e in enumerate(ev)}
    def arc_at(j,u):  # arc containing point (edge j, param u), not an undercrossing
        k=sum(1 for e in ev if e<(j,u))
        return (k-1)%c
    rows=[]
    for (i,t,j,u) in cr:
        e=idx[(i,t)]; o=arc_at(j,u)
        row=[0]*c; row[o]+=2; row[(e-1)%c]-=1; row[e]-=1
        rows.append([x%p for x in row])
    # rank mod p
    M=[r[:] for r in rows]; rank=0
    for col in range(c):
        piv=next((r for r in range(rank,len(M)) if M[r][col]%p),None)
        if piv is None: continue
        M[rank],M[piv]=M[piv],M[rank]
        inv=pow(M[rank][col],p-2,p)
        M[rank]=[x*inv%p for x in M[rank]]
        for r in range(len(M)):
            if r!=rank and M[r][col]:
                f=M[r][col]; M[r]=[(a-f*b)%p for a,b in zip(M[r],M[rank])]
        rank+=1
    return p**(c-rank)
if __name__=="__main__":
    word=sys.argv[1]; R=int(sys.argv[2]) if len(sys.argv)>2 else 4
    best=[]
    for D in itertools.product(range(-R,R+1),repeat=3):
        if D[2]<=0 or 0 in D: continue
        cr=diagram(word,D)
        if cr is None: continue
        best.append((len(cr),D))
    best.sort()
    for c,D in best[:8]: print(c,D,colorings(word,D))
