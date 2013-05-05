
Compilation of Matrix Expressions to Computations
-------------------------------------------------

\label{sec:matrix-compile}

The projects SymPy matrix expressions (section \ref{sec:matrix-language}) and Computations (section \ref{sec:computations}) are logically distinct.  They are developed separately in different repositories by different communities.  We now consider the problem of selecting the right set of computations to compute a given set of mathematical expressions.  Selecting the a valid set of computations to cover the expressions is non-trivial.  Additionally there may be multiple valid sets of computations able to cover the given expressions.  In practice expert numerical programmers base this decision on a number of factors depending on both the mathematical problem and the target hardware.

We are now in a situation where a large quantity of expertise must be formally described by a community without a strong tradition in automated methods.  As in section \ref{sec:matrix-refine} we seek to enable this transcription through declarative programming.  We encode this expertise in two separate sets of data


### Compute Patterns 

We ask computational experts to encode what expressions can be broken down by which expressions.  For example we know that expressions like $\alpha A B + \beta C$ can be broken into their components $\alpha, A, B, \beta, C$ via computations like `GEMM` or `SYMM`.  In cases like `SYMM` additional constraints must be met on the inputs.  We might want to encode this pattern as follows

    [alpha*A*B + beta*C] -> [alpha, A, B, beta, C] via SYMM if A or B is symmetric

In practice we encode the above patterns as `(source expression,  computation,  condition)` Python tuples.

    (alpha*A*B + beta*C ,  GEMM(alpha, A, B, beta, C) ,  True)
    (alpha*A*B + beta*C ,  SYMM(alpha, A, B, beta, C) ,  Q.symmetric(A) | Q.symmetric(B))


### Objective Function

The above patterns specify the possible transformations.  There are often several valid sets of BLAS/LAPACK routines to compute any given expression.  In the above example if `A` or `B` is symmetric than either `GEMM` or `SYMM` may be used with equal validity.  How do we choose which to use?

We ask the user to provide an objective function that ranks the overall quality of a computation.  This might include runtimes, power cost, or an easily accessible proxy like FLOPs.  

Operationally we default to an ordering on computations that places specialized operations like `SYMM` above equivalent but general operations like `GEMM`. 

### Strategy

Given a set of patterns/decisions and an objective function we search a graph of all possible transformations for the optimal computation.

At each stage of the compilation we must decide between a set of compute patterns valid at that stage.  The objective function can assist us in this selection.  However greedily following the objective function may lead us into a local minimum.  Computing all possibilities may lead to combinatorial blowup.

We resolve this problem by separating it.  We implement a subset of the Stratego language for control flow programming as a set of higher order functions in Python.  This allows the separate construction of traveral strategies of our graph of possible computations.  We then implement strategies like greedy or brute force and can assess their performance.

Operationally we default to a greedy strategy.

