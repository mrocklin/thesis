
Mathematical Numerical Linear Algebra
=====================================

\label{sec:math-num-linalg-performance}

This should eventually be a sizable chapter on the performance of our solution mathematically informed, blocked linear algebra.

--------------------------------------------------------------------------
 Section          Contents                                                                                                          
---------------- ---------------------------------------------------------
 Background       BLAS/LAPACK, Matrix Algebra/inference, 
                  Why do we need array compilers?                                            

 Related work     FLAME, Magma, PLAPACK, 
                  various array programming languages                                                        

 Implementation   Matrix algebra, inference, BLAS/LAPACK DAG generation, 
                  inplace processing, code generation                        

 Results          Several intermediate representations, 
                  highlight particular optimizations, 
                  compare on a couple real world problems 
--------------------------------------------------------------------------

High Productivity Languages
---------------------------

"High productivity" languages haved gained popularity in recent years.  These languages target application domain programmers by reducing barriers to entry and providing syntax for high-level constructs.  Scripting languages like MatLAB, R, and Python remove explicit typing, separate compilation steps, and support high level primitives for matrix and common statistical operations.  These languages allow non-expert programmers the abillity to solve a certain class of common problems with little training in traditional programming.

Need for Compilers in Numerial Linear Algebra
---------------------------------------------

Each of these languages provide a set of high performance array operations.  A small set of array operations like matrix multiplication, solve, slicing, and elementwise scalar operations can be combined to solve a wide range of problems in statistical and scientific domains.  Because this set is small these routines can be implemented by language designers in a lower-level language and then conveniently linked to the high-productivity syntax, providing a good separation of expertise. These efforts have proven popular and useful among applied communities.

None of these popular array programming languages are compiled (TODO: are there counter-examples?).  Because the array operations call down to precompiled library code this may seem unnecessary.

include [Operation Ordering in Matlab](operation-ordering-matlab.md)

Related Work
------------

Both the broad applicability of this domain and the performance improvments from expert treatment have made it the target of substantial academic study and engineering efforts.

### Statically compiled libraries - BLAS/LAPACK

### Heterogeneous computing - Magma

### Automated methods - FLAME

BLAS/LAPACK, Magma, and FLAME all build custom treatments of linear algebra in order to create high performance libraries.  Unfortunately there is duplication and an inability to share the intermediate logic with other projects.  


Language
--------

\label{sec:language}

In SymPy Matrix Expressions we express linear algebra theory in isolation, separately from any specific attmept of automated algorithm search.  `sympy.matrices.expressions` is a module within the open source computer algebra system SymPy, based in the Python language. 

Operations/sorts in SymPy are implemented as Python classes.  A term is an instantiation of such a class with a set of children.  Matrix Expressions implements the following core types

    MatrixSymbol
    MatAdd
    MatMul
    Transpose
    Inverse

The Python language allows hooks into arithmetic operator syntax allowing mathematically idiomatic construction of terms as might be found in specialized matrix languages such as MatLab.  
    
    n = Symbol('n')
    X = MatrixSymbol('X', n, n)
    Y = MatrixSymbol('Y', n, n)
    Z = X*Y + X.T

The execution of these commands does not perform any specific numeric computation.  Rather it builds an expression tree that can be analyzed and manipulated.

### Basic Logic and Canonicalization

At expression construction time (during the `__init__` call in the Python object) basic shape checking is done to ensure validity of the expression.  Additionally, a set of mathematically trivial presumed desired transformations occur such as

    tree flattening         MatMul(X, MatMul(Y, Z)) -> MatMul(X, Y, Z)
    trivial identities      Transpose(Transpose(X)) -> X
    simple simplifications  X + X                   -> 2*X

### Extensions

A number of additional types have been added to this system including 

    Trace, Deterimant, BlockMatrix, MatrixSlice, Identity, ZeroMatrix, 
    Adjoint, Diagonal Matrix, HadamardProduct, ElemwiseMatrix, 
    EigenVectors, EigenValues, ....

