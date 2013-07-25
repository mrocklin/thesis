Algorithm Search
----------------

\label{sec:search}

include [TikZ](tikz_search.md)

We reinforce that a Term Rewrite System consists of the following elements:

1.  A language of terms
2.  A collection of isolated transformations
3.  A system to coordinate the application of those transformations.

In this section we discuss the third element, the coordination of transformations.  

We iteratively evolve our input through repeated application of a collection of transformations.  At each stage we select one among a set of several valid transformations.  These repeated decisions form a decision tree.

We may arrive at the same state through multiple different decision paths.  We consider a directed graph where nodes are states (terms) and edges are transitions between states (transformations).  Macroscopic properties of this graph of possible states depend on properties of the set of transformations and terms.


#### Properties on Transformations

A set of transformations is said to be *simply normalizing* if they are unable to return to visited states.  In this case the graph of state transitions is a directed *acyclic* graph (DAG).

A set of terminating transformations is *confluent* if exhaustive application of the transformations can only lead to a single state, regardless of the order of application.  I.e. the DAG has at most one node with zero out-degree.


#### Properties on States 

The information known on states affects the search problem.  We consider the following properties:

*   Validity:  There may be a notion of validity at each final state.  Only some leaves represent valid terminal points; others may be incompletely transformed dead-ends.
*   Quality:  There may be a notion of quality or cost both at each final state and at intermediate states.  Such an objective function may be used as a local guide in a search process.

include [Search Challenges](search-challenges.md)
