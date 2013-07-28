Background
==========

\label{sec:background}

Scientific software engineering is a deep topic with broad scope and decades of
history.  Even a reasonably comprehensive coverage is well beyond the scope of
this document.  Instead we pick and describe a few particularly relevant subtopics.  

*   In Section \ref{sec:background-evolution} we give motivation for historical developments to make scientific computing accessible and to distribute work
*   In Section \ref{sec:nwp} we discuss numerical weather prediction as a representative of monolithic scientific software. 
*   In Section \ref{sec:background-nla} we discuss BLAS and LAPACK, widely reused static libraries for numerical linear algebra.
*   In Sections \ref{sec:numerics} and \ref{sec:trilinos} we discuss the BLAS/LAPACK/PETSc/FEniCS software stack and Trilinos as representatives of modern scientific software

include [Introduction](background-evolution.md)

include [Numerical Weather Prediction](nwp.md)

include [BLAS/LAPACK](background-nla.md)

include [BLAS-LAPACK-PETSc-FEniCS](numerics.md)

include [Trilinos](trilinos.md)
