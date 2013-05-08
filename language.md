
Matrix Algebra
--------------

\label{sec:matrix-language}

include [Tikz](tikz_math.md)

*I probably need help to understand both the ideal style and extent that a section like this should have*

We extend the SymPy computer algebra system to Matrix Algebra.  Leaf variables in a matrix algebra are defined by an identifier (e.g. `'X'`) and a shape, two integers of rows or columns.  These shape integers may themselves be symbolic. Common matrix algebra operators include Matrix Multiplication, Matrix Addition, Transposition, and Inversion.  Each of these operators has its own logic about the shape of the term given the shapes of its inputs, validity, and possible simplifications.

In the end we desire the construction of expressions like the following expression for least squares linear regression where $X$ is an $n \times m$ matrix and $y$ an $n \times 1$ column vector.

$$\beta = (X^T X)^{-1} X^T y $$


#### Simplification

Just as we simplify $\log(e^x) \rightarrow x$ in real analysis we have trivial simplifications in matrix algebra as well such as $(X^T)^T \rightarrow X$ or $Trace(X + Y) \rightarrow Trace(X) + Trace(Y)$. 


#### Extension 

Like real analysis, matrix algebra has a rich and extensive theory.  As a result this algebra can be extended to include a large set of additional operators including Trace, Determinant, Blocks, Slices, EigenVectors, Adjoints, Matrix Derivatives, etc....   Each of these operators has its own rules about validity and propagation of shape, its own trivial simplifications, and its own special transformations.

### Embedding in SymPy

We implement this matrix algebra in the SymPy langauge.  As in section \ref{sec:sympy-software} we implement the literals and operators as Python classes.

~~~~~~~~~~Python
# Literals
class MatrixSymbol(MatrixExpr):
    ...
class Identity(MatrixExpr):
    ...
class ZeroMatrix(MatrixExpr):
    ...

# Operators 
class MatAdd(MatrixExpr):
    ...
class MatMul(MatrixExpr):
    ...
class Inverse(MatrixExpr):
    ...
class Transpose(MatrixExpr):
    ...
~~~~~~~~~~

In this case however matrix expression "literals" contain not only Python variables for identification but also SymPy scalar expressions like `Symbol('n')` for shape information.

We can encode the least squares example above in the following way

~~~~~~~~~~~Python
>>> n = Symbol('n')
>>> m = Symbol('m')
>>> X = MatrixSymbol('X', n, m)
>>> y = MatrixSymbol('y', n, 1)
>>> beta = MatMul(Inverse(MatMul(Transpose(X), X)), Transpose(X), y)
~~~~~~~~~~~

The execution of these commands does not perform any specific numeric computation.  Rather it builds an expression tree that can be analyzed and manipulated in the future.

\begin{figure}[htbp]
\centering
\includegraphics[width=.4\textwidth]{images/beta}
\label{fig:expr}
\end{figure}

### Syntax

As in section \ref{sec:sympy-syntax} we overload Python operator methods `__add__`, `__mul__` to point to `MatAdd` and `MatMul` respectively.  We use Python `property`s to encode `.T` as Tranpose and `.I` as inverse.  This follows the precedent of `NumPy` a popular library for numeric linear algebra.  These changes allow a more familiar syntax for mathematical users

~~~~~~~~~~~Python
>>> beta = (X.T*X).I * X.T * y
~~~~~~~~~~~
