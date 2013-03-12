
# TODO: Purely positive tone

Scientific Software 
-------------------

Modern science relies on computation.  The insight gained from scientific simulations and data analysis have elevated along theory and experiment as the "third pillar of science."  An increasing number of research scientists approach their problems with computers.  Their solutions range from small data analysis scripts in wet-labs to large multidisciplinary high performance codes.  Due to the novelty of scientific research these programs are often custom built and encode a great deal of specialized scientific expertise.

The average scientific researcher is not trained as a software engineer.  As a result the cost of building performant scientific codes is high, requiring many hours of labor from highly specialized workers.  Because scientists are rarely incentivized to produce generally applicable code that spans domains their work is rarely reusable, greatly diminishing its social value.  High performance standards, a tradition of monolithic non-reusable solutions, and sparse training creates a situation where highly trained research scientists spend much of their time overcoming difficult tasks for which they are ill-suited.  Society loses productive hours from some of its most highly trained members.

The rise of multidisciplinary science and heterogeneous hardware compounds this problem.  A single scientific project may require expertise from several scientific, mathematical, and computational domains.  Performance requirements may constrain solutions to high quality approaches within each domain, requiring monolithic software developers to develop substantial expertise far outside of their original field of training.  Scientists spend less time doing science and more time learning and practicing foreign skills.  Monolithic scientific software ecosystems do not scale well and present substantial opportunities for efficiency gains.


Modularity
----------

Software design principles advocate modular and composable design.

Modularity encourages the separation of code into multiple distinct pieces.  Ideally these pieces are *atomic*, meaning that they are split as finely as meaningfully possible, each encoding exactly one area of expertise.  Composability encourages the development of standard interfaces to enable the independent connection of these pieces to form larger programs.

Modular and composable software possess the following virtues

*   Code is simpler to inspect and verify
*   Expert solutions can be more easily written in isolation 
*   A limited context encourages code reuse and ensures longer-term applicability
*   Collaborative efforts require less communication
*   Pluggability of alternative algorithms encourages experimentation and evolution

Modular and composable software possesses the following vices
    
*   It requires ahead-of-time coordination on interfaces
*   Information between pieces must propagate through a restrictive interface
*   A critical mass of components must be developped before end-to-end solutions are feasible

In a scientific context modular design encourages growth and reuse at the cost of tight integration between domains.  Historically scientific computing was a practice of a few highly trained numerical analysts who pushed maximum performance out of specialized hardware.  In this context modular design inhibits high level information from influencing low-level design decisions, substantially limiting performance.  High performance remains a priority today but the problems and hardware have both grown in complexity and the distribution of skills of scientific programmers has broadened substantialy.  As the problem size exceeds the capacity of individual researchers the benefits of modular design begin to outweigh the performance drawbacks.

*Trends towards multidisciplinary solutions and heterogeneous architecture motivate the increased use of modularity and composability in scientific software.  Substantial unclaimed efficiencies exist in both programmer and execution time across a wide range of problem scales.*

The Existing Scientific Software Stack
--------------------------------------

Traditional solutions to modularity include libraries, domain specific languages, and compilers.  These allow the work of a few expert developers to affect a broad base of domain scientists.  However as variety among hardware increases these solutions sometimes fail to adapt.  As projects become more interdisciplinary these solutions sometimes fail to interoperate.  The rising importance of interdisciplinary work and a rapidly changing hardware landscape pressure us to refactor our current ecosystem.

### Libraries

*Example: BLAS/LAPACK*

High performance libraries like BLAS/LAPACK and PETSc provide a set of performant functions for numeric computing within a general purpose programming language.  As the numerics community develops novel methods the implementations of these libraries may be modified while maintaining a consistent interface for downstream users.  This buffering effect may break down under large changes in mathematical methods or hardware architecture.  Library developers may be pressured to change their interface by adding, deprecating or modifying funciton headers.  These inconsistencies cause friction and a lack of confidence downstream.

Well established and dependable interfaces like BLAS/LAPACK are valuable.  Confidence in the interface promotes synergistic development on both sides.  The original implementation has been modified and even completely reimplemented by several groups using a variety of disparate techniques (hand-tuning, automated-tuning, distributed computation).  Users of the interface can pick and choose their implementation and be relatively secure that they will be well supported into the future.  As new hardware comes online (e.g. GPGPU) that hardware community rapidly develops a BLAS/LAPACK implementation (cuBLAS/CULA/MAGMA) so their hardware is immediately relevant to existing scientific problems.

Libraries like BLAS/LAPACK form an excellent high-level interface to low-level computational hardware.  However libraries generally only target the lowest level of the stack of computational abstractions.  Some domains in scientific computing are purely high-level.  Compiled libraries are not appropriate for these situations.

### Domain Specific Languages 

*Example: FEniCS*

Domain Specific Languages traditionally form very high level interfaces appropriate for scientific users.  They are often associated to compilers that encode knowledge from the domain and transform the high-level input to some lower-level language.  For example projects like FEniCS transform a very high level description of partial differential equations (PDEs) into performant low-level C++ code suitable for execution on distributed hardware. This approach has the following benefits

