
Introduction
------------

In Section \ref{sec:cas} we described a computer algebra system to express and manipulate mathematical expressions at a high, symbolic level.  In Section \ref{sec:matrix-language} we specialized this to matrix expressions.  This symbolic work is not appropriate for numeric computation.  In this section we describe numeric routines for computation of matrix subproblems, in particular the BLAS/LAPACK routines.  In section \ref{sec:computations-software} we present a package for the high-level description of these routines using SymPy matrix expressions and the subsequent generation of Fortran code.  Later in Section \ref{sec:matrix-compilation} we use logic programming to connect these two to build an automated system.

We primarily target modern Fortran code that calls down to the curated BLAS/LAPACK libraries described in Section \ref{sec:blas-lapack}.  These libraries have old and unstructured interfaces that are difficult to target with high-level automated systems.  In this chapter we build a high-level description of these computations as an intermediary.  We use SymPy matrix expressions to assist with this high level description.  This system is extensible to support other low-level libraries.  We believe that its separation makes it broadly applicable to applications beyond our own.

Specifically we present a small library to encode low-level computational routines that is amenable to manipulation by automated high-level tools.  This library is extensible and broadly applicable.  This library also supports low level code generation.
