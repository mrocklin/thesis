
Need for Compilers in Numerial Linear Algebra
---------------------------------------------

\label{sec:need-for-compilers}

"High productivity" languages have gained popularity in recent years.  These languages target application domain programmers by reducing barriers to entry and providing syntax for high-level constructs.  Scripting languages like MatLab, R, and Python remove explicit typing, replace compilation with interpreters, and support high level primitives for matrix and common statistical operations.  These languages allow non-expert programmers the ability to solve a certain class of common problems with little training in traditional programming.

Each of these languages provide a set of high performance array operations.  A small set of array operations like matrix multiplication, solve, slicing, and element-wise scalar operations can be combined to solve a wide range of problems in statistical and scientific domains.  Because this set is small these routines can be implemented by language designers in a lower-level language and then conveniently linked to the high-productivity system, providing a good separation of expertise. These efforts have proven popular and useful among applied communities.

None of these popular array programming languages are compiled.  Because the array operations call down to precompiled library code this may at first seem unnecessary.

include [Operation Ordering in Matlab](operation-ordering-matlab.md)
