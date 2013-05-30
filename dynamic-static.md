
Static and Dynamic Task Scheduling
----------------------------------

Tasks may be scheduled dynamically at runtime or statically at compile time.  There are benefits to each.

### Dynamic Scheduling

Dynamic scheduling algorithms assume little knowledge about the runtime performance of the tasks.  Instead they allocate tasks onto resources as the tasks and resources become available.

#### Pros

*   Little understanding of the application is required
*   Robust to uncertainty in runtimes 
*   Robust to hardware failure in worker nodes

#### Cons

*   Requires a runtime system to perform scheduling (consumes resources)
*   May not optimally schedule tasks (not very performant)

### Static Scheduling

Static scheduling algorithms analyze the performance characteristics of both the computation and the hardware to create a schedule at compile time.  Because the analysis happens once it is common to use more sophisticated and time-consuming algorithms to determine an optimal schedule.

#### Pros

*   Generally higher performance under optimal conditions
*   No runtime scheduler required (cheap at runtime)

#### Cons

*   Not robust to runtime uncertainty in tasks
*   Not robust to hardware failure
