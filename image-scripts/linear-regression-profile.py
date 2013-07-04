from sympy import *
from megatron.core import compile
from computations.matrices.blas import COPY
from computations.inplace import inplace_compile
from computations.matrices.fortran.core import generate_module

n, k = 1000, 500
X = MatrixSymbol('X', n, k)
y = MatrixSymbol('y', n, 1)
beta = (X.T*X).I * X.T*y

c = compile([X, y], [beta], Q.fullrank(X))
ic = inplace_compile(c, Copy=COPY)
with assuming(Q.real_elements(X), Q.real_elements(y)):
    source = generate_module(ic, [X, y], [beta], modname='lls')
with open('lls.f90', 'w') as f:
    f.write(source)

import os
os.system('f2py -c lls.f90 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lmkl_core -lpthread --f90flags="-L/home/mrocklin/Software/epd-7.3-2-rh5-x86_64/lib/"')

import untitled
f = untitled.lls.py_f

import numpy as np
nX = np.random.rand(n, k); ny = np.random.rand(n)
mX, my = np.matrix(nX), np.matrix(ny).T

import numpy.linalg
import scipy.linalg
# timeit (mX.T*mX).I * mX.T*my
# timeit numpy.linalg.solve(mX.T*mX, mX.T*my)
# timeit scipy.linalg.solve(mX.T*mX, mX.T*my, sym_pos=True)
# timeit f(nX, ny)
