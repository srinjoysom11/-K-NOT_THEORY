# Independent implementation of Spec.lean's Survive and a flip-closure test.
import sys, itertools
U=[(1,0,0),(-1,0,0),(0,1,0),(0,-1,0),(0,0,1),(0,0,-1)]
L='ewnsud'; IDX={c:i for i,c in enumerate(L)}
rev=lambda d: d^1
axis=lambda d: d>>1
add=lambda a,b:(a[0]+b[0],a[1]+b[1],a[2]+b[2]); sub=lambda a,b:(a[0]-b[0],a[1]-b[1],a[2]-b[2])
def verts(w):
    v=[(0,0,0)]
    for d in w: v.append(add(v[-1],U[d]))
    return v
def lexpos(v): return v[2]>0 or (v[2]==0 and (v[1]>0 or (v[1]==0 and v[0]>0)))
def survive(w):
    n=len(w); V=verts(w)
    if n<4 or V[n]!=(0,0,0) or len(set(V[:n]))!=n: return False
    S=set(V[:n])
    if not all(lexpos(V[i]) for i in range(1,n)): return False
    if not w[0]<rev(w[n-1]): return False
    c=[sum(1 for d in w if axis(d)==A) for A in range(3)]
    if not (c[2]<=c[1]<=c[0]): return False
    for i in range(n):
        a=w[i]
        for k in range(1,n):
            if axis(w[(i+k)%n])==axis(a):
                if w[(i+k)%n]==rev(a) and k-1>=1 and (k-1)+2<=n:
                    kk=k-1
                    if not any(sub(V[(i+j)%n],U[a]) in S for j in range(2,kk+1)): return False
                elif w[(i+k)%n]==rev(a) and k-1==0:
                    pass  # k=0 not a curtain (needs k>=1)
                break
    for i in range(1,n):
        p,d=w[i-1],w[i]
        q=add(V[i-1],U[d])
        if p==4 and d<4 and q not in S: return False
        if d==5 and p<4 and q not in S: return False
        if p==2 and d<2 and q not in S: return False
        if d==3 and p<2 and q not in S: return False
    return True
# symmetries: signed permutations
SYMS=[]
for perm in itertools.permutations(range(3)):
    for sg in itertools.product((1,-1),repeat=3):
        SYMS.append((perm,sg))
def apply(sym,v):
    perm,sg=sym; return tuple(sg[k]*v[perm[k]] for k in range(3))
def poly_key(V):
    n=len(V); best=None
    for o in (V, V[::-1]):
        for s in range(n):
            W=o[s:]+o[:s]; b=W[0]; t=tuple(sub(x,b) for x in W)
            if best is None or t<best: best=t
    return best
def word_of(W):
    n=len(W); return [U.index(sub(W[(i+1)%n],W[i])) for i in range(n)]
def flips(V):
    n=len(V); S=set(V)
    for i in range(n):
        p,c,q=V[i-1],V[i],V[(i+1)%n]
        if sub(c,p)==sub(q,c): continue
        x=add(p,sub(q,c))
        if x in S: continue
        W=list(V); W[i]=x; yield W
def survive_words(V):
    n=len(V); out=[]
    for sym in SYMS:
        Vs=[apply(sym,v) for v in V]
        for o in (Vs,Vs[::-1]):
            s=min(range(n),key=lambda j:(o[j][2],o[j][1],o[j][0]))
            if True:
                W=o[s:]+o[:s]; b=W[0]; W=[sub(x,b) for x in W]
                w=word_of(W)
                if survive(w): out.append(''.join(L[d] for d in w))
    return out
if __name__=="__main__":
    outs=set(open(sys.argv[1]).read().split())
    N=len(next(iter(outs)))
    # closure
    seen={}; stack=[]
    for s in outs:
        V=verts([IDX[c] for c in s])[:-1]
        for sym in SYMS:
            Vs=[apply(sym,v) for v in V]; k=poly_key(Vs)
            if k not in seen: seen[k]=list(k); stack.append(list(k))
    while stack:
        V=stack.pop()
        for W in flips(V):
            k=poly_key(W)
            if k not in seen: seen[k]=list(k); stack.append(list(k))
    print("outputs",len(outs),"closure polygons (up to translation)",len(seen))
    # completeness test: every Survive word of every polygon in the closure is an output
    sw=set(); 
    for V in seen.values(): sw.update(survive_words(V))
    print("survive words in closure",len(sw),"missing from output",len(sw-outs),"outputs not Survive",len([o for o in outs if not survive([IDX[c] for c in o])]))
    for m in list(sw-outs)[:5]: print("MISSING",m)
