
Inference on predicates
-----------------------

\label{sec:matrix-inference}

SymPy provides a system for logical inference on mathematical expressions.  It includes 

1.  A syntax to state predicates  --  `Q.positive(x) & Q.positive(y)`
2.  A collection of handlers for type-predicate pairs, e.g. the addition of positive numbers is positive
3.  A collection of relations --  `Implies(Q.prime, Q.integer)`
4.  A SAT solver to compute the truth of queries given a set of known facts and relations

We have extended this system to handle common matrix predicates including the following

    positive_definite, invertible, singular, fullrank, symmetric, 
    orthogonal, unitary, normal, upper/lower triangular, diagonal, square,
    complex_elements, real_elements, integer_elements

This supports the solution of complex queries on complex matrix expressions. 

### Example

For all matrices $\mathbf{A, B}$ such that $\mathbf A$ is symmetric positive-definite and $\mathbf B$ is fullrank 

*is $\mathbf B \cdot\mathbf A \cdot\mathbf B^\top$ symmetric and positive-definite?*

~~~~~~~~Python
>>> A = MatrixSymbol('A', n, n)
>>> B = MatrixSymbol('B', n, n)

>>> context = Q.symmetric(A) & Q.positive_definite(A) & Q.fullrank(B)
>>> query   = Q.symmetric(B*A*B.T) & Q.positive_definite(B*A*B.T)

>>> ask(query, context)
True
~~~~~~~~

This particular question is computationally relevant.  It arises frequently in scientific problems and significantly more efficient algorithms are applicable when it is true.  Unfortunately relatively few scientific users are able to recognize this situation.  Even this situation is correctly identified many developers are unable to take advantage of the appropriate routines.

This is the first system that can answer questions like this for abstract matrices.


### Refined Simplification

\label{sec:matrix-refine}

This advanced inference enables a substantially larger set of optimizations that depend on logical information.   For example, the inverse of a matrix can be simplified to its transpose if that matrix is orthogonal

    X.I   ->   X.T    if      Q.orthogonal(X)

Linear algebra is a mature field with many such relations \cite{matrix-cookbook}.  It is challenging to write them down.  We hope to leverage the linear algebra community to develop this further.  In order to accomplish this we endeavor to reduce the extent of the code-base with which a mathematician must familiarize themselves to encode these relations.  

Our original approach to this problem was through a meta-programming and term rewrite system \cite{matrix-algebra}.  Our original implementation of automated matrix algebra was written in Maude and contained expressions like the following

    inverse(X) = transpose(X) if X is orthogonal

The meta-programming approach allowed the specification of mathematical relations in a math-like syntax, drastically lowering the barrier of entry for potential mathematical developers.  The term-rewrite infrastructure allowed these relations to be automatically applied by generic, mature, and computationally efficient strategies.

Unfortunately the Maude system is an exotic dependency in the scientific community and interoperability with low-level computational codes was not a priority in it's development.

Our current implementation depends on LogPy, discussed later in section \ref{sec:declarative} to implement a term rewrite system.  Though we lack the convenient syntax support provided by Maude we can still encode a set of transformations in `(source, target, condition)` tuples.  A set of these tuples are then fed into a term rewrite system and used to simplify matrix expressions.

    Wanted      X.I   ->   X.T    if      Q.orthogonal(X)
    Delivered  (X.I    ,   X.T     ,      Q.orthogonal(X))

These allow mathematical users to encode mathematical expertise and have that expertise be automatically applied to all problems described in this system.  Extending the set of simplification relations is straightforward and approachable to a very broad community.  Additionally, this declarative nature allows us to swap out the term rewrite system backend should future development produce more mature solutions.

We present mathematical information about determinants taken from the Matrix Cookbook \cite{matrix-cookbook} and encoded in the manner described above. 

~~~~~~~~~~~~~~Python
# Determinants
(det(A),       0,   Q.singular(A)),
(det(A),       1,   Q.orthogonal(A)),
(Abs(det(A)),  1,   Q.unitary(A)),
(det(BlockMatrix([[A,B],[C,D]])),   det(A)*det(D - C*A.I*B),  Q.invertible(A)),
...
~~~~~~~~~~~~~~

