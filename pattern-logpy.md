
## Mathematical Rewriting - LogPy and SymPy 

\label{sec:logpy-sympy}
\label{sec:pattern-logpy}

We implement a rudimentary mathematical pattern matcher by composing LogPy, a general purpose logic programming library, and SymPy, a computer algebra system.  We chose this approach instead of one of the mature systems mentioned in Section \ref{sec:pattern-previous-work} in order to limit the number of dependencies that are uncommon within the scientific computing ecosystem and in order to leverage and expose existing mathematical expertise already within SymPy.

### LogPy Manipulates SymPy Terms

Recall that LogPy supports the `term` interface discussed in Section \ref{sec:term}.

We now impose the `term` interface on SymPy classes so that LogPy can manipulate SymPy terms.  This happens outside of the SymPy codebase.  We do this with the following definitions of the `_term_xxx` methods:

~~~~~~~~~~Python
from sympy import Basic
Basic._term_op      = lambda self: self.func
Basic._term_args    = lambda self: self.args
Basic._term_new     = classmethod(lambda op, args: op(*args))
Basic._term_isleaf  = lambda self: len(self.args) == 0
~~~~~~~~~~

We do not invent a new term language for this term rewrite system.  Rather, we reuse the existing language from the SymPy computer algebra system; mathematics is not reinvented within the logic programming system.


### Storing Mathematical Patterns

A rewrite rule can be specified by a source, target, and condition terms.  These are specified with SymPy terms.  For example the following transformation can be specified with the following tuple:

$$\log(\exp(x)) \rightarrow x \;\;\; \forall x \in \mathbb{R}$$

    ( log(exp(x)),       x,      Q.real(x) )

For a particular theory we may store a large collection of these

~~~~~~~~~~~~Python
patterns = [
    (Abs(x),            x,      Q.positive(x)),
    (exp(log(x)),       x,      Q.positive(x)),
    (log(exp(x)),       x,      Q.real(x)),
    (log(x**y),     y*log(x),   True),
    ...    
          ]

vars = {x, y}
~~~~~~~~~~~~

These are later indexed in a LogPy relation.

~~~~~~~~~~~~Python
from logpy import TermIndexedRelation as Relation
from logpy import facts
rewrites = Relation('rewrites')
facts(rewrites, *patterns)
~~~~~~~~~~~~

Note that the definition of the mathematical patterns depends only on SymPy.  The injection into a LogPy relation is well isolated.  In the future more mature implementations can replace the LogPy interaction easily without necessitating changes in the mathematical code.  Removing such connections enables components to survive obsolesence of neighboring components.  The `patterns` collection does not depend on the continued use of `LogPy`.  By removing unnecessary connections between modules we avoid "weakest link in the chain" survivability.


### LogPy Execution

We transform SymPy's `ask` function for mathematical inference into a LogPy goal with `goalify` to form `asko`, a goal constructor.  `asko` simply evaluates `ask` on the first parameter and filters a stream so that results match the second parameter.

~~~~~~~~~~~~Python
from logpy import goalify
from sympy import ask
asko = goalify(ask)
~~~~~~~~~~~~

We construct a function to perform a single term rewrite step.  It creates and executes a brief LogPy program, discussed immediately afterwards.

~~~~~~~~~~Python
include [rewrite_step.py](rewrite_step.py)
~~~~~~~~~~

The `run` function asks for a lazily evaluated iterator (`None`) that returns reified values of the variable `target` that satisfy both of the following goals:
    
#### `rewrites(expr, target, condition)`

The LogPy Relation `rewrites` stores facts, in this case our rewrite patterns.  The facts are of the form `(source, target, condition)` and claim that an expression matching `source` can be rewritten as the `target` expression if the boolean expression `condition` holds true.  For example rewrites might contain the following facts
    
    (Abs(x),            x,      Q.positive(x)),
    (exp(log(x)),       x,      Q.positive(x)),
    (log(exp(x)),       x,      Q.real(x)),
    (log(x**y),     y*log(x),   True),

    
By placing the input, `expr`, in the source position we mandate that `expr` must unify with the `source` of the pattern.  The `rewrites` relation selects the set of potentially matching patterns and produces a stream of matching substitutions.  The `target` and `condition` terms will be reified with these matchings during future computations.

For example if `expr` is the term `Abs(y**2)` then only the first pattern matches because the operations `exp` and `log` can not unify to `Abs`.  The logic variables `target` and `condition` reify to `y**2` and `Q.positive(y**2)` respectively.  In this case only one pattern in our collection yields a valid transformation.

#### `asko(condition, True)`

The `asko` goal further constrains results to those for which the `condition` of the pattern  evaluates to `True` under SymPy's `ask` routine.  This engages SymPy's logic system and the underlying SAT solver.  Through interoperation we gain access to and interact with a large body of pre-existing logic code.

If as above `expr` is `Abs(y**2)` and `x` matches to `y**2` then we ask SymPy if the boolean expression `Q.positive(y**2)` is true.  This might hold if, for example, we knew that the SymPy variable `y` was real and non-zero.  If this is so then we yield the value of `target`, in this case `y**2`; otherwise this function returns an empty iterator.

Finally we return a lazy iterator of all target patterns such that the source pattern matches the input expression and that the condition of the pattern is satisfied.

#### Analysis

Interactions between mathematical, logical, and algorithmic pieces of our solution are limited to a few lines of code.  Simultaneous expertise is only rarely necessary.

Teaching LogPy to interact with SymPy is a simple exercise.  The need for simultaneous expertise in both projects is brief.  Using LogPy to construct a term rewrite system is similarly brief, only a few lines in the function `rewrite_step`.

By supporting interoperation with preexisting data structures we were able to leverage the preexisting mathematical logic system in SymPy without significant hassle.

The implementation of the `rewrites` Relation determines matching performance.  Algorithmic code is a separate concern and not visible to the mathematical users.

include [Matrix Rewriting in SymPy](matrix-rewriting-sympy.md)
