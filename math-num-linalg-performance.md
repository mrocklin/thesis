
Introduction
------------

### High Productivity Languages

"High productivity" languages haved gained popularity in recent years.  These languages target application domain programmers by reducing barriers to entry and providing syntax for high-level constructs.  Scripting languages like MatLAB, R, and Python remove explicit typing, separate compilation steps, and support high level primitives for matrix and common statistical operations.  These languages allow non-expert programmers the abillity to solve a certain class of common problems with little training in traditional programming.

### Need for Compilers in Numerial Linear Algebra

Each of these languages provide a set of high performance array operations.  A small set of array operations like matrix multiplication, solve, slicing, and elementwise scalar operations can be combined to solve a wide range of problems in statistical and scientific domains.  Because this set is small these routines can be implemented by language designers in a lower-level language and then conveniently linked to the high-productivity syntax, providing a good separation of expertise. These efforts have proven popular and useful among applied communities.

None of these popular array programming languages are compiled (TODO: are there counter-examples?).  Because the array operations call down to precompiled library code this may seem unnecessary.


### Operation Ordering in MatLab

[Operation Ordering in Matlab](operation-ordering-matlab.md)

### Analysis

At the high array programming level this optimization is straightforward.  It is a common homework assignment in introductory algorithms courses involving dynamic programming.  A small amount of pre-execution logic can provide orders of magnitude in savings.

This is a single example of a family of optimizations that can be made at the array programming level.  These optimizations are well known to numerical analysts but are still uncommonly implemented in practice.  We present a project that attempts to encode this expert knowledge within an automated compiler system.

Background
----------

Both the broad applicability of this domain and the performance improvments from expert treatment have made it the target of substantial academic study and engineering efforts.

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

#### Application - Linear Regression

[Linear regresion - Inference and algorithm selection](linear-regression.md)

[Linear regresion - Extensibility - SYRK v. GEMM](syrk.md)

#### Application - BLAS/LAPACK in Python via `F2Py`

[Kalman filter - The value of inference and specialized routines](kalman-specialized.md)

### Blocking

#### Application - Blocked Kalman Filter

[Blogpost : Blocked Kalman filter in Theano](http://matthewrocklin.com/blog/work/2013/04/05/SymPy-Theano-part-3/)

### Conclusion

The above examples demonstrate substantial improvements on frequent computational bottlenecks.  They improve performance through automated selection and organization of existing algorithms rather than detailed creation of new ones.  The work done was driven by a mathematical library not intended for this task.  Using `f2py` and integration into widely distribued open source packages the work is immediately and broadly accessible.
