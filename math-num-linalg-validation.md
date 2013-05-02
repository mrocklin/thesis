
Mathematical Numerical Linear Algebra - Validation
==================================================

include [Linear regresion - Inference and algorithm selection](linear-regression.md)

include [Linear regresion - Extensibility - SYRK v. GEMM](syrk.md)

include [Kalman filter - The value of inference and specialized routines](kalman-specialized.md)

include [Blocked Kalman filter in Theano](blocking.md)

Conclusion
----------

The above examples demonstrate substantial improvements on frequent computational bottlenecks.  They improve performance through automated selection and organization of existing algorithms rather than detailed creation of new ones.  The work done was driven by a mathematical library not intended for this task.  Using `f2py` and integration into widely distribued open source packages the work is immediately and broadly accessible.
