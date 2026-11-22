import sys, collections
D={'e':(1,0,0),'w':(-1,0,0),'n':(0,1,0),'s':(0,-1,0),'u':(0,0,1),'d':(0,0,-1)}
AX={'e':0,'w':0,'n':1,'s':1,'u':2,'d':2}
def add(p,q,k=1): return (p[0]+k*q[0],p[1]+k*q[1],p[2]+k*q[2])
def analyse(w):
    n=len(w); V=[(0,0,0)]
    for c in w[:-1]: V.append(add(V[-1],D[c]))
    occ=set(V); cnt=[0,0,0]
    for c in w: cnt[AX[c]]+=1
    cx,cy,cz=cnt
    ymin=min(v[1] for v in V)
    viol=collections.Counter()
    for j in range(n):
        a=w[j]
        # U: a, S (k>=1 same letter b, b perp a), -a
        b=w[(j+1)%n]
        if AX[b]==AX[a]: continue
        k=1
        while k<n-2 and w[(j+1+k)%n]==b: k+=1
        if w[(j+1+k)%n]!={'e':'w','w':'e','n':'s','s':'n','u':'d','d':'u'}[a]: continue
        P=V[j]; Q=add(P,D[b],k)
        def free_row(c):
            return all(add(add(P,D[b],t),D[c]) not in occ for t in range(k+1))
        ra,rb=AX[a],AX[b]
        if a=='u':                    # hat: rotate to horizontal sides perp b
            for c in 'ewns':
                if AX[c]!=rb and free_row(c): viol['C2 hat->side (S along %s)'%('xy'[rb])]+=1; break
        elif a in 'ewns' and rb!=2:   # horizontal U -> rotate to d, level >=1
            if P[2]>=1 and free_row('d'):
                ok=(cz<cy) if ra==0 else (cz+4<=cy)
                viol['C1 horizU->down a%s %s'%('xy'[ra],'valid' if ok else 'cond-fails')]+=1
        elif a in 'ewns' and rb==2:   # vertical bar U
            if a=='n':
                for c in 'ew':
                    if free_row(c):
                        viol['C3 n-bar->x %s'%('valid' if cy>cz else 'cond-fails')]+=1; break
            elif a in 'ew':
                if P[1]-1>=ymin and free_row('s'):
                    viol['C3 x-bar->s %s'%('valid' if cx>=cy+4 else 'cond-fails')]+=1
    # bottom face excess
    def face_excess(ax,val):
        bad=0
        inface=[V[i][ax]==val for i in range(n)]
        for i in range(n):
            if not inface[i]: continue
            p=V[i]; L=0; j=i
            while L<n-1:
                j2=(j+1)%n
                if not inface[j2]: break
                L+=1; j=j2; q=V[j]
                if L-sum(abs(q[t]-p[t]) for t in range(3))>=4: return True
        return False
    if face_excess(2,0): viol['F bottom face excess>=4']+=1
    ext=[]
    for ax in range(3):
        vals=[v[ax] for v in V]
        if face_excess(ax,min(vals)) or face_excess(ax,max(vals)): ext.append(ax)
    if ext: viol['F some face excess>=4']+=1
    return viol
words=[l.split()[0] for l in open(sys.argv[1]) if l.strip() and l[0] in 'ewnsud']
tot=collections.Counter(); anyv=0; anyvalid=0
for w in words:
    v=analyse(w)
    for k in v: tot[k]+=1
    anyv+=bool(v); anyvalid+=any(('cond-fails' not in k) for k in v)
print(len(words),'words; words with a violation of each kind:')
for k,c in sorted(tot.items()): print('  %6d  %s'%(c,k))
print('words with any unconditionally-valid violation:',anyvalid)
