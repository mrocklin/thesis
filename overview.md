
Overview
--------

This dissertation describes modularity in scientific computing in general and linear algebra in particular.  It is separated into the following chapters:

First we discuss past and current efforts in modularity and numerical linear algebra

*   Chapter \ref{sec:background-scientific-software-engineering} discusses historical status of modularity in scientific software
*   Chapter \ref{sec:background-nla} discusses work in numerical linear algebra

We then separate the problem of automated generation of high-level codes for matrix computations into reusable components.  In each section we discuss the history, problems, and a software solution to a single subproblem.

*   Chapter \ref{sec:cas} discusses computer algebra
*   Chapter \ref{sec:computations} discusses computations with BLAS/LAPACK and code generation
*   Chapter \ref{sec:term-rewrite-system} discusses term rewriting
*   Chapter \ref{sec:voltron} assembles components from the previous sections to form a cohesive whole.  It then exercises this conglomerate on common computational kernels.

We then demonstrate the extensibility of this system by extensibility of this system by adding components not present in the original design

*   Chapter \ref{sec:static-scheduling} discusses static scheduling and the generation of parallel codes
