
Blocked Kalman Filter
---------------------

\label{sec:blocking}


The addition of expertise to a single module may reverberate throughout the greater project.  In this example we investigate the added value of mathematical matrix blocking, known by SymPy, across the larger application. We continue to use the Kalman filter as an example computation and Theano as a backend.


#### Blocked Execution

If arrays are too large to fit comfortably in the fastest parts of the memory hierarchy then each sequential operation needs to move large chunks of memory in and out of cache during computation.  After one operation completes the next operation moves around the same memory while it performs its task.  This repeated memory shuffling impedes performance.

A common approach to reduce memory shuffling is to cut the computation into smaller blocks and then perform as many computations as possible on a single block before moving on.  This is a standard technique in matrix multiplication.  The multiplication of two $2 \times 2$ blocked matrices can be expanded using the same logic that one uses to multiply matrices of scalar expressions

$$ \begin{bmatrix} A & B \\\\ C & D \end{bmatrix} 
   \begin{bmatrix} E & F \\\\ G & K \end{bmatrix}
   \rightarrow
   \begin{bmatrix} A E + B G & A F + B K \\\\ 
                   C E + D G & C F + D K\end{bmatrix} $$

We are now able to focus on substantially smaller chunks of the array that fit more comfortably in memory allowing us to improve memory locality during execution.  For example we can choose to keep `A` in local memory and perform all computations that involve `A` (i.e. $AE$, $AF$) before releasing it permanently.  We will still need to shuffle some memory around (this need is inevitable) but by organizing with blocks we're able to shuffle less.  This idea extends beyond matrix multiplication.  Matrix inverse expressions can also be expanded. 

$$ \begin{bmatrix} A & B \\\\ C & D \end{bmatrix} ^{-1}
   \rightarrow
   \begin{bmatrix} 
\left(- B D^{-1} C + A\right)^{-1} & - A^{-1} B \left(- C A^{-1} B + D\right)^{-1} \\\\ 
- \left(- C A^{-1} B + D\right)^{-1} C A^{-1} & \left(- C A^{-1} B + D\right)^{-1}
\end{bmatrix} $$

High performance dense linear algebra libraries hard-code these tricks into individual routines.  The call to the general matrix multiply routine `GEMM` performs blocked matrix multiply within the call.  The call to the general matrix solve routine `GESV` can perform blocked matrix solve.  Unfortunately these routines are unable to coordinate blocked computation *between* calls.

Fortunately, SymPy can generate these high-level blocked matrix mathematical expressions at compile time and Theano can generate code for them.


#### General Code to Block the Kalman Filter

SymPy can define and reduce the blocked Kalman filter using matrix relations like those shown above for multiplication and inversion.  The listing below shows all the code necessary to block the Kalman filter into blocks of size `n/2`.  The code is dense and not particularly insightful but demonstrates that blocking, a general mathematical transformation can be transferred to a computational context with a small amount of general purpose glue code.  SymPy is able to block a large computation with general purpose commands.  No special computation-blocking library needs to be built.

The mathematical expression is then transformed to a computation with our traditional approach.  No new interface is required for the increase in mathematical complexity.  The two systems are well isolated.  We can translate the expression into a Theano graph and compile it to low-level code with the same process as in Section \ref{sec:theano}.  The resulting computation calls and organizes over a hundred operations; both the mathematics and the computation would be a difficult to coordinate by hand.


#### Numeric Results

We measure performance by timing the standard and blocked variants of the Kalman filter

~~~~~~~~~~~~~~~Python
>>> timeit f(*ninputs)
1 loops, best of 3: 2.69 s per loop

>>> timeit fblocked(*ninputs)
1 loops, best of 3: 2.12 s per loop
~~~~~~~~~~~~~~~

This performance increase is substantial in this case but dependent on many factors, most notably the relationship between matrix size and memory hierarchy and the sequential BLAS implementation.  Conditions such as with small matrices with generous memory conditions are unlikely to see such an improvement and may even see a performance degradation.

Blocked matrix multiply and blocked solve routines have long been established as a good idea.  High level mathematical and array programming libraries like SymPy and Theano allow us to extend this good idea to *arbitrary* array computations composed of these operations.  Moreover, experimentation with this idea is simple, requiring only a few lines of high-level general purpose code rather than a new software project.

High-level modular systems with mathematical components enable experimentation.  Note that we have not introduced a new library for interoperation blocked dense linear algebra.  Instead we compose pre-existing general purpose high-level tools to that effect.  Block matrix manipulations were not developed for this application but are instead a commonly occurring mathematical sub-problem that is useful to have around.


#### Multiple Backends

Because we invested in interfaces, we were able to trivially plug in a different backend.  This ability is critical for the comparison and evaluation of components instead of systems.  It also allows features to flow more smoothly between systems.  A loose federation of components is less brittle than a monolithic system.  Components with access to multiple clients encourage comparison, experimentation, and overall accelerate the evolution of scientific software.
