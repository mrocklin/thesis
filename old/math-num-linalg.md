
Mathematical Numerical Linear Algebra
=====================================

\label{sec:math-num-linalg}

Linear algebra powers scientific computation from a very high mathematical domain level down to a very low numerical level.  Many domains ranging from machine learning to differential equations use linear algebra as a shared language between mathematical researchers and compute hardware.  Numerically most FLOPs occur within dense linear algebra routines.  Because of this depth and range of importance the software development community invests significant resources to the production of dense linear algebra software solutions.  Changing hardware and novel problems force frequent redevelopments within this space.  

We believe that in the context of changing hardware and skewed expertise demographics, this development process can be improved through automation.  In \ref{sec:need-for-compilers} we motivate the use of high-level array and mathematics compilers.  In \ref{sec:math-num-linalg-background} we discuss previous work in this area.  We then present our approach to this problem, a system for mathematically informed automated linear algebra composed of multiple independent pieces.  In \ref{sec:matrix-language} we present a matrix language embedded in SymPy, in \ref{sec:matrix-inference} an inference engine on logical statements, and in \ref{sec:computations} a project to describe BLAS/LAPACK at a high level and then generate low level code.  In Section \ref{sec:matrix-compilation} we briefly discuss the related algorithm search problem involved in connecting these pieces to form a complete product.  Finally in Section \ref{sec:matrix-analysis} we motivate the separable and declarative design decisions in this federation of projects.  Later in \ref{sec:math-num-linalg-validation} we validate this work through a sequence of numerical experiments.

include [Tikz](tikz_all.md)

#### Contributions

The software contributions are as follows

1.  A library for the description, simplification, and analysis of problems in abstract linear algebra
2.  A library for the high-level description, combination, and code generation of popular low-level libraries
3.  A declarative framework to combine the two

Philosophical contributions are as follows

1.  Discussion of the importance of generally solving common sub-problems
2.  Discussion of designing software around developer demographics
3.  Discussion of enabling experimentation and unforseen applications

include [Need for Compilers](need-for-compilers.md)

include [Related Work](math-num-linalg-related-work.md)

include [Language](matrix-language.md)

include [Inference](matrix-inference.md)

include [Computations](computations.md)

include [Compilation](matrix-compilation.md)

include [Analysis](math-num-linalg-analysis.md)

