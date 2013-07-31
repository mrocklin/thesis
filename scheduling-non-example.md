
Parallel Blocked Matrix Multiply
--------------------------------

\label{sec:parallel-blocked-mm}

The above example is the minimum viable parallel matrix computation.  In this section, we discuss a more relevant example and show both the potential power and drawbacks of this technique.  Strong scaling can be achieved in matrix operation through blocking.  As discussed in Section \ref{sec:blocking}, SymPy is capable of providing all necessary blocked definitions for various operations.  In this section, we create and execute a computation to perform a matrix-matrix multiply across two computational nodes.

As in Section \ref{sec:scheduling-example}, we form our problem in SymPy, pass it the  `conglomerate` project to construct a task graph, profile each of these nodes on our workers and pass this information to the scheduler to partition the computation graph in two.  We then rely on the code generation elements of `computations` to generate MPI code.  This code blocks the two matrices and performs the various `GEMM` and `AXPY` calls while transmitting intermediate results across the network.


#### Positive Results

For large matrices over a fast interconnect this problem can be parallelized effectively.  Scheduled times are substantially shorter than the sequential time.  Additionally, this technique can be used in the non-general matrix multiply case.  Symmetric matrix multiply or even more exotic symmetric-symmetric or symmetric-triangular blocked variants can be generated and effectively scheduled.   This approach allows for the construction of parallel routines specially tailored to a particular architecture and mathematical operation.

#### Negative Results

Unfortunately on our test framework the executed runtimes do not match the predictions produced by the scheduler.  Upon close inspection this mismatch is owed to a mismatch in assumptions made by the scheduler and the common MPI implementations.  As they are written the schedulers assume perfect asynchronous communication/computation overlap.  On our architecture with our MPI implementation (`openmpi-1.6.4`), this is not the case and valid transactions for which both the `iRecv` and `iSend` calls have occurred are not guaranteed to transmit immediately, even if the network is open.  The underlying problem is the lack of a separate thread for communication in the MPI implementation.

#### Details on the Communication Issue

To better understand the communication failure we focus on a particular computation within our program, the multiplication of `X*Y` via a `GEMM` on Machine 1.  Times and code have been altered for presentation.  General magnitudes and ordering have been preserved.

    Machine 1                  Actual Start Time    Scheduled Start Time

    iRecv(A from 2)                         0.00                    0.00
    Y = ....                                0.01                    0.01
    iRecv(X from 2)                         0.02                    0.02
    Wait(transfer of B from 2)              0.03                    0.03
    [1.0, X, Y, 0, 0] -> GEMM -> [...]      3.10                    0.13

    Machine 2

    iSend(X to 1)                           0.00                    0.00
    ... Time consuming work ...
    iSend(A to 1)                           3.00                    3.00

Note the discrepancy between the actual and scheduled start time of the `GEMM` operation on Machine 1.  This operation depends on `X`, generated locally, and `Y`, transferred from Machine 2.  Both the `iSend` and `iRecv` for this transfer started near the beginning of the program.  Based on the bandwidth of `1e8 Bytes/s` and data size of $1000^2*8 Bytes$, we expect a transfer time of around `0.1` seconds as is reflected in the schedule.  Instead, from the perspective of Machine 1, the `Wait` call blocks on this transfer for three seconds.  It appears that the transfer of `X` is implicitly blocked by the transfer of `A`, presumably by scheduling policies internal to the MPI implementation.  As a result of this inability to coordinate asynchronous transfers across the machines at precise times the computation effectively runs sequentially.

#### Approaches for Resolution

This problem could be resolved in the following ways: 

*   The spawning of threads to handle simultaneous communication (so-called progress threads).  Historically many MPI implementations have threads to handle communication even when control is not explicitly given to the library.  These are disabled by default for due to overhead concerns in common-case applications and development support for them has ceased (at least in our implementation).  This deprecated feature suits our needs well.

*   The careful generation of MPI calls that are mindful of the MPI scheduler in question.  Currently `iRecv` several calls are dumped at the beginning of the routine without thought to how they will be interpreted by the internal MPI scheduler.  By matching this order with the expected availability of data across machines implicit blocks caused by the scheduler may be avoided.

*   The improvement of internal MPI schedulers.  Rather than generate code to satisfy a scheduler work could be done to improve the schedulers themselves, making them more robust to situations with several open channels.

*   The modification of schedulers for synchronous communication.  These complications can be avoided by abstaining from asynchronous communication.  This degrades performance, particularly when communication times are on par with computation times, but greatly simplifies the problem.  Our current schedulers do not match this model (they assume asynchronicity) but other schedulers could be found or developed and inserted into the compilation chain without worry.

We leave these approaches for future work.
