
Linear Regression
-----------------

\label{sec:linear-regression}

Linear regression is a common computational problem in data driven science.  It is used to find parameters $\beta$ such that several equations of the form $\beta_n x_{i,n} + \beta_{i,n-1} x_{i,n-1} + \beta_{i,1} x_{i,1} + \beta_{i,0} = y_i$ are correct possible for many $i$.  In practice there are many more equations than unknowns and so these equations can not be satisfied exactly.  Instead the $\beta$s are chosen to minimize the squared error.

$$ X \beta \cong y $$

\begin{figure}[htbp]
\centering
\includegraphics[width=.4\textwidth]{images/linregress-xy}
\end{figure}

The solution to this problem can be posed as a matrix expression.  The $\beta_i$ which minimize the squared error of the above equation can be computed by the following

$$ \beta = (X^TX)^{-1}X^Ty $$


### Naive Implementation

Writing code to compute this expression given variables `X` and `y` can be challenging in a low-level language.  Algorithms for multiplication and solution of matrices are not commonly known, even by practicing statisticians.  Fortunately high-level languages like Matlab and Python/NumPy provide idiomatic solutions to these problems.

Math

$$ \beta = (X^TX)^{-1}X^Ty $$

-------------- -----------------------------
 Python/NumPy  `beta = (X.T*X).I * X.T*y`
 MatLab        `beta = inv(X'*X) * X'*y`
-------------- -----------------------------

The code matches mathematical syntax almost exactly, greatly enabling mathematical programmers.

### Refined Implementations

Unfortunately the code above is very inefficient.  The average numerical analyst will note that this code first computes explicit inverses and then performs a matrix multiply rather than performing matrix solves, an operation for which substantially cheaper and numerically robust methods exist.  A slight change yields the following, vastly improved implementations

-------------- -----------------------------
 Python/NumPy  `beta = solve(X.T*X, X.T*y)`
 MatLab        `beta = X'*X \ X'*y`
-------------- -----------------------------

A particularly astute numerical analyst will find yet another refinement.  In the case when `X` is full rank (this is almost always the case in linear regression) then the left hand side of the solve operation, $X^TX$, is both symmetric and positive definite.  In this case a more efficient solve routine exists based on the Cholesky decomposition.  

The Matlab backslash operator will perform dynamic checks for this property, the Python `solve` routine will not.  The Matlab solution however still suffers from operation ordering issues as the backsolve will target the matrix `X'` rather than the vector `(X'*y)`.

And so a further refined solution might look like the following

-------------- -----------------------------
 Python/NumPy  `beta = solve(X.T*X, X.T*y, sym_pos=True)`
 MatLab        `beta = (X'*X) \ (X'*y)`
-------------- -----------------------------


### BLAS/LAPACK

The high-level syntax in Python and MatLab calls down to routines found within the BLAS/LAPACK libraries for dense linear algebra.  In particular the routine `POSV` for symmetric positive definite matrix solve is the ideal routine in the case presented above.  Searching for and using the correct routine is non-trivial for scientific developers.

    SUBROUTINE DPOSV( UPLO, N, NRHS, A, LDA, B, LDB, INFO )


### Connecting Math and Computation

    TODO: Need better connectivity here

Languages like Matlab, Python, and R have demonstrated the utility of linking a "high productivity" syntax to low-level "high performance" routines like those within BLAS/LAPACK.  While the process of designing efficient programs is notably simpler it remains imperfect.  Naive users are often incapable even of the simple optimizations at the high level language (e.g. using solve rather than computing explicit inverses); these optimizations require significant computational experience.  Additionally, even moderately expert users are incapable of leveraging the full power of BLAS/LAPACK.  This may be because they are unfamiliar with the low-level interface or because their high-level language does not provide clean hooks to the full lower-level library.

Ideally we want to be given a naive input like the following expression and predicates

    (X.T*X).I * X.T*y
    full_rank(X)

We produce the following sophisticated computation

\begin{figure}[htbp]
\centering
\includegraphics[width=.7\textwidth]{images/hat-comp}
\end{figure}

We perform this through a progression of small mathematically informed transformations.

\begin{figure}[htbp]
\centering
\includegraphics[width=.24\textwidth]{images/hat0}
\includegraphics[width=.24\textwidth]{images/hat1}
\includegraphics[width=.24\textwidth]{images/hat2}
\includegraphics[width=.24\textwidth]{images/hat3}
\end{figure}


### User Experience

This search process and the final code emission is handled automatically.  A scientific user has the following experience

~~~~~~~~Python
X = MatrixSymbol('X', n, m)
y = MatrixSymbol('y', n, 1)

inputs  = [X, y]
outputs = [(X.T*X).I*X.T*y]
facts   = fullrank(X)

f = fortran_function(inputs, outputs, facts)
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

This code can be run in a separate context without the Python runtime environment.  Alternatively for interactive convenience it can be linked in with Python's foreign function interface to a callable python function object that consumes the popular numpy array data structure.  This wrapping functionality is provided by the pre-existing and widely supported package `f2py`.


### Numerical Result

We provide timings for various implementations of least squares linear regression under a particular size.  As we increase the sophistication of the method we decrease the runtime substantially.

>>> n, k = 1000, 500

>>> X = np.matrix(np.random.rand(n, k))
>>> y = np.matrix(np.random.rand(n, 1))

>>> timeit (X.T*X).I * X.T*y
10 loops, best of 3: 74.6 ms per loop

>>> timeit numpy.linalg.solve(X.T*X, X.T*y)
10 loops, best of 3: 36.3 ms per loop

>>> timeit scipy.linalg.solve(X.T*X, X.T*y, sym_pos=True)
10 loops, best of 3: 32.8 ms per loop

We now take the most naive user input from SymPy

>>> X = MatrixSymbol('X', n, k)
>>> y = MatrixSymbol('y', n, 1)
>>> beta = (X.T*X).I * X.T*y

And have our compiler build the computation

>>> with assuming(Q.real_elements(X), Q.real_elements(y)):
...     f = build(c, [X, y], [beta])

Our computation originates from the naive user input $(X^TX)^{-1} X^Ty$ but, due to inplace execution and the use of `SYRK` executes faster than the most sophisticated version that the `scipy` stack provides.

>>> timeit f(nX, ny)
10 loops, best of 3: 22.9 ms per loop


### Development Result

Our solution produces the numerically optimal result.  It was generated by the most naive expression.  We deliver high quality results to the majority of naive users.
