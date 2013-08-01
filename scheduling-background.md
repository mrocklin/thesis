
Background
----------

Task Scheduling is a broad topic under active development.  Approaches in task scheduling can be separated along two different axes

1.  The amount of assumed knowledge
2.  When the scheduling is performed

The distribution along these axes is highly correlated.  In general, systems with more knowledge perform sophisticated analyses that consume significant amounts of resources.  These analyses are preferably done only once at compile-time rather than during execution when they may slow down the actual computation.  Conversely systems about which little is known often use simple analyses and so can be done cheaply at runtime.  While less is known a priori, these cheaper runtime systems can respond more dynamically to events as they occur.


#### Dynamic Scheduling 

In general, dynamic scheduling systems do not assume much knowledge about the computation.  In the simplest case they blindly schedule operations from the task graph to computational workers as these tasks become available (data dependencies are met) and workers become available (no longer working on the previous job).  More sophisticated analyses may try to schedule tasks onto machines more intelligently, for example by preferentially keeping data local to a single machine if possible.

Systems like Condor, Pegasus, or Swift dynamically schedule a directed acyclic graph of tasks onto a pool of workers connected over a network.  These systems enable users to define a task graph as a set of processes.  They traditionally handle communication over a network file system.  Hadoop, a common infrastructure for the MapReduce interface, bears mention.  The MapReduce interface allows only a restricted form of dependency graph defined by one-to-one mapping functions and many-to-one reduction functions.  This added restriction allows implementations like Hadoop to assume more about the problem and opens up various efficiencies.  Hadoop, an implementation, allows substantially more control for reduced communication than MapReduce.  For example, by controlling Partitioner objects data locality can be exploited to minimize network or even disk communication.  In general, more restrictive models enable more sophisticated runtime analyses.


#### Static Scheduling 

The majority of static scheduling research assumes some knowledge both about the costs of tasks and, if the set of agents is heterogeneous, each agent's strengths and weaknesses.  This situation has been historically rare in parallel programming but common in operations research.  For example operations in the construction and assembly of an automobile or the distribution of goods is often well known ahead of time and automated workers often have widely varying but highly predictable task completion times.  These problems are far more regular than a generic program and also far more dependent on the worker agents available (not all agents are equally suited to all tasks.)

In general, optimal scheduling is NP-hard; however algorithms, approximations, and heuristics exist.  They differ by leveraging different theory, assuming different symmetries of the problem (e.g. homogeneous static scheduling where all agents are identical) or by assuming different amounts of the knowledge or symmetries about the tasks (all times known, all times known and equivalent, communication times known, communication times are all zero, etc....)  Kwok and Ahmed\cite{Kwok1999} give a good review.

Finally we note that in practice most static scheduling at this level is written by hand.  HPC software developers often explicitly encode a schedule statically into their code with MPI calls.  This application is the target for this chapter.


#### Informed Dynamic Scheduling

In special cases we may know something about the tasks and the architecture and also want to schedule dynamically for robustness or performance reasons.   These situations tend to be fairly specialised.   In the context of numerical linear algebra we can consider the communication of blocks or tiles (a term for a small block) around a network.

This approach is taken by systems like Supermatrix, Elemental, BLACS, and most recently, DAGuE\cite{Bosilca2012}.  These systems all move regularly sized blocks between connected nodes to perform relatively similarly timed operations.  In the case of DAGuE, information about the network can be encoded to better support data locality.

Recent work with PLAMSA \cite{Agullo2009, Song2012} shows a trend towards hybrid schedulers where part of the communication is handled dynamically for robustness and part is handled statically for performance.  As parallelism increases both sophisticated analyses and robustness are necessary.  These can be added at different levels of granularity; for example operations on sets of neighboring nodes can be statically scheduled while calls to this neighborhood can be scheduled dynamically for robustness.  Alternatively a top-down static schedule may exist over several high-granularity dynamic schedulers.
