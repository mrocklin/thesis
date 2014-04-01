### General Array Programming

It is worth noting that while BLAS/LAPACK cover many matrix operations they
fail to address the entire space of multi-dimensional array operations.  Array
programming with high level abstractions can confer both numeric performance
benefits (e.g. through loop fusion) and also programming performance, by
providing a set of high-level primitives.  By using array objects or terms rather
than pointers to sequences of scalars we enable the mathematical programmer to
more cleanly communicate his intent to the computer which is then able to more
efficiently generate low-level code to solve the intended problem.

Array programming with high level abstractions is an old idea, going back as
far as the 1960s with the Array Programming Language (APL)\cite{Iverson1962}.

These ideas have been widely adopted in a variety of projects.  Common
scripting languages, like MatLAB, R, IDL, and Python-NumPy, implement array
abstractions with hooks to low-level codes.  Various C++ libraries like
Armadillo\cite{Armadillo}, Eigen\cite{Eigen3}, Expression
Templates\cite{Veldhuizen:ET}, Blaze\cite{Blaze1, Blaze2}, also provide
high-level syntax to array operations.  These sorts of projects often leverage
C++'s templating system to perform extra optimizations like loop fusion or
better use of in-place execution before the traditional compile time.
