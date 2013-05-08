
Computations - BLAS/LAPACK
--------------------------

\label{sec:computations}

include [Tikz](tikz_computation.md)

In section \ref{sec:language} we described a computer algebra system to express and manipulate matrix expressions at a high, symbolic level.  This work is not appropriate for numeric computation.  In this section we describe a separate system to describe numeric codes to compute the mathematical expressions described in \ref{sec:language}.  Our primary target will be Modern Fortran code that calls down to the curated BLAS/LAPACK libraries for dense linear algebra.  These libraries have old and unstructured interfaces which are difficult to target high-level automated systems.  In this section we build a high-level description of these computations as an intermediary.  We use SymPy matrix expressions to assist with this high level description.  This system will be extensible to support other low-level libraries.  We believe that its separation makes it broadly applicable to applications beyond our own. 

Specifically we present a small library to encode low-level computational routines that is amenable to manipulation by automated high-level tools.  This library is extensible and broadly applicable.  This library also supports low level code generation.

Later in section \ref{sec:matrix-compile} we connect the work in this section and in \ref{sec:language} to form a cohesive generator of high-level computations from high-level math expressions.

### BLAS and LAPACK

TODO: Describe BLAS and LAPACK

### Atomic Computations

Every BLAS/LAPACK routine can be logically identified by a set of inputs, outputs, conditions on the inputs, and inplace memory behavior.  Additionally each routine can be imbued with code for generation of the inline call in a variety of languages.  In our implementation we focus on Fortran but C, scipy, or even CUDA could be added without substantial difficulty.

Each routine is represented by a Python class.  In this paragraph we describe `SYMM`, a routine for **SY**mmetric **M*atrix **M**ultiply, in prose; just below we describe this same routine in code.  `SYMM` fuses a matrix multiply `A*B` with a scalar multiplication `alpha*A*B` and an extra matrix addition `alpha*A*B + beta*C`.  This is done for computational efficiency.  `SYMM` is a specialized version which is only valid when one of the first two matrices `A, B` are symmetric.  It exploits this special structure and performs only half of the normally required FLOPs.  Like many BLAS/LAPACK routines `SYMM` operates *inplace*, storing the output in one of its inputs.  In this particular case it stores the result of the zeroth output, `alpha*A*B + beta*C` in its fourth input, `C`. 

~~~~~~~~~~~~~Python
class SYMM(BLAS):
    """ Symmetric Matrix Multiply """
    _inputs   = [alpha, A, B, beta, C]
    _outputs  = [alpha*A*B + beta*C]
    condition = Q.symmetric(A) | Q.symmetric(B)
    inplace   = {0: 4}
~~~~~~~~~~~~~

### Composite Computations

Composite computations may be built up from many constituents.  These edges between these constituents exist if the output of one computation is the input of the other.  Treating computations as nodes and data dependencies as edges defines a directed acyclic graph (DAG) over the set of computations.


### Tokenized Computations

\label{sec:tokenize}

We desire to transform DAGs of computations into executable Fortran code.  Unfortunately the mathematical definition of our routines is not sufficient information to print consistent code.  Because the atomic computations overwrite memory we must consider and preserve state within our system.  This will require the introduction of `COPY` operations and a treatment of variable names.  Consider `COPY` defined below

~~~~~~~~~~~~~Python
class COPY(BLAS):
    _inputs   = [X]
    _outputs  = [X]
    condition = True
    inplace   = {}
~~~~~~~~~~~~~

Mathematically this definition is correct.  It consumes a variable, `X`, and produces a new variable whose *mathematical definition* is exactly `X`.  While this definition is mathematically consistent, it lacks computational meaning; the output `X` exists in a new location in memory from the input.

\begin{figure}[htbp]
\centering
\includegraphics[height=.2\textheight]{images/copy}
\includegraphics[height=.2\textheight]{images/copy-inplace}
\end{figure}

To encode this information about memory location we expand our model so that each variable is both a mathematical sympy term and a unique identifier, usually a string.  This supports a new class of transformations to manage inplace computations.  These considerations are only relevant in the latter stages of compilation and so we delay their introduction until later in the pipeline.


