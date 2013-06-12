Pattern Matching
----------------

\label{sec:pattern}

include [TikZ](tikz_pattern.md)

Rewriting via term matching enables the definition of transformations using only the mathematical language of terms (e.g. SymPy).  The underlying algorithmic language (e.g. Python) is separated from the definition of transformations.  This separation compounds many of the previously mentioned benefits of term rewrite systems.

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

We define a rewrite pattern/rule as a source term, a target term, a condition and a set of variables, each of which is a term in the mathematical language.  For example the $\log(\exp(\cdot))$ transformation can be decomposed into the following pieces

$$\log(\exp(x)) \rightarrow x \;\;\; \forall x \in \mathbb{R}$$

*   Source:  $\log(\exp(x))$
*   Target:  $x$
*   Condition:  $x \in \mathbb{R}$
*   Variables: $\forall x$

Each of these elements may be encoded in the computer algebra system (SymPy) without additional support from the general purpose language (Python).  We encode them below in a `(source, target, condition, variables)` tuple. 

    ( log(exp(x)),       x,      Q.real(x) ,    {x} )

In practice we will have a fixed set of variables, reducing the tuple to three elements

    ( log(exp(x)),       x,      Q.real(x) )

Using these rewrite patterns we reduce the problem of transformation to matching incoming terms against the source pattern, obtaining appropriate values for `x`, checking the condition, and then reifying these values into the target pattern.  These operations can be dealt with outside the context of mathematics.  Mature solutions already exist, largely stemming from work in logic programming languages and theorem provers. 
