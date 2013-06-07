
Program Generation
==================

\label{sec:declarative}

Motivation
----------

*The mathematical software ecosystem can best be served by separating the mathematics from the software.*

The following arguments support this principle

#### Math changes slowly

Software is often rewritten.  This may be because of evolution in programming languages, changes in hardware, or simply due to adoption of an old technique by a new community.  Conversely much of the Mathematics used in computation is well established or a worst changes relativelys slowly.  By separating the mathematics from the software we reduce the task of software rewriting.


#### Demographics

Expertise in the domains of mathematics and software enginnering is rarely shared in the same individual.  By separating the mathematics from the software we reduce the demands of writing *and verifying* a solution.  A larger body of mathematicians can work on the mathematics and a larger body of software engineers can work on the pure software components.


Term Rewrite Systems
--------------------

We use Term Rewrite Systems to enable the separation of mathematics from software.  A term rewrite system is composed of

1.  A language of terms
2.  A collection of isolated transformations on those terms
3.  A system to coordinate the application of those transformations

In our case our terms are mathematical expressions, our transformations are known mathematical relations, and the system of coordination will be a greedy depth first search. 

This approach separates mathematics from software.  The language and transformations are mathematical while the system for coordination is algorithmic in nature.  The isolated nature of the transformations limits the extent to which mathematical programmers need to understand the broader software context.  The system for coordination need not depend on the transformations themselves, eliminating the need for mathematical understanding from an algorithmically centered task.

Explicitly Term Rewrite Systems confer the following benefits in the context of mathematical computing

*   Mathematical programmers can focus on much smaller units of software
*   Algorithmic programmers are isolated from the mathematics
*   Smaller transformations can be more effectively verified
*   Multiple independent coordination systems can interact with the same set of transformations
*   Multiple sets of transformations can interact with the same coordination systems


In section \ref{sec:pattern} we discuss the pattern matching problem in the context of computer algebra and then in \ref{sec:logpy} our particular software solution to this problem.  In section \ref{sec:search} we pose the problem of coordinating these rules as a graph search problem.  These respectively address parts 1 and 2 listed above.

In section \ref{sec:math-num-linalg} we demonstrate the utility of these tools by implementing a mathematically informed linear algebra compiler with minimal math/compilers expertise overlap.

include [Pattern Matching](pattern.md)

include [Algorithm Search](search.md)
