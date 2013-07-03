from sympy import *
from megatron.core import compile
from computations.matrices.fortran.core import build

n, k = 1000, 500
X = MatrixSymbol('X', n, k)
y = MatrixSymbol('y', n, 1)
beta = (X.T*X).I * X.T*y

c = compile([X, y], [beta], Q.fullrank(X))
with assuming(Q.real_elements(X), Q.real_elements(y)):
    f = build(c, [X, y], [beta], filename='lls.f90', modname='lls')

import numpy as np
nX = np.random.rand(n, k); ny = np.random.rand(n)
mX, my = np.matrix(nX), np.matrix(ny).T

import numpy.linalg
import scipy.linalg
# timeit (mX.T*mX).I * mX.T*my
# timeit numpy.linalg.solve(mX.T*mX, mX.T*my)
# timeit scipy.linalg.solve(mX.T*mX, mX.T*my, sym_pos=True)
# timeit f(nX, ny)
