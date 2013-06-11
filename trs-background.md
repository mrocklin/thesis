
Background
----------

\label{sec:pattern-previous-work}

Term rewrite systems benefit from substantial theory and mature software packages.

### Pattern Matching

Pattern matching in some form is ubiquitous in modern programming languages.  Unification of terms has long been a cornerstone of both logic programming languages and of theorem provers.  Basic algorithms exist in standard texts on artificial intelligence\cite{aima}.


#### Many Patterns

Mathematical theories may contain thousands of rewrite patterns.  `RUBI`\cite{Rich2009} a system for the solution of indefinite integrals requires a collection of thousands of patterns; none of which overlap.  Because these patterns are used at every transformation step and because the collection changes infrequently it makes sense to store them in an indexed data structure that trades insertion time for query time.  In particular discrimination nets are often used in practice \cite{Christian1993}.  These provide simultaneous matching of one input term to many stored rewrite patterns.


#### Associative Commutative Matching

Mathematical theories often contain associative and commutative operations (like scalar addition or set union).  These associative commutative operators are often given special consideration within term rewrite systems for the sake of efficiency.  While associativity and commutativity could be defined in standard systems with the following identities 

$$ f(x, f(y, z)) = f(f(x, y), f(z)) $$
$$ f(x, y) = f(y, x) $$

doing so may result in pathologically poor search patterns.  Naively associativity is handled by a round of flattening to n-ary trees (e.g. $f(x, f(y, z)) \rightarrow f(x, y, z)$) and commutativity by bipartite graph matching.

In practice both the many-to-one and associative commutative problems are solved simultaneously with specially constructed data structures.  Both \cite{Bachmair1993} and \cite{Kirchner2001} approach the associative commutative many-to-one matching problem with a collection of specially formed discrimination nets.


### Search Strategies

Both multiple patterns and associative-commutative operators introduce the possibility of multiple valid transfomrations at a single stage.  If the collection of transformations are not confluent and if the set of possible states is large then a search strategy must be specified to find a good solution in a reasonable amount of time.

Systems like Prolog and Maude \cite{Clavel1996} hard-wire specific search strategies into the transformation system.  Other systems like Elan \cite{Borovansky2002} enable users to specify a search strategy.  Stratego \cite{Visser2004} developed as a language to define such search strategies.

#### Stratego

Stratego is a language for programmable rewriting strategies.  Example expressions in Stratego include terms for apply rule exhaustively, apply each of a set of rules until one works, traversals, etc....  

TODO
