
Introduction
============

Scientists increasingly use computation.

*   This has proven valuable.  It's growing rapidly.
*   However scientists are not trained in software engineering
    -   So this activity is an inefficient use of their time
    -   The resulting software ecosystem is inefficient.  It doesn't select and 
        distribute the best solutions.  It doesn't adapt well to today's 
        changing hardware

We discuss how the computer science community can improve the situation.

*   State the demographics of both the types of problems to be solved and the skillset of scientific workforce.  [Expertise](expertise.md)
*   State software engineering values of modularity, coupling and cohesion and explain why pathological cases limit software evolution.  [Software Principles](principles.md) -- not written
*   Analyze existing scientific software under this lens
    -   Anecdotal case studies
        *   [Numerical Weather Prediction](nwp.md) - An example of monolithic Fortran.  In particular we focus on duplicated efforts and an inability to adapt to GPU hardware.
        *   [Trilinos/PETSc/FEniCS](numerics.md) - These projects exhibit a hierarchical or "Russian Doll" approach to modularity, coupling high-level expertise (e.g. PDEs) to lower-level implementations.  They have proven far more effective than monolithic designs but, we argue, are not yet optimlal.
    -   Quantitatve study of dependencies in software package managers.  Apply the tools of complex networks analysis to existing package dependencies.
        *   [PyPi, CRAN, clojars](package-managers.md) -- not yet written

    These analyses show that while low-level software is well modularized and loosely coupled, high and intermediate-level modules are often tightly coupled to specific lower-level implementations, limiting efficient selection and distribution at this level.  This causes fragmentation and slower software evolution.

*   This provides our major argument

    *The computational science community should construct
     loosely coupled, cohesive, intermediate-level packages*

*   Finally note that mathematical experts often lack training to produce such packages. 



Static Scheduling of Numerical Linear Algebra
=============================================

This should be a sizable chapter on the performance of our solution to statically scheduled, mathematically informed, blocked linear algebra.

|                |                                                                                                                  |
|:---------------|:-----------------------------------------------------------------------------------------------------------------|
| Background     | BLAS/LAPACK, Matrix Algebra/inference, Heterogeneous static scheduling                                           |
| Related work   | FLAME, Magma, PLAPACK, task scheduling, various array programming languages                                      |
| Implementation | Matrix algebra, inference, BLAS/LAPACK DAG generation, inplace processing, static scheduling, code generation    |
| Results        | Several intermediate representations, highlight particular optimizations, compare on a couple real world problems|

This chapter is intended to contain little conversation about modularity, declarative programming, etc.... Rather it is a more traditional section establishing the validity of a particular solution to a common problem.  It is meant to give a measure of authority to future discussion.




Modular Design - The Benefits of Interaction
============================================

Previous Numerical Linear Algebra Project
-----------------------------------------

Analyzes the previous chapter from the lens of software design.  Note the benefits of various design choices. 

*   The different pieces of the above program can be developed independently.  Each piece assumes knowledge of only one area of expertise.
*   New parts can be tested and compared. 
    *   Swap out schedulers
    *   Swap out code generators (use Theano instead, see how it compares)
*   The different pieces can be broadly applied.  They're generally applicable beyond this problem.

Applying this elsewhere
-----------------------

### SymPy/Theano Interaction

I have a couple of examples about two libraries for high-level computation.  Each extends a bit into the others' domain.  By replacing these in-house attempts to expand the boundary of one project with interfaces between the two projects we reap substantial performance gains.

*   SymPy:  a library for mathematics which does a bit of code generation
*   Theano: a library for code generation which does a little mathematics

By providing a translation from one to the other we use the best implementions of each idea, producing substantially more performant programs.  This is currently written up as a couple of blog posts

*   [Code Generation](http://mrocklin.github.com/blog/work/2013/03/19/SymPy-Theano-part-1)
*   [Scalar Simplification](http://mrocklin.github.com/blog/work/2013/03/28/SymPy-Theano-part-2)


SymPy Stats
-----------

Present the sympy.stats project and see how it fits into and benefits from these ideals.

Existing written work

*   [Original conference paper](http://people.cs.uchicago.edu/~mrocklin/tempspace/scipy2012-sympystats-paper.pdf)
*   [BlogPost: Generating characteristic functions](http://matthewrocklin.com/blog/work/2012/12/03/Characteristic-Functions/)
*   [BlogPost: Maximum a posteriori estimation](http://matthewrocklin.com/blog/work/2013/02/25/MaximumAposteriori/)
*   [BlogPost: Rewrite rules](http://matthewrocklin.com/blog/work/2012/12/11/Statistical-Simplification/)

Unwritten work

*   Integration with Theano
*   Application with PyMC? (markov chain monte carlo group)


Declarative Programming
=======================

Mathematical experts may not be able to build efficient modular software.  Discuss how the projects above made use of declarative techniques to separate mathematical expertise from algorithmic term rewriting.  

|             |                                                                                                                  |
|:------------|:-----------------------------------------------------------------------------------------------------------------|
| Background  | Stratego/XT, Maude, miniKanren (a simple embedding in Scheme).  Considerations about term rewrite systems.       |
| Approach    | [LogPy](http://github.com/logpy/logpy) , an implementation of miniKanren in Python. Accessible logic programming | 
| Results     | We show how optimizations have been made to both SymPy and Theano with this technology                           |
