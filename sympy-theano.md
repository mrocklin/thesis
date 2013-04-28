
SymPy/Theano Interaction
========================

\label{sec:sympy-theano}

We compare two high level libraries for computation,

*   SymPy:  a library for mathematics which does a bit of code generation
*   Theano: a library for code generation which does a little mathematics

Each project extends a bit into the others' domain.  We will find that these extensions are less sophisticated and infrequently curated.  By replacing these in-house attempts to expand the boundary of one project with interfaces between the two projects we reap substantial performance gains.  In \ref{sec:sympy-theano-1} we show how Theano's code generation outperform's SymPy's attempts at the same problem.  In \ref{sec:sympy-theano-2} we show how SymPy's scalar simplification routines can accelerate Theano computations.  

include [Code Generation](sympy-theano-1.md)

include [Scalar Simplification](sympy-theano-2.md)
