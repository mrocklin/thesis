Pattern Matching
----------------

include [TikZ](tikz_pattern.md)

### Motivation

Projects within this thesis leverage mathematics and computational knowledge to generate efficient programs.  The mathematics involved is often voluminous and often known only to a small community of experts.  These experts may not be capable of formally writing down their expertise in general purpose code within a code generation system.  Additionally, any work integrated into a particular system may is unlikely to be transferrable to future work.

To expand the pool of potential developers and to increase the reusability of their work we focus on declarative methods that enable the formal definition of expertise in a way that is familiar to mathematical users and not connected to any particular implementation.  In particular we focus on pattern matching and term rewrite systems.  These mimic the style of expression common within mathematics and separate the formal definition of patterns from the particular implementation of their application.

### Term Matching

*Include this?*

### Associative Commutative Matching

Mathematical operations are often associative and commutative.  Within pattern matching associative and commutative operators substantially increase the complexity of the matching problem.  Consider the following pattern and expression

    pattern:        a*b
    expression:     x*y*z

If `*` is an associative operator then these two terms unify with either of the following set of matchings

    {a: x,   b: y*z}
    {a: x*y, b: z}

If `*` is a  commutative operator then these two terms unify with the following set of matchings

    {a: x,   b: y*z}
    {a: y,   b: x*z}
    {a: z,   b: x*y}
    {a: y*z, b: x}
    {a: x*z, b: y}
    {a: x*y, b: z}

Complex problems matching many patterns may work only with a particular one of these matchings.  Patterns with associative-commutative operators may quickly generate a combinatorial number of matchings.  Pruning this set of possibilities efficiently is an important challenge in the complex mathematical matching problem.


### Indexing Patterns

At each step of a term rewrite system we match one expression against a collection of patterns to select viable next steps.  Operationally this collection can grow into the thousands\cite{rubi}.  If patterns contain associative-commutative operators then the cost of matching against each pattern may also grow large.  To resolve this it is common to index patterns into a data structure that supports efficient simultaneous matching of many patterns against a single expression.  In the non-associative-commutative case a variant of the Trie data structure is commonly used.  The associative-commutative multi-pattern match problem has mature solutions in literature.
