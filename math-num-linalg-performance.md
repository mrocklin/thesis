
Introduction
------------

### High Productivity Languages

"High productivity" languages haved gained popularity in recent years.  These languages target application domain programmers by reducing barriers to entry and providing syntax to for high-level constructs.  Scripting languages like MatLAB, R, and Python remove explicit typing, provide interpreters, and provide high level primitives like matrix operations or statistical functions directly in the language.  These languages allow non-expert programmers the abillity to solve a certain class of common problems with little training in traditional programming theory.

### Need for Compilers in Numerial Linear Algebra

Each of these languages also provide a set of high performance array operations.  A small set of array operations like matrix multiplication, solve, slicing, and elementwise scalar operations can be combined to solve a wide range of problems ranging in domains from machine learning to the solution of PDEs.  Because this set is small these routines can be implemented by language designers in a lower-level language and then linked to hooks within the high-producitivy language, providing a good separation of expertise. These efforts have proven popular and useful among applied communities.

None of these popular array programming languages are compiled (TODO: are there counter-examples?).  Because the array operations call down to precompiled library code this may seem unnecessary.


### Operation Ordering in MatLab

Taken from [http://matthewrocklin.com/blog/work/2013/02/26/MatLabOrdering/](http://matthewrocklin.com/blog/work/2013/02/26/MatLabOrdering/)

Consider the following MatLab code

    >> x = ones(10000, 1);
    >> tic; (x*x')*x; toc
    Elapsed time is 0.337711 seconds.
    >> tic; x*(x'*x); toc
    Elapsed time is 0.000956 seconds.

Depending on where the parentheses are placed one either creates `x*x'`, a large 10000 by 10000 rank 1 matrix, or `x'*x`, a 1 by 1 rank 1 matrix.  Either way the result is the same.  The difference in runtimes however spans several orders of magnitude.

Graphically the operation looks something like the following

![](xxtrans.pdf)

This is a common lesson that the order of matrix operations matters.  Do computers know this lesson?  It is difficult to implement this optimization in compiler for C or Fortran.  They would have to inspect sets of nested for loopsto realize the larger picture.  A hosted library like `numpy` is also unlikely to make this optimization; operation ordering is determined by the Python language.  With MatLab it is uncertain.  MatLab is interpreted and so generally doesn't compile.  However it inspect each line statement before execution.

Unfortunately Matlab does not perform this optimization.
    
    >> tic; x*x'*x; toc
    Elapsed time is 0.317499 seconds.

### Analysis

At the high, array programming level, this optimization is straightforward.  It is a common homework assignment in introductory algorithms courses.  A small amount of pre-execution logic can provide orders of magnitude in savings.

This is a single example of a family of optimizations that can be made at the array programming level.  These optimizations are well known to numerical analysts but are still uncommonly implemented in practice.  We present a project that attempts to encode this expert knowledge within an automated compiler system.

Background
----------

Both the broad applicability of this domain and the performance improvments from expert treatment have made it the target of substantial academic study and engineering optimization.

### Statically compiled libraries - BLAS/LAPACK

### Heterogeneous computing - Magma

### Automated methods - FLAME


Encoding Linear Algebra in SymPy
--------------------------------

BLAS/LAPACK, Magma, and FLAME all build custom treatments of linear algebra in order to create high performance libraries.  Unfortunately there is duplication and an inability to share the intermediate logic with other projects.  

In SymPy matrix expressions we approach this problem by first expressing linear algebra theory in isolation and then separately applying that automated expertise to the specific problem of automated algorithm search.

### Language

#### Application - Operation Ordering

### Inference on predicates

### Computations - BLAS/LAPACK

#### Application - Selection of Algorithms SYMM v. GEMM

#### Application - BLAS/LAPACK in Python via `F2Py`

### Blocking

#### Application - Blocked Linear Regression

### Conclusion

The above examples demonstrate substantial improvements on ubiquitous problems that are frequent computational bottlenecks in practice.  The improve performance through intelligent selection and organization of existing algorithms rather than detailed implementations of new ones.  The work done was driven by a mathematical library not intended for this task.

