
Scheduling on Future Architectures
----------------------------------

Current trends in computer hardware predict the following trends in high performance computer architecture.

#### Increased Parallelism 

will substantially increase the rate at which individual nodes fail.  A successful global scheduling system must be robust to isolated hardware failure.

#### Increased Heterogeneity

will increase the difficulty of producing performant parallel code.

#### Increased Structure

will provide different levels to implement different scheduling schemes.

### Hybrid Scheduling

Increasingly frequent hardware failure limits the scalability of pure static-scheduling solutions.  Hardware failures occur at run time and must be handled dynamically.

However increased parallelism and increased heterogeneity both limit the performance of dynamically scheduled programs.  Scheduling on complex hardware often necessitates sophisticated analyses to produce performant programs.

We believe that it is possible to mix and match static and dynamic scheduling at different levels within the parallel hierarchy to achieve moderate levels of both performance and robustness.  In this section we build computational kernels on small-scale parallel machines.  For example the tools presented here could build a blocked matrix multiply on a particular node architecture (e.g. a two CPU system).  This operation could then be used at a higher level by a dynamic scheduler.  The operation is sensitive to failure in any of its elements but the larger computation remains robust if it can dynamically schedule over several such nodes.  Performance is achieved at a small scale and robustness at the large scale.

