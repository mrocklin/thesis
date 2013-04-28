
Numeric Libraries
-----------------

\label{sec:numerics}

The numeric methods community has a good record of developing performant libraries in isolation from any particular application.  These methods are developed by dedicated groups with mature software engineering practices.  They are used in a broad set of applications.

In particular lets examine a stack of numeric libraries for the solution of differential equations. 

*   FEniCS
*   PETSc/Trilinos
*   LAPACK
*   BLAS

BLAS is a library for simple dense matrix operations (e.g. matrix multiply).  LAPACK is a similar library for more complex matrix operations (e.g. Cholesky Solve); it calls on BLAS for most manipulations.  PETSc and Trilinos are projects for numeric solvers for distributed and sparse problems, they use MPI, BLAS, and LAPACK calls within their codebase.  FEniCS is a high level domain specific language that transforms a description of PDEs into performant C++ code that calls PETSc routines.  Each of these libraries builds off of the beneath them, making use of preexisting high-quality implementations when available.

In a sense this style of *hierarchical* modularity is like a Russian Doll.  Each new higher-level project can omit a substantial computational core by depending on generally applicable previous solutions.  New projects create a shell rather than a complete solid.

The interfaces of the lower levels of this stack are worth mention.  

### BLAS/LAPACK

BLAS/LAPACK have an incredibly simple-yet-verbose interface.  They are accessed by Fortran function calls with several inputs (5-20) of very basic types (string, int, float, array of floats).  Attempts to refactor the BLAS/LAPACK interface into object oriented frameworks has had some success but the original interface remains dominant.  This may be because every numeric project is capable of providing these basic types but may not have simple access to the custom objected oriented framework.  The original Fortran interface (or it's c counterpart) remain the defacto standard.  This supports the use of common simple interfaces over rich interfaces.

### Trilinos

The Trilinos project takes a different approach.  Trilinos provides a common data structure (distributed array) and a set of C++ interfaces for generic solver types (e.g. Eigensolve).  Over time a loose federation of over fifty independently developed packages have coevolved around these interfaces into a robust and powerful ecosystem.

Trilinos does not dominate its domain like BLAS/LAPACK, but it does demonstrate the value of prespecified complex interfaces in a higher level setting.  A number of differently abled groups are able to co-develop in the same space with relatively little communication.


Not Fully Written.
