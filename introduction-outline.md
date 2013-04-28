
Introduction
============

include [Scientific Software is important.](value.md)

include [Demographics of developers and users is highly skewed](expertise.md)

include [Software Principles](principles.md) -- not written


### Structure

Our thesis is the following:

*Loosely coupled and cohesive solutions to common subproblems can significantly accelerate the development of scientific software.*

With the following strong opinion

*The computational science community would substantially increase its effectiveness by focusing efforts on interfaces and common-subproblems*

We support these claims in the following ways:

*   In section \ref{sec:motivation} we provide positive and pathological cases of historical approaches to scientific software development.  In particular we look at how projects adapt to external changes from hardware development.
*   In section \ref{sec:sympy-theano} we look at two high-level packages for mathematical software generation with overlapping functionality, SymPy and Theano.  We show how developing an interface between the two projects is substantially more effective than extending either one.
*   In section \ref{sec:math-num-linalg-performance} we present a system to generate mathematically informed numerical linear algebra codes.  We demonstrate the value of high-level mathematics in algorithm selection and the applicability of composable solutions to sub-problems instead of monolithic solutions.
*   In section \ref{sec:static-scheduling} we extend this argument by adding another separate component, static scheduling.  We use this piece to attack problems in heterogeneous statically scheduled linear algebra.
*   In section \ref{sec:sympy-stats} we present a computer algebra system for uncertainty modeling that uses many of the same principles.  In particular we demonstrate the value of small cohesive projects and dependence on clean interfaces. 
*   In section \ref{sec:declarative} we discuss declarative techniques for the expression of expertise and generation of domain specific compilers.  We outline a toolchain used in the above projects. 
