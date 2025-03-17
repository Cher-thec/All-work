from numpy import *
from matplotlib.pyplot import *
from math import exp,sin,cos,pi

#Fonction solution de l'equation de cadran
def solcubique(p,q):
  delta= 4*(p**3)+27*(q**2)
  alpha= cbrt(-(q/2)-((delta/108)**0.5)) + (-(q/2)+((delta/108)**0.5))**(1/3)
  return alpha
print('racine=',solcubique(1.0,1.0))

#fonction qui determine par la fonction de newton
def newton(x0,Niter,epsilon,solexacte,p,q):
  error=1
  iter=0
  x=x0
  I,E,S=[iter],[error],[x0]
  while error > epsilon and iter < Niter:
    x=x-(((x**3)+p*x+q)/(3*(x**2)+p))
    error=abs(solexacte-x)
    iter+=1
    I.append(iter)
    S.append(x)
    E.append(error)
  return S,E,I

#Fonction qui detrmine le point fixe par la methode du point fixe
def pointfixe(x0,Niter,epsilon,solexacte,p,q):
  error=1
  iter=0
  x=x0
  I,E,S=[iter],[error],[x0]
  while error > epsilon and iter < Niter:
    x=(-q)/(p+x**2)
    error=abs(solexacte-x)
    iter+=1
    I.append(iter)
    S.append(x)
    E.append(error)
  return S,E,I

#méthode point fixe paramétré
def pointfixe2(a,x0,Niter,epsilon,solexacte,p,q):
  error=1
  iter=0
  x=x0
  I,E,S=[iter],[error],[x0]
  while error > epsilon and iter < Niter:
    x=x+a*((x**3)+p*x+q)
    error=abs(solexacte-x)
    iter+=1
    I.append(iter)
    S.append(x)
    E.append(error)
  return S,E,I

#affichage de l'erreur en fonction du nombre d'itération par methode de newton
sne,ene,ine=newton(0.5,200,10**(-4),solcubique(1.0,1.0) ,1.0,1.0)
plot(ine,ene,color='red',marker='o')
grid()
xlabel('iter')
ylabel('erreur(iter)')
legend()
title('erreur obtenue par methode de newton')
yscale('log')

#affichage de l'erreur mar methode du point fixe
sne,ene,ine=newton(0.5,200,10**(-4),solcubique(1.0,1.0) ,1.0,1.0)
plot(ine,ene,color='red',marker='o')
grid()
xlabel('iter')
ylabel('erreur(iter)')
legend()
title('erreur obtenue par methode de newton')
#yscale('log')

#affichage simultané
sne,ene,ine=newton(0.5,200,10**(-4),solcubique(1.0,1.0) ,1.0,1.0)
S,E,I=pointfixe(0.5,200,10**(-4),solcubique(1.0,1.0) ,1.0,1.0)
plot(ine,ene,color='red',marker='o',label='newton')
plot(I,E,color='blue',marker='o',label='point fixe')
grid()
xlabel('iter')
ylabel('erreur(iter)')
legend()
title('comparaison pointfixe et newton')
yscale('log')
show()

#affichage des Xk en fonction des iteration
sne,ene,ine=newton(0.5,200,10**(-4),solcubique(1.0,1.0) ,1.0,1.0)
S,E,I=pointfixe(0.5,200,10**(-4),solcubique(1.0,1.0) ,1.0,1.0)
plot(ine,sne,color='red',marker='o',label='newton')
plot(I,S,color='blue',marker='o',label='point fixe')
grid()
xlabel('iter')
ylabel('erreur(iter)')
legend()
ylim(-0.75,-0.6)
title('comparaison pointfixe et newton')
show()

#affichage de la courbe pour fa(x)=xn+a (xn**3+p*xn+q)
a=arange(-0.80,-0.05,0.10)
for av in a:
  spfa,epfa,ipfa=pointfixe2(av,0,200,1.0e-4,solcubique(1.0,1.0),1.0,1.0)
  plot(ipfa,epfa,'.--',label='a=%.2f' %av)
  sne,ene,ine=newton(0.5,200,10**(-4),solcubique(1.0,1.0) ,1.0,1.0)
