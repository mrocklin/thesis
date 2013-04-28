
Adding Computations
-------------------

\label{sec:syrk}

The computation for linear regression can be improved.  In particular the computation `X -> GEMM -> X'*X`, while correct, actually fits a special pattern; it is a symmetric rank-k update and can be replaced by `X -> SYRK -> X'*X`.  

This was discovered by a scientific programmer with extensive familiarity with BLAS/LAPACK.  He was able to correct this inefficiency by adding an additional computation

~~~~~~~~~Python
class SYRK(BLAS):
    """ Symmetric Rank-K Update `alpha X' X + beta Y' """
    _inputs  = (alpha, A, beta, D)
    _outputs = (alpha * A * A.T + beta * D,)
    inplace  = {0: 3}
    fortran_template =  ...
~~~~~~~~~

And by adding the relevant patterns 

~~~~~~~~~Python
  (alpha*A*A.T + beta*D, SYRK(alpha, A, beta, D), [alpha, A, beta, D], True),
  (A*A.T,                SYRK(1.0, A, 0.0, 0),    [A],                 True),
~~~~~~~~~

This resulted in a 50% speedup in the `X -> X'*X` computation and a 9% speedup overall. 

\begin{figure}[htbp]
\centering
\includegraphics[width=.9\textwidth]{images/hat-comp}
\end{figure}

    Elapsed time with GEMM = 0.43399999 
    
\begin{figure}[htbp]
\centering
\includegraphics[width=.9\textwidth]{images/hat-comp-syrk}
\end{figure}

    Elapsed time with SYRK = 0.39500001 

There are two results in the above experiment.  First, there is a numeric speedup of a common algorithm.  Second, this speedup was found and implemented only because we were able to engage a domain expert and because that domain expert was able to contribute to the codebase.  The intermediate representations were clear in his domain and his code contribution was isolated to a section that did not require expertise outside of his experience.
