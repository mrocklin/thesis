
Blocked Kalman Filter
---------------------

In this example we investigate the value of blocking matrices across large algorithms.  
We continue to use the Kalman filter as an example computation.


### Blocked Execution

If arrays are too large to fit comfortably in the fastest parts of the memory hierarchy then each sequential operation needs to move large chunks of memory during computation.  After one operation completes the next operation moves around the same memory while it performs its task.  This repeated memory shuffling hurts performance.

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

High performance dense linear algebra libraries hard-code these tricks into individual routines.  The call to the general matrix multiply routine `GEMM` performs blocked matrix multiply within the call.  The call to the general matrix solve routine `GESV` can perform blocked matrix solve.  Unfortunately these routines are unable to coordinate blocked computation *between* calls.

Fortunately, SymPy can generate these high-level blocked matrix mathematical expressions at compile time and Theano can generate code for them.


### General Code to Block the Kalman Filter

SymPy can define and reduce the blocked Kalman filter using relations like what are shown above.  In the listing below we show all the code necessary to block the Kalman filter into blocks of size `n/2`.  The code is dense and not particularly insightful; the goal is to demonstrate that blocking, a general mathematical utility in a mathematical code, can be used in a specific computational context with a small amount of general purpose connection code.

SymPy is able to block a large computation with the following general purpose commands.

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
~~~~~~~~~~~~~~~

We then compose this expression with a computational engine.  Below we translate this computation into a Theano graph and compile it to low-level code.  Note that this is the same operation as in Section \ref{sec:theano-kalman}.  At this stage the expresssions/computations are fairly complex and difficult to present.  Here is an image of the computation as a directed acyclic graph.  This image is not meant to be insightful, rather it is meant to demonstrate the complexity of the underlying programming task.  This would be a difficult operation to coordinate by hand.

~~~~~~~~~~~~~~~Python
fblocked = theano_function(inputs, collapsed_outputs, dtypes=dtypes)
~~~~~~~~~~~~~~~

\begin{figure}[htbp]
\centering
\includegraphics[width=.9\textwidth]{images/fblocked}
\label{fig:fblocked}
\end{figure}


### Numeric Results

We measure performance by timing the standard and blocked variants of the Kalman filter

~~~~~~~~~~~~~~~Python
>>> timeit f(*ninputs)
1 loops, best of 3: 2.69 s per loop

>>> timeit fblocked(*ninputs)
1 loops, best of 3: 2.12 s per loop
~~~~~~~~~~~~~~~

This performance increase is substantial in this case but dependent on many factors, notably the relationship between matrix size and memory hierarchy and the sequential BLAS implementation.  Other conditions such as with small matrices with generous memory conditions will not see such an improvement and may even see a performance degredation.  

Blocked matrix multiply and blocked solve routines have long been established as *a good idea*.  High level mathematical and array programming libraries like SymPy and Theano allow us to extend this good idea to *arbitrary* array computations composed of these operations.  Moreover, experimentation with this idea was simple, requiring only a few lines of high-level general purpose code rather than a new software project.

High-level modular systems with mathematical components enable experimentation.

Note that we have not introduced a new library for inter-operation blocked dense linear algebra.  Instead we compose pre-existing general purpose high-level tools to that effect.  Block matrix manipulations were not developed for this application.  They are a commonly occuring sub-problem that is useful to have around.


#### Multiple Backends

Our BLAS/LAPACK `computations` backend did not have the computational elements to perform this experiment.  However because the linear algebra component is separate from the computational backend we are not restricted by this failing.  Because we invested in interfaces we were able to trivially plug in a different backend that did have the necessary features.   A loose federation of components is less brittle than a monolithic system.  Components with access to multiple clients encourage comparison and  experimentation and overall accelerate software evolution.
