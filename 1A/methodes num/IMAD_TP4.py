import numpy as np
import matplotlib.pyplot as plt
import matplotlib.cm as cm
from scipy.optimize import minimize

def rosenbrock(x, y, alpha):
    return (1 - x)**2 + alpha * (y - x**2)**2

def norm(x,y):
    return np.sqrt((x**2)+(y**2))

def gradient_feild(x,y,alpha):
    djdx=-2*(1-x)-4*alpha*x*(y-x**2)
    djdy=2*alpha*(y-x**2)
    return np.array([djdx,djdy])

def norm(x,y):
    return np.sqrt((x**2)+(y**2))

#minimum est (1,1)

def grand_res(x,y):
  return (1-x)**2+ 100*(y-x**2)**2

def hessian_res(x,y,alpha):
  H=np.zeros((2,2))
  H[0,0]=2+2*alpha*(4*x**2-2*(y-x**2))
  H[1,0]=2*alpha*(-2*y+6*x**2)
  H[0,1]=2*alpha*(-2*y+6*x**2)
  H[1,1]=2*alpha
  return H

# Range for x and y
x = np.linspace(-6, 6, 100)
y = np.linspace(-6, 6, 100)

# Creating a grid of (x, y) points
X, Y = np.meshgrid(x, y)

# Calculate the value of Rosenbrock function at each point
Z = rosenbrock(X, Y, 100)
grad_x,grad_y= gradient_feild(X,Y,100)

plt.plot(1,1,color='red')
# Plotting the contours
plt.contour(X, Y, Z, levels=np.logspace(-1, 3, 10),cmap=cm.jet)
plt.xlabel('x')
plt.ylabel('y')
plt.title('Contours of Rosenbrock')
plt.colorbar(label='Value of Rosenbrock Function')
plt.xlim(-6,6)
plt.ylim(-6,6)
plt.grid()

plt.figure()
plt.quiver(X,Y,grad_x,grad_y,norm(X,Y))
plt.show()
# Define the Rosenbrock function for optimization
def rosen(x):
    return rosenbrock(x[0], x[1], alpha)

# Define callback function to store trajectory
def callback(x):
    traj.append(x)

# Define the optimization starting points
start_points = [(3, 3), (0, 0)]

# Define alpha values
alphas = [1, 10, 100]

# Perform optimization for each alpha and starting point
for alpha in alphas:
    plt.figure()
    for start_point in start_points:
        traj = []  # Trajectory of optimization

        # Perform optimization using Nelder-Mead method with callback
        res = minimize(rosen, start_point, method='Nelder-Mead', callback=callback, tol=1e-6)

        # Extract objective function values
        obj_values = [rosen(step) for step in traj]

        # Plot the trajectory
        traj = np.array(traj)
        plt.plot(traj[:, 0], traj[:, 1], label=f'Start: {start_point}',color='yellow')
        plt.title(f'Trajectory for alpha = {alpha}')
        plt.xlabel('x')
        plt.ylabel('y')
        plt.legend()
        plt.grid(True)
        plt.xlim(-5, 5)
        plt.ylim(-5, 5)
        plt.contour(X, Y, Z, levels=np.logspace(-1, 3, 10),cmap=cm.jet)
        plt.gca().set_aspect('equal', adjustable='box')
        plt.show()

        # Plot the evolution of J(xk)
        plt.figure()
        plt.plot(obj_values, marker='o')
        plt.xscale('log')
        plt.yscale('log')
        plt.title(f'Evolution of J(xk) for alpha = {alpha}')
        plt.xlabel('Iteration')
        plt.ylabel('J(xk)')
        plt.grid(True)
        plt.show()


#méthode d'ordre 1

def ordre1(gho, x0, niter, alpha):
    i = 0
    X = [x0]
    x = x0
    while i < niter:
        gradient = gradient_feild(x[0], x[1], alpha)
        x = x - gho * np.array(gradient)
        X.append(x)
        i += 1
    return np.array(X).T

X, Y = ordre1(0.001, np.array([0, 0]), 100000, 100)
plt.figure()
plt.plot(X, Y)
plt.xscale('log')
plt.yscale('log')
plt.show()