### Fortran Code Generation

From such a directed acyclic graph we can generate readable low-level code.  We focus on Fortran 90.  Each atomic computation contains a method to print a string to execute that computation given the correct parameter names.  We traverse the directed acyclic graph to obtain variable names and a topological sort of atomic computations.  Generating Fortran code from this stage is trivial.


### Extensibility

This model is not specific to BLAS/LAPACK.  In particular other developers have extended this to include other high performance numerical libraries like FFTW and ARPACK (arpack is in progress).


### Example use of `computations`

We use `computations` to construct a simple program.  The following example uses `SYMM` and `AXPY`, a routine for vector addition, to create a complex composite computation.  It then introduces copy operations and generates human readable Fortran code.

Specific instances of each computation can be constructed by providing corresponding inputs, traditionally SymPy Expressions.   We generate an instance of `SYMM`, here called `symm` that computes `X*Y` and stores the result in `Y`.

~~~~~~~~~~~~~Python
>>> n = Symbol('n')
>>> X = MatrixSymbol('X', n, n)
>>> Y = MatrixSymbol('Y', n, n)
>>> symm = SYMM(1, X, Y, 0, Y)
>>> symm.inputs
[X, Y]
>>> symm.outputs
[X*Y]
~~~~~~~~~~~~~

We now want to take the result `X*Y` and add it again to `Y`.  This can be done with a vector addition, accomplished by the routine `AXPY`.  Notice that computations can take compound expressions as inputs

~~~~~~~~~~~~~Python
>>> axpy = AXPY(5, X*Y, Y)
>>> axpy.inputs
[X*Y, Y]
>>> axpy.outputs
[5*X*Y + Y]
~~~~~~~~~~~~~

Computations like `symm` and `axpy` can be combined to form composite computations.  These are assembled into a directed acyclic graph based on their inputs and outputs.  For example because `symm` produces `X*Y` and `axpy` consumes `X*Y` we infer that an edge much extend from `symm` to `axpy`.

~~~~~~~~~~~~~Python
>>> composite = CompositeComputation(axpy, symm)
>>> composite.inputs
[X, Y]
>>> composite.outputs
[5*X*Y + Y]
~~~~~~~~~~~~~

\begin{figure}[htbp]
\centering
\includegraphics[width=.5\textwidth]{images/symm-axpy}
\end{figure}

The computation above is purely mathematical in nature.  We now consider inplace behavior and inject unique tokens as described in section \ref{sec:tokenize}.  We inject `COPY` operations where necessary.

~~~~~~~~~~~~~Python
>>> inplace = inplace_compile(composite)
~~~~~~~~~~~~~

\begin{figure}[htbp]
\centering
\includegraphics[width=.7\textwidth]{images/symm-axpy-inplace}
\end{figure}

Finally we declare the types of the matrices and print Fortran code

~~~~~~~~~~~~~Python
>>> with assuming(Q.symmetric(X), Q.real_elements(X), Q.real_elements(Y)):
...     print generate(inplace, [X, y], [5*X*Y + Y])
~~~~~~~~~~~~~

~~~~~~~~~~~~~Fortran
subroutine f(X, Y, Y_2)
    implicit none

    ! Argument Declarations !
    ! ===================== !
    real(kind=8), intent(in) :: X(:,:)
    real(kind=8), intent(in) :: Y(:,:)
    real(kind=8), intent(out) :: Y_2(:,:)

    ! Variable Declarations !
    ! ===================== !
    real(kind=8), allocatable :: Y_3(:,:)
    integer :: n

    ! Variable Initializations !
    ! ======================== !
    n = size(Y, 1)
    allocate(Y_3(n,n))

    ! Statements !
    ! ========== !
    call dcopy(n**2, Y, 1, Y_3, 1)
    call dsymm('L', 'U', n, n, 1, X, n, Y_3, n, 0, Y_3, n)
    call dcopy(n**2, Y, 1, Y_2, 1)
    call daxpy(n**2, 5, Y_3, 1, Y_2, 1)

    deallocate(Y_3)
    return
end subroutine f
~~~~~~~~~~~~~Fortran



