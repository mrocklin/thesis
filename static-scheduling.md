
Heterogeneous Static Scheduling
===============================

\label{sec:static-scheduling}

Introduction
------------

Recent developments in computations for dense linear algebra engage parallelism at the shared memory, distributed memory, and heterogeneous levels.  This has required several significant software rewrites among many research teams.  In this section we adapt our existing system to engage parallel computation by adding another composable component, a static scheduler.  We show that this can be done separately, without affecting existing code.  This demonstrates both extensibility of the existing system and durability of the individual components.

Specifically we implement application-agnostic static scheduling algorithms in isolation.  We compose these with our existing components to automatically generate MPI programs to compute dense linear algebra on specific architectures. 

### Motivating Problem 

We want to develop high performance numerical algorithms on increasingly heterogeneous systems.  This is a case of high importance and high development time.  We focus on systems with a few computational units (less than 10) such as might occur on a single node within a large high performance computer.

Traditionally these kernels are written by hand.  They are tuned and written by hand.
Can automation do a decent enough job?

include [Static and Dynamic Task Scheduling](dynamic-static.md)

include [Predicting Array Computation Times](array-times.md)

include [Scheduling Related Work](scheduling-related.md)

include [Scheduling Algorithms](scheduling-algorithms.md)

include [Interoperation with existing pieces](scheduling-interoperation.md)

## Experiment

Lets compute the Kalman filter over a few nodes.  Lets see that we obtain strong scaling.  Lets see to what degree our computation time is predictable.


If I have time I'll implement a heterogeneous CUDA solution.  If I don't have time I'd like to cut this.


### Analysis

My goal is not to produce a production system to perform dense linear algebra.  Instead my goal is to demonstrate a proof of concept that scheduling concerns can be lifted from numerical linear algebra systems and still obtain quantitative results.  Hopefully I see this.
