Algorithm Search
----------------

\label{sec:search}

include [TikZ](tikz_search.md)

The projects within this thesis repeatedly match and apply one of a set of transformations to an input.  Each stage in this process may have multiple valid transformations which yield multiple possible transformation paths.  This defines a tree where the root is the input expression and the leaves are the terminal states where no further transformations are valid.

The sets of transformations described within this thesis have two important properties

*   They *terminate*:  No cycles exist.  There is always a sense of constant bounded progression to a final result
*   They are not *confluent*:  There are multiple possible outcomes.  The choice of final outcome depends on which of the multiple valid paths the system takes at intermediate stages.

Due to these two properties we can consider the set of all possible intermediate and final states as a tree.  In operational contexts this tree can grow prohibitively large.  In this section we discuss ways to traverse this tree to efficiently find *high quality* computations.

The desire for *quality* necessitates the presence of an objective function to guide the search at all intermediate and final states.

In this section we consider the abstract problem of exploring a tree to minimize an objective function.  We depend on the following interface

    children  ::  node -> [node]
    objective ::  node -> score
    isvalid   ::  node -> bool

In section \ref{sec:matrix-compilation} we will provide implementations of these functions for the particular problem of algorithm search without our system.

### A Tree of Incomplete Algorithms

### Strategies for Graph Search



Strategies is a mimicry of [Stratego](http://strategoxt.org/)\cite{stratego} in Python.

