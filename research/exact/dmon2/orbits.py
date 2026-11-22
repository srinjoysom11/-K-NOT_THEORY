import sys, itertools, collections
D={'e':(1,0,0),'w':(-1,0,0),'n':(0,1,0),'s':(0,-1,0),'u':(0,0,1),'d':(0,0,-1)}
def verts(w):
    p=(0,0,0); V=[p]
    for c in w:
        d=D[c]; p=(p[0]+d[0],p[1]+d[1],p[2]+d[2]); V.append(p)
    return V[:-1]
def key(V):  # canonical: set of edges up to translation, as frozenset -> orbit key via all 48 syms
    best=None
    n=len(V)
    for perm in itertools.permutations(range(3)):
        for sg in itertools.product((1,-1),repeat=3):
            W=[tuple(sg[k]*v[perm[k]] for k in range(3)) for v in V]
            m=min(W, key=lambda p:(p[2],p[1],p[0]))
            W=[(a-m[0],b-m[1],c-m[2]) for a,b,c in W]
            i=W.index((0,0,0))
            for dr in (1,-1):
                seq=tuple(W[(i+dr*j)%n] for j in range(n))
                if best is None or seq<best: best=seq
    return best
def stats(V):
    n=len(V); out=[]
    for ax in (2,1,0):
        q=[v[ax] for v in V]; lo,hi=min(q),max(q)
        s=sum(x-lo for x in q); out.append((s, n*(hi-lo)))
    return out
words=[l.split()[0] for l in open(sys.argv[1]) if l.strip() and l[0] in 'ewnsud']
orb=collections.Counter(); bal=[0,0,0]; tie=[0,0,0]
for w in words:
    V=verts(w); orb[key(V)]+=1
    for k,(s,T) in enumerate(stats(V)):
        if 2*s<T: bal[k]+=1
        elif 2*s==T: tie[k]+=1
print(len(words),'words',len(orb),'orbits; multiplicity hist',sorted(collections.Counter(orb.values()).items()))
print('strictly low centroid z,y,x:',bal,' ties:',tie)
# joint test: valid now = z and y balance (<=); with psiX tiebreak also x
j2=j3=0
for w in words:
    st=stats(verts(w))
    okz=2*st[0][0]<=st[0][1]; oky=2*st[1][0]<=st[1][1]; okx=2*st[2][0]<=st[2][1]
    j2+=okz and oky; j3+=okz and oky and okx
print('pass z&y balance:',j2,' pass z&y&x:',j3)
