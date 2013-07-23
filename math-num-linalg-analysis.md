
Analysis
--------

\label{sec:matrix-analysis}

We have seen that the composition of computer algebra, numerical subroutines, and term rewriting can transform mathematical expressions into sophisticated high performance, human readable code.  Here we motivate design decisions.


#### Small Components Enable Reuse

Solutions to scientific problems often share structure.  Large codes written for specific applications are often too specific to be reusable outside of their intended problem  without substantial coding investment.  Smaller components designed to solve common sub-problems may be more generally applied.


#### Smaller Scope Lowers Barriers to Development

These components do not depend on each other for development.  This isolated nature reduces the expertise requirements on potential developers.  Mathematical developers can contribute to SymPy Matrix Expressions even if they are ignorant of Fortran.  Computational developers familiar with BLAS/LAPACK can contribute to `computations` even if they are unfamiliar with compilers.  Shared interfaces propagate these improvements to users at all levels.  The demographics of expertise in scientific computing \ref{sec:expertise} necessitate this decision.


#### Multiple Intermediate Representations Encourages Experimentation

Broadly applicable software is unable to anticipate all possible use cases.  In this situation it is important to provide clean intermediate representations at a variety of levels.  This project allows users to manipulate representations at the math/term, DAG, and Fortran levels.  Care has been taken so that each representation is human readable to specialists within the relevant domain.

This approach encourages future development within the project.  For example to support multiple output languages we only need to translate from the DAG level, a relatively short conceptual distance relative to the size of the entire project.  We currently support Fortran and DOT (for visualization), but adding other languages is a straightforward process.

This approach encourages development outside the project.  In Section \ref{sec:static-scheduling} we manipulate the DAG with an external composable static scheduler and then re-inject the transformed result into our compiler chain.  Additionally scientific users can use the resulting Fortran90 code as a template for future by-hand development.
