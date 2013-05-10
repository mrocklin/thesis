
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

*Some of this should go into [search.md](search.md)*

Given a set of expressions-to-be-computed we consider a tree where 

*   Each node is a computation whose outputs include those expressions
*   An edge exists between two nodes if we know a transformation to produce one computation from the other

At the top of this tree is the trivial identity computation which computes the desired outputs given those same outputs as inputs.  At the bottom of this tree are computations whose inputs are not decomposable by any of our patterns.  In particular, some of these leaf computation have inputs that are all atoms; we call these leaves valid.

In principle this tree can be very large which negates the possibility of exhaustive search in the general case.  Additionally some branches of this tree may contain dead-ends (we may not be able to find a valid all-inputs-are-atoms leaf within a subtree.)   We desire an algorithm to efficiently find a valid and high-quality leaf of this tree.

This problem matches the abstract version in section \ref{sec:search.md} on algorithmic search.  In that section we discussed algorithms to search a tree given the following interface functions: 

    children  ::  node -> [node]
    objective ::  node -> score
    isvalid   ::  node -> bool

In sections \ref{sec:matrix-patterns} we will describe transformations declaratively using LogPy.  In section \ref{sec:matrix-children} we will use these transformations to define the `children` function`.  In section \ref{sec:matrix-objective} we discuss objective functions on computations and define a simple and effective one.  In section \ref{sec:matrix-isvalid} we quickly define a validity function.  In section \ref{sec:matrix-search} we reproduce a simple depth first greedy search first encountered in section \ref{sec:search}.  Finally in section \ref{sec:matrix-compilation-compile} we produce our final code.

We reinforce that this is the entirety of our solution for the particular problem of automated search of dense linear algebra algorithms.  All other intelligence is distributed to the appropriate general purpose package.


### Compute Patterns 

\label{sec:matrix-patterns}

We use computations to break expressions into smaller pieces.  For example $\alpha A B + \beta C$ can be broken into the components $\alpha, A, B, \beta, C$ using the various Matrix Multiply routines (`GEMM`, `SYMM`, `TRMM`).  To determine this automatically we create a set of patterns that match expressions to computations valid in that case.   We encode this information in `(source expression,  computation,  condition)` patterns.

~~~~~~~~~~~~~~Python
patterns = [
    (alpha*A*B + beta*C ,  GEMM(alpha, A, B, beta, C) ,  True),
    (alpha*A*B + beta*C ,  SYMM(alpha, A, B, beta, C) ,  Q.symmetric(A) | Q.symmetric(B)),
    ...]

from logpy import facts, Relation
computes = Relation('computes')
facts(computes, *patterns)
~~~~~~~~~~~~~~

These patterns can be encoded by computational experts and can be used by pattern matching systems such as LogPy.


### Children of a Computation

\label{sec:matrix-children}

Given a computation we compute a set of possible extensions with simpler inputs.  We search the list of patterns for all computations which can break down one of the non-trivial inputs.  We can then add any of the resulting new computations into the current one.

Our solution with LogPy and `computations` looks like the following

~~~~~~~~~~~~~~Python
computations_for = partial(rewrite_step, rewrites=computes)

def children(comp):
    """ Compute next options in tree of possible algorithms """
    atomics = sum(map(computations_for, comp.inputs), ())
    return map(comp.__add__, atomics)
~~~~~~~~~~~~~~

### Validity

\label{sec:matrix-valid}

When we build a computation we ask for the desired inputs of that computation. 

~~~~~~~~~~~~~~Python
#      compile(inputs,       outputs       ,   assumptions )
comp = compile([X, y],  [(X.T*X).I * X.T*y],  Q.fullrank(X))
~~~~~~~~~~~~~~

We desire computations whose inputs are restricted to those requested.

~~~~~~~~~~~~~~Python
def isvalid(comp):
    return set(comp.inputs.issubset(set(inputs))
~~~~~~~~~~~~~~


### Objective Function

\label{sec:matrix-objective}

To guide our search we need an objective function to rank the overall quality of a computation.  In general this function might include runtime, energy cost, or an easily accessible proxy like FLOPs.

Operationally we order atomic computations so that specialized operations like `SYMM` are above mathematically equivalent but general operations like `GEMM`. 

~~~~~~~~~~~~~~Python
order = [FFTW, POSV, GESV, LASWP, SYRK, SYMM, GEMM, AXPY]

def objective(comp):
    """ Cost of a computation `comp` - lower is better """
    if isinstance(comp, CompositeComputation):
        return sum(map(objective, comp.computations))
    else:
        return order.index(type(comp))
~~~~~~~~~~~~~~

This simple function is intuitive to extend and works surprisingly well in practice.

### Search

\label{sec:matrix-search}

We discuss the search problem in section \ref{sec:search}.  Fortunately this problem is easily separable.  For cohesion we restate our greedy solution below

~~~~~~~~~~~~~~Python
include [Greedy Search](greedy.py)
~~~~~~~~~~~~~~

Note that this solution is ignorant of our application.  The graph search problem is separable from our application.

### Compile 

\label{sec:matrix-compilation-compile} 

~~~~~~~~~~~~~~Python
include [Compile master function](compile.py)
~~~~~~~~~~~~~~

### Analysis

This section explicitly presents code to demonstrate that once the general purpose pieces are constructed the particular problem of automated matrix algebra algorithm search can be reduced to 10-100 lines of general purpose code.  The Conglomerate project is very small.
