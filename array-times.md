
Predicting Array Computation Times
----------------------------------

### Challenges

To create high performance task parallel programs at compile time we need to know the compute and communication times of each task on each machine and each variable between each pair of machines.  In general this is challenging.  

Compute times can depend strongly on the the inputs (known only at runtime), other processes, the operating system, and potentially even the hardware.  Interactions with complex memory hierarchies introduce difficult-to-model durations.  Even if estimates of tasks are available the uncertainty may be sufficient to ruin the accuracy of the overall schedule.

Communication times suffer similar though less significant obstacles.  Network congestion may be hard to model.

Optimal scheduling is NP-Hard; limiting the scale of schedulable programs.


### Array Programming is Easier

Fortunately, scheduling in the context of array operations in high performance computing mitigates several of these concerns.

Routines found in high performance libraries like BLAS/LAPACK are substantially more predictable.  Often the action of the routine depends only on the size of the input, not the contents.  Memory access patterns are often very regular and extend beyond the unpredictable lower levels of the cache.  Because this computation occurs in a high performance context there are relatively few other processes sharing resources and our task is given relatively high priority.

Array programs can often be written with relatively few tasks, making the NP-Hard scheduling problem feasible.


### The Predictability of BLAS Operations

TODO

An experiment in which we statistically characterize the runtimes of BLAS operations in a variety of contexts.  I hope to show that the uncertainty is not-too-large when certain conditions are met (an otherwise quiet system).
