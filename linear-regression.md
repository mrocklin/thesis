
Linear Regression
-----------------

\label{sec:linear-regression}

We automatically generate code to compute least squares linear regression, a common application first encountered in Section \ref{sec:matrix-language}.

$$ X \beta \cong y $$

\begin{figure}[htbp]
\centering
\includegraphics[width=.4\textwidth]{images/linregress-xy}
\caption{Array shapes for linear regression}
\label{fig:linregress-xy}
\end{figure}

The solution to this problem can be posed as the following matrix expression which will serve as the input to our compilation chain.

$$ \beta = (X^TX)^{-1}X^Ty $$


#### Naive Implementation

Writing code to compute this expression given variables `X` and `y` can be challenging in a low-level language.  Algorithms for multiplication and solution of matrices are not commonly known, even by practicing statisticians.  Fortunately high-level languages like Matlab and Python/NumPy provide idiomatic solutions to these problems.

$$ \beta = (X^TX)^{-1}X^Ty $$

-------------- -----------------------------
 Python/NumPy  `beta = (X.T*X).I * X.T*y`
 MatLab        `beta = inv(X'*X) * X'*y`
-------------- -----------------------------

The code matches mathematical syntax almost exactly, enabling mathematical programmers.

#### Refined Implementations

Unfortunately this implementation is also inefficient.  A numerical expert would note that this code first computes an explicit inverse and then performs a matrix multiply rather than performing a direct matrix solve, an operation for which substantially cheaper and numerically robust methods exist.  A slight change yields the following, improved implementation:

-------------- -----------------------------
 Python/NumPy  `beta = solve(X.T*X, X.T*y)`
 MatLab        `beta = X'*X \ X'*y`
-------------- -----------------------------

These implementations can again be refined.  In the case when `X` is full rank (this is often the case in linear regression) then the left hand side of the solve operation, $X^TX$, is both symmetric and positive definite.  The symmetric positive definite case supports a more efficient solve routine based on the Cholesky decomposition.

The Matlab backslash operator performs dynamic checks for this property, while the Python/NumPy `solve` routine will not.  The Matlab solution however still suffers from operation ordering issues as the backsolve will target the matrix `X'` rather than the vector `(X'*y)`.

And so a further refined solution looks like the following, using a specialized solve from the `scipy` Python library and explicitly parenthesizing operations in MatLab.

-------------- -----------------------------
 Python/NumPy  `beta = scipy.solve(X.T*X, X.T*y, sym_pos=True)`
 MatLab        `beta = (X'*X) \ (X'*y)`
-------------- -----------------------------


#### Connecting Math and Computation

Languages like Matlab, Python, and R have demonstrated the utility of linking a "high productivity" syntax to low-level "high performance" routines like those within BLAS/LAPACK.  While the process of designing efficient programs is notably simpler, it remains imperfect.  Naive users are often incapable even of the simple optimizations at the high level language (e.g. using solve rather than computing explicit inverses); these optimizations require significant computational experience.  Additionally, even moderately expert users are incapable of leveraging the full power of BLAS/LAPACK.  This may be because they are unfamiliar with the low-level interface, or because their high-level language does not provide clean hooks to the full lower-level library.

Ideally we want to be given a naive input like the following expression and predicates:

    (X.T*X).I * X.T*y
    full_rank(X)

We produce the following sophisticated computation:

\begin{figure}[htbp]
\centering
\includegraphics[width=.7\textwidth]{images/hat-comp}
\caption{A computation graph for least squares linear regression}
\label{fig:hat-comp}
\end{figure}

We perform this through a progression of small mathematically informed transformations.

\begin{figure}[htbp]
\centering
\includegraphics[width=.24\textwidth]{images/hat0}
\includegraphics[width=.24\textwidth]{images/hat1}
\includegraphics[width=.24\textwidth]{images/hat2}
\includegraphics[width=.24\textwidth]{images/hat3}
\caption{A progression of computations to evolve to the computation in Figure \ref{fig:hat-comp}}
\label{fig:hat-comp-progression}
\end{figure}

