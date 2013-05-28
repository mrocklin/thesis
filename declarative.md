
Program Generation
==================

\label{sec:declarative}

To automatically transform a set of mathematical expressions to an efficient and sophisticated computation we require substantial expertise both in the relevant mathematical domain and in the automated compilation of programs.  Unfortunately few mathematical experts also hold compilers expertise.

To resolve this demographic issue we separate the problem into two parts:

1.  A collection of small mathematical transformations 
2.  A system to coordinate their application
    
The small transformations encompass the mathematical expertise and are sufficiently isolated to not require substantial expertise in compilers.  This piece is appropriate for mathematicians.  Conversely the system to coordinate their application is isolated from the mathematical domain and encompasses all of the necessary expertise in automated generation of computations.  This piece is appropriate for computer scientists.  This separation enables contributions from a substantially broader single-domain-of-expertise demographic.

For further convenience to the mathematical expert the majority of the transformations are encoded as declarative rewrite rules specified in a computer algebra system.  This practice aligns well with the written tradition of mathematics.

In section \ref{sec:pattern} we discuss the pattern matching problem in the context of computer algebra and then in \ref{sec:logpy} our particular software solution to this problem.  In section \ref{sec:search} we pose the problem of coordinating these rules as a graph search problem.  These respectively address parts 1 and 2 listed above.

In section \ref{sec:math-num-linalg} we demonstrate the utility of these tools by implementing a mathematically informed linear algebra compiler with minimal math/compilers expertise overlap.

include [Pattern Matching](pattern.md)

include [LogPy](logpy.md)

include [Algorithm Search](search.md)
