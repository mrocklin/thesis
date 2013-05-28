
Heterogeneous Static Scheduling
===============================

\label{sec:static-scheduling}

### The Problem

We want to develop high performance numerical algorithms on increasingly heterogeneous systems.  This is a case of high importance and high development time.  Can automation do a decent enough job?

### Challenges

Static scheduling is hard.

1.  Depends on known compute and communication times.  This is difficult in general due to uncertainty from inputs and uncertainty from hardware/software context.
2.  It's NP-Hard

Heterogeneous scheduling is hard.

3.  It depends on a set of hardware agnostic primitives


### Array Computations are Easier

This problem is easier in our context for the following reasons

1.  Very regular memory access and HPC context yield predictable runtimes
2.  Low expression complexity - programs have few terms
3.  A set of instructions common to multiple types of hardware (BLAS/LAPACK)

### Background

Scheduling in general (big topic, how much should I cover?)

In the context of linear algebra.  Extensions to FLAME, Magma.


### Static Scheduling Algorithms

1.  Mixed Integer Linear Programming
2.  Dynamic List Scheduling Heuristic


### Interoperation with Existing work

This is just another piece to add to the system.  We can develop it in complete isolation from this application.  Because we have clean interfaces we can inject it easily.


### Experiment

Lets compute the Kalman filter over a few nodes.  Lets see that we obtain strong scaling.  Lets see to what degree our computation time is predictable.


If I have time I'll implement a heterogeneous CUDA solution.  If I don't have time I'd like to cut this.


### Analysis

My goal is not to produce a production system to perform dense linear algebra.  Instead my goal is to demonstrate a proof of concept that scheduling concerns can be lifted from numerical linear algebra systems and still obtain quantitative results.  Hopefully I see this.
