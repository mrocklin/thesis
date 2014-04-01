Relation to Other Work
----------------------

\label{sec:voltron-other-work}

Fabregat-Traver and Bientinesi approached this same problem with similar
methods\cite{CLAK-VECPAR12, CLAK-IJHPCA}.  They too transform matrix terms
into BLAS/LAPACK call graphs by searching through a graph of possible
transformations.  They take this work further by providing matrix-specific
heuristics to guide and to constrain the search space, and also by providing
support for iterative algorithms.

While we were aware of their preliminary work early in the development of this
project, we developed our work independently.  Their work has since delved more
deeply into efficient search for efficient matrix algorithms while ours has
broadened out into the use of rewrite rules within other subfields of computer
algebra as well as alternative control abstractions to support novice users.
