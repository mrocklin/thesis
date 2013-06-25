
Numerical Linear Algebra
------------------------

Numerical Linear Algebra is a well developed and optimized domain in scientific software.  This dissertation investigates linear algebra as a case study for modular scientific software development.

Linear algebra serves as an interface between computational scientists and computational hardware.  Many scientific domains can express their problems as matrix computations.  Scientific or mathematical programmers are often well trained in theoretical linear algebra.  High performance and curated libraries for numerical linear algebra exist for most computational architectures.  These libraries have a consistent and durable interface and are supported by a variety of software.  As a result of this double familiarity linear algebra serves as a defacto computational language between computational researchers and low-level hardware.  The majority of floating point operations within scientific computations occur within a linear algebra routine.

For full performance linear algebra libraries are tightly coupled to hardware models.  This forces a software rewrite when existing models are broken.  Today this occurs both due to the break from heterogeneity and the break from a simple memory-hierarchy (due to various forms of parallelism).  Despite the paramount importance of numerical linear algebra only a small number of groups seem able to reliably contribute to the software engineering endeavor.  The simultaneous expertise required in mathematics, numerical analysis, low-level hardware, and software engineering is only found in relatively few groups specially geared for this task.

These groups produce very high quality software, capable of executing common matrix computations order of magnitude faster than naive attempts.  Still, despite their expertise it is difficult to responde to the rapidly changing hardware landscape, introducing a lag of several years between a new technology (e.g. CUDA) and a mature linear algebra implementation that makes use of that technology (e.g. CUDA-LAPACK).