Because the scope of this project is quite small the barrier to add new types is low and has been accomplished by novice contributors.


Inference on predicates
-----------------------

SymPy provides a system for logical inference on mathematical expressions.  It includes 

1.  A syntax to state predicates  --  `Q.positive(x) & Q.positive(y)`
2.  A collection of handlers for type-predicate pairs, e.g. the sum of positive numbers is positive
3.  A collection of relations --  `Implies(Q.prime, Q.integer)`
4.  A SAT solver to compute the truth of queries given a set of known facts and relations

We have extended this system to handle common matrix predicates including the following

    positive_definite, invertible, singular, fullrank, symmetric, 
    orthogonal, unitary, normal, upper/lower triangular, diagonal, square,
    complex_elements, real_elements, integer_elements

This allows inference of complex matrix expressions. 

### Example

For all matrices $\mathbf{A, B}$ such that $\mathbf A$ is symmetric positive-definite and $\mathbf B$ is fullrank 

*is $\mathbf B \cdot\mathbf A \cdot\mathbf B^\top$ symmetric and positive-definite?*

~~~~~~~~Python
>>> A = MatrixSymbol('A', n, n)
>>> B = MatrixSymbol('B', n, n)

>>> context = Q.symmetric(A) & Q.positive_definite(A) & Q.fullrank(B)
>>> query   = Q.symmetric(B*A*B.T) & Q.positive_definite(B*A*B.T)

>>> ask(query, context)
True
~~~~~~~~

This particular question arises frequently when developing scientific code.  Significantly more efficient algorithms are applicable in the symmetric positive definite case.  Expressions like $BAB^T$ are very common mathematically.  Unfortunately relatively few scientific users are able to recognize and infer this situation.

This is the first system that can answer questions like this for abstract matrices.


### Refined Simplification

\label{sec:matrix-refine}

This advanced inference enables a substantially larger set of optimizations that depend on logical information.   For example, the inverse of a matrix can be simplified to its transpose if that matrix is orthogonal

    X.I   ->   X.T    if      Q.orthogonal(X)

Linear algebra is a mature field with many such relations \cite{matrix-cookbook}.  It is challenging to write them down.  We hope to leverage the linear algebra community to develop this further.  In order to accomplish this we endeavor to reduce the extent of the code-base with which a mathematician must familiarize themselves to encode these relations.  

Our original approach to this problem was through a meta-programming and term rewrite system \cite{matrix-algebra}.  Our original implementation of automated matrix algebra was written in Maude and contained expressions like the following

    inverse(X) = transpose(X) if X is orthogonal

The meta-programming approach allowed the specification of mathematical relations in a math-like syntax, drastically lowering the barrier of entry for potential mathematical developers.  The term-rewrite infrastructure allowed these relations to be automatically applied by generic, mature, and computationally efficient strategies.

Unfortunately the Maude system is an exotic dependency in scientific community and interoperability with low-level computational codes was not a priority in it's development. 

Our final implementation depends on LogPy, discussed later in section \ref{sec:declarative} to implement a term rewrite system without the convenient syntax.  A set of transformations are encoded in `(source, target, condition)` tuples.  A set of these tuples are then fed into a term rewrite system and used to simplify matrix expressions based on complex relations.

    Wanted      X.I   ->   X.T    if      Q.orthogonal(X)
    Delivered  (X.I    ,   X.T     ,      Q.orthogonal(X))

These allow mathematical users to encode mathematical expertise and have that expertise be automatically applied to all problems described in this system.  Extending the set of simplification relations is straightforward and approachable to a very broad community.  Additionally, this declarative nature allows us to swap out the term rewrite system backend should future development produce more mature solutions.

Computations - BLAS/LAPACK
--------------------------

\label{sec:computations}

