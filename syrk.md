
SYRK - Adding Computations
--------------------------

\label{sec:syrk}

The computation for linear regression can be further improved.  In particular the computation `X -> GEMM -> X'*X`, while correct, actually fits a special pattern; it is a symmetric rank-k update and can be replaced by `X -> SYRK -> X'*X`.  

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
  (alpha*A*A.T + beta*D, SYRK(alpha, A, beta, D),   True),
  (A*A.T,                SYRK(1.0, A, 0.0, 0),      True),
~~~~~~~~~

\begin{figure}[htbp]
\centering
\includegraphics[width=.9\textwidth]{images/hat-comp}
\end{figure}

\begin{figure}[htbp]
\centering
\includegraphics[width=.9\textwidth]{images/hat-comp-syrk}
\end{figure}


#### Numeric Result

This optimization is relevant within this application.  The `SYRK` computation generally consumes about 50% as much compute time as the equivalent `GEMM`.  It reads the input `X` only once and performs an symmetric multiply.  The computation of $X^TX$ consumes a significant fraction of the cost within this computation.

#### Development Result

This speedup was both found and implemented by a domain expert.  He was able to identify the flaw in the current implementation because the intermediate representations (DAG, Fortran code) were clear and natural to someone in his domain.  The code invited inspection.  After identification he was able to implement the correct computation (`class SYRK`).  The `computations` project for BLAS/LAPACK routines was simple enough for him to quickly engage and develop his contribution.  Finally he was able to formulate a pattern `(A*A.T,  SYRK(1.0, A, 0.0, 0), True)` into the compilation system so that his work could be automatically applied.  The declarative inputs of the compiler are sufficiently approachable to be used by developers without a background in automated program development.
