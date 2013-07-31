
Term Rewrite System
===================

\label{sec:term-rewrite-systems}
\label{sec:term-rewrite-system}

In Chapter \ref{sec:cas} we saw that computer algebra systems represent and manipulate mathematical elements as terms or trees.  In this chapter we discuss techniques for the manipulation of terms separately from mathematics.  We first motivate the separation of term manipulation into a set of many small transformations and a system to coordinate those transformations in Section \ref{sec:trs-motivation}.  Then in Section \ref{sec:pattern} we present the use of pattern matching to specify small transformations in mathematical syntax, enabling mathematical users to define transformations without knowledge of the underlying graph representations.  In Section \ref{sec:search} we describe problems associated with coordinating many such transformations and pose the general topic as a graph search problem.  We discuss background and existing solutions to these problems in Section \ref{sec:trs-background}.  We then apply these ideas to the automated generation of expert solutions in matrix computations.  We first implement a prototype matrix algebra language in one of these solutions in Section \ref{sec:matrix-rewriting-maude} and then discuss our final approach to these problems in Sections \ref{sec:term}-\ref{sec:search-direct}.

Later in Chapter \ref{sec:voltron} we demonstrate the utility of these tools by implementing a mathematically informed linear algebra compiler with minimal math/compilers expertise overlap.  This system translates computer algebra (SymPy) expressions into directed acyclic `computations` graphs.


include [Introduction](trs-motivation.md)

include [Pattern Matching](pattern.md)

include [Search Theory](search.md)

include [Background](trs-background.md)

include [Matrix Rewriting in Maude](matrix-rewriting-maude.md)

include [Software - Term](term.md)

include [Software - LogPy](logpy.md)

include [Pattern-LogPy](pattern-logpy.md)

include [Matrix Rewriting in SymPy](matrix-rewriting-sympy.md)

include [Software - Search](search-direct.md)

include [Managing Rule Sets](trs-managing-rule-sets.md)
