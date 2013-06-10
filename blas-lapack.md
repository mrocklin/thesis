
### BLAS and LAPACK

\label{sec:blas-lapack}

include [Tikz](tikz_computation.md)

*Possible reorganization: These are important.  These are hard.*

Sections \ref{sec:sympy}-\ref{sec:matrix-inference} described SymPy and then a Matrix extension to SymPy.  These projects are purely for the symbolic description of mathematics.  They are not appropriate for numeric computations.  In section \ref{sec:computations} we will describe a high-level description of the popular BLAS/LAPACK libraries for *numeric* matrix computations.  In this section we first provide background on these libraries.  Finally in section \ref{sec:matrix-compilation} we will tie the symbolic and numeric pieces together.

#### Basic Linear Algebra Subroutines (BLAS)

The Basic Linear Algebra Subroutines are a library of routines to perform common operations on dense matrices.  They were originally implemented in FORTRAN-77 in 1979.  They are in wide use today.  They have the following virtues:

*   High performance:  They optimize for memory hierarchy, blocking, loop unrolling, assembly level tuning, multi-core etc....  BLAS routines traditionally run an order of magnitude faster than their naively implemented counterparts.
*   Established interface:  
*   Hardware support:
*   Simple interface:  
*   Historical familiarity: 

Potential additional details: FLOP/memory usage, levels 1,2,3, common operations.


#### Linear Algebra Package (LAPACK)

The Linear Algebra Package (LAPACK) is a library that builds on BLAS to solve more complex problems in dense numerical linear algebra.  LAPACK includes routines for the solution of systems of linear equations, matrix factorizations, eigenvalue problems, etc....

These operations can often be solved by multiple algorithms.  These redundant algorithms are simultaneously included in LAPACK yielding a large library with thousands of individual routines.

Algorithms for the solution of these operations often require standard operations on dense matrices.  Where possible LAPACK depends on BLAS for these operations.  This isolates the majority of hardware specific optimizations to the BLAS library, allowing LAPACK to remain relatively high-level.  Optimizations to BLAS improve LAPACK without additional development.


#### Interface

Parameters to BLAS/LAPACK routines include scalars (real, complex, integer) of varying precision, arrays of those types, and strings.  

These types are widely implemented in general purpose programming languages.  As a result many numerical packages in other languages link to BLAS/LAPACK, extending their use beyond Fortran users.  In particular array-oriented scripting languages like MatLab, R, and Python/NumPy rely on BLAS/LAPACK routines for their array operators.

However, simplicity of parameter types significantly increases their cardinality.  In higher level languages array objects often contain fields for a data pointer, shape, and stride/access information.  In BLAS/LAPACK these must be passed explicitly.

Many different algorithms exist for matrix problems with slightly different structure.  BLAS and LAPACK implement these different algorithms in independent subroutines.  For example the routine GEMM performs a Matrix-Matrix multiply in the general case, `SYMM` performs a Matrix-Matrix multiplication when one of the matrices is symmetric, and `TRMM` performs a Matrix-Matrix Multiplication when one of the matrices is triangular.  A combination of the quantity of different algorithms, multiple scalar types, and lack of polymorphism causes BLAS and LAPACK to contain over two thousand routines.

Examples of the interfaces for `GEMM` and `SYMM` are included below

>*  `DGEMM` - **D**ouble precision **GE**neral **M**atrix **M**ultiply -- $\alpha A B + \beta C$
    *   `SUBROUTINE DGEMM(TRANSA,TRANSB,M,N,K,ALPHA,A,LDA,B,LDB,BETA,C,LDC)`

>*  `DSYMM` - **D**ouble precision **SY**mmetric **M**atrix **M**ultiply -- $\alpha A B + \beta C$
    *   `SUBROUTINE DSYMM(SIDE,UPLO,M,N,ALPHA,A,LDA,B,LDB,BETA,C,LDC)`


#### Analysis

BLAS and LAPACK are sufficiently entrenched and widely supported to be a stable and de facto programming interface in numeric computing.  This stability causes two notable attributes 

*   Durable: Today BLAS/LAPACK are implemented *and optimized* for most relevant hardware.  For example nVidia released `cuBLAS`, an implementation of the original `BLAS` interface in CUDA shortly after GPGPU gained popularity.  We can be relatively confident that this support will continue for new architectures into the future.
*   Archaic: The interface from 1979 is not appropriate for modern programmers.
