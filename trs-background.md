
Background
----------

\label{sec:pattern-previous-work}

*Comment*: In general I think I'm just saying what I know how to say, rather than precisely what needs to be said.  I also don't know much about what I'm talking about below.  My understanding here is obviously shallow; just deep enough to get the other pieces running.

Logic programming and term rewrite systems benefit from substantial theory and mature software packages.

### Software Systems

Several mature term rewrite systems exist.  In spirit these descend from logic programming, first popularized by the Prolog language in the early seventies.  Today systems like Maude and Elan from the OBJ family and the Stratego/XT toolset use term rewriting for the declarative construction of languages.  They serve as repositories for results from academic research.

#### Maude/Elan: 

The Maude system\cite{Clavel1996} uses term rewriting to support a meta-programming environment.  The Maude language provides syntax to define syntax for other languages.  It also enables the description of rewrite rules to transform terms in that language.  Rewrite rules are separated into a set of confluent equations and a set of non-confluent rewrite rules.  The non-confluent rules can be applied in two built-in strategies.  Elan\cite{Borovansky2002} differs from Maude in that it includes strategies as first class citizens.


#### Stratego/XT:

The Stratego/XT\cite{Visser2004} toolset contains several separate tools to support the definition of syntax, language, transformations on terms within that language, and strategies to coordinate the application of those transformations.  This orthogonal approach separates many of the ideas that are present in systems like Elan into distinct, clearly defined ideas.


### Algorithmic Challenges - Pattern Matching

Pattern matching in some form is ubiquitous in modern programming languages.  Unification of terms has long been a cornerstone of both logic programming languages and of theorem provers.  Basic algorithms exist in standard texts on artificial intelligence\cite{aima}.

However, as mentioned in Section \ref{sec:pattern-concerns}, mathematical theories can be pathological because they may require very many rewrite patterns and they make heavy use of associative-commutative operators.


#### Many Patterns

Because these patterns are used at every transformation step and because the collection changes infrequently it makes sense to store them in an indexed data structure that trades insertion time for query time.  Discrimination nets are often used in practice \cite{Christian1993}.  These provide simultaneous matching of one input term to many stored rewrite patterns in logarithmic time.

#### Associative Commutative Matching

Including the traditional definitions of associativity and commutativity in the rule set may lengthen compute times beyond a reasonable threshold.

$$ f(x, f(y, z)) = f(f(x, y), f(z)) $$
$$ f(x, y) = f(y, x) $$

Instead operators that follow one or both of these identities are often specifically handled within the implementation of the term rewrite system.  Languages like Maude request that such operators be identified with special keywords. 

In the simple case associativity may be handled by a round of flattening to n-ary trees (e.g. $f(x, f(y, z)) \rightarrow f(x, y, z)$) and commutativity by bipartite graph matching\cite{Eker1995}.  Because associative-commutative operators often occur in theories with many rewrite patterns, these two problems may be solved simultaneously.  Discrimination nets can be extended (using multiple nets) to efficiently index many associative-commutative patterns\cite{Bachmair1993, Kirchner2001}, supporting many-to-one associative-commutative matching.


### Algorithmic Challenges - Search Strategies

Both multiple patterns and associative-commutative operators introduce the possibility of multiple valid transformations at a single stage.  If the collection of transformations are not confluent and if the set of possible states is large then a search strategy must be specified to find a good solution in a reasonable amount of time.

Systems like Prolog hard-wire a single specific traversal into the transformation system.  It includes backtracking to allow the search to walk out of dead ends and continuation to allow a user to lazily request additional results.  Maude extends this system with the option of "fair rewrites" that samples from the applicable transformations with a round-robin policy.  

While these strategies are useful in the common case it may be that a problem requires custom traversal for efficient computation.  Systems like Elan enable developers to specify search strategies within their program.  Elan includes terms like `repeat` to exhaustively evaluate a particular strategy or `dc one` which non-deterministically applies one of a set of strategies.  The Stratego/XT reinforces this idea by isolating it into it's own separate language Stratego.  Stratego enables the description of complex traversals independent of any particular search problem.


### Mathematica

Likely the most popular term rewrite system to date is Mathematica, the popular commercial computer algebra system.
