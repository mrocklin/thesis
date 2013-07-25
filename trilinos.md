
## Trilinos

\label{sec:trilinos}

Trilinos is a success story for flat modular scientific design.  Trilinos grew from an original three complementary projects into a loose federation of over fifty packages, each developed by an independent team.  These packages interoperate through a set of C++ interfaces for generic solver types (e.g. Eigensolve).  Trilinos has grown into a robust and powerful ecosystem for numeric computing.

The organization of Trilinos differs from the BLAS-LAPACK-PETSc-FEniCS stack. Trilinos packages operate largely as peers rather than in a strict hierarchy.  Trilinos does not dominate its domain like BLAS/LAPACK, but it does demonstrate the value of prespecified complex interfaces in a higher level setting.  A number of differently-abled groups are able to co-develop in the same space with relatively little communication.


Potential developers are enticed into this ecosystem with the following:

*   A standardized testing and documentation framework 
*   A high-level distributed array data structure
*   Functionality from other packages
*   Name recognition and an established user-base

These incentives are essential for the creation of an active ecosystem.  Unfortunately, Trilinos often suffers from significant software distribution and building overhead.  The lack of centralized control and wide variety of dependencies required by various packages results in substantial startup cost for novice developers.
