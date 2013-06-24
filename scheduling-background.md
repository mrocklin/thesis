
Background
----------

Task Scheduling is a broad topic under active development.  

Approaches in task scheduling can be separated along two different axes

1.  The amount of assumed knowledge
2.  When the scheduling is performed (run-time or compile-time)

The distribution along these axes is highly correlated.  In general systems that assume knowledge can perform more sophisticated analyses which can consume a significant amount of resources.  These analyses are preferably done once at compile-time.  Conversely systems about which little is known are more likely to require real-time response, necessitating a runtime solution.

### Ignorant Dynamic Scheduling 

Fork-Join, Condor-Pegasus-Swift, Hadoop

Locality, resource utilization, node failure

Are there any universal/modular software/libraries for this?  


### Informed Static Scheduling 

The majority of static scheduling research assumes some knowledge both about the costs of tasks and, if the set of agents is heterogeneous, each agents strengths and weaknesses.  This situation is rare in parallel programming but is common in operations research where the application may be the efficient construction and assembly of an automobile or the distribution of goods.  These problems are far more regular than a generic program and also far more dependent on the worker agents available (not all agents can perform all tasks.)

In general optimal scheduling is NP-hard.  However algorithms, approximations, and heuristics exist.  They differ by leveraging different theory, assuming different symmetries of the problem (e.g. homogenous static scheduling where all agents are identical) or by assuming different amounts of the knowledge or symmetries about the tasks (all times known, all times known and equivalent, communication times known, communication times are all zero, etc....)  Kwok and Ahmed\cite{Kwok1999} give a good review.

TODO

Finally we note that informed static scheduling is often written by hand.  MPI programs embed an explicit communications schedule statically into the code.


### Informed Dynamic Scheduling

In special cases we may know something about the tasks and the architecture and also want to schedule dynamically for robustness or performance reasons.   These situations tend to be fairly specialied.   In the context of numerical linear algebra we can consider the communication of blocks or tiles (a term for a small block) around a network.

Talk about DAGuE\ref{Bosilca2012}?  Or maybe this is a separate section.

### Distributed Numerical Linear Algebra

Parallel solutions to linear algebra first gained popularity with ScaLAPACK, which used the Basic Linear Algebra Communication Subroutines (BLACS) as a communication interface on top of MPI.  ScaLAPACK acheives parallelism by breaking up matrices into blocks or small tiles, constructing a computation as in \ref{sec:blocked} and then coordinating task to different compute resources.

This same model has been repeated in existing systems.  SuperMatrix extends the FLAME environement with a run-time scheduler for shared memory multi-core parallelism.  Elemental extends FLAME with a distributed memory run-time scheduler. 

(Need to verify this) The PLASMA project describes parallel dense linear algebra problems as executable DAGs that it then hands off to DAGuE\ref{Bosilca2012}, a dedicated "high performance architecture aware runtime scheduler."  With this abstraction PLASMA has been able to grow from a purely multi-core project to a distributed and, in new work, heterogeneous system.

