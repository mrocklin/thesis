
Matrix Inference
----------------

\label{sec:matrix-inference}

include [Tikz](tikz_math.md)

In Section \ref{sec:sympy-inference} we saw that SymPy supports the expression and solution of logical queries on mathematical expressions.  In this section we extend this system to matrix algebra.

#### Inference Problems

Matrices can satisfy a rich set of predicates.  A matrix can have structural attributes like symmetry, upper or lower triangularity, or bandedness.  Matrices can also exhibit mathematical structure like invertibility, orthogonality, or positive definiteness.  Matrices also have basic field types like real, complex, or integer valued elements.  Rich interactions exist between these predicates and between predicate/operator pairs.  For example positive definiteness implies invertibility (a predicate-predicate relation) and the product of invertible matrices is always invertible (a predicate-operator relation).

#### Example

In Section \ref{sec:sympy-inference} we posed the following example:

*Given that $x$ is a natural number and that $y$ is real, is $x + y^2$ positive?*

An analogous example in matrix algebra would be the following:

*Given that $\mathbf A$ is symmetric positive-definite and $\mathbf B$ is fullrank, is $\mathbf B \cdot\mathbf A \cdot\mathbf B^\top$ symmetric and positive-definite?*

To teach SymPy to answer this question we need to supply the same information as in the scalar case:

1.  A set of predicates
2.  A set of predicate-predicate relations
3.  A set of predicate-operator relations

Fortunately the syntax and SAT solver may be reused.  The only elements that need to be generated for this case are relatively declarative in nature.

#### Predicates

We provide the following predicates:

    positive_definite, invertible, singular, fullrank, symmetric, 
    orthogonal, unitary, normal, upper/lower triangular, diagonal, square,
    complex_elements, real_elements, integer_elements

#### Predicate-Predicate Relations

Many of these predicates have straightforward relationships.  For example:

    Implies(Q.orthogonal, Q.positive_definite)
    Implies(Q.positive_definite, Q.invertible)
    Implies(Q.invertible, Q.fullrank)
    Equiavlent(Q.fullrank & Q.square, Q.invertible)  # & operator connotes "and"
    Equivalent(Q.invertible, ~Q.singular) # ~ operator connotes "not"
    ...

From these a wider set of implications can be inferred at code generation time.  Such a set would include trivial extensions such as the following:

    Implies(Q.orthogonal, Q.fullrank)

#### Predicate-Operator Relations

As in \ref{sec:sympy-inference-predicate-operator} the relationship between predicates and operators may be described by low-level Python functions.  These are organized into classes of static methods where classes are indexed by predicate and methods are indexed by operator.

~~~~~~~~~~Python
class AskInvertibleHandler(...):
    @staticmethod
    def MatMul(expr, assumptions):
        """ An MatMul is invertible if all of its arguments are invertible """
        if all(ask(Q.invertible(arg, assumptions) for arg in expr.args)):
            return True
~~~~~~~~~~

#### Example revisited

We posed the following question above:

*Given that $\mathbf A$ is symmetric positive-definite and $\mathbf B$ is fullrank, is $\mathbf B \cdot\mathbf A \cdot\mathbf B^\top$ symmetric and positive-definite?*

We are now able to answer this question using SymPy.

~~~~~~~~Python
>>> A = MatrixSymbol('A', n, n)
>>> B = MatrixSymbol('B', n, n)

>>> context = Q.symmetric(A) & Q.positive_definite(A) & Q.fullrank(B)
>>> query   = Q.symmetric(B*A*B.T) & Q.positive_definite(B*A*B.T)

>>> ask(query, context)
True
~~~~~~~~

This particular question is computationally relevant.  It arises frequently in scientific problems and significantly more efficient algorithms are applicable when it is true.  Unfortunately relatively few scientific users are able to recognize this situation.  Even when this situation is correctly identified developers may not be able to take advantage of the appropriate lower-level routines.

SymPy matrix expressions is the first computer algebra system that can answer questions like this for abstract matrices.  In Section \ref{sec:computations} we describe a system to describe the desired subroutines.  In Section \ref{sec:matrix-compilation} we describe a system to select the desired subroutine given the power of inference described here.


#### Refined Simplification

\label{sec:matrix-refine}

This advanced inference enables a substantially larger set of optimizations that depend on logical information.   For example, the inverse of a matrix can be simplified to its transpose if that matrix is orthogonal.

Linear algebra is a mature field with many such relations.  The Matrix Cookbook \cite{Petersen2008} alone contains thousands of such relations.  Formally describing each of these is challenging due both to their quantity and the limited population of practitioners.  To address this issue we create a mechanism to describe them declaratively.  This will be discussed further in Section \ref{sec:matrix-rewriting-sympy}.  Declarative techniques reduces the extent of the code-base with which a mathematician must be familiar in order to encode mathematics.  It also increases portability.  This reduction in scope drastically increases the domain of qualified developers.