title('methode du point fixe pour fa(x)=xn+a (xn**3+p*xn+q)')
grid()
xlabel('iter')
ylabel('erreur(iter)')
yscale('log')
ylim(10**(-5),1)
show()

#étude de deux dimension:

#tracage de l'ellipse
x=arange(-1,2,0.02)
y=arange(-1.2,1.2,0.02)
X,Y=meshgrid(x,y)
print(X)
print(Y)
F=(X**2)+2*(Y**2)-1
G=X*(Y**2)-0.1
contour(X,Y,F,[0],colors='r')
contour(X,Y,G,[0],colors='b')
grid()

def norm2D(X,Y):
    return sqrt(((X[0]-Y[0])**2)+((X[1]-Y[1])**2))

def F(A):
    X = A[0]
    Y = A[1]
    f = (X**2) + 2*(Y**2) - 1
    g = X * (Y**2) - 0.1
    return np.array([f, g])

def JF(A):
    X = A[0]
    Y = A[1]
    return np.array([[2 * X, 4 * Y], [Y**2, 2 * X * Y]])

def newton2D(x0, Niter, epsilon, solexacte, p, q):
    error = 1
    iter = 0
    x=x0

    I, E, S = [iter], [error], [x0]
    while error > epsilon and iter < Niter:
        J = JF(x)
        J_inv = np.linalg.inv(J)
        x = x - np.dot(J_inv, F(x))
        error = norm2D(solexacte, x)  # Utiliser la norme pour calculer l'erreur
        iter += 1
        I.append(iter)
        S.append(x)
        E.append(error)

    return np.array(S), np.array(E), np.array(I)

# Exemple de fonction solcubique, à adapter selon le cas
def aray(x, y):
    return np.array([x, y])

# Exécution de l'algorithme de Newton
solexacte = aray(1,1)
sne, ene, ine = newton2D(np.array([2, 1]), 200, 10**(-8), solexacte, 1.0, 1.0)

# Tracé de l'évolution de x et y en fonction des itérations
sne = np.array(sne)
plot(sne[:, 0], sne[:, 1], 'o-',color='black', label='Trajectoire de Newton')
xlabel('x')
ylabel('y')
xlim(-1, 2)
ylim(-1, 1)
legend()
grid(True)
show()

#tracé d'erreur:
plot(ine, ene, 'o-',color='black', label='lerreur')
xlabel('x')
ylabel('y')
xlim(0,6)
ylim(1e-4,1)
yscale('log')
legend()
grid(True)
show()

#newton 3D
def norm3D(X,Y):
    return sqrt(((X[0]-Y[0])**2)+((X[1]-Y[1])**2)+((X[2]-Y[2])**2))

def G(A):
    x=A[0]
    y=A[1]
    z=A[2]
    f=(x**2)+(y**2)+(z**2)-6
    g=(x*y)-(x*y*z)+(z**5)-1
    h=cos(pi*x)+sin(pi*x)+exp(x+y)
    return np.array([f,g,h])

def JG(A):
    x=A[0]
    y=A[1]
    z=A[2]
    return array([[2*x,2*y,2*z],[y-y*z,x-x*z,5*(z**4)-x*y],[-pi*sin(pi*x)+pi*cos(pi*x)+exp(x+y),exp(x+y),0]])

def newton3D(x0, Niter, epsilon, solexacte, p, q):
    error = 1
    iter = 0
    x=x0

    I, E, S = [iter], [error], [x0]
    while error > epsilon and iter < Niter:
        J = JG(x)
        J_inv = np.linalg.inv(J)
        x = x - np.dot(J_inv, G(x))
        error = linalg.norm(x-solexacte)  # Utiliser la norme pour calculer l'erreur
        iter += 1
        I.append(iter)
        S.append(x)
        E.append(error)

    return np.array(S), np.array(E), np.array(I)

sol=array([[ 1,-1,2]])
sni, eni, ini = newton3D(np.array([7,-5,3]), 200, 10**(-8), sol, 1.0, 1.0)
sni = np.array(sni)
plot(ini, eni, 'o-',color='black', label='Trajectoire de Newton')
xlabel('x')
ylabel('y')
xlim(0,13)
ylim(1e-5, 1)
yscale('log')
legend()
grid(True)
show()
