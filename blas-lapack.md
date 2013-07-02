
## BLAS and LAPACK

\label{sec:blas-lapack}

include [Tikz](tikz_computation.md)

### Basic Linear Algebra Subroutines (BLAS)

The Basic Linear Algebra Subroutines are a library of routines to perform common operations on dense matrices.  They were originally implemented in FORTRAN-77 in 1979.  They remain in wide use today.

The BLAS are organized into three levels

*   Level-1:  Vector-Vector operations, like elementwise addition
*   Level-2:  Matrix-Vector operations, like Matrix-vector multiply or solve
*   Level-3:  Matrix-Matrix operations, like Matrix-Matrix multiply or solve


### Hardware Coupling of Level-3

As memory hierarchies have become both more complex and the upper levels have become substantially slower relative to compute power the importance of keeping data local in cache for as many computations as possible has increased.  This is of primary importance in the Level-3 BLAS, which are characterized by $O(n^3)$ computations on $O(n^2)$ data elements.  Through clever organization of the computation into blocks, communication within the slower elements of the memory hierarchy can be hidden, resulting in order-of-magnitude performance gains.

In fact, Level-3 BLAS operations are one of the few cases where compute-intensity can match the imbalance in CPU-Memory speeds, making them highly desirable operations on modern hardware.  This benefit is even more significant in the case of many-core accelerators, e.g. GPGPU.


### Linear Algebra Package (LAPACK)

The Linear Algebra Package (LAPACK) is a library that builds on BLAS to solve more complex problems in dense numerical linear algebra.  LAPACK includes routines for the solution of systems of linear equations, matrix factorizations, eigenvalue problems, etc....

Algorithms for the solution of these operations often require standard operations on dense matrices.  Where possible LAPACK depends on BLAS for these operations.  This isolates the majority of hardware specific optimizations to the BLAS library, allowing LAPACK to remain relatively high-level.  Optimizations to BLAS improve LAPACK without additional development.

### Expert LAPACK Subroutines

LAPACK retains the compute-intense characteristic of Level-3 and so can provide highly preformant solutions.  However the expert use of LAPACK requires several additional considerations.

LAPACK operations like matrix factorizations can often be solved by multiple algorithms.  For example matrices can be factored into LU or QR decompositions.  The Cholesky variant of LU can be used only if the left side is symmetric positive definite.  These redundant algorithms are simultaneously included in LAPACK yielding a large library with thousands of individual routines a collection of which might be valid in any situation.

Additionally LAPACK internally makes use of utility functions (like matrix permutation) and special storage formats (like banded matrices), further adding to a set of high-level matrix operations.

### Interface

Parameters to BLAS/LAPACK routines include scalars (real, complex, integer) of varying precision, arrays of those types, and strings.  

These types are widely implemented in general purpose programming languages.  As a result many numerical packages in other languages link to BLAS/LAPACK, extending their use beyond Fortran users.  In particular array-oriented scripting languages like MatLab, R, and Python/NumPy rely on BLAS/LAPACK routines for their array operators.

However, simplicity of parameter types significantly increases their cardinality.  In higher level languages array objects often contain fields for a data pointer, shape, and stride/access information.  In BLAS/LAPACK these must be passed explicitly.

Many different algorithms exist for matrix problems with slightly different structure.  BLAS and LAPACK implement these different algorithms in independent subroutines with very different subroutine headers.  For example the routine GEMM performs a Matrix-Matrix multiply in the general case, `SYMM` performs a Matrix-Matrix multiplication when one of the matrices is symmetric, and `TRMM` performs a Matrix-Matrix Multiplication when one of the matrices is triangular.  A combination of the quantity of different algorithms, multiple scalar types, and lack of polymorphism causes BLAS and LAPACK to contain over two thousand routines.

For concreteness examples of the interfaces for `GEMM` and `SYMM` for double precision real numbers are included below

*  `DGEMM` - **D**ouble precision **GE**neral **M**atrix **M**ultiply -- $\alpha A B + \beta C$
    *   `SUBROUTINE DGEMM(TRANSA,TRANSB,M,N,K,ALPHA,A,LDA,B,LDB,BETA,C,LDC)`

*  `DSYMM` - **D**ouble precision **SY**mmetric **M**atrix **M**ultiply -- $\alpha A B + \beta C$
    *   `SUBROUTINE DSYMM(SIDE,UPLO,M,N,ALPHA,A,LDA,B,LDB,BETA,C,LDC)`


### Challenges

The interface to BLAS/LAPACK was standardized in 1979 within the scope of the Fortran-77 language.  Memory locations, array sizes, strides, and transposition are all stated explicitly and independently.  Modern language assistance like basic type checking or wrapping shape and stride information into array objects is unavailable.

The interface to BLAS/LAPACK appeals to a very low and common denominator.  This makes it trivial to interoperate with a broad set of languages.  For example the popular Fortran to Python wrapper `f2py` handles most of the BLAS/LAPACK library without additional configuration.  Unfortunately this same low and common denominator alienates direct use by naive scientific users.


### Analysis

BLAS and LAPACK are sufficiently entrenched and widely supported to be a stable and de facto programming interface in numeric computing.  This stability causes two notable attributes 

*   Durable: Today BLAS/LAPACK are implemented *and optimized* for most relevant hardware.  For example nVidia released `cuBLAS`, an implementation of the original `BLAS` interface in CUDA shortly after GPGPU gained popularity.  We can be relatively confident that this support will continue for new architectures into the future.
*   Archaic: The interface from 1979 is not appropriate for modern programmers.
