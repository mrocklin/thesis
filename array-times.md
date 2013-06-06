
Predicting Array Computation Times
----------------------------------

### Challenges

To create high performance task parallel programs at compile time we need to know the compute times of each task on each machine.  In general this is challenging.  

Compute times can depend strongly on the inputs (known only at runtime), other processes running on the hardware, behavior of the operating system, and potentially even the hardware itself.  Interactions with complex memory hierarchies introduce difficult-to-model durations.  Even if estimates of tasks are available the uncertainty may be sufficient to ruin the accuracy of the overall schedule.


### Array Programming is Easier

Fortunately, scheduling in the context of array operations in a high performance computing context mitigates several of these concerns.

Routines found in high performance libraries like BLAS/LAPACK are substantially more predictable.  Often the action of the routine depends only on the size of the input, not the contents.  Memory access patterns are often very regular and extend beyond the unpredictable lower levels of the cache.  Because this computation occurs in a high performance context there are relatively few other processes sharing resources and our task is given relatively high priority.


### Profiling Operations with `computations`

We introduce a high-level `Profile` operation that wraps existing operations within the `computations` package.  `Profile` wraps an operation's emitted Fortran code within `MPI_Wtime` timing blocks provided by the MPI library.  Implementations for `MPI_Wtime` are high resolution and generally well respected.  This provides a simple high-level way to generate accurate profiles.


### The Predictability of BLAS Operations

We build a computation to test the runtime of the popular `GEMM` operation.  In Figure \ref{fig:gemm-profile} we present a time series of runtimes for a $1000 \times 1000 \times 1000$ dense matrix multiply.  In Figure \ref{fig:gemm-hist} we plot a histogram of the same data.  We separate the data into two distributions.  Most of the data lies tightly distributed around a central peak with a standard deviation of a few percent.  There is also a small population of (a few percent) of long tail of durations up to 30% longer.  

\begin{figure}[htbp]
\centering
\includegraphics[width=.9\textwidth]{images/gemm-profile}
\label{fig:gemm-profile}
\caption{A time series of durations of $1000\times 1000 \times 1000$ dense matrix matrix multiplies using {\tt DGEMM}}
\end{figure}


\begin{figure}[htbp]
\centering
\includegraphics[width=.6\textwidth]{images/gemm-hist}
\label{fig:gemm-hist}
\caption{A histogram of durations of dense matrix matrix multiplies}
\end{figure}

#### Profiling Outside of the Python Runtime

The times above were run and timed entirely within a Fortran subroutine.  However they were called from within the Python runtime for convenience of data creation and plotting.  While convenient this environment also includes an active garbage collector.  Fortunately the generated subroutines can be run in isolation from the Python environment.  To see the impacts of these elements we run the fortran code in isolation and plot the results in Figures \ref{fig:gemm-profile-fortran}, \ref{fig:gemm-hist-fortran}. 

\begin{figure}[htbp]
\centering
\includegraphics[width=.9\textwidth]{images/gemm-profile-fortran}
\label{fig:gemm-profile-fortran}
\caption{A time series of durations taken in a quiet environment}
\end{figure}

\begin{figure}[htbp]
\centering
\includegraphics[width=.6\textwidth]{images/gemm-hist-fortran}
\label{fig:gemm-hist-fortran}
\caption{A histogram of durations taken in a quiet environment}
\end{figure}

We see that both the distribution has changed significantly.  More of the samples are clustered within the primary distribution (there are fewer outliers/spikes).  The central distribution is much more tightly packed, exhibiting a standard deviation of less than a percent.

These results still come from a laptop running a traditional operating system.  They can be further reduced.
