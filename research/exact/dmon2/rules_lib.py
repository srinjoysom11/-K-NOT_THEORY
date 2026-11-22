import sys, collections
exec(open(__file__.rsplit('/',1)[0]+'/crank.py').read().split('words=[')[0])
def stats(w):
    V=[(0,0,0)]
    for c in w[:-1]: V.append(add(V[-1],D[c]))
    n=len(V); out=[]
    for ax in (2,1,0):
        q=[v[ax] for v in V]; lo,hi=min(q),max(q); out.append((sum(x-lo for x in q), n*(hi-lo)))
    return out
