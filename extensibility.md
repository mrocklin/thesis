
Extensibility
=============

\label{sec:extensibility}

A good tool can be applied to unforseen problems.  The hand held hammer can be applied beyond the application of driving nails.  It can be extended to any activity that requires the delivery of percussive force.  A good tool can be composed with other unanticipated tools.  For example the hammer composes well with the end of a wrench to apply percussive torsion onto tough bolts. 

In this same sense the computational tools discussed in this dissertation above must be tested in novel contexts outside of the application for which they were originally designed.  The following sections present examples using these software components in novel contexts.  The following work demonstrates substanial results with trivial efforts.

In Section \ref{sec:theano} we demonstrate interchangability by swapping out our prototypical `computations` project for BLAS/LAPACK code generation with `Theano`, a similar project designed for array computations in machine learning.  In Section \ref{sec:blocking} we show that improvments isolated to a single module can reverberate over the entire system by using the mathematical blocking known in SymPy to develop and execute blocked matrix algorithms.  Finally in Section \ref{sec:sympy-stats} we apply the ideas of this dissertation to the field of statistics to demonstrate applicability outside of linear algebra. 

include [Kalman filter in Theano](theano.md)

include [blocking](blocking.md)

include [SymPy stats](sympy-stats.md)
