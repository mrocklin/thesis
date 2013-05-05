
Mathematical Numerical Linear Algebra
=====================================

\label{sec:math-num-linalg}

Linear algebra powers scientific computation from a very high mathematical domain level down to a very low numerical level.  Many domains ranging from machine learning to differential equations use linear algebra as a shared language between mathematical researchers and compute hardware.  Numerically most FLOPs occur within a dense linear algebra routine.  Because of this depth and range of importance the software development community invests significant resources to the production of dense linear algebra software solutions.  Changing hardware and novel problems force frequent redevelopments within this space.  

We believe that in the context of changing hardware and skewed expertise demographics, this development process can be improved through automation.  In \ref{sec:need-for-compilers} we motivate the use of high-level array and mathematics compilers.  In \ref{sec:math-num-linalg-background} we discuss previous work in this area.  We then present our approach to this problem, a system for mathematically informed automated linear algebra composed of multiple independent pieces.  In \ref{sec:matrix-language} we present a matrix language embedded in SymPy, in \ref{sec:matrix-inference} an inference engine on logical statements, and in \ref{sec:computations} a project to describe BLAS/LAPACK at a high level and then generate low level code.  In section \ref{sec:matrix-compile} we briefly discuss the related algorithm search problem involved in connecting these pieces to form a complete product.  Finally in section \ref{sec:matrix-analysis} we motivate the separable and declarative design decisions in this federation of projects.  Later in \ref{sec:math-num-linalg-validation} we will validate this work through a sequence of numerical experiments.

### Contributions

The software contributions are as follows

1.  A library for the description, simplification, and analysis of problems in abstract linear algebra
2.  A library for the high-level description, combination, and code generation of popular low-level libraries
3.  A declarative framework to combine the two

Philosophical contributions are as follows

1.  A design that favors reuse, development by single-domain experts, and future experimentation

Need for Compilers in Numerial Linear Algebra
---------------------------------------------

\label{sec:need-for-compilers}

"High productivity" languages haved gained popularity in recent years.  These languages target application domain programmers by reducing barriers to entry and providing syntax for high-level constructs.  Scripting languages like MatLab, R, and Python remove explicit typing, replace compilation with interpreters, and support high level primitives for matrix and common statistical operations.  These languages allow non-expert programmers the abillity to solve a certain class of common problems with little training in traditional programming.

Each of these languages provide a set of high performance array operations.  A small set of array operations like matrix multiplication, solve, slicing, and elementwise scalar operations can be combined to solve a wide range of problems in statistical and scientific domains.  Because this set is small these routines can be implemented by language designers in a lower-level language and then conveniently linked to the high-productivity system, providing a good separation of expertise. These efforts have proven popular and useful among applied communities.

None of these popular array programming languages are compiled (TODO: are there counter-examples?).  Because the array operations call down to precompiled library code this may at first seem unnecessary.

include [Operation Ordering in Matlab](operation-ordering-matlab.md)

Related Work
------------

\label{sec:math-num-linalg-background}

Both the broad applicability of this domain and the performance improvments from expert treatment have made it the target of substantial academic study and engineering efforts.

### Statically compiled libraries - BLAS/LAPACK

### Autotuning - ATLAS

### Heterogeneous computing - Magma

### Automated methods - FLAME

BLAS/LAPACK, Magma, and FLAME all build custom treatments of linear algebra in order to create high performance libraries.  Unfortunately there is duplication and an inability to share the intermediate logic with other projects.  

include [Language](language.md)

include [Inference](inference.md)

include [Computations](computations.md)

include [Compilation](compilation.md)

Analysis
--------

\label{sec:matrix-analysis}

We can use these pieces together to transform mathematical expressions into well-selected computations and generate performant, human readable Fortran code.  In section \ref{sec:validation} we will demonstrate the utility of the system described above.  Here we will first motivate its design decisions.


### Small Components Enable Reuse

Solutions to scientific problems often share structure.  Large codes written for specific applications are often too specific to be reusable outside of their intended problem  without substantial coding investment.  Smaller components designed to solve common sub-problems may be more generally applied.


### Smaller Scope Lowers Barriers to Development

These components do not depend on each other for development.  This isolated nature reduces the expertise requirements on potential developers.  Mathematical developers can contribute to SymPy Matrix Expressions even if they are ignorant of Fortran.  Computational developers familiar with BLAS/LAPACK can contribute to `computations` even if they are unfamiliar with compilers.  Shared interfaces propagate these improvements to users at all levels.  The demographics of expertise in scientific computing \ref{sec:expertise} necessitate this decision.


### Multiple Intermediate Representations Encourages Experimentation

Broadly applicable software will never be able to anticipate all possible use cases.  In this situation it is important to provide clean intermediate representations at a variety of levels.  This project allows users to manipulate representations at the math/term, DAG, and Fortran levels.  Care has been taken so that each representation is human readable to specialists within the relevant domain.

This encourages future development within the project.  For example to support multiple output languages we only need to translate from the DAG level, a relatively short conceptual distance relative the the size of the entire project.  We currently support Fortran and DOT (for visualization) but adding other languages is a straightforward process.

This encourages development outside the project.  In section \ref{sec:static-scheduling} we will manipulate the DAG with an external composable static scheduler and then re-inject the transformed result into our compiler chain.  Additionally scientific users can use the resulting Fortran90 code as a template for future by-hand development.
