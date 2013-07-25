
Numerical Linear Algebra
------------------------

\label{sec:introduction-nla}

Numerical Linear Algebra is a long running scientific application that has been developed by experts for several decades.  This dissertation investigates linear algebra as a case study and microcosm for modular scientific software development.

Linear algebra serves as an interface between computational scientists and computational hardware.  Many scientific domains can express their problems as matrix computations.  Scientific or mathematical programmers are often well trained in theoretical linear algebra.  High performance and curated libraries for numerical linear algebra exist for most computational architectures.  These libraries have a consistent and durable interface and are supported by a variety of software.  As a result of this cross-familiarity, linear algebra serves as a de-facto computational language between computational researchers and low-level hardware.  The majority of floating point operations within scientific computations occur within a linear algebra routine.

For full performance, linear algebra libraries are tightly coupled to hardware models.  This organization forces a software rewrite when existing models become obsolete.  Today this occurs both due to the break from homogeneity and the break from a simple memory-hierarchy (due to various forms of parallelism.)  Despite the paramount importance of numerical linear algebra only a small number of groups at major universities and national labs seem able to contribute meaningfully to the software engineering endeavor.  The simultaneous expertise required in linear algebra, numerical analysis, low-level hardware, parallel computation, and software engineering, is only found in relatively few groups specially geared for this task; each well known group has decades of experience.

These groups produce very high quality software, capable of executing common matrix computations orders of magnitude faster than reasonably intelligent attempts.  Still, despite their expertise it is difficult to respond to the rapidly changing hardware landscape, introducing a lag of several years between a new technology (e.g. CUDA) and a mature linear algebra implementation that makes use of that technology (e.g. CUDA-LAPACK).
