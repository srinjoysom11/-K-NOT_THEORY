import re,sys,os
roots=sys.argv[1:]
base='/home/user/-K-NOT_THEORY/research/exact/lean42/.lake/packages'
pk={'Mathlib':'mathlib','Batteries':'batteries','Aesop':'aesop','Qq':'Qq','ProofWidgets':'proofwidgets','Plausible':'plausible','ImportGraph':'importGraph','LeanSearchClient':'LeanSearchClient','Cli':'Cli'}
seen=set()
def path(m):
    top=m.split('.')[0]
    if top not in pk: return None
    return os.path.join(base,pk[top],m.replace('.','/')+'.lean')
def visit(m):
    if m in seen: return
    seen.add(m)
    p=path(m)
    if not p or not os.path.exists(p): return
    for l in open(p):
        mm=re.match(r'\s*(?:public\s+)?import\s+(?:all\s+)?(\S+)',l)
        if mm: visit(mm.group(1))
        elif l.strip().startswith('/-') or l.strip().startswith('def ') or l.strip().startswith('theorem '): pass
for r in roots: visit(r)
print(len([s for s in seen if s.split('.')[0]=='Mathlib']), len(seen))
