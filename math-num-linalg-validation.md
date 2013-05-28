
Mathematical Numerical Linear Algebra - Validation
==================================================

\label{sec:math-num-linalg-validation}

include [Tikz](tikz_megatron.md)

In this section we validate our numerical linear algebra system with a sequence of examples.  In each example we will see the following

1.  The automated solution of a common computational kernel
2.  Quantitative results demonstrating improvement in that particular problem
3.  Qualitative results demonstrating a virtue of software development

We stress that for each problem there are two measures of progress.  A pure numericist will appreciate decreased runtimes on relevant problems.  A software engineer will appreciate efficiencies in development.

### Contributions

Contributions in numerical methods are as follows

1.  A quantification of performance among scripting languages in the context of mathematically structured problems
2.  A quantification of the importance of mathmatically informed routines in compiled code
3.  A system that finds expert numerical algorithms from naive inputs
4.  A system for blocking large numerical algorithms

Contributions in scientific software development are as follows

1.  A demonstration that clear intermediate representations and small-scope subprojects enable contributions from single-domain experts.
2.  An argument for the use and combination of general packages for common sub-problems


include [Linear regresion - Inference and algorithm selection](linear-regression.md)

include [Linear regresion - Extensibility - SYRK v. GEMM](syrk.md)

include [Kalman filter - The value of inference and specialized routines](kalman.md)

include [Blocked Kalman filter in Theano](blocking.md)

Conclusion
----------

The above examples demonstrate substantial improvements on frequent computational bottlenecks.  They improve performance through automated selection and organization of existing algorithms rather than detailed creation of new ones.  The work done was driven by a mathematical library not intended for this task.  Using `f2py` and integration into widely distribued open source packages the work is immediately and broadly accessible.
