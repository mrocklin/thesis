
Proof of Concept
----------------

\label{sec:scheduling-example}

To show how schedulers interoperate with our existing compilation chain we walk through a simple example.  We build a parallel code for the matrix expression `(A*B).I * (C*D)` for execution on a two node system.  The `conglomerate` project discussed in Chapter \ref{sec:voltron} transforms this expression into the computation shown in Figure \ref{fig:ABiCD}.

\begin{figure}[htbp]
\centering
\includegraphics[width=.5\textwidth]{images/ABiCD}
\caption{A simple computation for parallelization}
\label{fig:ABiCD}
\end{figure}

Our two node system consists of two workstations (Intel Core i7-3770 with 8GB memory ) over a gigabit switch.  Profiling the network shows that connections can be well characterized by a latency of $270\mu s$ and a bandwidth of `1.1e8 Bytes/s`.  With inputs of random $2000 \times 2000$ matrices computation times are as follows

   Computation        Mean (s)        Standard Error (s)
-----------------   ----------      --------------------
    GEMM                  4.19                     0.017 
    GEMM                  4.19                     0.012
    GESV/LASWP            8.57                     0.038

Feeding this information into either of our static schedulers (they produce identical results) we obtain the computations in Figure \ref{fig:ABiCD-scheduled} with a total runtime of `13.03` seconds.  Note that the graph has been split and asynchronous MPI computations have been injected to handle communication.  In particular the matrix multiplications are done in parallel and then collected onto a single node to perform the final general matrix solve `GESV/LASWP`.

\newpage
\begin{figure}[htbp]
\centering
\includegraphics[width=\textwidth]{images/ABiCD_0}
\includegraphics[width=.7\textwidth]{images/ABiCD_1}
\caption{The computation from Fig. \ref{fig:ABiCD} scheduled onto two nodes}
\label{fig:ABiCD-scheduled}
\end{figure}

Re ran this program ten times on our two-node system and recordd runtimes with mean of `13.17` and standard error of `0.017`.  This measurement is not different from the predicted time of `13.03`.  The error observed in both computation times and communication times is not sufficient to account for the discrepancy; clearly there exists some unaccounted factor.  Still, on a macroscopic level the runtime is sufficiently close to the predicted time to be useful operationally.  This speed-up demonstrates the feasibility of an end-to-end solution from high-level matrix expressions to hardware-specific MPI code.
