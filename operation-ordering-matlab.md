
### Operation Ordering in Matlab

\label{sec:operation-ordering-matlab}

Taken from [http://matthewrocklin.com/blog/work/2013/02/26/MatLabOrdering/](http://matthewrocklin.com/blog/work/2013/02/26/MatLabOrdering/)

Consider the following MatLab code

    >> x = ones(10000, 1);
    >> tic; (x*x')*x; toc
    Elapsed time is 0.337711 seconds.
    >> tic; x*(x'*x); toc
    Elapsed time is 0.000956 seconds.

Depending on where the parentheses are placed one either creates `x*x'`, a large 10000 by 10000 rank 1 matrix, or `x'*x`, a 1 by 1 rank 1 matrix.  Either way the result is the same.  The difference in runtimes however spans several orders of magnitude.

Graphically the operation looks something like the following

\begin{figure}[htbp]
\centering
\includegraphics[width=.4\textwidth]{images/xxtrans}
\end{figure}

This is a common lesson that the order of matrix operations matters.  Do computers know this lesson?  It is difficult to implement this optimization in a C or Fortran compiler.  The compiler would have to identify patterns in sets of nested for loops to realize the higher-level implication.  A hosted library like `numpy` in Python is also unlikely to make this optimization; operation ordering is determined by the Python language, not by the numeric library.  With MatLab it is uncertain.  MatLab is interpreted and so generally doesn't compile.  However it can inspect each line before execution.

Unfortunately Matlab does not perform this optimization.
    
    >> tic; x*x'*x; toc
    Elapsed time is 0.317499 seconds.

#### Analysis

At the high array programming level this optimization is straightforward.  It is a common homework assignment in introductory algorithms courses involving dynamic programming.  A small amount of pre-execution logic can provide orders of magnitude in savings.

This is a single example of a family of optimizations that can be made at the array programming level.  These optimizations are well known to numerical analysts but are still uncommonly implemented in practice.  We present a project that attempts to encode this expert knowledge within an automated compiler system.
