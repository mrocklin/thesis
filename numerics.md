
BLAS, LAPACK, PETSC, FEniCS
---------------------------

\label{sec:numerics}

The numerical methods community has a good record of developing performant libraries in isolation from any particular application.  These methods are developed by dedicated groups with mature software engineering practices.  They are used in a broad set of applications.

In this section we examine a stack of numeric libraries for the solution of differential equations. 

*   BLAS
*   LAPACK
*   PETSc
*   FEniCS

As just discussed, BLAS is a library for simple dense matrix operations (e.g. matrix multiply) and LAPACK is a similar library for more complex matrix operations (e.g. Cholesky Solve) that calls on BLAS for most manipulations.  PETSc builds on MPI, BLAS, and LAPACK to implement numeric solvers for distributed and sparse problems.  FEniCS is a high level domain specific language that transforms a high-level description of PDEs into C++ code that assembles matrices and then calls PETSc routines.  Each of these libraries builds off of the layers beneath, making use of preexisting high-quality implementations when available.

In a sense this style of hierarchical modularity is like a russian doll.  Each new higher-level project can omit a substantial computational core by depending on generally applicable previous solutions.  New higher level projects must create a shell rather than a complete solid.


#### Analysis

The solution of numerical PDEs is a relevant problem in several applied domains.  The ability to generate automatically high performance low-level codes from high-level descriptions is both encouraging and daunting.  FEniCS development was greatly assisted by PETSc which was in turn greatly assisted by LAPACK, which was in turn greatly assisted by BLAS.

The different projects adhere to clear interfaces, enabling swappability of different implementations.  This observation is particularly relevant for BLAS/LAPACK for which a healthy set of competing implementations exist and continues to develop.  FEniCS also provides support for PETSc's peer, Trilinos discussed further in Section \ref{sec:trilinos}.  Unlike BLAS/LAPACK, the relevant interface for the PETSc/Trilinos layer has not been standardized, requiring explicit pairwise support in the FEniCs codebase.
