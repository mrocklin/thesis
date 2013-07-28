
Theano Backend
--------------

\label{sec:theano}

Modular components allow interchangability.  This enables experimentation with alternative implementations of some of the components without rewriting the entire system.  Fine software granularity encourages evolution and avoids global rewrites.

We demonstrate this virtue by swapping out our `computations` backend for BLAS/LAPACK routines with Theano, a Python package for array computing.  Theano comes from the machine learning community.  It was developed with different goals and so has a different set of strengths and weaknesses.  It supports NDArrays, non-contiguous memory, and GPU operation but fails to make use of mathematical information like symmetry or positive-definiteness.  It is also significantly more mature and its longevity extends beyond that of most research projects.  In particular, it is the natural surrogate to the `computations` project, should it fail to persist.

#### Kalman Filter

In Section \ref{sec:kalman-filter} we mathematically defined the Kalman Filter in SymPy and then implemented it automatically in `computations`.  We do the same here with Theano.

~~~~~~~~~Python
include [Kalman code](kalman.py)
~~~~~~~~~

We take this same mathematical definition and generate a Theano graph and runnable function.

~~~~~~~~~~~~~~~Python
from sympy.printing.theanocode import theano_function
inputs  = [mu, Sigma, H, R, data]
outputs = [newmu, newSigma]
dtypes  = {i: 'float64' for i in inputs}

f = theano_function(inputs, outputs, dtypes=dtypes)
~~~~~~~~~~~~~~~

Theano builds a Python function that calls down to a combination of low-level `C` code, `scipy` functions, and calls to static libraries.  This function takes and produces numpy arrays corresponding to the symbolic `inputs` and `outputs`.  Any SymPy matrix expression can be translated to and run by Theano in this manner.

\begin{figure}[htbp]
\centering
\includegraphics[width=\textwidth]{images/theano-kalman}
\label{fig:theano-kalman}
\caption{Theano computation graph for the Kalman Filter}
\end{figure}

This allows us to experiment with and evaluate features present in different systems.  For example the value of adding GPU operations to `computations` may be evaluated first by viewing their value in Theano.
