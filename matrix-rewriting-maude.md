
Matrix Rewriting in Maude
-------------------------

\label{sec:matrix-rewriting-maude}

We implement matrix expressions in Maude and use rewrite rules to declare mathematical transformations with intuitive syntax.  Our goal is to demonstrate the simplicity with which mathematical theories can be constructed and to serve as proof of concept for a later implementation using SymPy and LogPy.

### Matrix Algebra

The `matrix-algebra`\cite{matrix-algebra} project defines a language for matrix expressions in Maude.  First we define the sorts of terms

sorts MatrixExpr MatrixSymbol Vector RowVector
subsort Vector RowVector MatrixSymbol < MatrixExpr

And a set of operators with associated precedences

    op _+_       : MatrixExpr MatrixExpr -> MatrixExpr [ctor assoc comm prec 30] .
    op __        : MatrixExpr MatrixExpr -> MatrixExpr [ctor assoc prec 25] .
    op __        : Float      MatrixExpr -> MatrixExpr [ctor left id: 1.0 prec 25] .
    op __        : Float      Float      -> Float      [ctor assoc comm prec 25] .
    op _\_       : MatrixExpr MatrixExpr -> MatrixExpr [ctor assoc prec 25] .
    op transpose : MatrixExpr            -> MatrixExpr [ctor] .
    op inverse   : MatrixExpr            -> MatrixExpr [ctor] .

Note that operators are declared to be associative or commutative as keywords in the Maude system.  These attributes are special cased for efficiency's sake.  These operators define a language for expressions like the following expression for least squares linear regression

    inverse(transpose(X) X) transpose(X) y

We then provide a collection of equality transformations like the following
    
    eq inverse(inverse(A)) = A .    
    eq inverse(A) A = I .
    eq A (B + C) = (A B) + (A C) [metadata "Distributive Law"] . 

### Matrix Inference

This set of relations can be greatly increased with the ability to infer matrix properties on large expressions.  In Maude we define a set of predicates

    sorts Predicate, AppliedPredicate, Context .
    subsort AppliedPredicate < Context

    ops symmetric orthogonal invertible positive-definite singular 
        lower-triangular upper-triangular triangular unit-triangular 
        diagaonal tridiagonal : -> Predicate .

    op _is_ : MatrixExpr Predicate -> AppliedPredicate [prec 45].
    op _,_ : Context Context -> Context [metadata "Conjoin two contexts"]

This provides the necessary infrastructure to declare a large set of matrix inference rules like the following example rules for symmetry

    ceq C => X Y is symmetric   = true if C => X is symmetric
                                      and C => Y is symmetric .
    ceq C => transpose(X)     is symmetric = true if C => X is symmetric .
    eq  C => transpose(X) X   is symmetric = true .

`matrix-algebra` contains dozens of such statements

### Matrix Refinement

The language and the inference can be combined to generate a rich set of simplification rules like the following

    ceq inverse(X) = transpose(X) if X is orthogonal

Statements of this form are clear to mathematical experts.  More importantly the set of relations is sufficiently simple so that it can be extended by these same experts without teaching them the underlying system for their application to expression trees.

The meta-programming approach allows the specification of mathematical relations in a math-like syntax, drastically lowering the barrier of entry for potential mathematical developers.  The term-rewrite infrastructure allows these relations to be automatically applied by generic, mature, and computationally efficient strategies.

Unfortunately the Maude system is an exotic dependency in the scientific community and interoperation with low-level computational codes was not a priority in its development.  In Section \ref{sec:matrix-rewriting-sympy} we will attain this same ideal by composing the SymPy and LogPy packages.

