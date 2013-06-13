
Related Work
------------

\label{sec:math-num-linalg-background}

Both the broad applicability of this domain and the performance improvments from expert treatment have made it the target of substantial academic study and engineering efforts.

### Statically compiled libraries - BLAS/LAPACK

BLAS/LAPACK\cite{LAPACK} are two of the longest lived and most widely used libraries.  They are ubiquitous not only in scientific computing but in almost all compute-centric disciplines.  They were first developped in the 70s and remain in wide use today.

Several implementations exist.  Each implementation is developped by a separate group (with occasional collaborations) and backs an idea about computation.

#### Reference BLAS

is still available from the original source.  It has been updated to more modern coding styles and has automated translations into C.

#### Automatically Tuned Linear Algebra Software (ATLAS)

benchmarks and several possible implementations on an architecture before installation.  ATLAS \cite{ATLAS} is able to intelligently select block sizes to fit memory hierarchy and even selects between different available execution paths with LAPACK.  ATLAS was the first successful use of automated methods in widespread use.

#### GOTO BLAS

is developped by a single man (Kazushige Goto) who hand-tunes the generated assembly for particular architectures.  GOTO BLAS\cite{Goto2008} is frequently among the fastest implementations available, routinely beating vendor supplied implementations.  This is an example of a single expert in low-level computation and memory hierarchy distributing expertise through software.

#### Formal Linear Algebra Methodology Environment (FLAME) 

provides a language for the idiomatic expression of blocked matrix computations.  FLAME\cite{Geijn2008} lowers the barriers to design novel matrix algorithms and provides some automated reasoning capabilities.  Using these methods FLAME is able to more exhaustively search the space of possible algorithms when creating a BLAS/LAPACK library.   

The FLAME group collaborates with Goto in an effort to automate and more broadly apply expertise

#### ScaLAPACK

is an implementation of LAPACK for distributed memory architecture.  ScaLAPACK\cite{ScaLAPACK} depends on BLACS\cite{Dongarra1997}, a library for the communication of blocks of memory, to coordinate computation of linear algebra routines across a parallel architecture.  ScaLAPACK was the first major parallel implementation

#### Parallel Linear Algebra for Scalable Multi-core Architectures (PLASMA)

is a more modern approach to the parallel linear algebra problem and the natural successor to ScaLAPACK.  It uses dynamic scheduling techniques to communicate tiles in a shared memory architecture.  PLASMA is actively developped to support distributed memory\cite{Bosilca2011}.

#### Matrix Algebra on GPU and Multicore Architectures (MAGMA)

is co-developped alongside PLASMA to support heterogeneous architectures with thought to their eventual merger\cite{Agullo2009a}


### Symbolic Linear Algebra

BLAS/LAPACK, FLAME, PLASMA, and MAGMA all build custom treatments of linear algebra in order to create high performance libraries.  It is necessary to reason about linear algebra in order to produce an efficient codebase.  Each codebase encodes a substantial amount of linear algebra either directly in calls to subroutines or within some automated reasoning knowledgebase

*   LAPACK knows that results from POTRF are triangular and can be used with POTRS
*   The parallel systems (ScaLAPACK, PLASMA, MAGMA) each encode how to block a matrix multiply or solve so that they can distribute the work
*   FLAME tracks loop invariants across computation steps

Unfortunately there is duplication and an inability to share the intermediate logic with other projects.  This abstract/symbolic knowledge has not been well described in any isolated and reusable symbolic system.

Full featured computer algebra systems like Mathematica and Maple traditionally support explicitly defined matrices where each element is a scalar expression. 

$$ \left[\begin{smallmatrix}\cos{\left (\theta \right )} & - \sin{\left (\theta \right )}\\\sin{\left (\theta \right )} & \cos{\left (\theta \right )}\end{smallmatrix}\right] $$ 

Given such a matrix of symbolic elements they are able to perform matrix multiplies, solves, or compute whether that particular matrix is symmetric, orthogonal, etc....  However these systems are unable to discuss matrix algebra abstractly, reasoning about "a symmetric n by n matrix" without explicitly specifying its elements.

However there are add-ons for Mathematica, notably xAct, which solve variations.  xAct\cite{xact} defines and reasons about tensor expressions in a purely abstract and geometrical (coordinate free) manner.  This approach is in the same vein as SymPy.Matrix.Expressions but in a different application.

Several treatments of matrix computations exist as libraries for Coq, an automated theorem prover.
