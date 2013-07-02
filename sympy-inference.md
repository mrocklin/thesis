
## SymPy Inference

\label{sec:sympy-inference}

### Problem description

We often want to test whether algebraic statements are true or not in a general case.  For example, 

*Given that $x$ is a natural number and that $y$ is real, is $x + y^2$  positive?*

To create a system to pose and answer these questions we need the following pieces 

1.  A set of predicates 

    *positive* and *real*

2.  A syntax to pose facts and queries

    Given that $x$ is positive, is $x+1$ positive?

2.  A set of relations between pairs of predicates.  

    $x$ is a natural number implies that $x$ is positive.

3.  A set of relations between predicates and operators

    The addition of positive numbers is positive or

    The square of a real number is positive

4.  A solver for satisfiability given the above relations


### Implementation in SymPy

#### A set of predicates

A set of predicates is collected inside the singleton object, `Q`

    Q.positive
    Q.real
    ....

These Python objects serve only as literal terms.  They contain no logic on their own.

#### A syntax for posing queries

Predicates may be applied to SymPy Expressions. 

    context = Q.positive(x)
    query   = Q.positive(x + 1)

The user interface for query is the `ask` function

    >>> ask(query, context)
    True

#### Predicate-Predicate Relations

\label{sec:sympy-inference-predicate-predicate}

A set of predicate relations is stated declaratively in the following manner

    Implies(Q.natural, Q.integer)
    Implies(Q.integer, Q.real)
    Implies(Q.natural, Q.positive)

For efficiency forward chaining from these axioms is done at code-distribution time and lives in a generated file in the source code, yielding a second set of generated implications that contains, for example

    Implies(Q.natural, Q.real)

#### Predicate-Operator Relations

\label{sec:sympy-inference-predicate-operator}

The relationship between predicates and operators is described by low-level Python functions.  These are organized into classes of static methods.  Classes are indexed by predicate and methods are indexed by operator name.  Logical relations are encoded in straight Python.  For example

~~~~~~~~~~Python
class AskPositiveHandler(...):
    @staticmethod
    def Add(expr, assumptions):
        """ An Add is positive if all of its arguments are positive """
        if all(ask(Q.positive(arg, assumptions) for arg in expr.args)):
            return True
~~~~~~~~~~


#### Testing for Satisfiability

TODO: Determine how relations are used

SymPy assumptions relies on the [Davis–Putnam–Logemann–Loveland](http://en.wikipedia.org/wiki/DPLL_algorithm) algorithm for solving the CNF-SAT problem.  This algorithm is separable from the rest of the codebase.  This solver accesses the predicate-predicate and predicate-operator relations defined above.

The separation of the SAT solver enables the mathematical code to be very declarative in nature.  This system is trivial to extend.
