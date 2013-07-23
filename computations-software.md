
Software
--------

\label{sec:computations-software}

We describe a software system, `computations`, that serves both as a repository for a high-level description of numeric libraries (particularly BLAS/LAPACK), and as a rudimentary code generation system.  In describing this system we motivate that the high-level coordination of low-level numeric routines can succinctly describe a broad set of computational science.

Every BLAS/LAPACK routine can be logically identified by a set of inputs, outputs, conditions on the inputs, and inplace memory behavior.  Additionally each routine can be imbued with code for generation of the inline call in a variety of languages.  In our implementation we focus on Fortran but C or scipy could be added without substantial difficulty.  CUDA code generation is a current work in progress.

Each routine is represented by a Python class.  In this paragraph we describe `SYMM`, a routine for **SY**mmetric **M**atrix **M**ultiply, in prose; just below we describe this same routine in code.  `SYMM` fuses a matrix multiply `A*B` with a scalar multiplication `alpha*A*B` and an extra matrix addition `alpha*A*B + beta*C`.  This fusion is done for computational efficiency.  `SYMM` is a specialized version which is only valid when one of the first two matrices `A` or `B` are symmetric.  It exploits this special structure and performs only half of the normally required FLOPs.  Like many BLAS/LAPACK routines `SYMM` operates *inplace*, storing the output in one of its inputs.  In this particular case it stores the result of the zeroth output, `alpha*A*B + beta*C` in its fourth input, `C`. 

~~~~~~~~~~~~~Python
class SYMM(BLAS):
    """ Symmetric Matrix Multiply """
    _inputs   = [alpha, A, B, beta, C]
    _outputs  = [alpha*A*B + beta*C]
    condition = Q.symmetric(A) | Q.symmetric(B)
    inplace   = {0: 4}
~~~~~~~~~~~~~

#### Composite Computations

Composite computations may be built up from many constituents.  Edges between these constituents exist if the output of one computation is the input of the other.  Treating computations as nodes and data dependencies as edges defines a directed acyclic graph (DAG) over the set of computations.


#### Tokenized Computations

\label{sec:tokenize}

We desire to transform DAGs of computations into executable Fortran code.  Unfortunately the mathematical definition of our routines does not contain sufficient information to print consistent code.  Because the atomic computations overwrite memory we must consider and preserve state within our system.  The consideration of inplace operations requires the introduction of `COPY` operations and a treatment of variable names.  Consider `COPY` defined below

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
\includegraphics[height=.15\textheight]{images/copy} \\
\includegraphics[height=.15\textheight]{images/copy-inplace}
\caption{A meaningful `Copy` operation with variables that contain both mathematical expressions and memory tokens}
\label{fig:copy}
\end{figure}

To encode this information about memory location we expand our model so that each variable is both a mathematical SymPy term and a unique identifier, usually a Python string.  This method supports a new class of transformations to manage inplace computations.

#### Fortran Code Generation

From such a directed acyclic graph we can generate readable low-level code.  We focus on Fortran 90.  Each atomic computation contains a method to print a string to execute that computation given the correct parameter names.  We traverse the directed acyclic graph to obtain variable names and a topological sort of atomic computations.  Generating Fortran code from this stage is trivial.


#### Extensibility

This model is not specific to BLAS/LAPACK.  A range of scientific software can be constructed through the coordination of historic numeric libraries.  Mature libraries exist for several fields of numerics.  Our particular system has been extended to support `MPI` and `FFTW`.  


#### Example use of `computations`

We use `computations` to construct a simple program.  The following example uses `SYMM` and `AXPY`, a routine for vector addition, to create a complex composite computation.  It then introduces copy operations and generates human readable Fortran code.

Specific instances of each computation can be constructed by providing corresponding inputs, traditionally SymPy Expressions.   We generate an instance of `SYMM`, here called `symm`, that computes `X*Y` and stores the result in `Y`.

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

We now want to take the result `X*Y`, multiply it by `5`, and add it again to `Y`.  This can be done with a vector addition, accomplished by the routine `AXPY`.  Notice that computations can take compound expressions like `X*Y` as inputs

~~~~~~~~~~~~~Python
>>> axpy = AXPY(5, X*Y, Y)
>>> axpy.inputs
[X*Y, Y]
>>> axpy.outputs
[5*X*Y + Y]
~~~~~~~~~~~~~

Computations like `symm` and `axpy` can be combined to form composite computations.  These are assembled into a directed acyclic graph based on their inputs and outputs.  For example, because `symm` produces `X*Y` and `axpy` consumes `X*Y` we infer that an edge much extend from `symm` to `axpy`.

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
\caption{A computation graph to compute $5XY + Y$}
\label{fig:symm-axpy}
\end{figure}

The computation above is purely mathematical in nature.  We now consider inplace behavior and inject unique tokens as described in Section \ref{sec:tokenize}.  We inject `COPY` operations where necessary.

~~~~~~~~~~~~~Python
>>> inplace = inplace_compile(composite)
~~~~~~~~~~~~~

\begin{figure}[htbp]
\centering
\includegraphics[width=.7\textwidth]{images/symm-axpy-inplace}
\caption{A tokenized computation graph to compute $5XY + Y$}
\label{fig:symm-axpy-inplace}
\end{figure}

Finally we declare the types of the matrices, specify orders for inputs and outputs,  and print Fortran code

~~~~~~~~~~~~~Python
>>> with assuming(Q.symmetric(X), Q.real_elements(X), Q.real_elements(Y)):
...     print generate(inplace, [X, Y], [5*X*Y + Y])
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
~~~~~~~~~~~~~
