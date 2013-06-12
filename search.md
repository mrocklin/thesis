Algorithm Search
----------------

\label{sec:search}

include [TikZ](tikz_search.md)

We reinforce that a Term Rewrite System consists of the following

1.  A language of terms
2.  A collection of isolated transformations
3.  A system to coordinate the application of those transformations.

In this section we approach the third element.  We pose this component as a graph search problem.

We iteratively evolve our input through repeated application of a collection of small transformations.  At each stage we select one among a set of several valid transformations.  These repeated decisions form a decision tree which may be costly to explore.  

This section discusses this search problem abstractly.  Section \ref{sec:matrix-compilation} discusses the search problem concretely in the context of BLAS/LAPACK computations.


### Problem Description

The projects within this thesis match and apply one of a set of possible transformations to a term.  This process is often repeated until no further transformations apply.  This process is not deterministic; each step may engage multiple valid transformations.  These in turn may yield multiple different transformation paths and multiple terminal results.  These steps and options define a graph with a single root node.  The root is the input expression and the nodes with zero out-degree (leaves) are terminal states on which no further transformation can be performed.

#### Properties on Transformations

The sets of transformations described within this thesis have two important properties

*   They *terminate*:  The graph has no cycles.  There is always a sense of constant bounded progression to a final result.  As a result the object of study is a directed acyclic graph (DAG).
*   They are not *confluent* in general:  There are potentially multiple valid outcomes; the DAG may have multiple leaves.  The choice of final outcome depends on which path the system takes at intermediate stages.

Due to these two properties we can consider the set of all possible intermediate and final states as a directed acyclic graph (DAG) with a single input.  In operational contexts this DAG can grow to be prohibitively large.  In this section we discuss ways to traverse this DAG to quickly find high quality nodes/computations.

#### Properties on States 

Additionally the states within this graph have two important properties

*   Quality:  There is a notion of quality or cost both at each final state and at all intermediate states.  This is provided by an objective function and can be used to guide our search
*   Validity:  There is a notion of validity at each final state.  Only some leaves represent valid terminal points; others are dead-ends.

For simplicity this section will consider the simpler problem of searching a tree (without duplicates.)  The full DAG search problem can be recovered through use of dynamic programming.


### Example Tree

\begin{wrapfigure}[10]{r}{.5\textwidth}
\vspace{-2em}
\centering
\includegraphics[width=.48\textwidth]{images/search}
\end{wrapfigure}

We reinforce the problem description above with an example.

This tree has a root at the top.  Each of its children represent incremental improvements on that computation.  Each node is labeled with a cost; costs of children correlate with the costs of their parents.  The leaves of the tree are marked as either valid (blue) or invalid (red).  Our goal is to quickly find a valid (blue) leaf with low cost without searching the entire tree.


