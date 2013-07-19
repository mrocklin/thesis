
Mathematical Numerical Linear Algebra Design
============================================

\label{sec:math-num-linalg-design}

Analyze the previous chapter from the lens of software design.  Note the benefits of various design choices. 

*   The different pieces of the above program can be developed independently.  Each piece assumes knowledge of only one area of expertise.
*   New parts can be tested and compared. 
    *   Swap out schedulers
    *   Swap out code generators (use Theano instead, see how it compares)
*   The different pieces can be broadly applied.  They're generally applicable beyond this problem.

Introduction
------------

Automated high performance numerical analysis requires simultaneous expertise in several challenging topics.  As a result software solutions to this problem originate from very few groups relative to the size of the user community.  Changing hardware puts substantial pressure on this small developer community, resulting in a substantial lag between hardware development and solution construction and penetration into the user community.

To address this we attempt to separate the hardware from mathematical concerns.  We do this by creating our solution from the following distinct and independent pieces.

*   A mathematical DSL for matrix algebra
*   A declarative description of computations like BLAS/LAPACK, FFTW
*   A library for relational programming, term matching and rewriting
*   A set of common compiler optimizations

Separation
----------

Each of these pieces engages relatively few domains of expertise and can be developed by a larger community of qualified experts.

Each module is easily replacable by competing projects, enabling comparison and evolution of the ecosystem.

Each piece may be tested and verified independently.  The verification is often simpler out of this special context.

### Modules may be used in other unrelated situations

Block-matrix algorithms for matrix inversion and determinants are commonly published for 2 by 2 blocks.  We can easily generate and publish algorithms for higher block resolutions.  We perform the same math but, instead of generating Fortran code generate LaTeX.

In appendix [LogPy](logpy.md) we describe an implementation of miniKanren, a relational programming library.  This library can be used widely for various problem ranging from parsing to a database query language.

### Modules are replacable

We can switch out our BLAS/LAPACK backend with Theano, a popular package for array programming.

[Blogpost: SymPy and Theano -- Matrix Expressions](http://matthewrocklin.com/blog/work/2013/04/05/SymPy-Theano-part-3/)

Intermediate Representations
----------------------------

Numerical linear algebra is used at a variety of levels by a population of programmers with a variety of skillsets.  To this end we focus on the creation of a sequence of clean intermediate representations.

### Fortran code

We emit human readable and mathematically commented Fortran code.  The output of our process does not depend on the continued use of our software system.  The output code can be wrapped immediately into a higher-level language like Python or Matlab, integrated into other high performance codes, or opened and edited by an expert developer.  The lack of dependencies increases the bredth of applicability.

Background - For example, the popular FFTW library is written in OCaml but does not depend on OCaml.  More scientific programmers probably know the artifact than know of the language.

### Directed Acyclic Graphs

#### Other Output Languages 

Before the emission of Fortran code computations exist as a mathematically annotated directed acyclic graph.  From this graph it is possible to emit a range of low-level code, not just Fortran.   We also support the emission of DOT code for graph visualization and a simple pseudocode language suitable for presentation and human comprehension.

Other languages can be added relatively simply, providing support for developers, for example, who prefer `C`.

#### Other transformations

Other developers who use this project may want to apply their own computational logic.  By providing them with clean intermediate representations we enable them to apply their own research ideas without needing to interact deeply with our codebase.  In section [scheduling](scheduling.md) we will see the application of static scheduling algorithms to dense linear algebra.  The code written for those solutions will be completely separate the linear algebraic code presented here.  Clean intermediate representations foster broad interaction with other developers, enabling software evolution.

In [math-num-linalg-performance.md](math-num-linalg-performance.md) we obtained a substantial speedup through full-algorithm blocking.  This speedup was because smaller matrix blocks were able to stay in memory longer.  This performance gain depends on the choice of sequential ordering of computations.  Our current approach to ordering independent computations is somewhat random.  It could be that a transformation at this stage would substantially improve the gain we have observed.
