
Automated Matrix Computations
=============================

\label{sec:voltron}

include [Tikz](tikz_megatron.md)

In this chapter we compose software components from the previous sections to create a compiler for the generation of linear algebra codes from matrix expressions.

*   Chapter \ref{sec:cas}: Computer Algebra
*   Chapter \ref{sec:computations}: Computations
*   Chapter \ref{sec:term-rewrite-systems}: Term Rewriting

We then compose these components to create a larger system to produce numeric codes for common matrix expressions called.  These examples demonstrate both the ability and the extensibility of our system.  We refer to this composition as the `conglomerate` project.  Specifically we will construct two computations that are common in scientific computing, least squares linear regression and the Kalman Filter.  In each case we will highlight the added value of modular design.

include [Compilation](matrix-compilation.md)

include [Relation to Other Work](voltron-other-work.md)

include [Linear Regression](linear-regression.md)

include [SYRK](syrk.md)

include [Kalman](kalman.md)

include [Analysis](math-num-linalg-analysis.md)
