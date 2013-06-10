Pattern Matching
----------------

\label{sec:pattern}

include [TikZ](tikz_pattern.md)

Rewriting via term matching enables the definition of transformations using only the mathematical language of terms.  The underlying algorithmic language (e.g. Python) is completely separated from the definition of transformations.  This separation compounds many of the previously mentioned benefits of term rewrite systems.

Pattern matching enables the construction of transformations declaratively, requiring only the syntax of the term language.  This provides further convenience to the mathematical programmer as the practice aligns well with the written tradition of mathematics.  Additionally, transformations written as rewrite patterns are more durable and reusable, depending only on the syntax of mathematical terms.  The syntax of mathematical terms has demonstrated significant longevity.

#### Mathematical Transformations

We reconsider the unpacking logarithms of exponents example 

$$\log(\exp(x)) \rightarrow x \;\;\; \forall x \in \mathbb{R} $$

We noted that this tranformation can be encoded as a manipulation of a tree within a computer algebra system, SymPy.  We appreciated that this algorithmic code was isolated to just a few lines and does not affect the code for coordination.  We do not simultaneously require any developer to understand both the mathematics and the coordination of transformations.

~~~~~~~~~~Python
if isinstance(term, log) and isinstance(term.args[0], exp) and ask(Q.real(x)):
    return term.args[0].args[0]  # unpack both `log` and `exp`
~~~~~~~~~~

However, this method of solution does simultaneously require the understanding of both the underlying mathematics and the particular data structures within the computer algebra system.  This approach has two flaws.

1.  It restricts the development pool to simultaneous experts in mathematics and the particular computer algebra system.
2.  The solution is only valuable within this particular computer algebra system.  It will need to be rewritten for future software solutions.

These flaws can be avoided by separating the mathematics from the details of term manipulation.  We achieve this through the description and matching of patterns.  We use the mathematical term language to describe the transformations directly, without referring to the particular data structures used in the computer algebra system.


### Rewrite Patterns

We define a rewrite pattern/rule as a source term, a target term, a condition and a set of variables, each of which is a term in the mathematical language.  For example the following transformation can be decomposed into the following pieces

$$\log(\exp(x)) \rightarrow x \;\;\; \forall x \in \mathbb{R}$$

*   Source:  $\log(\exp(x))$
*   Target:  $x$
*   Condition:  $x \in \mathbb{R}$
*   Variables: $\forall x$

Each of these elements may be encoded in the computer algebra system (SymPy) without additional support from the general purpose language (Python).  We encode them below in a `(source, target, condition, variables)` tuple. 

    ( log(exp(x)),       x,      Q.real(x) ,    {x} )

In practice we will have a fixed set of variables, reducing the tuple to three elements

    ( log(exp(x)),       x,      Q.real(x) )

### Background - Algorithms

Pattern matching of terms is a well established technology in programming languages.

TODO: Cut this (unless someone says otherwise)


### Computational Concerns

Repeatedly matching mathematical terms against source patterns can be costly.  In the context of computer algebra this cost is compounded by the following conerns

#### Associative Commutative Matching

Mathematical theories often include associative and commutative operators.  These operators can substantially increase the complexity of the matching problem. 

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


#### Many Patterns

A single step of a term rewrite system compares the input term against a database of applicable rules.  A naive one-to-one matching of the input term to each rewrite pattern scales linearly with the number of patterns.  Operationally the collection of source patterns can grow into the thousands.  For example RUBI\cite{Rich2009}, a system to resolve symbolic integrals requires thousands of rewrite patterns even after taking great care to eliminate redundancy.

This cost can be managed by indexing the patterns into a hierarchical data structure that allows efficient simultaneous matching of one input term to many rewrite patterns.

