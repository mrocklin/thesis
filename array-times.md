
Predicting Array Computation Times
----------------------------------

\label{sec:computation-times}

#### Challenges

To create high performance task parallel programs at compile time we need to know the compute times of each task on each machine.  This task is challenging in general. 

Compute times can depend strongly on the inputs (known only at runtime), other processes running on the hardware, behavior of the operating system, and potentially even the hardware itself.  Interactions with complex memory hierarchies introduce difficult-to-model durations.  Even if estimates of tasks are available the uncertainty may be sufficient to ruin the accuracy of the overall schedule.


#### Array Programming is Easier

Fortunately, scheduling in the context of array operations in a high performance computing context mitigates several of these concerns.  Routines found in high performance libraries like BLAS/LAPACK are substantially more predictable.  Often the action of the routine depends only on the size of the input, not the contents.  Memory access patterns are often very regular and extend beyond the unpredictable lower levels of the cache.  Because this computation occurs in a high performance context there are relatively few other processes sharing resources and our task is given relatively high priority.


#### The Predictability of BLAS Operations

We profile the runtime of the `DGEMM` operation.  We compute a $1000 \times 1000 \times 1000$ dense matrix multiply $1000$ times on a workstation with an Intel i5-3320M running `OpenBLAS`.  In Figure \ref{fig:gemm-profile-fortran} we present a time series and in Figure \ref{fig:gemm-hist-fortran} a histogram of the same data.  While runtimes are not deterministic we do find that a tight distribution around a central peak with variations less than a percent. 


\begin{figure}[htbp]
\centering
\includegraphics[width=.9\textwidth]{images/gemm-profile-fortran}
\caption{A time series of durations of $1000\times 1000 \times 1000$ dense matrix matrix multiplies using {\tt DGEMM}}
\label{fig:gemm-profile-fortran}
\end{figure}

\begin{figure}[htbp]
\centering
\includegraphics[width=.6\textwidth]{images/gemm-hist-fortran}
\caption{A histogram of durations of dense matrix matrix multiplies}
\label{fig:gemm-hist-fortran}
\end{figure}

The context in which computations are run is relevant.  These times were computed on a workstation running a traditional operating system.  To study the effects of runtime context we run this same computation within a Python environment.  Compute times are computed strictly within Fortran subroutines but the memory is managed by the Python runtime.  A time series and histogram are presented in Figures  \ref{fig:gemm-profile} and \ref{fig:gemm-hist}.  These times have a marginally shifted central peak (the median value remains similar) but the distribution has widened in two ways.  First, there is a larger population of outliers that require around substantially more time.  Second, the central distribution is substantially wider with variations up to a few percent.

\begin{figure}[htbp]
\centering
\includegraphics[width=.9\textwidth]{images/gemm-profile-both}
\caption{A time series of durations taken in a noisy environment}
\label{fig:gemm-profile}
\end{figure}

\begin{figure}[htbp]
\centering
\includegraphics[width=.6\textwidth]{images/gemm-hist-both}
\caption{A histogram of durations taken in a noisy environment.}
\label{fig:gemm-hist}
\end{figure}


Presumably by running this same computation on a high performance machine with a quiet operating system the uncertainty could be further reduced.


#### Dynamic Routines

These results on `GEMM` are representative of most but not all BLAS/LAPACK routines.  Some routines, like `GESV` for general matrix solve do perform dynamic checks at runtime on the content of the array.  In special cases, such as when the solving matrix is the identity, different execution paths are taken, drastically changing the execution time.  Ideally such conditions are avoided beforehand at the mathematical level; if a matrix is known ahead-of-time to be the identity then SymPy should be able to reduce it before a `GESV` is ever generated.  If this information is not known ahead of time then schedules may be invalid.  In general we test with random matrices as they are, for most operations, representative of the general/worst case.  Even this assumption breaks down under iterative methods like conjugate gradient solution, for which this approach is invalid.
