
Static Scheduling Algorithms
----------------------------

\label{sec:scheduling-algorithms}

### Interface

Optimal scheduling is NP-Hard; limiting the scale of schedulable programs.  Array programs can often be written with relatively few tasks, making the NP-Hard scheduling problem feasible.


We use the following interface for heterogeneous static scheduling 

Inputs:

*   Task Directed Acyclic Graph
*   Graph of Computational Agents
*   Compute Time function :: Task, Agent $\rightarrow$ Time
*   Communication Time function :: Variable, Agent, Agent $\rightarrow$ Time

Outputs:

*   Mapping of Agent $\rightarrow$ Task DAG


We implement two static scheduling algorithms.

### Mixed Integer Linear Programming

We pose the heterogeneous static scheduling problem as a mixed integer linear program.  This was done by Tompkins in \cite{Tompkins2003}. 

Integer programming is a standard description language with a rich theory and mature solutions.  It is an NP-Hard problem but has a variety of approximation algorithms.

TODO: Explain Integer Programming

### Dynamic List Scheduling Heuristic

We also experiment with the Heterogeneous Earliest Finish Time (HEFT)\cite{Topcuoglu2002} heuristic.  This runs in polynomial time but is greedy and does not guarantee optimal solutions.

TODO: Explain algorithm