We engage the pattern matching and search system described in Section \ref{sec:term-rewrite-system} to transform the mathematical expression into the computational directed acyclic graph.


#### User Experience

This search process and the final code emission is handled automatically.  A scientific user has the following experience:

~~~~~~~~Python
X = MatrixSymbol('X', n, m)
y = MatrixSymbol('y', n, 1)

inputs  = [X, y]
outputs = [(X.T*X).I*X.T*y]
facts   = Q.fullrank(X)
types   = Q.real_elements(X), Q.real_elements(y)

f = build(inputs, outputs, facts, *types)
~~~~~~~~~


This generates the following Fortran code.

~~~~~~~~Fortran
subroutine f(X, y, var_7, m, n)
implicit none

integer, intent(in) :: m
integer, intent(in) :: n
real*8, intent(in) :: y(n)          !  y
real*8, intent(in) :: X(n, m)       !  X
real*8, intent(out) :: var_7(m)     !  0 -> X'*y -> (X'*X)^-1*X'*y
real*8 :: var_8(m, m)               !  0 -> X'*X
integer :: INFO                     !  INFO

call dgemm('N', 'N', m, 1, n, 1.0, X, n, y, n, 0.0, var_7, m)
call dgemm('N', 'N', m, m, n, 1.0, X, n, X, n, 0.0, var_8, m)
call dposv('U', m, 1, var_8, m, var_7, m, INFO)

RETURN
END
~~~~~~~~~

This code can be run in a separate context without the Python runtime environment.  Alternatively for interactive convenience it can be linked in with Python's foreign function interface to a callable python function object that consumes the popular NumPy array data structure.  This wrapping functionality is provided by the pre-existing and widely supported package `f2py`.


#### Numerical Result

\label{sec:linear-regression-numeric-result}

We provide timings for various implementations of least squares linear regression under a particular size.  As we increase the sophistication of the method we decrease the runtime substantially.

~~~~~~~~~~Python
>>> n, k = 1000, 500

>>> X = np.matrix(np.random.rand(n, k))
>>> y = np.matrix(np.random.rand(n, 1))

>>> timeit (X.T*X).I * X.T*y
10 loops, best of 3: 76.1 ms per loop

>>> timeit numpy.linalg.solve(X.T*X, X.T*y)
10 loops, best of 3: 55.4 ms per loop

>>> timeit scipy.linalg.solve(X.T*X, X.T*y, sym_pos=True)
10 loops, best of 3: 33.2 ms per loop
~~~~~~~~~~

We now take the most naive user input from SymPy

~~~~~~~~~~Python
>>> X = MatrixSymbol('X', n, k)
>>> y = MatrixSymbol('y', n, 1)
>>> beta = (X.T*X).I * X.T*y
~~~~~~~~~~

And have our compiler build the computation:

~~~~~~~~~~Python
>>> with assuming(Q.real_elements(X), Q.real_elements(y)):
...     comp = compile([X, y], [beta])
...     f = build(comp, [X, y], [beta])
~~~~~~~~~~

Our computation originates from the naive user input $(X^TX)^{-1} X^Ty$ but competes with the most sophisticated version that the `scipy` stack provides.

~~~~~~~~~~Python
>>> timeit f(nX, ny)
10 loops, best of 3: 30.9 ms per loop
~~~~~~~~~~

Disclaimer: These times are dependent on matrix size, architecture, and BLAS/LAPACK implementation.  Results may vary.  The relevant point is the comparable performance rather than the explicit numbers.


#### Development Result

Our solution produces the numerically optimal result.  It was generated by the most naive expression.  We deliver high quality results to the majority of naive users.

This result is not isolated to the particular application of linear regression.  SymPy supports the expression of a wide range of matrix computations ranging from simple multiplies to complex factorizations and solves.

Finally we mention that further room for improvement exists.  Least squares problems can be solved with a single specialized LAPACK routine.  This routine depends on the QR factorization for greater numerical stability.
