Algorithm Search
----------------

\label{sec:search}

include [TikZ](tikz_search.md)

In section \ref{sec:matrix-compile} we will compile a set of matrix expressions into a BLAS/LAPACK computation by repeatedly applying an incremental set of rewrite rules.  At each stage in this incremental process we may have to select between several differnt options.  This decision-making forms a graph search problem which we discuss abstractly here.

### Problem Description

The projects within this thesis match and apply one of a set of possible transformations to a term.  This process is often repeated until no further transformations apply.  Each step in this process may have multiple valid transformations.  These in turn may yield multiple different transformation paths and multiple terminal results.  These steps and options define a graph with a single root node.  The root is the input expression and the nodes with zero out-degree (leaves) are terminal states on which no further transformation can be performed.

#### Properties on Transformations

The sets of transformations described within this thesis have two important properties

*   They *terminate*:  I.e. the graph has no cycles.  There is always a sense of constant bounded progression to a final result.  As a result the object of study is a directed acyclic graph (DAG).
*   They are not *confluent* in general:  There are potentially multiple valid outcomes; the DAG may have multiple leaves.  The choice of final outcome depends on which path the system takes at intermediate stages.

Due to these two properties we can consider the set of all possible intermediate and final states as a directed acyclic graph (DAG) with a single input.  In operational contexts this DAG can grow to be prohibitively large.  In this section we discuss ways to traverse this DAG to quickly find high quality nodes/computations.

#### Properties on States 

Additionally the states within this graph have two important properties

*   Quality:  There is a notion of quality or cost both at each final state and at all intermediate states.  This is provided by an objective function and can be used to guide our search
*   Validity:  There is a notion of validity at each final state.  Not all leaves are valid terminal points.

For simplicity this section will consider the simpler problem of searching a tree (without duplicates.)  The full problem can be recovered through use of dynamic programming.

#### Interface

In this section we consider the abstract problem of exploring a tree to minimize an objective function.  We depend on the following interface

    children  ::  node -> [node]
    objective ::  node -> score
    isvalid   ::  node -> bool

In section \ref{sec:matrix-compilation} we will provide implementations of these functions for the particular problem of matrix algorithm search.


### Example Tree

We reinforce the problem description above with an example.

\begin{wrapfigure}[10]{r}{.5\textwidth}
\vspace{-2em}
\centering
\includegraphics[width=.48\textwidth]{images/search}
\end{wrapfigure}

This tree has a root at the top.  Each of its children represent incremental improvements on that computation.  Each node is labeled with a cost; costs of children correlate with the costs of their parents.  The leaves of the tree are marked as either valid (blue) or invalid (red).  Our goal is to quickly find a valid (blue) leaf with low cost without searching the entire tree.


### Strategies

We consider a sequence of decreasingly trivial traversal algorithms.  These expose important considerations.  We build up to greedy depth first search with backtracking.

#### Leftmost Traversal

\begin{wrapfigure}[10]{r}{.5\textwidth}
\vspace{-2em}
\centering
\includegraphics[width=.48\textwidth]{images/search-left}
\end{wrapfigure}

A simple traversal may find sub-optimal solutions.  For example consider the strategy that takes the left-most node at each step.  This arrives at a node cost 21.  In this particular case that node is scored relatively poorly.  The search process was cheap but the result was poor. 

~~~~~~~~~Python
def leftmost(children, objective, isvalid, node):
    if isvalid(node):
        return node 

    kids = children(node):
    if kids:
        return leftmost(kids[0])
    else:
        raise Exception("Unable to find valid leaf")
~~~~~~~~~


#### Greedy Search

\begin{wrapfigure}[10]{r}{.5\textwidth}
\vspace{-2em}
\centering
\includegraphics[width=.48\textwidth]{images/search-dumb}
\end{wrapfigure}

If we can assume that the cost of intermediate nodes is indicative of the cost of their children then we can implement a greedy solution that always considers the subtree of the minimum cost child.

~~~~~~~~~Python
def greedy(children, objective, isvalid, node):
    if isvalid(node):
        return node

    kids = children(node):
    if kids:
        best_subtree = min(kids, key=objective)
        return greedy(best_subtree)
    else:
        raise Exception("Unable to find valid leaf")
~~~~~~~~~

        
#### Greedy Search with Backtracking

\begin{wrapfigure}[10]{r}{.5\textwidth}
\vspace{-2em}
\centering
\includegraphics[width=.48\textwidth]{images/search-greedy}
\end{wrapfigure}

Greedy solutions like the one above can become trapped in a dead-end.  In our example they arrive at an invalid leaf with cost `8`.  There is no further option to pursue in this case.  The correct path to take at this stage is to regress backwards up the tree and consider other previously discarded options.

This requires the storage and management of history of the traversal.  By propagating streams of ordered solutions rather than a single optimum we implement a simple backtracking scheme.

~~~~~~~~~Python
include [Greedy](greedy.py)
~~~~~~~~~

The functions `chain` and `imap` operate lazily, computing results as they are requested.  Management of history, old state, and garbage collection is performed by the Python runtime and is localized to the generator mechanism in `chain` and `imap`.
 

#### Continuing the Search
 
\begin{wrapfigure}[10]{r}{.5\textwidth}
\vspace{-2em}
\centering
\includegraphics[width=.48\textwidth]{images/search-continue}
\end{wrapfigure}

This has the added benefit that a lazily evaluated stream of all leaves is returned.  If the first result is not adequate then one can ask the system to find subsequent solutions.  These subsequent computations pick up where the previous search process ended, limiting redundant search.

By exhaustively computing the iterator above we may also traverse the entire tree and can minimize over all valid leaves.  This may be prohibitively expensive in some cases but remains possible when the size of the tree is small.


#### Repeated Nodes - Dynamic Programming

If equivalent nodes are found in multiple locations then we can increase search efficiency by considering a DAG rather than tree search problem.  This is equivalent to dynamic programming and can be achieved by memoizing the intermediate shared results.  The tree search functions presented above can be transformed into their DAG equivalents with a `memoize` function decorator.


### Extensions

In the section above we describe a greedy depth first search with backtracking.  In this section we discuss a few generalizations.

#### K-deep greedy 

Rather than compute and then minimize over the children of a node we could compute and minimize over the grandchildren.  More generally we can compute and minimize over the descendents of depth k.  This increases foresight and computational cost.

#### Breadth first 

The greedy search above is *depth first*.  It exhausts its current subtree before moving on to siblings.  Alternatively it could search subtrees more fairly, returning a single greedily optimal solution within each before moving on to the next.  This cycles between early alternatives rather than late alternatives.  Code for this algorithm can be obtained by replacing `chain` with `interleave` in the code above.

#### Expanding Frontier

Both depth and breadth first are special cases of an expanding frontier, navigating the graph (evaluating `children`) at nodes adjacet to those just visited.  This restriction of adjacency is not essential.  Instead we can maintain a set of accessible nodes and select a global optimum to evaluate.