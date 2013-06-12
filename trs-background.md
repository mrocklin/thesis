
Background
----------

\label{sec:pattern-previous-work}

*Comment*: In general I think I'm just saying what I know how to say, rather than precisely what needs to be said.

Logic programming and term rewrite systems benefit from substantial theory and mature software packages.

### Software Systems

In regards to software engineering, term rewrite systems can be associated with the geneological branch of logic programming, first popularized by the Prolog language in the early seventies.  Logic programming grew and speciated into data query languages like Datalog, theorem provers like Coq, and rule-based langauges like the OBJ language family.  We'll discuss three elements coming from this last group of rule-based languages notably Maude, Elan, and the Stratego/XT toolset.

#### Maude: 

The Maude system\cite{Clavel1996} uses term rewriting to support a meta-programming environment.  The Maude language provides syntax to define syntax for other languages.  It also enables the description of rewrite rules to transform terms in that language.  Rewrite rules are separated into a set of confluent equations and a set of non-confluent rewrite rules.  The non-confluent rules can be applied in both a depth and breadth first search strategy with backtracking and continuation.

Maude provides

#### Elan: 

Elan\cite{Borovansky2002} differs from Maude in that it includes strategies as first class citizens.


#### Stratego/XT:

The Stratego/XT\cite{Visser2004} toolset contains several orthogonal tools to support the definition of languages, transformations on terms within that language, and strategies to coordinate the application of those transformations.  This orthogonal approach separates many of the ideas that are present in systems like Elan into distinct, clearly defined ideas.

### Algorithmic Challenges - Pattern Matching

Pattern matching in some form is ubiquitous in modern programming languages.  Unification of terms has long been a cornerstone of both logic programming languages and of theorem provers.  Basic algorithms exist in standard texts on artificial intelligence\cite{aima}.

However, as mentioned in Section \ref{sec:pattern-concerns}, mathematical theories can be pathological because they may require very many rewrite patterns and they make heavy use of associative-commutative operators.


#### Many Patterns

Because these patterns are used at every transformation step and because the collection changes infrequently it makes sense to store them in an indexed data structure that trades insertion time for query time.  Discrimination nets are often used in practice \cite{Christian1993}.  These provide simultaneous matching of one input term to many stored rewrite patterns.

#### Associative Commutative Matching

Including the traditional definitions of associativity and commutativity in the rule set may lengthen compute times beyond a reasonable threshold.

$$ f(x, f(y, z)) = f(f(x, y), f(z)) $$
$$ f(x, y) = f(y, x) $$

Instead operators that follow one or both of these identities are often sepcifically handled within the implementation of the term rewrite system.  Languages like Maude request that such operators be identified with special keywords. 

In the simple case associativity may be handled by a round of flattening to n-ary trees (e.g. $f(x, f(y, z)) \rightarrow f(x, y, z)$) and commutativity by bipartite graph matching\cite{Eker1995}.  Because associative-commutative operators often occur in theories with many rewrite patterns, these two problems are often solved simulteneously.  Discrimination nets can be extended (using multiple nets) to efficiently index many associative-commutative patterns\cite{Bachmair1993, Kirchner2001},  supporting many-to-one associative-commutative matching.


### Algorithmic Challenges - Search Strategies

Both multiple patterns and associative-commutative operators introduce the possibility of multiple valid transfomrations at a single stage.  If the collection of transformations are not confluent and if the set of possible states is large then a search strategy must be specified to find a good solution in a reasonable amount of time.

Systems like Prolog hard-wire a single specific traversal into the transformation system.  It includes backtracking to allow the search to walk out of dead ends and continuation to allow a user to lazily request additional results.  Maude extends this system with the option of "fair rewrites" that samples from the applicable transformations with a round-robin policy.  Systems like Elan further extend this option to allow search strategies to be specified by the user.  Elan includes terms like `repeat` to exhaustively evaluate a particular strategy or `dc one` which non-deterministically applies one of a set of strategies.  This concept of programmable strategies is isolated within the Stratego language.


### Mathematica

Likely the most popular term rewrite system to date is Mathematica, the popular commercial computer algebra system.
