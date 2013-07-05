
### Algorithmic Challenges - Search Strategies

Both multiple patterns and associative-commutative operators compound the possibility of multiple valid transformations at a single stage.  If the collection of transformations are not confluent and if the set of possible states is large then a search strategy must be specified to find a good solution in a reasonable amount of time.

Systems like Prolog hard-wire a single specific traversal into the transformation system.  It includes backtracking to allow the search to walk out of dead ends and continuation to allow a user to lazily request additional results.  Maude extends this system with the option of "fair rewrites" that samples from the applicable transformations with a round-robin policy.  

While these strategies are useful in the common case it may be that a problem requires custom traversal for efficient computation.  Systems like Elan enable developers to specify search strategies within their program.  Elan includes terms like `repeat` to exhaustively evaluate a particular strategy or `dc one` to non-deterministically applies one of a set of strategies.  The Stratego/XT reinforces this idea by isolating it into it's own separate language Stratego.  Stratego enables the description of complex traversals independent of any particular search problem.

