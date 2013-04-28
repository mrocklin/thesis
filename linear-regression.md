
### Linear Regression

\label{sec:linear-regression}

Linear regression is a common computational problem in data driven science.It is used to find parameters $\beta$ such that several equations of the form $\\beta_n x_{i,n} + \beta_{i,n-1} x_{i,n-1} + \beta_{i,1} x_{i,1} + \beta_{i,0} = y_i$ are as correct as possible for many $i$.  In practice there are many more equations than unknowns and so these equations can not be satisfied exactly.  Instead the $\beta$s are chosen to minimize the squared error. Graphically this computation looks like the following.

$$ X \beta \cong y $$

\begin{figure}[htbp]
\centering
\includegraphics[width=.4\textwidth]{images/linregress-xy}
\end{figure}

Conveniently this problem can be expressed as a matrix expression.  The $\beta_i$ which minimize the squared error of the above equation can be computed by the following

$$ \beta = (X^TX)^{-1}X^Ty $$

#### Naive Implementation

Writing code to compute this expression given variables `X` and `y` can be challenging in a low-level language.  Algorithms for multiplication and solution of matrices are not commonly known, even by practicing statisticians.  Fortunately high-level languages like Matlab and Python/NumPy provide idiomatic solutions to these problems.

Math

$$ \beta = (X^TX)^{-1}X^Ty $$

-------------- -----------------------------
 Python/NumPy  `beta = (X.T*X).I * X.T*y`
 MatLab        `beta = inv(X'*X) * X'*y`
-------------- -----------------------------

The code matches mathematical syntax almost exactly, greatly enabling mathematical programmers.

#### Refined Implementations

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
