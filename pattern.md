Pattern Matching
----------------

\label{sec:pattern}

include [TikZ](tikz_pattern.md)

Pattern matching enables the construction of transformations declaratively, requiring only the syntax of the term language.  This provides further convenience to the mathematical programmer as the practice aligns well with the written tradition of mathematics.  Additionally, transformations written as rewrite patterns are more durable and reusable, depending only on the syntax of mathematical terms rather than the syntax of a particular language.  The syntax of mathematical terms has demonstrated significant longevity.

#### Mathematical Transformations

Mathematical theories often contain transformations on expressions.  For example in section \ref{sec:sympy} we discuss the cancellation of exponentials nested within logarithms, e.g. 

$$log(exp(x)) \rightarrow x \;\; \textrm{ if } x \textrm{ is real}$$

We may encode this tranformation into a computer algebra system like SymPy by manipulating the tree directly

~~~~~~~~~~Python
if isinstance(term, log) and isinstance(term.args[0], exp):
    term = term.args[0].args[0]  # unpack both `log` and `exp`
~~~~~~~~~~

This method of solution simultaneously requires understanding of both the underlying mathematics and the particular data structures used in the computer algebra system.  This approach has two flaws.

1.  It restricts the development pool to simultaneous experts in these two domains
2.  The solution is only valuable within this particular computer algebra system.  It will need to be endlessly rewritten for future software solutions.

These flaws can be avoided by separating the mathematics from the details of term manipulation.  We achieve this through the description and matching of patterns.


### Rewrite Rule 

We define a rewrite rule as a source term, a target term, a condition and a set of variables, each of which is a term in the mathematical language.  For example the following transformation can be decomposed into the following pieces

$$ log(exp(x)) \rightarrow x \;\; \textrm{ if } x \textrm{ is real} $$

*   Source:  $log(exp(x))$
*   Target:  $x$
*   Condition:  $x$ is real
*   Variables: $x$

Each of these elements may be encoded in the computer algebra system (SymPy) without additional language support from the general purpose language (Python).  We encode them below in a `(source, target, condition)` tuple.  `x` is managed separately.

    ( log(exp(x)),       x,      Q.real(x) )


### Background - Algorithms

Pattern matching of terms is a well established technology in programming languages.


### Computational Concerns

Repeatedly matching mathematical terms against source patterns can be costly.  This cost is compounded by the following conerns

#### Associative Commutative Matching

Mathematical theories often include associative and commutative operators.  These operators can substantially increase the complexity of the matching problem.  This variant of pattern matching is not as well established.

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


#### Simultaneous Matching

A single step of a term rewrite system must often compare the input term against a database of applicable rules.  A naive matching of the input term to each pattern scales linearly with the number of patterns.  Operationally the collection of source patterns can grow into the thousands \cite{Rich2009}, even when care is taken to limit the quantity.  As a result the matching process may quickly become costly.  

This cost can be managed by indexing the patterns into a hierarchical data structure that allows efficient simultaneous matching.


### Background - Previous Work

\label{sec:pattern-previous-work}

These ideas are well developed within the programming languages community.  Mature products include Maude \cite{maude}, Elan \cite{elan}, and the Stratego/XT toolset \cite{strategoxt}.  These projects benefit from the following work
