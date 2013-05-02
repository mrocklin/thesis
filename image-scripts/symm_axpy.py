from sympy import Symbol, MatrixSymbol
from computations.matrices.blas import SYMM, AXPY
from computations.dot import writedot

n = Symbol('n')
X = MatrixSymbol('X', n, n)
Y = MatrixSymbol('Y', n, n)
symm = SYMM(1, X, Y, 0, Y)
axpy = AXPY(5, X*Y, Y)
writedot(axpy+symm, 'images/symm-axpy', rankdir='LR')

from computations.inplace import inplace_compile

ic = inplace_compile(symm + axpy)
writedot(ic, 'images/symm-axpy-inplace', rankdir='LR')
