from sympy import *
from computations.matrices.blas import COPY
n = Symbol('n')
X = MatrixSymbol('X', n, n)
copy = COPY(X)
from computations.dot import writedot
writedot(copy, 'images/copy', rankdir='LR')
from computations.inplace import TokenComputation
tc = TokenComputation(copy, ['X'], ['X_2'])
writedot(tc, 'images/copy-inplace', rankdir='LR')
