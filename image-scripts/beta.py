from sympy import Symbol, MatrixSymbol, MatMul, Transpose, Inverse

X = MatrixSymbol('X', n, m)
y = MatrixSymbol('y', n, 1)
beta = MatMul(Inverse(MatMul(Transpose(X), X)), Transpose(X), y)
from sympy.printing.dot import dotprint
dotprint(beta)
with open('images/beta.dot', 'w') as f:
        f.write(dotprint(beta))
