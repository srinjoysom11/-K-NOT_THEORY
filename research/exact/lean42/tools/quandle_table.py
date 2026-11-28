import pickle
names,Q,C=pickle.load(open('fam.pkl','rb'))
chosen=[(15,2),(7,6),(5,4),(7,2),(13,12),(9,2),(11,3),(13,2)]
def inv(n,t): return pow(t,-1,n)
order=['0_1','3_1','4_1','5_1','5_2','6_1','6_2','6_3','3_1#3_1_w40','3_1#-3_1_w40','8_19','7_1','7_2','7_3','7_4','7_5','7_6','7_7','8_20']
print('| knot | '+' | '.join(f'A({n},{t})' for n,t in chosen)+' |')
print('|'+'---|'*(len(chosen)+1))
for k in order:
    print(f'| {k.replace("_w40","")} | '+' | '.join(str(C[k][q]) if C[k][q]==C[k][(q[0],inv(*q))] else f'{C[k][q]}/{C[k][(q[0],inv(*q))]}' for q in chosen)+' |')
