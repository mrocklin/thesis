
BLAS/LAPACK
-----------

\label{sec:background-nla}

### Design

Computational science often relies on computationally intensive dense linear algebra operations.  This reliance is so pervasive that numerical linear algebra (NLA) libraries are among the most heavily optimized and studied algorithms in the field.  

An early pair of software packages, BLAS and LAPACK\cite{LAPACK}, were sufficiently pervasive to establish a long-standing standard interface between users and developers of dense numerical linear algebra libraries (DLA).  This particular set of algorithms has seen constant development over the last few decades due both to the importance of this problem and to the standard interface.

To optimize these operations fully the software solutions must be tightly coupled to hardware architecture.  In particular the design of most BLAS/LAPACK implementations tightly integrates a model for the memory architecture.  Because memory architectures continue to change, no long-standing solution has arisen and this field sees constant development.  In this sense it is a self-contained microcosm of the larger scientific software development problem.  The only difference is that the majority of practitioners in numerical linear algebra are highly trained experts.

include [BLAS/LAPACK](blas-lapack.md)

include [Parallel solutions](blas-lapack-implementations.md)
