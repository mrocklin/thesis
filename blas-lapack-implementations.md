
## Implementations

The BLAS/LAPACK\cite{LAPACK} interface has multiple implementations.  These stress a variety of techniques.  We list them both as a review of past work but also to demonstrate the wealth of techniques used to accelerate this set of operations.


#### Reference BLAS

is still available from the original source.  It has been updated to more modern coding styles and has automated translations into C.


#### Automatically Tuned Linear Algebra Software (ATLAS)

benchmarks and several possible implementations on an architecture before installation.  ATLAS \cite{ATLAS} is able to intelligently select block sizes to fit memory hierarchy and even selects between different available execution paths with LAPACK.  ATLAS was the first successful use of automated methods in widespread use.


#### GOTO BLAS

is developped by a single man (Kazushige Goto) who hand-tunes the generated assembly for particular architectures.  GOTO BLAS\cite{Goto2008} is frequently among the fastest implementations available, routinely beating vendor supplied implementations.  This is an example of a single expert in low-level computation and memory hierarchy distributing expertise through software.


#### Formal Linear Algebra Methodology Environment (FLAME) 

provides a language for the idiomatic expression of blocked matrix computations.  FLAME\cite{Geijn2008} lowers the barriers to design novel matrix algorithms and provides some automated reasoning capabilities.  Using these methods FLAME is able to more exhaustively search the space of possible algorithms when creating a BLAS/LAPACK library.   

The FLAME group collaborates with Goto in an effort to automate and more broadly apply expertise


#### MKL

The Microsoft Kernel Library is an industry standard.  It is a professional multi-core implementation.


#### ScaLAPACK

is an implementation of LAPACK for distributed memory architecture.  ScaLAPACK\cite{ScaLAPACK} depends on BLACS\cite{Dongarra1997}, a library for the communication of blocks of memory, to coordinate computation of linear algebra routines across a parallel architecture.  ScaLAPACK was the first major parallel implementation


#### Parallel Linear Algebra for Scalable Multi-core Architectures (PLASMA)

is a more modern approach to the parallel linear algebra problem and the natural successor to ScaLAPACK.  It uses dynamic scheduling techniques to communicate tiles in a shared memory architecture.  PLASMA is actively developped to support distributed memory\cite{Bosilca2011}.


#### Matrix Algebra on GPU and Multicore Architectures (MAGMA)

is co-developped alongside PLASMA to support heterogeneous architectures with thought to their eventual merger\cite{Agullo2009a}
