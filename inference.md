
Inference on predicates
-----------------------

\label{sec:matrix-inference}

In section \ref{sec:sympy-inference} we saw that SymPy supports the expression and solution of logical queries on mathematical expressions.  In this section we extend this system to matrix algebra.

### Inference Problems

Matrices can satisfy a rich set of predicates.  A matrix can have structural attributes like symmetry, upper or lower triangularity, or bandedness.  Matrices can also exhibit mathematical structure like invertibility, orthogonality, or positive definiteness.  Matrices also have basic field types like real, complex, or integer valued elements.  Rich interactions exist between these predicates and between predicate/operator pairs.  for example positive definiteness implies invertibility (a predicate-predicate relation) and the product of invertible matrices is always inveritible (a predicate-operator relation).

#### Example

In section \ref{sec:sympy-inference} we posed the following example

*Given that $x$ is a natural number and that $y$ is real, is $x + y^2$ positive?*

An analagous example in matrix algebra would be the following:

*Given that $\mathbf A$ is symmetric positive-definite and $\mathbf B$ is fullrank, is $\mathbf B \cdot\mathbf A \cdot\mathbf B^\top$ symmetric and positive-definite?*

To teach SymPy to answer this question we need to supply the same information as in the scalar case

1.  A set of predicates
2.  A set of predicate-predicate relations
3.  A set of predicate-operator relations

Fortunately the syntax and SAT solver may be reused.  The only elements that need to be generated for this case are relatively declarative in nature.

#### Predicates

We provide the following predicates

    positive_definite, invertible, singular, fullrank, symmetric, 
    orthogonal, unitary, normal, upper/lower triangular, diagonal, square,
    complex_elements, real_elements, integer_elements

#### Predicate-Predicate Relations

Many of these predicates have straightforward relationships.  For example

    Implies(Q.orthogonal, Q.positive_definite)
    Implies(Q.positive_definite, Q.invertible)
    Implies(Q.invertible, Q.fullrank)
    Equiavlent(Q.fullrank & Q.square, Q.invertible)  # & operator connotes "and"
    Equivalent(Q.invertible, ~Q.singular) # ~ operator connotes "not"
    ...

From these a wider set of implications can be inferred at code generation time.  Such a set would include trivial extensions such as 

    Implies(Q.orthogonal, Q.fullrank)

#### Predicate-Operator Relations

As in \ref{sec:sympy-inference-predicate-operator} the relationship between predicates and operators may be described by low-level Python functions.  These are organized into classes of staticmethods where classes are indexed by predicate and methods are indexed by operator.

~~~~~~~~~~Python
class AskInvertibleHandler(...):
    @staticmethod
    def MatMul(expr, assumptions):
        """ An MatMul is invertible if all of its arguments are invertible """
        if all(ask(Q.invertible(arg, assumptions) for arg in expr.args)):
            return True
~~~~~~~~~~

#### Example revisited

We posed the following question above 

*Given that $\mathbf A$ is symmetric positive-definite and $\mathbf B$ is fullrank, is $\mathbf B \cdot\mathbf A \cdot\mathbf B^\top$ symmetric and positive-definite?*

We are now able to answer this question using SymPy

~~~~~~~~Python
>>> A = MatrixSymbol('A', n, n)
>>> B = MatrixSymbol('B', n, n)

>>> context = Q.symmetric(A) & Q.positive_definite(A) & Q.fullrank(B)
>>> query   = Q.symmetric(B*A*B.T) & Q.positive_definite(B*A*B.T)

>>> ask(query, context)
True
~~~~~~~~

This particular question is computationally relevant.  It arises frequently in scientific problems and significantly more efficient algorithms are applicable when it is true.  Unfortunately relatively few scientific users are able to recognize this situation.  Even this situation is correctly identified many developers are unable to take advantage of the appropriate routines.

This is the first system that can answer questions like this for abstract matrices.  In section \ref{sec:computations} we will describe a system to describe the desired routine.  In section \ref{sec:matrix-compile} we will describe a system to select the desired routine given the power of inference described here.


### Refined Simplification

\label{sec:matrix-refine}

This advanced inference enables a substantially larger set of optimizations that depend on logical information.   For example, the inverse of a matrix can be simplified to its transpose if that matrix is orthogonal

    X.I   ->   X.T    if      Q.orthogonal(X)

Linear algebra is a mature field with many such relations \cite{matrix-cookbook}.  It is challenging to write them down.  We hope to leverage the linear algebra community to develop this further.  In order to accomplish this we endeavor to reduce the extent of the code-base with which a mathematician must familiarize themselves to encode these relations.  Enter declarative programming.

Our original approach to this problem was through a meta-programming and term rewrite system \cite{matrix-algebra}.  Our original implementation of automated matrix algebra was written in Maude and contained code like the following

    inverse(X) = transpose(X) if X is orthogonal

The meta-programming approach allowed the specification of mathematical relations in a math-like syntax, drastically lowering the barrier of entry for potential mathematical developers.  The term-rewrite infrastructure allowed these relations to be automatically applied by generic, mature, and computationally efficient strategies.

Unfortunately the Maude system is an exotic dependency in the scientific community and interoperability with low-level computational codes was not a priority in it's development.

Our current implementation depends on LogPy, discussed later in section \ref{sec:declarative}, to implement a term rewrite system.  Because LogPy is embedded in Python we can not acheive the same convenient syntax support provided by Maude, but we can still encode a set of transformations in `(source, target, condition)` tuples.  A set of these tuples are then fed into a term rewrite system and used to simplify matrix expressions.

    Wanted      X.I   ->   X.T    if      Q.orthogonal(X)
    Delivered  (X.I    ,   X.T     ,      Q.orthogonal(X))

These allow mathematical users to encode mathematical expertise and have that expertise be automatically applied to all problems described in this system.  Extending the set of simplification relations is straightforward and approachable to a very broad community.  Additionally, this declarative nature allows us to swap out the term rewrite system backend should future development produce more mature solutions.

We present mathematical information about determinants taken from the Matrix Cookbook \cite{matrix-cookbook} and encoded in the manner described above. 

~~~~~~~~~~~~~~Python
# Determinants
(det(A),        0,              Q.singular(A)),
(det(A),        1,              Q.orthogonal(A)),
(Abs(det(A)),   1,              Q.unitary(A)),
(det(A*B),      det(A)*det(B),  Q.square(A)),
(det(BlockMatrix([[A,B],[C,D]])),   det(A)*det(D - C*A.I*B),  Q.invertible(A)),
...
~~~~~~~~~~~~~~

