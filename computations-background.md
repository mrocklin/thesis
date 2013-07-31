
Background
----------

\label{sec:computations-background}

#### Low-level Libraries

BLAS/LAPACK, FFTW, and MPI are examples of efficient low level libraries/interfaces that serve as computational building blocks of mathematical codes.  These codes are commonly linked to by higher level languages (e.g. `scipy.linalg.blas`, `numpy.fft`, `mpi4py`).  The high-level packages magnify the utility of the low-level libraries both by providing a more modern interface for novice users and by interconnection with the scientific Python ecosystem. "High productivity" languages like Python, Matlab, and `R` are very popular within scientific communities.  The dual needs of performance and accessibility are often met with such links to lower level refined code.

#### Compiled Python

Occasionally this set of high-level operators is insufficient to describe a computational task, forcing users to revert to execution within the relatively slow CPython/Matlab/R runtimes.  Also, even if the high-level operators can describe a computation the interpreted nature of the Python runtime may not be able to take advantage of transformations like operation fusion, inplace computation, or execution on a GPU.

Dozens of projects have attempted to address these issues in recent years by compiling user-friendly Python code into more performant low-level code (see list in Section \ref{sec:scipy-compiled-langs}.)  These traditionally annotate Python functions with light type information, use this information to generate low-level C/C++ code, wrap this code with the appropriate CPython bindings and expose it to the Python level.  Care is taken so that this transformation is hidden from the scientific user.

#### Problems with Current Approaches

When these projects bind themselves to the CPython runtime they retain some of the less obvious inefficiencies of Python.  

On a multicore machine, concurrency between simultaneous operations remains difficult due to Python's global interpretter lock (GIL). In a massively parallel context each process still needs to load the `python` runtime and import the necessary libraries.  This import process routinely takes hours on a standard network file system.  Resulting codes depend strongly on the Python ecosystem, eliminating opportunities for interaction with other software systems in the future.  They are also written in exotic language variants with uncertain longevity and support.

These projects lack a common data structure or framework to share contributions.  Dozens of implementations exist which reimplement roughly the same architecture in order to experiment with a relatively small novel optimization.

With regards to this last point this chapter is no different.  We implement a small intermediate representation and code generation system in order to demonstrate the values of exclusively using low-level libraries as primitives and using mathematical inference to inform matrix computation.  Fortunately this redundant element is small and does not contain the majority of our logic.  The intelligence of this system resides in a far more stable and dominant computer algebra system, SymPy.
