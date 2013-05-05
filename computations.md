
Computations - BLAS/LAPACK
--------------------------

\label{sec:computations}

The above systems live in SymPy, a library for *symbolic* computer algebra.  SymPy is not appropriate for numeric computation.  In this chapter we describe a system to generate numeric codes to compute the mathematical expressions described in SymPy.  Our primary target will be Modern Fortran code that calls down to the curated BLAS/LAPACK libraries for dense linear algebra.  These libraries have old and unstructured interfaces which are difficult to target with automated systems.  To resolve this issue we build a high-level description of these computations as an intermediary.  We use SymPy matrix expressions to assist with this high level description.  This system will be extensible to support other low-level libraries.  We believe that its separation makes it broadly applicable to applications beyond our own.

Specifically we present a small library to encode low-level computational routines that is amenable to manipulation by automated high-level tools.  This library is extensible and broadly applicable.  This library also supports low level code generation.

### BLAS and LAPACK

TODO: Describe BLAS and LAPACK

### Atomic Computations

Every BLAS/LAPACK routine can be logically identified by a set of inputs, outputs, conditions on the inputs, and inplace memory behavior.  Additionally each routine can be imbued with code for generation of the inline call in a variety of languages.  In our implementation we focus on Fortran but C, scipy, or even CUDA could be added without substantial difficulty.

Each routine is represented by a Python class

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

The computations above are mathematical in nature.  They consider only mathematical transformations that are performed by the computations and not the computational concerns; in particular they are ignorant of memory use.  We provide transformations to a second representation where each variable contains both mathematical information and a unique identifier.

This representation handles the inplace nature of BLAS/LAPACK calls by injecting `COPY` operations and removing them when possible.

\begin{figure}[htbp]
\centering
\includegraphics[width=.7\textwidth]{images/symm-axpy-inplace}
\end{figure}

### Fortran Code Generation

From such a directed acyclic graph we can generate readable low-level code.  We focus on Fortran 90.

We traverse the graph to find all variables.  We use their position in the graph and optional user input to determine intent (input, output).  We use the associated mathematical variable to determine type and shape.  We use the identification token to determine the variable name.  

We topologically sort the graph of atomic computations to obtain a linear ordering.  Each computation object (e.g. `symm` or `axpy`) is then given the names of its variables and then emits the Fortran code necessary to call its associated BLAS/LAPACK routine.

### Extensibility

This model is not specific to BLAS/LAPACK.  In particular other developers have extended this to include other high performance numerical libraries like FFTW and ARPACK (arpack is in progress).