*   Domain specific simplification may be encoded into the compiler
*   Domain specific languages may be specialized to the target audience, increasing accessibility to communities unfamiliar with performant general purpose languages.
*   DSLs are traditionally more complete end-to-end packages

In the context of this thesis traditional DSLs exhibit the following design flaws.  

*   They are specific to a single community of end-users
*   Their inputs are often terminal in design, intended for use by humans but not for composition with other packages
*   They often specify a fixed set of computational steps
*   Their construction requires domain experts capable of language design

This combination limits the long term utility of traditional DSLs.  Explicit dependence on multiple stages of computation exposes them to changes in computational methods/architecture.  The specialization to a small community reduces the developer base available to adapt the code.  

### Middle Languages

*Example: Matrix Algebra*

While libraries traditionally target low-level architecture and DSLs traditionally source from high-level descriptions there is little development of isolated packages that strictly operate as intermediaries.  Yet many broadly applicable domains of expertise lie below domain science and above hardware.  

For example symbolic matrix algebra is a mathematical domain used by *several* high-level scientific domains and is influential in many different computational methods.  Matrix algebra has a clean theory amenable to a automation yet is reimplmeneted by a substantial fraction of scientific packages.

Include scicomp.stackexchange example?


### Side Transformations

*Example: Automatic Differentiation*

The top-down view of a sequence of transformations from high to low level is incomplete.  Domains like statistical uncertainty, differentiation, and distributed computing all provide transformations that start and end within the intermediate representation. 

Automatic differentiation (AD) has found tremendous use in the computational community specifically due to its composability.  Source to source AD compilers operate on mature codes that were not written with AD in mind.  It allows research scientists to reuse previously developed work to develop novel solutions to important problems today.

### Short and Wide Domain Specific Languages

This thesis focuses around DSLs that are *short* and *wide* with *simple* and *common* interfaces.  These adjectives are explained below.

*   Short v. Long - These are measures of the conceptual distance between source and target languages.  The larger the distance the more sensitive a language is to external change.
*   Wide v. Narrow - These are measures of the applicability of the language across domains.  Wide projects interest a diverse population of users.  Narrow projects are more specialized to a specific community.

Long and narrow projects are *brittle*.  They are unlikely to adapt to external pressures (like GPGPU.) 

*   Simple v. Complex - 
*   Common v. Custom - 

Demographics
------------

*Example: Meteorologists*

Researchers that are both experts in a scientific domain and capable of building domain specific languages and compilers are rare.

Case Study
----------

Science uses computation (third column)
Scientists custom build software
Lack of incentive/training -> low reuse and generality
This is true across skill levels (gordon bell to data analysis scripts)
Multidisciplinary+heterogeneity -> scientists spend less time doing science, more time learning foreign skills.  Monolithic code design does not scale well to multiple domains.
Society loses valuable hours from highly trained citizens

Software design encourages modularity and composability
Expertise sharing
    For performance/clarity in single piece
    For broad reuse
    For collaboration on single problem
    For new growth (going farther, experimentation->evolution)
Libraries, DSLs

Demographics are important
Highly skilled in their domain, but rarely trained as programmers.  Need to provide algorithmic help/infrastructure.
Need a system that produces correct behavior under present incentive structure.
Declarative programming - what vs how
Support popular and high performance languages




The scientific software ecosystem is ripe for refactoring.

*   Repeated code
*   Refactoring leads to new growth
*   Demographics are important
    *   Highly specialized and important expertise


Research scientists increasingly spend their time writing and running scientific software.  This may range from small data analysis scripts to large distributed multiphysics simulations.  

Research scientists increasingly rely on computation to gain insight in their domain.  The novelty of their work often requires that they encode their problem in custom built software.  This may be a time consuming task, particularly among domains without a strong tradition of software engineering.  Frequently this work is not easily transferable to other researchers in related domains.  This may be occur either from poor software design, a lack of systems administration, or a lack of incentive to generalize or publish.

Recent trends compound this problem further.  Increased pressure towards multidisciplinary work and the growth of parallel and many-core architectures demand an increasingly broad set of skills from the scientific programmer.  As a result domain scientists spend significant time learning foreign fields and technologies rather than exercising their unique expertise.  This is inefficient both from the perspective of the researcher spending time on frustrating tasks and from the perspective of soceity whose highly trained experts work on their area of expertise only a fraction of the possible time.

At the same time research scientists often produce very performant code.

Case Study - Numerical Weather Prediction
-----------------------------------------

Wait, this isn't about reuse, it's about modification.

Case Study - MapReduce
----------------------

Specialized non-domain specific interface.  Less powerful than MPI but much more widely used.  Composable within Java ecosystem.  

However several reimplementions exist with different backends.  Each copies part of the project (task manager) with different backends.  Different backend implementations are likely unavoidable, different task management solutions are not.
