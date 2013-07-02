
Experiment - Parallel Kalman Filter
-----------------------------------

\label{sec:scheduling-kalman}


TODO

### Two Node System

We schedule the Kalman filter over two nodes.  

We note the breaking points in the DAG and compare the two algorithms differing solutions and runtimes.

We execute the MPI computation and profile its runtime.  We compare the distribution of these times with our predictions.


### Four Node System

We now wish to compute the same problem on four nodes rather than two.  

In order to expose this much parallelism we must block the computation.  We do this at the mathematical level and propagate the solution down to the DAG level.  

We note that this compilation process is somewhat slow, encouraging the use of more sophisticated matching algorithms and search methods.

We schedule this system with both schedulers, compare both scheduling times and the runtimes of the solution schedules.

We execute the MPI computation and profile its runtime.  We compare distribution of these times with our predictions.
