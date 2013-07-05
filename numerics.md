
BLAS, LAPACK, PETSC, FEniCS
---------------------------

\label{sec:numerics}

The numeric methods community has a good record of developing performant libraries in isolation from any particular application.  These methods are developed by dedicated groups with mature software engineering practices.  They are used in a broad set of applications.

In this section we examine a stack of numeric libraries for the solution of differential equations. 

*   BLAS
*   LAPACK
*   PETSc
*   FEniCS

BLAS is a library for simple dense matrix operations (e.g. matrix multiply).  LAPACK is a similar library for more complex matrix operations (e.g. Cholesky Solve); it calls on BLAS for most manipulations.  PETSc builds on MPI, BLAS, and LAPACK to implement numeric solvers for distributed and sparse problems.  FEniCS is a high level domain specific language that transforms a description of PDEs into C++ code that calls PETSc routines.  Each of these libraries builds off of the layers beneath, making use of preexisting high-quality implementations when available.

In a sense this style of hierarchical modularity is like a Russian Doll.  Each new higher-level project can omit a substantial computational core by depending on generally applicable previous solutions.  New higher level projects must create a shell rather than a complete solid.

### BLAS/LAPACK

BLAS/LAPACK are libraries for dense linear algebra.  They have a simple-yet-verbose interface which are traditionally accessed by Fortran function calls with several inputs (5-20) of very basic types (string, int, float, array of floats).  Attempts to refactor the BLAS/LAPACK interface into object oriented frameworks has had some success but the original interface remains dominant.  This may be because every numeric project is capable of providing these basic types but may not have simple access to the custom objected oriented framework.  The original Fortran interface (or it's c counterpart) remain the defacto standard.  This supports the use of common simple interfaces over rich interfaces.

BLAS and LAPACK will be described in more detail in Section {sec:blas-lapack}.


### PETSc

The Petascale Extensible Toolkit for Scientific computing (PETSc) is a library for distributed linear algebra and (non)-linear solvers.  It encodes a set of curated numerical methods common in scientific computing problems.  It relies on BLAS/LAPACK for local sequential computations and MPI for distributed memory communication.  It is curated by a small dedicated team of developers that focus on a small core of relevant sub-problems.


### FEniCS 

FEniCS is a domain specific language and code generation tool for the description and solution of problems in numerical PDEs.  FEniCS depends on PETSc and custom generated C++ code to construct and solve linear systems that correspond to systems of differential equations.


### Analysis

The solution of numerical PDEs is a relevant problem in several applied domains.  The ability to automatically generate high performance low-level codes from high-level descriptions is both encouraging and daunting.  FEniCS development was greatly assisted by PETSc which was in turn greatly assisted by LAPACK, which was in turn greatly assisted by BLAS.

The different projects adhere to clear interfaces, enabling swappability of different implementations.  This is particularly relevant for BLAS/LAPACK for which a healthy set of competing implementations exist and continues to develop.  FEniCS also provides support for PETSc's peer, Trilinos discussed further in Section \ref{sec:trilinos}.  Unlike BLAS/LAPACK, the relevant interface for the PETSc/Trilinos layer has not been standardized, requiring explicit pairwise support in the FEniCs codebase.
