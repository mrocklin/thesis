
Interoperation with Existing Work
---------------------------------

This is just another piece to add to the system.  We can develop it in complete isolation from this application.  Because we have clean interfaces we can inject it easily.

We interrupt the existing compile chain at the generation of the mathematical DAG.  We send this, along with the extra timing information to the static scheduler and receive a set of DAGs, each associated with a computational agent.  These smaller DAGs now also include communication tasks.  These tasks are implemented in `computations` as MPI `send` and `recv` tasks.  We send these DAGs through the rest of the compile chain and receive a set of Fortran90 programs with appropriately injected MPI code.
