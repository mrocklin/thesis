
Predicting Array Computation Times
----------------------------------

\label{sec:computation-times}

### Challenges

To create high performance task parallel programs at compile time we need to know the compute times of each task on each machine.  This is challenging in general. 

Compute times can depend strongly on the inputs (known only at runtime), other processes running on the hardware, behavior of the operating system, and potentially even the hardware itself.  Interactions with complex memory hierarchies introduce difficult-to-model durations.  Even if estimates of tasks are available the uncertainty may be sufficient to ruin the accuracy of the overall schedule.


### Array Programming is Easier

Fortunately, scheduling in the context of array operations in a high performance computing context mitigates several of these concerns.

Routines found in high performance libraries like BLAS/LAPACK are substantially more predictable.  Often the action of the routine depends only on the size of the input, not the contents.  Memory access patterns are often very regular and extend beyond the unpredictable lower levels of the cache.  Because this computation occurs in a high performance context there are relatively few other processes sharing resources and our task is given relatively high priority.


### The Predictability of BLAS Operations

We profile the runtime of the `DGEMM` operation.  We compute a $1000 \times 1000 \times 1000$ dense matrix multiply$ $1000$ times.  In Figure \ref{fig:gemm-profile-fortran} we present a time series and in Figure \ref{fig:gemm-hist-fortran} a histogram of the same data.  While runtimes are not deterministic we do find that a tight distribution around a central peak with variations less than a percent.  We also detect an outlier well outside of this distribution.  We believe that this is due to contention with other processes on the same system.


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

The context in which computations are run is relevant.  These times were computed on a notebook computer running a traditional operating system.  To study the effects of context we run this same computation within a Python environment.  Compute times are computed strictly within Fortran subroutines but the memory is managed by the Python runtime.  A time series and histogram are presented in Figures  \ref{fig:gemm-profile} and \ref{fig:gemm-hist}.  These times have the same central peak (the median value remains the same) but the distribution has widened in two ways.  First, there is a larger population of outliers that require around 30% more time.  Second, the central distribution is substantially wider with variations up to a few percent.

\begin{figure}[htbp]
\centering
\includegraphics[width=.9\textwidth]{images/gemm-profile}
\caption{A time series of durations taken in a noisy environment}
\label{fig:gemm-profile}
\end{figure}

\begin{figure}[htbp]
\centering
\includegraphics[width=.6\textwidth]{images/gemm-hist}
\caption{A histogram of durations taken in a noisy environment. {\it TODO: Merge this image with the previous one on the same axes}}
\label{fig:gemm-hist}
\end{figure}


Presumably by running this same computation on a high performance machine with a quiet operating system the uncertainty could be further reduced.


### Operational

We introduce a high-level `Profile` operation that wraps existing operations within the `computations` package.  `Profile` wraps an operation's emitted Fortran code within `MPI_Wtime` timing blocks provided by the MPI library.  Implementations for `MPI_Wtime` are high resolution and generally well respected within the computational community.  This provides a simple high-level way to generate code to provide accurate computation times.

We can use this `Profile` operation to transform a computation into a profiled computation

~~~~~~~~~~~Python
def profile(comp):
    """ Build a profiled version of ``comp``, a Computation 
    
    Returns a tuple of (computation, [inputs], [outputs])
    """
    # Wrap a ProfileMPI node around each sub-computation
    pcomp = CompositeComputation(*map(ProfileMPI, c.computations))

    # Desired inputs and outputs
    inputs = comp.inputs
    durations = [p.duration for p in pcomp.computations]
    outputs = comp.outputs + durations

    return pcomp, inputs, outputs
~~~~~~~~~~~

This computation can then be compiled and run with the expected numerical inputs.  It will return the duration of each task rather than the normal numerical outputs.  This computation can be run independently on each computational worker.
