from numpy import *
from matplotlib.pyplot import *
from scipy.integrate import odeint

#schéma d'euler explicite en temps:

def sol_explicite(x0,y0,a,b,c,d,tmax,ndt):
    x=x0
    y=y0
    X=[x0]
    Y=[y0]
    dt=tmax/ndt
    T=arange(0,tmax,dt)
    for i in range(1,len(T)):
        xi=x
        x=x+(tmax/ndt)*(x*(a-b*y))
        y=y+(tmax/ndt)*(-y*(c-d*xi))
        X.append(x)
        Y.append(y)
    return T,X,Y

Te,Xe,Ye =sol_explicite(2.0,4.0,3.0,1.0,2.0,1.0,10.0,1000)
plot(Te,Xe,label='x') #tracage x(t)
plot(Te,Ye,label='y') #tracage y(t)
plot(Xe,Ye,label='x en fct de y') #tracage (x,y)
legend()
grid()

#inv(t)

inv=[]
a,b,c,d=3.0,1.0,2.0,1.0
for i in range(len(Xe)):
    t= -c*log(Xe[i]) +d*Xe[i] +c*log(Xe[0]) -d*Xe[0] -a*log(Ye[i]) +b*Ye[i] +a*log(Ye[0]) -b*Ye[0]
    inv.append(t)
plot(inv,Te)
show()

#erreur:

def func(z,t,a,b,c,d):
    x,y=z
    dxdt = x * (a - b * y)
    dydt = -y * (c - d * x)
    return [dxdt, dydt]

def sol_odeint(x0,y0,a,b,c,d,tmax,ndt):
    dt = tmax / ndt
    T = np.arange(0, tmax, dt)
    z0 = [x0, y0]
    sol = odeint(func, z0, T, args=(a, b, c, d))
    X = sol[:, 0]
    Y = sol[:, 1]
    return T, X, Y

T0,X0,Y0 =sol_odeint(2.0,4.0,3.0,1.0,2.0,1.0,10.0,1000)
err=[]

for i in range(len(T0)):
    t=max(abs(X0[i]-Xe[i]),abs(Y0[i]-Ye[i]))
    err.append(t)

plot(T0,err)  #tracage de courbe
grid()
show()


