
Mathematical Numerical Linear Algebra Performance
=================================================

\label{sec:math-num-linalg-performance}

This should eventually be a sizable chapter on the performance of our solution mathematically informed, blocked linear algebra.

--------------------------------------------------------------------------
 Section          Contents                                                                                                          
---------------- ---------------------------------------------------------
 Background       BLAS/LAPACK, Matrix Algebra/inference, 
                  Why do we need array compilers?                                            

 Related work     FLAME, Magma, PLAPACK, 
                  various array programming languages                                                        

 Implementation   Matrix algebra, inference, BLAS/LAPACK DAG generation, 
                  inplace processing, code generation                        

 Results          Several intermediate representations, 
                  highlight particular optimizations, 
                  compare on a couple real world problems 
--------------------------------------------------------------------------

This chapter is intended to contain little conversation about modularity, declarative programming, etc.... Rather it is a more traditional section establishing the validity of a particular solution to a common problem.  It is meant to give both a context and a measure of authority to future discussion.

Introduction
------------

### High Productivity Languages

"High productivity" languages haved gained popularity in recent years.  These languages target application domain programmers by reducing barriers to entry and providing syntax for high-level constructs.  Scripting languages like MatLAB, R, and Python remove explicit typing, separate compilation steps, and support high level primitives for matrix and common statistical operations.  These languages allow non-expert programmers the abillity to solve a certain class of common problems with little training in traditional programming.

### Need for Compilers in Numerial Linear Algebra

Each of these languages provide a set of high performance array operations.  A small set of array operations like matrix multiplication, solve, slicing, and elementwise scalar operations can be combined to solve a wide range of problems in statistical and scientific domains.  Because this set is small these routines can be implemented by language designers in a lower-level language and then conveniently linked to the high-productivity syntax, providing a good separation of expertise. These efforts have proven popular and useful among applied communities.

None of these popular array programming languages are compiled (TODO: are there counter-examples?).  Because the array operations call down to precompiled library code this may seem unnecessary.

include [Operation Ordering in Matlab](operation-ordering-matlab.md)

Related Work
------------

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

include [Linear regresion - Inference and algorithm selection](linear-regression.md)

include [Linear regresion - Extensibility - SYRK v. GEMM](syrk.md)

#### Application - BLAS/LAPACK in Python via `F2Py`

include [Kalman filter - The value of inference and specialized routines](kalman-specialized.md)

### Blocking

include [Blogpost : Blocked Kalman filter in Theano](http://matthewrocklin.com/blog/work/2013/04/05/SymPy-Theano-part-3/)

### Conclusion

The above examples demonstrate substantial improvements on frequent computational bottlenecks.  They improve performance through automated selection and organization of existing algorithms rather than detailed creation of new ones.  The work done was driven by a mathematical library not intended for this task.  Using `f2py` and integration into widely distribued open source packages the work is immediately and broadly accessible.
