import random, sys
U={'e':(1,0,0),'w':(-1,0,0),'n':(0,1,0),'s':(0,-1,0),'u':(0,0,1),'d':(0,0,-1)}
INV={v:k for k,v in U.items()}
def verts(w):
    v=[(0,0,0)]
    for c in w:
        a=U[c]; p=v[-1]; v.append((p[0]+a[0],p[1]+a[1],p[2]+a[2]))
    assert v[-1]==(0,0,0) and len(set(v[:-1]))==len(w)
    return v[:-1]
def word(V):
    n=len(V); o=V[0]
    return ''.join(INV[tuple(V[(i+1)%n][k]-V[i][k] for k in range(3))] for i in range(n))
add=lambda a,b:tuple(x+y for x,y in zip(a,b)); sub=lambda a,b:tuple(x-y for x,y in zip(a,b))
PERP=[(1,0,0),(-1,0,0),(0,1,0),(0,-1,0),(0,0,1),(0,0,-1)]
def step(V,maxn):
    n=len(V); S=set(V); i=random.randrange(n)
    a,b=V[i],V[(i+1)%n]; e=sub(b,a)
    p=random.choice([q for q in PERP if sum(x*y for x,y in zip(q,e))==0])
    a2,b2=add(a,p),add(b,p)
    prev=V[i-1]; nxt=V[(i+2)%n]
    # cases: -2 move if prev==a2 and nxt==b2 ; neutral if exactly one ; +2 if none
    if prev==a2 and nxt==b2:
        if n<=6: return V
        # remove a,b ; path prev->nxt adjacent
        W=[V[j] for j in range(n) if j not in (i,(i+1)%n)]
        return W
    if prev==a2:
        if b2 in S: return V
        W=list(V); W[i]=b2  # a replaced by b2? path prev(a2) -> b2 -> b
        # prev=a2 adjacent to b2 (since a2-b2 = e) ; b2 adjacent to b
        return W
    if nxt==b2:
        if a2 in S: return V
        W=list(V); W[(i+1)%n]=a2
        return W
    if a2 in S or b2 in S or n+2>maxn: return V
    W=V[:i+1]+[a2,b2]+V[i+1:]
    return W
def canon(V):
    o=V[0]; return [sub(v,o) for v in V]
if __name__=="__main__":
    random.seed(int(sys.argv[2])); w=sys.argv[1]; cnt=int(sys.argv[3]); maxn=int(sys.argv[4])
    V=verts(w)
    out=set()
    for it in range(cnt*200):
        V=step(V,maxn)
        if it%200==199:
            V=canon(V); ww=word(V); verts(ww); out.add(ww)
    for ww in out: print(ww)
