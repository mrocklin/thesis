Computer Algebra
================

\label{sec:cas}

include [Tikz](tikz_math.md)

This dissertation promotes the acceleration of scientific computing through the automated use of expert methods, many of which are mathematical in nature.  It also supports the separation of different domains of expertise into different modules.  This chapter discusses the design of computer algebra systems, the traditional home of automated mathematics and then builds an isolated module to encapuslate the particular domain of mathematical linear algebra.

In Sections \ref{sec:cas-introduction}, \ref{sec:cas-background} we describe the basic design and history of computer algebra.  In Sections \ref{sec:sympy} and \ref{sec:sympy-inference} we describe SymPy, a particular computer algebra system on which the work of this dissertation depends.  In Sections \ref{sec:matrix-language}, \ref{sec:matrix-inference} we present an extension of SymPy to linear algebra.  Finally in \ref{sec:cas-code-generation} we motivate the use of computer algebra in the generation of numeric codes through a brief experiment.

include [Background](cas-background.md)

include [Introduction](cas-introduction.md)

include [SymPy](sympy.md)

include [SymPy Inference](sympy-inference.md)

include [Language](matrix-language.md)

include [Inference](matrix-inference.md)

include [Code Generation](cas-code-generation.md)
