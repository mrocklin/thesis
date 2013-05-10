
Covering Matrix Expressions with Computations
-------------------------------------------------

\label{sec:matrix-compilation}

include [Tikz](tikz_megatron.md)

In this section we put the pieces together.  We search for high quality computations to compute a set of matrix expressions.  This will require functionality from the following sections

*   Matrix Language \ref{sec:matrix-language}: extends SymPy to handle symbolic linear algebra
*   Computations \ref{sec:computations}: describes BLAS/LAPACK at a high level and provides Fortran90 code generation
*   Pattern Matching \ref{sec:pattern} and LogPy \ref{sec:logpy}: provides functionality to match a current state to a set of valid next states
*   Graph Search \ref{sec:search}: traverses a potentially large tree of decisions to arrive at a "good" final state.

These projects are disjoint.  In this section we describe the information necessary to compose them to solve our problem in automated generation of mathematically informed linear algebra routines. 


### A Graph of Computations

Given a set of expressions-to-be-computed we consider a tree where 

*   each node is a computation whose outputs include those expressions
*   An edge exists from A to B if we know how to get from A to B through the addition or subtraction of an atomic computation. 

At the top of this tree is the trivial identity computation which computes the desired outputs given them as inputs.  At the bottom of this tree are computations whose inputs are not decomposable by one of our patterns.  In particular, some of these leaves have inputs that are all atoms; we call these leaves valid.

In principle this tree can be very large, negating the possibility of exhaustive search in the general case.  Additionally some branches of this tree may contain dead-ends (we may not be able to find a valid all-inputs-are-atoms leaf within a subtree.)   We desire an algorithm which quickly finds a valid and high-quality leaf of this tree.  

We pose this as a search problem where we start at the root of the tree (the trivial identity computation) and search down the tree, reducing inputs at each step.  In the following sections we describe the elements of this search in more detail.


### Compute Patterns 

We use computations to break expressions into smaller pieces.  For example $\alpha A B + \beta C$ can be broken into the components $\alpha, A, B, \beta, C$ using the various Matrix Multiply routines (`GEMM`, `SYMM`, `TRMM`).  To determine this automatically we create a set of patterns that match expressions to computations valid in that case.   We encode this information in `(source expression,  computation,  condition)` patterns.

~~~~~~~~~~~~~~Python
patterns = [
    (alpha*A*B + beta*C ,  GEMM(alpha, A, B, beta, C) ,  True),
    (alpha*A*B + beta*C ,  SYMM(alpha, A, B, beta, C) ,  Q.symmetric(A) | Q.symmetric(B)),
    ...]
~~~~~~~~~~~~~~

These patterns can be encoded by computational experts and can be used by pattern matching systems such as LogPy.


### Extending a Computation

Given a computation we compute a set of possible extensions with simpler inputs.  We search the list of patterns for all computations which can break down one of the non-trivial inputs.  We can then add any of the resulting new computations into the current one.

Our solution with LogPy and `computations` looks like the following

~~~~~~~~~~~~~~Python
computations_for = partial(rewrite_step, rewrites=patterns)

def children(comp):
    """ Compute next options in tree of possible algorithms """
    atomics = sum(map(computations_for, comp.inputs), ())
    return map(comp.__add__, atomics)
~~~~~~~~~~~~~~


### Non-Confluence

In general there are several valid computations to solve any particular set of expressions.  Depending on the pattern/new computation we choose to add we will search 

In the general case multiple patterns will match our input.  

The above patterns specify the possible transformations.  There are often several valid sets of BLAS/LAPACK routines to compute any given expression.  In the above example if `A` or `B` is symmetric than either `GEMM` or `SYMM` may be used with equal validity.  While our set of transformations does terminate it is not confluent; there are several possible outcomes.


### Objective Function

To guide our search we need an objective function to rank the overall quality of a computation.  In general this function might include runtime, energy cost, or an easily accessible proxy like FLOPs.

Operationally we order atomic computations so that specialized operations like `SYMM` are above mathematically equivalent but general operations like `GEMM`. 

~~~~~~~~~~~~~~Python
order = [FFTW, POSV, GESV, LASWP, SYRK, SYMM, GEMM, AXPY]

def objective(C):
    if isinstance(C, CompositeComputation):
        return sum(map(objective, C.computations))
    else:
        return order.index(type(c))
~~~~~~~~~~~~~~


### Strategy

Pattern matching and the function `children` above define the set of steps we can take from any state.  An objective function gives us some understanding about the local quality of intermediate states.  This is now an abstract graph search problem.  Common solutions include exhaustive, greedy, and dynamic programming solutions. 

We implement a greedy depth first search 

~~~~~~~~~~~~~~Python
def greedy(children, objective, isleaf, node):
    """ Greedy guided depth first search

    Returns:  a lazy iterator of nodes

    children    :: a -> [a]     --  Children of node
    objective   :: a -> score   --  Quality of node
    isleaf      :: a -> bool    --  Successful leaf of tree
    """
    if isleaf(node):
        return iter([node])

    f = partial(greedy, children, objective, isleaf)
    options = sorted(children(node), key=objective)
    streams = map(f, options)

    return it.chain(*streams)
~~~~~~~~~~~~~~

Note that this solution is ignorant of our application.  The graph search problem is separable from our application.
