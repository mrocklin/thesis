
Contributions
-------------

\label{sec:contributions}

This dissertation presents a software system to transform high-level matrix expressions into high-performance code.  This project supplies mathematical programmers access to powerful-yet-inaccessible computational libraries.

Additionally, this dissertation discusses the virtues of modularity within this domain.  Care has been taken to separate the software system into a set of individual components, each of which retains value both independently and in other applications.  These software contributions are the following:

*   A computer algebra system for manipulation and inference over linear algebra expressions
*   A high-level representation of common numeric libraries and the generation of low-level codes
*   A composable Python implementation of miniKanren, a logic programming system
*   A conglomerate compiler from matrix expressions to intelligently selected computational routines 

Conceptually this software experiment has yielded the following novel ideas within the context of numerical linear algebra:

*   The use of logic inference over mathematical attributes for algorithm selection
*   The use of static scheduling for distributed numerical linear algebra
