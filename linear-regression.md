
Linear Regression
-----------------

\label{sec:linear-regression}

Linear regression is a common computational problem in data driven science.It is used to find parameters $\beta$ such that several equations of the form $\\beta_n x_{i,n} + \beta_{i,n-1} x_{i,n-1} + \beta_{i,1} x_{i,1} + \beta_{i,0} = y_i$ are as correct as possible for many $i$.  In practice there are many more equations than unknowns and so these equations can not be satisfied exactly.  Instead the $\beta$s are chosen to minimize the squared error. Graphically this computation looks like the following.

$$ X \beta \cong y $$

\begin{figure}[htbp]
\centering
\includegraphics[width=.4\textwidth]{images/linregress-xy}
\end{figure}

Conveniently this problem can be expressed as a matrix expression.  The $\beta_i$ which minimize the squared error of the above equation can be computed by the following

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

Unfortunately the code above incredibly inefficient.  The average numerical analyst will note that this code first computes explicit inverses and then performs a matrix multiply rather than performing matrix solves, an operation for which substantially cheaper and numerically robust methods exist.  A slight change yields the following, vastly improved implementations

-------------- -----------------------------
 Python/NumPy  `beta = solve(X.T*X, X.T*y)`
 MatLab        `beta = X'*X \ X'*y`
-------------- -----------------------------

A particularly astute numerical analyst will find yet another refinement.  In the case when `X` is full rank (this is almost always the case in linear regression) then the left hand side of the solve operation, $X^TX$, is both symmetric and positive definite.  In this case a more efficient solve routine exists based on the Cholesky decomposition.  

The Matlab backslash operator will perform dynamic checks for this property, the Python `solve` routine will not.  The Matlab solution however still suffers from operation ordering issues as the backsolve will target the matrix `X'` rather than the vector `(X'*y)`.

And so a further refined solution might look like the following

-------------- -----------------------------
 Python/NumPy  `beta = spd_solve(X.T*X, X.T*y)`
 MatLab        `beta = (X'*X) \ (X'*y)`
-------------- -----------------------------

Unfortunately the `spd_solve` routine does not exist.

### BLAS/LAPACK

Fortunately such routines do exist within the BLAS/LAPACK libraries for dense linear algebra.  In particular the routine `POSV` for symmetric positive definite matrix solve is the ideal routine in this case.  As previously noted searching for and using the correct routine is non-trivial for scientific developers. 

    SUBROUTINE DPOSV( UPLO, N, NRHS, A, LDA, B, LDB, INFO )

### Connecting Math and Computation

Given the following expression and predicates

    (X.T*X).I*X.T*y
    full_rank(X)

We wish to produce the following computation

\begin{figure}[htbp]
\centering
\includegraphics[width=.7\textwidth]{images/hat-comp}
\end{figure}

This can be accomplished through the following progression

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

This code can be run in a separate context without the Python runtime environment.  Alternatively it can be linked in with Python's foreign function interface to a callable python function object that consumes the popular numpy array data structure. 
