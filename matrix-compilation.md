
Covering Matrix Expressions with Computations
---------------------------------------------

\label{sec:matrix-compilation}

We put the software pieces together.  We search for high quality computations to compute a set of matrix expressions.  This will require functionality from the following sections

*   Matrix Language \ref{sec:matrix-language}: extends SymPy to handle symbolic linear algebra
*   Computations \ref{sec:computations}: describes BLAS/LAPACK at a high level and provides Fortran90 code generation
*   Pattern Matching \ref{sec:pattern} and LogPy \ref{sec:logpy}: provides functionality to match a current state to a set of valid next states
*   Graph Search \ref{sec:search}: traverses a potentially large tree of decisions to arrive at a "good" final state.

These projects are disjoint.  In this section we describe the information necessary to compose them to solve our problem in automated generation of mathematically informed linear algebra routines. 


### A Graph of Computations

Given a set of expressions-to-be-computed we consider a tree where:

*   Each node is a computation whose outputs include those expressions
*   An edge exists between two nodes if we know a transformation to produce one computation from the other

At the top of this tree is the trivial identity computation which computes the desired outputs given those same outputs as inputs.  At the bottom of this tree are computations whose inputs are not decomposable by any of our patterns.  In particular, some of these leaf computations have inputs that are all atoms; we call these leaves valid.

In principle this tree can be very large negating the possibility of exhaustive search in the general case.  Additionally some branches of this tree may contain dead-ends requiring back-tracking; we may not be able to find a valid all-inputs-are-atoms leaf within a subtree.   We desire an algorithm to find a valid and high-quality leaf of this tree efficiently.

This problem matches the abstract version in Section \ref{sec:search-direct} on algorithmic search.  In that section we discussed the declarative definition and application of rewrite rules and algorithms to search a decision tree given the following interface: 

    children  ::  node -> [node]
    objective ::  node -> score
    isvalid   ::  node -> bool

In this section we implement a concrete version.  We provide a set of transformation patterns and implementations of the search interface functions.

Section \ref{sec:matrix-patterns} describes transformations declaratively in `SymPy` and `computations`.  Section \ref{sec:matrix-children} uses these transformations and `LogPy` to define the `children` function.  Section \ref{sec:matrix-objective} discusses a simple and effective objective functions on intermediate computations.  Section \ref{sec:matrix-isvalid} quickly defines a validity function.  Section \ref{sec:matrix-search} reproduces a function for simple greedy search with backtracking first encountered in Section \ref{sec:search}.  Finally, Section \ref{sec:matrix-compilation-compile} produces our final code.

We reinforce that this is the entirety of the solution for the particular problem of automated search of dense linear algebra algorithms.  All other intelligence is distributed to the appropriate application agnostic package.


### Compute Patterns 

\label{sec:matrix-patterns}

Computations are used to break expressions into smaller pieces much in the way an enzyme breaks a protein into constituents.  For example $\alpha A B + \beta C$ can be broken into the components $\alpha, A, B, \beta, C$ using the various Matrix Multiply routines (`GEMM`, `SYMM`, `TRMM`).  To determine this automatically we create a set of patterns that match expressions to computations valid in that case.   We encode this information in `(source expression,  computation,  condition)` patterns.

~~~~~~~~~~~~~~Python
include [Patterns](patterns.py)
~~~~~~~~~~~~~~

These patterns can be encoded by computational experts and can be used by pattern matching systems such as LogPy.

~~~~~~~~~~~~~~Python
include [Computes](computes.py)
~~~~~~~~~~~~~~


### Children of a Computation

\label{sec:matrix-children}

Given a computation we compute a set of possible extensions with simpler inputs.  We search the list of patterns for all computations which can break down one of the non-trivial inputs.  Any of the resulting computations may be added into the current one.

Our solution with LogPy and `computations` depends on `rewrite_step` from \ref{sec:pattern-logpy} and looks like the following:

~~~~~~~~~~~~~~Python
include [Children](children.py)
~~~~~~~~~~~~~~


### Validity

\label{sec:matrix-isvalid}

When we build a computation we ask for the desired inputs of that computation.  Our frontend interface will look like the following:

~~~~~~~~~~~~~~Python
#      compile(inputs,       outputs       ,   assumptions )
comp = compile([X, y],  [(X.T*X).I * X.T*y],  Q.fullrank(X))
~~~~~~~~~~~~~~

We desire computations whose inputs are restricted to those requested.

~~~~~~~~~~~~~~Python
def isvalid(comp):
    return set(comp.inputs).issubset(inputs)
~~~~~~~~~~~~~~


### Objective Function

\label{sec:matrix-objective}

To guide our search we use an objective function to rank the overall quality of a computation.  In general this function might include runtime, energy cost, or an easily accessible proxy like FLOPs.

Operationally we compute a much simpler objective function.  We order atomic computations so that specialized operations like `SYMM` are preferred over mathematically equivalent but computationally general operations like `GEMM`.  Less efficient operations like `AXPY` are deemphasized by placing them at the end.  This function often produces results that match decisions made by individual experts when writing code by hand. 

~~~~~~~~~~~~~~Python
include [Objective](objective.py)
~~~~~~~~~~~~~~

The list `order` is trivially accessible by numeric experts.  This solution is intuitive to extend and works surprisingly well in practice.


### Search

\label{sec:matrix-search}

We re-present the tree search problem first defined in Section \ref{sec:search}.  Fortunately this problem is easily separable.  For cohesion we restate our greedy solution below:

~~~~~~~~~~~~~~Python
include [Greedy Search](greedy.py)
~~~~~~~~~~~~~~

Note that this solution is ignorant of the application of matrix computations.

### Compile 

\label{sec:matrix-compilation-compile} 

We coordinate these functions in the following master function:

~~~~~~~~~~~~~~Python
include [Compile master function](compile.py)
~~~~~~~~~~~~~~

### Analysis

We chose to explicitly provide code in this section both for completeness and to demonstrate the simplicity of this problem once the appropriate machinery is in place.
We showed that once the generally applicable components exist the particular problem of automated matrix algorithm search can be reduced to around 40 lines of general purpose code (including comments and whitespace).  The `conglomerate` project contains very little logic outside of what is present in the application agnostic and reusable packages (like LogPy).  The information that is present is largely expert knowledge for this application (like the objective function or patterns.)

\newpage

### Finished Result

~~~~~~~~~~~~~~Python
include [Patterns](patterns.py)
include [Computes](computes.py)

include [Children](children.py)

include [Objective](objective.py)

include [Compile master function](compile.py)
~~~~~~~~~~~~~~
