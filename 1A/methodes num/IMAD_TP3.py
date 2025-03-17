import numpy as np
import matplotlib.pyplot as plt
import time

#1: solution sol_1dlin
def sol_1dlin(NX,Bi):
    dx=Bi/NX
    x=np.linspace(0,1,NX)
    T=[]
    for i in range(0,NX):
        u=x[i]*(-1/(Bi+1))+1
        T.append(u)
    return [x,T]
[x,T]=sol_1dlin(10,1)

#2: calcul matrice
def mat_a(NX,Bi,ordre):
    dx=Bi/NX
    mat_a=np.zeros((NX,NX))
    mat_a[0,0]=1
    for i in range(1,NX-1):
        mat_a[i,i]=2
        mat_a[i,i-1]=-1
        mat_a[i-1,i]=-1
    mat_a[0,1]=0
    if ordre==2:
        mat_a[NX-1,NX-3]=-1/(2*dx)
        mat_a[NX-1,NX-2]=4/(2*dx)
        mat_a[NX-1,NX-1]=-(Bi+(3/(2*dx)))
    if ordre==1:
        mat_a[NX-1,NX-3]=0
        mat_a[NX-1,NX-2]=1/dx
        mat_a[NX-1,NX-1]=-(Bi+(1/dx))
        print(mat_a)
    return mat_a

#3:

def sol_biot_array(NX,Bi,ordre):
    début=time.time()
    A=mat_a(NX,Bi,ordre)
    b=np.zeros((NX,1))
    b[0,0]=1
    [x,Tex]=sol_1dlin(NX,Bi)
    Ts=np.linalg.solve(A,b)
    L=[]
    for i in range(NX):
        L.append(abs(Tex[i]-Ts[i]))
    erreur=max(L)
    temps=time.time()-début
    return [x,Ts,erreur,temps]
#4/

def tempscalc(ordre=1,Bi=0.1):
    N=np.linspace(1,2000,100)
    Tim=[]
    for i in range(len(N)):
        temps=sol_biot_array(N[i],Bi,ordre)[3]
        Tim.append(temps)
    return N,Tim
plt.plot(tempscalc(1,0.1)[0],tempscalc(1,0.1)[1],marker='o')
plt.grid()
plt.yscale('log')
plt.xscale('log')
plt.show()





