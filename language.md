
Language
--------

\label{sec:matrix-language}

*I probably need help to understand both the ideal style and extent that a section like this should have*

In SymPy Matrix Expressions we express linear algebra theory in isolation, from any specific attmept of automated algorithm search.  `sympy.matrices.expressions` is a module within the open source computer algebra system SymPy, based in the Python language. 

Operations/sorts in SymPy are implemented as Python classes.  A term is an instantiation of such a class with a set of children stored as instance variables.  Matrix Expressions implements the following core types

    MatrixSymbol
    MatAdd
    MatMul
    Transpose
    Inverse

The Python language allows hooks into arithmetic operator syntax allowing mathematically idiomatic construction of terms such as might be found in specialized matrix languages such as MatLab.  
    
    n = Symbol('n')
    X = MatrixSymbol('X', n, n)
    Y = MatrixSymbol('Y', n, n)
    Z = X*Y + X.T

The execution of these commands does not perform any specific numeric computation.  Rather it builds an expression tree that can be analyzed and manipulated in the future.

### Basic Logic and Canonicalization

At expression construction time (during the `__init__` call in the Python object) basic shape checking is done to ensure validity of the expression.  Additionally, a set of mathematically trivial and presumed-always-desired transformations occur such as

    tree flattening         MatMul(X, MatMul(Y, Z)) -> MatMul(X, Y, Z)
    trivial identities      Transpose(Transpose(X)) -> X
    simple simplifications  X + X                   -> 2*X

### Extensions

A number of additional types have been added to this system including 

    Trace, Deterimant, BlockMatrix, MatrixSlice, Identity, ZeroMatrix, 
    Adjoint, Diagonal Matrix, HadamardProduct, ElemwiseMatrix, 
    EigenVectors, EigenValues, ....

Because the scope of this project is quite small the barrier to add new types is low and has been accomplished by novice contributors.

*Question:  How deeply should I describe the capabilities of this system?*

