
Introduction
============

Scientists increasingly use computation.

*   This has proven valuable.  It's growing rapidly.
*   However scientists are not trained in software engineering
    -   So this activity is an inefficient use of their time
    -   The resulting software ecosystem is inefficient.  It doesn't select and 
        distribute the best solutions.  It doesn't adapt well to today's 
        changing hardware

Describe existing scientific software from the perspective of software engineering.

*   State the demographics of both the types of problems to be solved and the skillset of scientific workforce.  [Expertise](expertise.md)
*   State software engineering values of modularity, coupling and cohesion and explain why pathological cases limit software evolution.  [Software Principles](principles.md) -- not written
*   Analyze existing scientific software under this lens
    -   Anecdotal case studies
        *   [Numerical Weather Prediction](nwp.md) - An example of monolithic Fortran.  In particular we focus on duplicated efforts and an inability to adapt to GPU hardware.
        *   [Trilinos/PETSc/FEniCS](numerics.md) - These projects exhibit a hierarchical or "Russian Doll" approach to modularity, coupling high-level expertise (e.g. PDEs) to lower-level implementations.  They have proven far more effective than monolithic designs but, we argue, are not yet optimlal.
        *   [Uncertainty Propagation](uq-methods.md) - The lack of high-level hardware agnostic tools slows development, particularly when new hardware changes the algorithm landscape.
    -   Quantitatve study of dependencies in software package managers.  Apply the tools of complex networks analysis to existing package dependencies.
        *   [PyPi, CRAN, clojars](package-managers.md) -- not yet written

    These analyses show that while low-level software is well modularized and loosely coupled, high and intermediate-level modules are often tightly coupled to specific lower-level implementations, limiting efficient selection and distribution at this level.  This causes fragmentation and slower software evolution.

*   This provides our major argument

    *The computational science community should construct
     loosely coupled, cohesive, intermediate-level packages*

*   Finally note that mathematical experts often lack training to produce such packages. 


include [Expertise](expertise.md)
include [Software Principles](principles.md) -- not written
