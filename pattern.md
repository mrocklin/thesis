
Pattern Matching
----------------

\label{sec:pattern}

include [TikZ](tikz_pattern.md)

*The syntax of mathematics is both more widely understood and more stable than the syntax of programming*

We consider the class of transformations that can be fully described by only source, target, and condition patterns.  We instantiate these transfromations using pattern matching.  Pattern matching enables the definition of transformations using only the mathematical language of terms (e.g. SymPy) without relying on the implementation (e.g. Python).  This separation compounds many of the previously mentioned benefits of term rewrite systems.

1.  Rewrite patterns align more closely with the tradition of written mathematics than does general purpose code
2.  Development of mathematical transformations is not tied to the implementation, freeing both to be developped at different time scales by different communities.

### Motivation

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

We define a rewrite pattern/rule as a source term, a target term, a condition and a set of variables, each of which is a term in the mathematical language.  For example the $\log(\exp(\cdot))$ transformation can be decomposed into the following pieces

$$\log(\exp(x)) \rightarrow x \;\;\; \forall x \in \mathbb{R}$$

*   Source:  $\log(\exp(x))$
*   Target:  $x$
*   Condition:  $x \in \mathbb{R}$
*   Variables: $\forall x$

Each of these elements may be encoded in the computer algebra system (SymPy) without additional support from the general purpose language (Python).  We encode them below in a `(source, target, condition)` tuple. 

    ( log(exp(x)),       x,      Q.real(x) )

Using these rewrite patterns we reduce the problem of transformation to matching incoming terms against the source pattern, obtaining appropriate values for `x`, checking the condition, and then reifying these values into the target pattern.  These operations can be dealt with outside the context of mathematics.  Mature solutions already exist, largely stemming from work in logic programming languages and theorem provers. 


### Concerns in Mathematical Theories

\label{sec:pattern-concerns}

Mathematical theories introduce the following additional computational concerns to the pattern matching problem


#### Many Patterns

Mathematical theories may contain thousands of rewrite patterns.  For example `RUBI`\cite{Rich2009}, a system for the solution of indefinite integrals, requires a collection of thousands of patterns; none of which overlap.  A matching process that scales linearly with the number of patterns can be computationally prohibitive.


#### Associative Commutative Matching

Mathematical theories often contain associative and commutative operations (like scalar addition or set union).  While associativity and commutativity could be defined in standard systems with the following identities 

$$ f(x, f(y, z)) = f(f(x, y), f(z)) $$
$$ f(x, y) = f(y, x) $$

doing so may result in pathologically poor search patterns.
