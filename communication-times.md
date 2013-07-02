
Predicting Communication Times
------------------------------

\label{sec:communication-times}

In Section \ref{sec:computation-times} we analyzed the predictability of computations on conventional hardware.  We found that array computations on large data sets were generally predictable to an accuracy of one percent.  In this section we perform a similar analysis on communication within a network.  We find a similar result that communication times of bulk data transfer are fairly predictable within a local network.


### Experiment

We write an MPI computation to transfer arrays between two processes.  We profile this computation, generate and run this code on two nodes within a conventional cluster on a wide range of data sizes.  We plot the relationship between data size and communication time in Figure \ref{fig:communication-time}.  We measure both the duration of the `MPI_Send` and `MPI_Recv` calls for data sizes ranging logarithmically from one eight byte word to $10^7$ words.  We time each size coordinate multiple times to obtain an estimate of the variance.  

\begin{figure}[htbp]
\centering
\includegraphics[width=.45\textwidth]{images/communication-time}
\includegraphics[width=.45\textwidth]{images/communication-variation}
\caption{Communication time between two points in a cluster}
\label{fig:communication-time}
\end{figure}

### Analysis

The image demonstrates that there is clear polynomial relationship above a few thousand bytes.  Further inspection reveals that this relationship is linear, as is expected by a simple latency/bandwidth model.  Below this size the linear model breaks down.  Uncertainty varies with size but decreases steadily after a few thousand bytes to within a few percent. 

We conclude that for this architecture communication times are both predictable and modelable above a few thousand bytes, at least for the sensitivity required for our applications.

We note that this is for a particular communication architecture and a particular implementation of MPI.  Our test cluster is a shared commodity cluster.  We expect that results in a high performance setting would not be less predictable.
