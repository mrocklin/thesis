
Introduction
------------

\label{sec:cas-introduction}

Before we leverage mathematics to generate efficient programs we must first describe mathematics in a formal manner amenable to automated reasoning.  To this end we engage computer algebra systems.


#### Data Structure

\begin{wrapfigure}{R}{.33\textwidth}
\centering
\includegraphics[width=.33\textwidth]{images/expr}
\caption{An expression tree for $\log(3e^{x+2})$ }
\label{fig:expr}
\end{wrapfigure}

Computer Algebra Systems (CAS) enable the expression and manipulation of mathematical terms.  In real analysis a mathematical term may be a literal like `5`, a variable like `x` or a compound term like `5 + x` composed of an operator like `Add` and a list of child terms `(5, x)`

We store mathematical terms in a tree data structure in which each node is either an operator or a leaf term.  For example the expression $\log(3 e^{x + 2})$ can be stored as shown in Figure \ref{fig:expr}.

#### Manipulation

A computer algebra system collects and applies functions to manipulate these tree data structures/terms.  A common class of these functions perform mathematical simplifications returning mathematically equivalent but combinatorially simpler expression trees.  Using the example $\log(3 e^{x + 2})$, we can expand the log and cancel the log/exp to form $x+2+\log(3)$; see Figure \ref{fig:sexpr}.

\begin{figure}[htbp]
\centering
\includegraphics[width=.33\textwidth]{images/sexpr}
\caption{An expression tree for $x + 2 + \log(3)$ }
\label{fig:sexpr}
\end{figure}

#### Extensions

Systems exist for the automatic expression of several branches of mathematics.  Extensive work has been done on traditional real and complex analysis including derivatives, integrals, simplification, equation solving, etc.... Other theories such as sets, groups, fields, polynomials, abstract and differential geometry, combinatorics and number theory all have similar treatments.  The literals, variables, and manipulations change but the basic idea of automatic manipulation of terms remains constant.
