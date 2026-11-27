import sys, collections
exec(open(sys.argv[2]).read())
ws=[l.split()[0] for l in open(sys.argv[1]) if l[0] in 'ewnsud']
n=len(ws[0]); keep=collections.Counter(); facepos=[]; balpos=[]
for w in ws:
    v=analyse(w); st=stats(w)
    f=any(k.startswith('F') for k in v); c=any(k.startswith('C') and 'cond-fails' not in k for k in v)
    bz=2*st[0][0]>st[0][1]; by=2*st[1][0]>st[1][1]; bx=2*st[2][0]>st[2][1]
    keep['face ok']+= not f
    keep['face+crank ok']+= not(f or c)
    keep['face+crank+bal(z,y) ok']+= not(f or c or bz or by)
    keep['... +bal(x) [needs psiX tiebreak]']+= not(f or c or bz or by or bx)
    # earliest detection of bottom-face excess>=4, head-only order
    V=[(0,0,0)]
    for ch in w[:-1]: V.append(add(V[-1],D[ch]))
    best=None
    for i in range(n):
        if V[i][2]!=0: continue
        j=i; L=0
        while j+1<n and V[j+1][2]==0:
            j+=1; L+=1
            if L-sum(abs(V[j][t]-V[i][t]) for t in range(3))>=4:
                best=j if best is None else min(best,j); break
    if best is not None: facepos.append(n-best)
    # balance z: earliest step where bound kills: S_prefix + min rest > n*Hmax/2
    if bz:
        Sz=0; Hc=0
        for t in range(1,n):
            Sz+=V[t][2]; Hc=max(Hc,V[t][2]); h=V[t][2]; R=n-t
            # rest vertices t+1..n-1 (R-1 of them), path from h to 0 in R steps; for a target max H'
            ok=False
            for Hp in range(Hc, h+R+1):
                up=max(0,Hp-h)
                if up+Hp>R: break
                # sum of rest: climb h+1..Hp, descend Hp-1..0, rest zeros (min)
                rest=sum(range(h+1,Hp+1))+sum(range(0,Hp)) if Hp>h else sum(range(0,h))
                if 2*(Sz+rest)<=n*max(Hc,Hp): ok=True; break
            if not ok: balpos.append(R); break
print(len(ws),'words at n=%d'%n)
for k,c in keep.items(): print('  %-40s %6d  (%.2fx fewer)'%(k,c,len(ws)/max(c,1)))
h=collections.Counter(facepos); print('bottom-face violation detectable with R remaining (head-only order):',sorted(h.items()))
h=collections.Counter(balpos); print('z-balance prefix bound kills violator with R remaining:',sorted(h.items()), 'of',sum(1 for _ in balpos))
