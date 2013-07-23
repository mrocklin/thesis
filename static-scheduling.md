
Heterogeneous Static Scheduling
===============================

\label{sec:static-scheduling}

Introduction
------------

Recent developments in computations for dense linear algebra engage parallelism
at the shared memory, distributed memory, and heterogeneous levels.  This has
required several significant software rewrites among many research teams.  In
this chapter we adapt our existing system to engage parallel computation by adding another composable component, a static scheduler.  We show that this can be done separately, without affecting existing code.  This demonstrates both the extensibility of the existing system and durability of the individual components.

Specifically we implement application-agnostic static scheduling algorithms in isolation.  We compose these with our existing components to automatically generate MPI programs to compute dense linear algebra on specific parallel architectures. 

### Motivating Problem 

We want to develop high performance numerical algorithms on increasingly heterogeneous systems.  This is a case of high importance and high development time.  We focus on systems with a few computational units (less than 10) such as might occur on a single node within a large high performance computer.

Traditionally these kernels are written by hand using MPI.  They are then tuned manually.  We investigate the feasibility/utility of automation for these tasks.

include [Background](scheduling-background.md)

include [Experiment](scheduling-experiment.md)

include [Predicting Array Computation Times](array-times.md)

include [Predicting Communication Times](communication-times.md)

include [Scheduling Algorithms](scheduling-algorithms.md)

include [Experiment - Parallel Kalman Filter](scheduling-kalman.md)
