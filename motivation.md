
Historical Motivation
=====================

\label{sec:motivation}

We argue for the adoption of software engineering principles by calling on both pathological and positive examples from existing scientific software projects.  

In Section \ref{sec:nwp} we investigate a large monolithic meteorological code.  In Section \ref{sec:numerics} we investigate the vertical `BLAS/LAPACK/PETSc/FEniCS` software stack.  In \ref{sec:uq-methods} we present a simple research problem that is difficult to pursue because of the lack of high-level software tools.  In Section \ref{sec:package-managers} we attempt to quantitatively demonstrate the value of loosely coupled highly cohesive software packages.

include [Numerical Weather Prediction](nwp.md)
include [Trilinos/PETSc/FEniCS](numerics.md)
include [Uncertainty Propagation](uq-methods.md)
include [PyPi, CRAN, clojars](package-managers.md) -- not yet written

Analysis
--------

High-level software organization has a profound and potentially debilitating impact on future development.  As we enter an era of increasing development challenges we should consider both the results from our numeric software and its potential integration into the future development and hardware contexts.

We found that we should separate the slowly changing ideas embedded in our code (like physics or high-level array computations) from rapidly changing elements like dependence on a certain memory hierarchy or low-level programming model.  This will allow socially important codes to survive changes in computational hardware.  We described the difference between vertical vs embarassing modularity.

We also described a more subtle flaw, that of Russian Doll or hierarchical modularity where high-level packages correctly depend on lower-level ones for the majority of their computational core but overly specialize their interface to that module.  This generates an unnecessary inflexibility to interoperate with other similar lower-level modules thus limiting both the higher-level projects applicability and reuse.

The lack of reusable and composable high-level transformations limits scientific development.  A number of problems exist, such as that found in \ref{sec:uq-methods}, which are primarily limited not by insight, but by development ability.

Historical approaches to scientific software organization can limit social progress.
