
Motivation
----------

\label{sec:trs-motivation}

*The mathematical software ecosystem can best be served by the separation of  mathematics from software.*

The following arguments support this principle

#### Math changes more slowly than Software

Software may change due to evolution in programming languages, radical shifts in hardware, or simply due to the adoption of an old technique by a new community.  Conversely much of the mathematics used in computation is well established and changes relatively slowly.  By separating the mathematics (a slowly changing component) from the software (a rapidly changing component) we reduce the extent of the expertise which must be frequently rewritten due to the natural evolution of the scientific computing ecosystem.


#### Demographics

Deep understanding of both computational mathematics and software engineering is held only by a small population of scientific software engineers.  Separating mathematics from software reduces the demands of writing and verifying solutions.  A larger body of mathematicians can work on the mathematics and a larger body of software engineers can work on the pure software components.  The costly practice of collaboration can be avoided.

#### Definition

We use Term Rewrite Systems to enable the separation of mathematics from software.  A term rewrite system is composed of the following:

1.  A language of terms
2.  A collection of isolated transformations on those terms
3.  A system to coordinate the application of those transformations

In our case terms are mathematical expressions, transformations are known mathematical relations, and the system of coordination is abstracted as a graph search problem.

This approach separates mathematics from software.  The language and transformations are mathematical while the system for coordination is algorithmic.  The isolated nature of the transformations limits the extent to which mathematical programmers need to understand the broader software context.  The system for coordination need not depend on the transformations themselves, eliminating the need for mathematical understanding from an algorithmically centered task.

Explicitly term rewrite systems confer the following benefits in the context of mathematical computing:

*   Mathematical programmers can focus on much smaller units of software
*   Algorithmic programmers are isolated from the mathematics
*   Smaller transformations can be verified more effectively 
*   Isolated coordination systems can be verified more effectively 
*   Multiple independent coordination systems can interact with the same set of transformations
*   Multiple sets of transformations can interact with the same coordination systems


#### Example

First, a motivating example.  Mathematical theories contain many small transformations on expressions.  For example  consider the cancellation of exponentials nested within logarithms, e.g.:

$$\log(\exp(x)) \rightarrow x \;\;\; \forall x \in \mathbb{R}$$

We encode this transformation into a computer algebra system like SymPy by manipulating the tree directly

~~~~~~~~~~Python
def unpack_log_exp_if_real(term):
    if isinstance(term, log) and isinstance(term.args[0], exp) and ask(Q.real(x)):
        return term.args[0].args[0]  # unpack both `log` and `exp`
~~~~~~~~~~

We appreciate that this transformation is isolated and compact.  The function `unpack_log_exp_if_real` may be one of a large set of transformations, each of which transform terms to other, possibly better terms.  This approach of many small `term -> term` functions isolates the mathematics from the coordination of the functions.  A mathematical programmer may easily encode several such functions without thinking about how they are applied while an algorithmic programmer may develop sophisticated systems to coordinate these many functions without thinking about what math they represent.
