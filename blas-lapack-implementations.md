
### Implementations

The BLAS/LAPACK interface has multiple implementations.  These stress a variety of techniques.  We list them both as a review of past work and also to demonstrate the wealth of techniques used to accelerate this set of important operations.

#### Reference BLAS

A standard implementation of BLAS remains available in both Fortran and C.  It implements the subroutines in a decent and human understandable manner.


#### Automatically Tuned Linear Algebra Software (ATLAS)

The ATLAS system benchmarks several possible implementations with different block-size parameters on an architecture before installation.  ATLAS \cite{ATLAS} is able to intelligently select block sizes to fit the memory hierarchy and even selects between different available execution paths with LAPACK.  ATLAS was the first successful use of automated methods in this domain and remains in widespread use.  It is the commonly installed software solution on standard Linux distributions.


#### GOTO BLAS

Instead of searching a parameter space the BLAS can be optimized by hand.  Kazushige Goto, a single developer, hand-tunes the generated assembly of BLAS for particular architectures.  GOTO BLAS\cite{Goto2008} is frequently among the fastest implementations available, routinely beating vendor supplied implementations.  This implementation is an example of a single expert in low-level computation and memory hierarchy distributing expertise through software.


#### Formal Linear Algebra Methodology Environment (FLAME) 

The FLAME project provides a language for the idiomatic expression of blocked matrix computations.  FLAME\cite{Geijn2008} lowers barriers to designing novel matrix algorithms and provides some automated reasoning capabilities.  Using these methods FLAME is able to search the space of possible algorithms when creating a BLAS/LAPACK library.

The FLAME group collaborates with Kazushige Goto in an effort to automate and more broadly apply expertise


#### Math Kernel Library (MKL)

The MKL is an industry standard.  It is a professional implementation for multi-core Intel processors.


#### Distributed Memory BLAS/LAPACK Implementations

The ubiquity of numerical linear algebra makes it an attractive candidate for mature parallel solutions.  All computational kernels expressible as BLAS/LAPACK computations may be automatically parallelized if a robust solution can be found for distributed numerical linear algebra.  Much of this work exists for sparse systems that are not part of the BLAS/LAPACK system.  See notes on PETSc and Trilinos in \ref{sec:numerics} and \ref{sec:trilinos} for more details.

In the case of dense linear algebra, data parallelism is most often achieved through blocking.  Input arrays are blocked or tiled and then each operation distributes computation by managing sequential operations on blocks on different processors.  A distributed GEMM may be achieved through many smaller sequential GEMMs on computational nodes.  More sophisticated computations, like SYMM or POSV, may make use of a variety of sequential operations.

Occasionally communication is handled by a separate abstraction.  For performance reasons these are often built off of or resemble MPI at a low level.


#### ScaLAPACK

is the original widespread implementation of LAPACK for distributed memory architecture.  ScaLAPACK\cite{ScaLAPACK} depends on BLACS\cite{Dongarra1997}, a library for the communication of blocks of memory, to coordinate computation of linear algebra routines across a parallel architecture.  ScaLAPACK was the first major parallel implementation

#### Parallel Linear Algebra for Scalable Multi-core Architectures (PLASMA)

is a more modern approach to the parallel linear algebra problem and the natural successor to ScaLAPACK.  It uses dynamic scheduling techniques to communicate tiles in a shared memory architecture.  PLASMA is actively developed to support distributed memory\cite{Bosilca2011}.

#### DPLASMA

The distributed memory variant of Plasma, depends on DAGuE\cite{Bosilca2012}, a "hardware aware" dynamic scheduler to manage its tile distribution.

#### Elemental

Elemental\cite{Poulson2010} forks FLAME to handle distributed memory parallelism.  Elemental breaks the fundamental model of fixed blocks/tiles, instead employing a more dynamic scheduler.


#### Matrix Algebra on GPU and Multicore Architectures (MAGMA)

is co-developed alongside PLASMA to support heterogeneous architectures with thought to their eventual merger\cite{Agullo2009}.

#### Analysis

The development history of BLAS/LAPACK closely mirrors the development history of computational hardware; hardware developments are closely followed by new BLAS/LAPACK implementations.  We can expect BLAS/LAPACK development to continue aggressively into the future.  This is particularly true as architecture development seems to have entered an age of experimentation as the need to ameliorate the effort of the power wall spurs the growth of parallel architectures; BLAS/LAPACK development seem to follow suit with a focus on distributing and scheduling tiled computations.

Robust BLAS/LAPACK implementations lag hardware development by several years.  This lag propagates to scientific codes because so many link to BLAS/LAPACK libraries.  Accelerating development and introducing hardware flexibility can meaningfully advance performance on mainstream scientific codes.
