
Introduction
------------

### Motivation

*The mathematical software ecosystem can best be served by separating the mathematics from the software.*

The following arguments support this principle

#### Math changes more slowly than Software

Software may change due to evolution in programming languages, radical shifts in hardware, or simply due to adoption of an old technique by a new community.  Conversely much of the Mathematics used in computation is well established or at worst changes relatively slowly.  By separating the mathematics (a slowly changing component) from the software (a rapidly changing component) we reduce the extent of the expertise which must be frequently rewritten due to the natural evolution of the scientific computing ecosystem.


#### Demographics

Deep understanding of both computational mathematics and software enginnering is held only by a small population of scientific software engineers.  By separating the mathematics from the software we reduce the demands of writing and verifying solutions.  A larger body of mathematicians can work on the mathematics and a larger body of software engineers can work on the pure software components.

### Definition

We use Term Rewrite Systems to enable the separation of mathematics from software.  A term rewrite system is composed of

1.  A language of terms
2.  A collection of isolated transformations on those terms
3.  A system to coordinate the application of those transformations

In our case our terms are mathematical expressions, our transformations are known mathematical relations, and the system of coordination is abstracted as a graph search problem.

This approach separates mathematics from software.  The language and transformations are mathematical while the system for coordination is algorithmic.  The isolated nature of the transformations limits the extent to which mathematical programmers need to understand the broader software context.  The system for coordination need not depend on the transformations themselves, eliminating the need for mathematical understanding from an algorithmically centered task.

Explicitly Term Rewrite Systems confer the following benefits in the context of mathematical computing

*   Mathematical programmers can focus on much smaller units of software
*   Algorithmic programmers are isolated from the mathematics
*   Smaller transformations can be more effectively verified
*   Isolated coordination systems can be more effectively verified
*   Multiple independent coordination systems can interact with the same set of transformations
*   Multiple sets of transformations can interact with the same coordination systems


In Section \ref{sec:pattern} we discuss the pattern matching problem in the context of computer algebra.  In Section \ref{sec:search} we pose the problem of coordinating these rules as a graph search problem.  These respectively address parts 2 and 3 listed above.

In Section \ref{sec:math-num-linalg} we demonstrate the utility of these tools by implementing a mathematically informed linear algebra compiler with minimal math/compilers expertise overlap.


#### Example

Mathematical theories contain many small transformations on expressions.  For example  consider the cancellation of exponentials nested within logarithms, e.g. 

$$\log(\exp(x)) \rightarrow x \;\;\; \forall x \in \mathbb{R}$$

We encode this tranformation into a computer algebra system like SymPy by manipulating the tree directly

~~~~~~~~~~Python
def unpack_log_exp_if_real(term):
    if isinstance(term, log) and isinstance(term.args[0], exp) and ask(Q.real(x)):
        return term.args[0].args[0]  # unpack both `log` and `exp`
~~~~~~~~~~

We appreciate that this transformation is isolated and compact.  The function `unpack_log_exp_if_real` may be one of a large set of transformations, each of which transform terms to other, possibly better terms.  This approach of many small `term -> term` functions isolates the mathematics from the coordination of the functions.  A mathematical programmer may easily encode several such functions without thinking about how they are applied while an algorithmic programmer may develop sophisticated systems to coordinate these many functions without thinking about what math they represent.