The above systems live in SymPy, a library for *symbolic* computer algebra.  SymPy is not appropriate for numeric computation.  In this chapter we describe a system to generate numeric codes to compute the mathematical expressions described in SymPy.  Our primary target will be Modern Fortran code that calls down to the curated BLAS/LAPACK libraries for dense linear algebra.  These libraries have old and unstructured interfaces which are difficult to target with automated systems.  To resolve this issue we build a high-level description of these computations as an intermediary.  We use SymPy matrix expressions to assist with this high level description.  This system will be extensible to support other low-level libraries.  We believe that its separation makes it broadly applicable to applications beyond our own.

Specifically we present a small library to encode low-level computational routines that is amenable to manipulation by automated high-level tools.  This library is extensible and broadly applicable.

### BLAS and LAPACK

Describe BLAS and LAPACK

### Atomic Computations

Every BLAS/LAPACK routine can be logically identified by a set of inputs, outputs, conditions on the inputs, and inplace behavior.  Additionally each routine can be imbued with code for generation of the inline call in a variety of languages.  In our implementation we focus on Fortran but C, scipy, or even CUDA could be added without substantial difficulty.

Each routine is represented by Python class

~~~~~~~~~~~~~Python
class SYMM(BLAS):
    _inputs   = [alpha, A, B, beta, C]
    _outputs  = [alpha*A*B + beta*C]
    condition = symmetric(A) or symmetric(B)
    inplace   = {0: 4}
~~~~~~~~~~~~~Python

Specific instances of each computation can be constructed by providing corresponding inputs, traditionally SymPy Expressions. 

    >>> X = MatrixSymbol('X', n, n)
    >>> Y = MatrixSymbol('Y', n, n)
    >>> symm = SYMM(1, X, Y, 0, Y)
    >>> symm.inputs
    [X, Y]
    >>> symm.outputs
    [X*Y]

Computations can take compound expressions as inputs

    >>> axpy = AXPY(5, X*Y, Y)
    >>> axpy.inputs
    [X*Y, Y]
    >>> axpy.outputs
    [5*X*Y + Y]

### Composite Computations

Basic logic exists for the conglomeration of multiple computations.  Atomic computations are stored in a set.  Properties about the composite computation such as inputs, outputs, and topological sort can be computed

    >>> composite = axpy + symm
    >>> composite.inputs
    [X, Y]
    >>> composite.outputs
    [5*X*Y + Y]

\begin{figure}[htbp]
\centering
\includegraphics[width=.5\textwidth]{images/symm-axpy}
\end{figure}

### Inplace Transformations

The computations above are mathematical in nature.  They consider only mathematical transformations that are performed by the computations and not the computational concerns; in particular they are ignorant of memory use.  We provide transformations to a second representation where each variable contains both mathematical information and a unique token identifier.

This representation handles the inplace nature of BLAS/LAPACK calls by injecting `COPY` operations and removing them when possible.

\begin{figure}[htbp]
\centering
\includegraphics[width=.7\textwidth]{images/symm-axpy-inplace}
\end{figure}

### Fortran Code Generation

From such a directed acyclic graph we can generate readable low-level code.  We focus on Fortran 90.

We traverse the graph to find all variables.  We use their position in the graph and optional user input to determine intent (input, output).  We use the associated mathematical variable to determine type and shape.  We use the identification token to determine the variable name.  

We topologically sort the graph of atomic computations to obtain a linear ordering.  Each computation object (e.g. `symm` or `axpy`) is then given the variable names of it's variables and then emits the Fortran code necessary to call its associated BLAS/LAPACK routine.

### Extensibility

This model is not specific to BLAS/LAPACK.  In particular other developers have extended this to include other high performance numerical libraries like FFTW and ARPACK.


Compilation of Matrix Expressions to Computations
-------------------------------------------------

\label{sec:linalg-compilation}

SymPy matrix expressions \ref{sec:language} and Computations \ref{sec:computations} are logically distinct.  They are developed separately in different repositories by different communities.  Expert numerical programmers apply specific computations to compute particular patterns of matrix expresssions.  They base this decision on a number of factors depending on both the mathematical problem and target hardware.  Selecting the best computation to cover the expressions is non-trivial.

