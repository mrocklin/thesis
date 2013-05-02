
Mathematical Numerical Linear Algebra - Validation
==================================================

\label{sec:validation}

In this section we validate our numerical linear algebra system with a sequence of examples.  In each example we will see the following

1.  The automated solution of a common computational bottleneck problem
2.  Quantitative timing results demonstrating improvement in that problem
3.  Qualitative results demonstrating a virtue of software development

We stress that for each problem there are two measures of progress.  A pure numericist will appreciate decreased runtimes on relevant problems.  Someone concerned with the challenges of scientific software development will appreciate various lessons and efficiencies in development.

include [Linear regresion - Inference and algorithm selection](linear-regression.md)

include [Linear regresion - Extensibility - SYRK v. GEMM](syrk.md)

include [Kalman filter - The value of inference and specialized routines](kalman-specialized.md)

include [Blocked Kalman filter in Theano](blocking.md)

Conclusion
----------

The above examples demonstrate substantial improvements on frequent computational bottlenecks.  They improve performance through automated selection and organization of existing algorithms rather than detailed creation of new ones.  The work done was driven by a mathematical library not intended for this task.  Using `f2py` and integration into widely distribued open source packages the work is immediately and broadly accessible.
