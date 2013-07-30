
Proof of Concept
----------------

\label{sec:scheduling-example}

We build a parallel code for the matrix expression `(A*B).I * (C*D)` for execution on a two node system.  The `conglomerate` project discussed in Chapter \ref{sec:voltron} transforms this expression into the computation shown in Figure \ref{fig:ABiCD}.

\begin{figure}[htbp]
\centering
\includegraphics[width=.5\textwidth]{images/ABiCD}
\caption{A simple computation for parallelization}
\label{fig:ABiCD}
\end{figure}

Our two node system consists of two workstation machines over a gigabit switch.  Profiling the network shows that connections can be well characterized by a latency of `2.7e-4s` and a bandwidth of `1.1e8 B/s`.  With inputs of random $2000 \times 2000$ matrices computation times are as follows

   Computation        Mean (s)        Standard Error (s)
-----------------   ----------      --------------------
    GEMM                  4.19                     0.017 
    GEMM                  4.19                     0.012
    GESV/LASWP            8.57                     0.038

Feeding this information into the integer programming static scheduler we obtain the computations in Figure \ref{fig:ABiCD-scheduled} with a total runtime of `13.03`.  Note that the graph has been split and asynchronous MPI computations have been injected to handle communication.  In particular the matrix multiplications are done in parallel and then collected onto a single node to perform the final general matrix solve `GESV/LASWP`.

\begin{figure}[htbp]
\centering
\includegraphics[width=.5\textwidth]{images/ABiCD_0}
\includegraphics[width=.3\textwidth]{images/ABiCD_1}
\caption{The computation from Fig. \ref{fig:ABiCD} scheduled onto two nodes}
\label{fig:ABiCD-scheduled}
\end{figure}

When we run this program ten times on our two-node system and record runtimes with mean `13.17` and standard error `0.017`.  This measurement is not different from the predicted time of `13.03`.  The error observed in both computation times and communication times is not sufficient to account for the discrepancy; clearly there exists some unaccounted factor.  Still, on a macroscopic level the runtime is sufficiently close to the predicted time to be useful operationally.  In any event the solution is significantly faster than the minimum sequential runtime of `16.95 s`.

This demonstrates the feasibility of an end-to-end solution from high-level matrix expressions to hardware-specific MPI code.

We include excerpts from the generated MPI code below

~~~~~~~~~~~~Fortran
include [MPI Excerpt](mpi-excerpt.f90)
~~~~~~~~~~~~
