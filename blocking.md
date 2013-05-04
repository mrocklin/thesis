
Blocked Kalman Filter
---------------------

In this example we investigate the value of blocking matrices across large algorithms.  At the time of this writing the BLAS/LAPACK computations backend does not support blocking/slicing and concatenation/joining operations.  For this subsection we use the Theano backend presented in section \ref{sec:sympy-theano} instead.

### Kalman Filter

The [Kalman filter](http://en.wikipedia.org/wiki/Kalman_filter) is an algorithm to compute the Bayesian update of a normal random variable given a linear observation with normal noise.  It is commonly used when an uncertain quantity is updated with the results of noisy observations.  For example it is used in weather forecasting after weather stations report in with new measurements, in aircraft/car control to automatically adjust for external conditions real-time, or even on your smartphone's GPS navigation as you update your position based on fuzzy GPS signals.   It's everywhere, it's important, and it needs to be computed quickly and continuously.  It suits our needs today because it can be completely defined with a pair of matrix expressions.

$$ \Sigma H^T \left(H \Sigma H^T + R\right)^{-1} \left(-data + H \mu\right) + \mu $$
$$ - \Sigma H^T \left(H \Sigma H^T + R\right)^{-1} H \Sigma + \Sigma $$

We define these expressions in SymPy

~~~~~~~~~~~~~~~Python
from sympy import MatrixSymbol, latex
n       = 1000                          # Number of variables in our system/current state
k       = 500                           # Number of variables in the observation
mu      = MatrixSymbol('mu', n, 1)      # Mean of current state
Sigma   = MatrixSymbol('Sigma', n, n)   # Covariance of current state
H       = MatrixSymbol('H', k, n)       # A measurement operator on current state
R       = MatrixSymbol('R', k, k)       # Covariance of measurement noise
data    = MatrixSymbol('data', k, 1)    # Observed measurement data

newmu   = mu + Sigma*H.T * (R + H*Sigma*H.T).I * (H*mu - data)      # Updated mean
newSigma= Sigma - Sigma*H.T * (R + H*Sigma*H.T).I * H * Sigma       # Updated covariance
~~~~~~~~~~~~~~~Python

### Theano Execution

The objects above are for symbolic mathematics, not for numeric computation.  If we want to compute this expression we pass our expressions to Theano.

~~~~~~~~~~~~~~~Python
inputs  = [mu, Sigma, H, R, data]
outputs = [newmu, newSigma]
dtypes  = {i: 'float64' for i in inputs}

from sympy.printing.theanocode import theano_function
f = theano_function(inputs, outputs, dtypes=dtypes)
~~~~~~~~~~~~~~~Python

Theano builds a Python function that calls down to a combination of low-level `C` code, `scipy` functions, and calls to the highly optimized `DGEMM` routine for matrix multiplication.  As input this function takes five numpy arrays corresponding to our five symbolic `inputs` and produces two numpy arrays corresponding to our two symbolic `outputs`.  [Recent work](https://github.com/sympy/sympy/pull/1965) allows *any* SymPy matrix expression to be translated to and run by Theano.

~~~~~~~~~~~~~~~Python
import numpy
ninputs = [numpy.random.rand(*i.shape).astype('float64') for i in inputs]
nmu, nSigma = f(*ninputs)
~~~~~~~~~~~~~~~Python

### Blocked Execution

These arrays are too large to fit comfortably in the fastest parts of the memory hierarchy.  As a result each sequential `C`, `scipy`, or `DGEMM` call needs to move big chunks of memory around while it computes.  After one operation completes the next operation moves around the same memory while it performs its task.  This repeated memory shuffling hurts performance.

A common approach to reduce memory shuffling is to cut the computation into smaller blocks.  We then perform as many computations as possible on a single block before moving on.  This is a standard technique in matrix multiplication.

The multiplication of two $2 \times 2$ blocked matrices

$$ \begin{bmatrix} A & B \\\\ C & D \end{bmatrix} 
   \begin{bmatrix} E & F \\\\ G & K \end{bmatrix}$$

Can be expanded using the same logic that one uses to multiply matrices of scalar expressions

$$ \begin{bmatrix} A E + B G & A F + B K \\\\ 
                   C E + D G & C F + D K\end{bmatrix} $$

We are now able to focus on substantially smaller chunks of the array which fit more comfortably in memory.  This allows us to improve memory locality during execution.  For example we can choose to keep `A` in local memory and perform all computations that involve `A`.  We will still need to shuffle some memory around (this is inevitable) but by organizing with blocks we're able to shuffle less.

This idea extends beyond matrix multiplication.  Matrix inverse expressions can also be expanded. 


$$ \begin{bmatrix} 
\left(- B D^{-1} C + A\right)^{-1} & - A^{-1} B \left(- C A^{-1} B + D\right)^{-1} \\\\ 
- \left(- C A^{-1} B + D\right)^{-1} C A^{-1} & \left(- C A^{-1} B + D\right)^{-1}
\end{bmatrix} $$

High performance dense linear algebra libraries hard-code all of these tricks into each individual routine.  The call to the general matrix multiply routine `DGEMM` performs blocked matrix multiply within the call.  The call to the general matrix solve routine `DGESV` can perform blocked matrix solve.  Unfortunately these routines are unable to coordinate blocked computation *between* calls.

Fortunately, SymPy can generate these high-level blocked matrix mathematical expressions and Theano can execute them.  The LaTeX above was generated with the following SymPy Code

~~~~~~~~~~~~~~~Python
from sympy import Symbol, MatrixSymbol, BlockMatrix, block_collapse, latex
n = Symbol('n')
A, B, C, D, E, F, G, K = [MatrixSymbol(a, n, n) for a in 'ABCDEFGK']
X = BlockMatrix([[A, B],
                 [C, D]])
Y = BlockMatrix([[E, F],
                 [G, K]])
print latex(X*Y)
print latex(block_collapse(X*Y))
print latex(block_collapse(X.I))
~~~~~~~~~~~~~~~Python


### General Code to Block the Kalman Filter

SymPy can define and reduce the blocked Kalman filter using relations like what are shown above.  In the listing below we show all the code necessary to block the Kalman filter into blocks of size `n/2`.  The code is dense and not particularly insightful; the goal is to demonstrate that this is a short task using pre-existing general purpose tools.

~~~~~~~~~~~~~~~Python
from sympy import blockcut, block_collapse
blocksizes = {
        Sigma: [(n/2, n/2), (n/2, n/2)],
        H:     [(k/2, k/2), (n/2, n/2)],
        R:     [(k/2, k/2), (k/2, k/2)],
        mu:    [(n/2, n/2), (1,)],
        data:  [(k/2, k/2), (1,)]
        }
blockinputs = [blockcut(i, *blocksizes[i]) for i in inputs]
blockoutputs = [o.subs(dict(zip(inputs, blockinputs))) for o in outputs]
collapsed_outputs = map(block_collapse, blockoutputs)

fblocked = theano_function(inputs, collapsed_outputs, dtypes=dtypes)
~~~~~~~~~~~~~~~Python

Theano is then able to coordinate this computation and compile it to low-level code.  At this stage the expresssions/computations are fairly complex and difficult to present.  Here is an image of the computation as a directed acyclic graph.

\begin{figure}[htbp]
\centering
\includegraphics[width=.9\textwidth]{images/fblocked}
\label{fig:fblocked}
\end{figure}

### Numeric Results

Lets time each function on the same inputs and see which is faster

~~~~~~~~~~~~~~~Python
>>> timeit f(*ninputs)
1 loops, best of 3: 2.69 s per loop

>>> timeit fblocked(*ninputs)
1 loops, best of 3: 2.12 s per loop
~~~~~~~~~~~~~~~Python

That's a 20% performance increase from just a few lines of high-level code.

Blocked matrix multiply and blocked solve routines have long been established as *a good idea*.  High level mathematical and array programming libraries like SymPy and Theano allow us to extend this good idea to *arbitrary* array computations composed of these operations.

Disclaimer: the numbers above are sensitive to the problem size and memory architecture.  Tuning may be required to obtain benefits of this magnitude.

### Development Results

#### General Purpose

First we note that we're not introducing a new library for dense linear algebra.  Instead we're noting that pre-existing general purpose high-level tools can be composed to that effect.  Block matrix manipulations were not developed for this application.  They are a commonly occuring sub-problem that it is useful to have around.

#### Multiple Backends

Our BLAS/LAPACK computations backend did not have the computational elements to perform this experiment.  However because the linear algebra component is separate from the computational backend we are not restricted by this failing.  Because we invested in interfaces we were able to trivially plug in a different backend that did have the necessary features.   A loose federation of components is less brittle than a monolithic system.  Components with access to multiple clients encourage comparison and  experimentation and overall accelerate software evolution.

#### Debugging Challenges

We noticed that the blocked version of this computation experiences some significant roundoff errors (on the order of `1e-3`).  This problem must occur somewhere in the following tool-chain 

                                /> C routines
    SymPy -> Blocking -> Theano -> NumPy/SciPy 
                                \> BLAS

Debugging in this context can be wonderful if all elements are well unit-tested.  If they're not then tracking down errors like this requires an unfortunate breadth of expertise.
