
Background - Numeric Linear Algebra
===================================

\label{sec:background-nla}

Introduction
------------

This dissertation studies modular scientific software development.  It uses numerical linear algebra as a case study. 

Computational science often relies on compute-intensive dense linear algebra operations.  This reliance is so pervasive that numerical linear algebra (NLA) libraries are among the most heavily optimized and studied algorithms in the field.  

An early pair of libraries, BLAS and LAPACK, were sufficiently pervasive to establish a long-standing standard interface between users and developers of dense numerical linear algebra libraries (DLA).  Due both to the massive importance of this problem and the standard interface this particular set of algorithms seen a constant development over the last few decades.

To fully optimize these operations the software solutions must be tightly coupled to hardware architecture.  In particular most implementations are coupled on a model for the memory architecture.  Because memory architectures continue to change no long-standing solution has arisen to this problem and this field sees constant development.  In this sense it is a self-contained microcosm of the larger scientific software development problem.  The only difference is that the majority of practitioners in this field are well trained experts.

include [BLAS/LAPACK](blas-lapack.md)

include [Parallel solutions](blas-lapack-implementations.md)
