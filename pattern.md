Pattern Matching
----------------

\label{sec:pattern}

include [TikZ](tikz_pattern.md)

### Motivation

Projects within this thesis leverage mathematics and computational knowledge to generate efficient programs.  The mathematics involved is often voluminous and known only to a small community of experts.  These experts may not be capable of formally describing their expertise in general purpose code within a code generation system.  Additionally, any work integrated into a particular system is unlikely to be transferrable to future work.

To expand the pool of potential developers and to increase the reusability of their work we focus on declarative methods that enable the formal definition of expertise in a way that is both familiar to mathematical users and also not connected to any particular implementation.  In particular we implement expertise as a collection of mathematical patterns and use pattern matching and term rewrite systems to turn these into a set of transformations.  The patterns mimic the style of expression common within mathematics and separate the formal definition of expertise from the particular implementation of their application.

#### Mathematical Transformations

Mathematical theories often contain transformations on expressions.  For example in section \ref{sec:sympy} we discussed the example of exponentials nested within logarithms cancelling, e.g. 

$$log(exp(x)) \rightarrow x$$

We may encode this tranformation into a computer algebra system by manipulating the tree directly

~~~~~~~~~~Python
if isinstance(term, log) and if isinstance(term.args[0], exp):
    term = term.args[0].args[0]  # unpack both `log` and `exp`
~~~~~~~~~~

This method of solution engages/requires both mathematical understanding and understanding of the particular data structures used in the computer algebra system.  From our perspective this has two flaws.

1.  It restricts the development pool to simultaneous experts in these two domains
2.  The solution is only valuable within this particular computer algebra system.  It will need to be endlessly rewritten for future software solutions.

These flaws can be avoided by separating the mathematics from the details of term manipulation.  We achieve this through the description and matching of patterns.

### Background

*Include this?*

Basic Pattern matching in programming languages, unification, etc.... To a certain extent all of this section is just background.

### Term Matching

*Include this?*

### Associative Commutative Matching

Mathematical theories often include associative and commutative operators.  These operators can substantially increase the complexity of the matching problem.  

#### Example

Consider the following pattern and expression

    pattern:        a*b
    expression:     x*y*z

If `*` is an associative operator then these two terms unify with either of the following set of matchings

    {a: x,   b: y*z}
    {a: x*y, b: z}

If `*` is also a commutative operator then these two terms unify with the following set of matchings

    {a: x,   b: y*z}
    {a: y,   b: x*z}
    {a: z,   b: x*y}
    {a: y*z, b: x}
    {a: x*z, b: y}
    {a: x*y, b: z}

Complex problems matching many patterns may work only with a particular one of these matchings.  Large patterns with many associative-commutative operators may quickly generate a combinatorial number of matchings.  Pruning this set of possibilities efficiently is an important challenge in the complex mathematical matching problem.


### Indexing Patterns

At each step of a term rewrite system we match one expression against a collection of patterns to select viable transformations.  Operationally this collection can grow into the thousands \cite{rubi}.  If patterns contain associative-commutative operators then the cost of matching against each pattern may also grow large.  To resolve this it is common to index patterns into a data structure that supports efficient matching of an input expression against many patterns simultaneously.  In the non-associative-commutative case a variant of the Trie data structure is commonly used.  The associative-commutative multi-pattern match problem has mature solutions in literature.
