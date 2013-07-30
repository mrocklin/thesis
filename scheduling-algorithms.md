
Static Scheduling Algorithms
----------------------------

\label{sec:scheduling-algorithms}


#### Complexity 

Optimal scheduling is NP-Hard; limiting the scale of schedulable programs.  We can get around this in a few ways:

1.  Array programs can often be written with relatively few tasks, making the full NP-Hard problem feasible for interesting problems.
2.  Robust approximation algorithms exist for common NP-Complete problems (e.g. integer linear programming.)
3.  Heuristics for heterogeneous static scheduling exist.


#### Interface

We use the following interface for heterogeneous static scheduling:

Inputs:

*   Task Directed Acyclic Graph
*   Graph of Computational Agents
*   Compute Time function,  `Task, Agent` $\rightarrow$ `Time`
*   Communication Time function,  `Variable, Agent, Agent` $\rightarrow$ `Time`

Outputs:

*   Mapping of `Agent` $\rightarrow$ `Task Directed Acyclic Graph`


We implement two static scheduling algorithms that satisfy this interface.


#### Mixed Integer Linear Programming

We pose the heterogeneous static scheduling problem as a mixed integer linear program as was done by Tompkins in \cite{Tompkins2003}.  Integer programming is a standard description language with a rich theory and mature software solutions.  It is an NP-Complete problem with a variety of approximation algorithms.  It is a common intermediate representation to computational engines in operations research.


#### Dynamic List Scheduling Heuristic

We also experiment with the Heterogeneous Earliest Finish Time (HEFT)\cite{Topcuoglu2002} heuristic.  This heuristic runs in polynomial time but is greedy and does not guarantee optimal solutions.

HEFT operates with two steps.  It first assigns a very rough time-to-completion score to each task, based on the score of all of its dependencies and the average compute time across all of the heterogeneous workers.  It then schedules each element of this list onto the computational resource that will execute that job with the earliest finish time.  This second step takes into account both the known duration of that task on each machine and the communication time of all necessary variables from all other machines on which they might reside.  It remains a greedy algorithm (it is unable to accept short-term losses for long-term optimality) but does perform well in many situations.