As in section \ref{sec:matrix-refine} we are in a situation where a large quantity of expertise must be formally described by a community without a strong tradition in automated methods.  We seek to enable this transcription by building a system to allow numerical algorithms experts encode information as declaratively as possible.  We encode this expertise in two separate sets of data


### Compute Patterns 

We ask computational experts to encode what expressions can be broken down by which expressions.  For example we know that expressions like $\alpha A B + \beta C$ can be broken into their components $\alpha, A, B, \beta, C$ via computations like `GEMM` or `SYMM`.  In cases like `SYMM` additional constraints must be met on the inputs.  We might want to encode this pattern as follows

    [alpha*A*B+beta*C] -> [alpha, A, B, beta, C] via SYMM if A or B is symmetric

In practice we encode the above patterns as `(source expression,  computation,  condition)` Python tuples.

    (alpha*A*B*beta*C ,  GEMM(alpha, A, B, beta, C) ,  True)
    (alpha*A*B*beta*C ,  SYMM(alpha, A, B, beta, C) ,  Q.symmetric(A) | Q.symmetric(B))


### Objective Function

The above patterns specify the possible transformations.  There are often several valid sets of BLAS/LAPACK routines to compute any given expression.  In the above example if `A` or `B` is symmetric than either `GEMM` or `SYMM` may be used with equal validity.  How do we choose which to use?

We ask the user to provide an objective function that ranks the overall quality of a computation.  This might include runtimes, power cost, or an easily accessible proxy like FLOPs.  

Operationally we default to an ordering on computations that places specialized operations like `SYMM` above equivalent but general operations like `GEMM`. 

### Strategy

Given a set of patterns/decisions and an objective function we search a graph of all possible transformations for the optimal computation.

At each stage of the compilation we must decide between a set of compute patterns valid at that stage.  The objective function can assist us in this selection.  However greedily following the objective function may lead us into a local minimum.  Computing all possibilities may lead to combinatorial blowup.

We resolve this problem by separating it.  We implement a subset of the Stratego language for control flow programming as a set of higher order functions in Python.  This allows the separate construction of traveral strategies of our graph of possible computations.  We then implement strategies like greedy or brute force and can assess their performance.

Operationally we default to a greedy strategy.


Analysis
--------

We can use these pieces together to transform mathematical expressions into well-selected computations and generate performant, human readable Fortran code.  In section \ref{sec:validation} we will demonstrate the utility of the system described above.  Here we will first motivate its design decisions.


### Small Components Enable Reuse

Solutions to scientific problems often share structure.  Large codes written for specific applications are often too specific to be reusable outside of their intended problem  without substantial coding investment.  Smaller components designed to solve common sub-problems may be more generally applied.


### Smaller Scope Lowers Barriers to Development

These components do not depend on each other for development.  This isolated nature reduces the expertise requirements on potential developers.  Mathematical developers can contribute to SymPy Matrix Expressions even if they are ignorant of Fortran.  Computational developers familiar with BLAS/LAPACK can contribute to `computations` even if they are unfamiliar with compilers.  Shared interfaces propagate these improvements to users at all levels.  The demographics of expertise in scientific computing \ref{sec:expertise} necessitate this decision.


### Multiple Intermediate Representations

Broadly applicable software will never be able to anticipate all possible use cases.  In this situation it is important to provide clean intermediate representations at a variety of levels.  This project allows users to manipulate representations at the math/term, DAG, and Fortran levels.  Care has been taken so that each representation is human readable to specialists within the relevant domain.

This encourages future development within the project.  For example to support multiple output languages we only need to translate from the DAG level, a relatively short conceptual distance relative the the size of the entire project.  We currently support Fortran and DOT (for visualization) but adding other languages is a straightforward process.

This encourages development outside the project.  In section \ref{sec:static-scheduling} we will manipulate the DAG with an external composable static scheduler and then re-inject the transformed result into our compiler chain.  Additionally scientific users can use the resulting Fortran90 code as a template for future by-hand development.
