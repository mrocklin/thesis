
## Matching mathematical patterns with LogPy and SymPy

\label{sec:term-rewriting}

We implement a rudimentary pattern matcher using LogPy, a general purpose logic programming library, and SymPy, a computer algebra system.  We chose this approach instead of one of the mature systems mentioned in Section \ref{sec:pattern-previous-work} in order to limit the number of dependencies that are uncommon within the scientific computing ecosystem and in order to leverage and expose existing mathematical expertise.

### Storing Mathematical Patterns

In Section \ref{sec:logpy-sympy-interaction} we specified how LogPy can interact with SymPy terms.

Mathematical rewrite patterns are stored as `(source, target, condition)` tuples of SymPy terms 

~~~~~~~~~~~~Python
patterns = [
    (Abs(x),        x,      Q.positive(x)),
    (exp(log(x)),   x,      Q.positive(x)),
    (log(exp(x)),   x,      Q.real(x)),
    ...    
          ]
~~~~~~~~~~~~

These are later indexed in a LogPy relation.

~~~~~~~~~~~~Python
from logpy import TermIndexedRelation as Relation
from logpy import facts
rewrites = Relation('rewrites')
facts(rewrites, *patterns)
~~~~~~~~~~~~

Note that the definition of the mathematical patterns is pure SymPy.  The injection into a LogPy relation is well isolated.  In the future more mature implementations can replace the LogPy interaction easily without necessitating changes in the mathematical code.  Removing such connections enables components to survive obsolesence of neighboring components.  The `patterns` collection does not depend on the continued use of `LogPy`.  By removing unnecessary connections between modules we avoid "weakest link in the chain" survivability.


### LogPy Execution

We transform SymPy's `ask` function for mathematical inference into a LogPy goal with `goalify` to form `asko`, a goal constructor.  `asko` simply evaluates `ask` on the first parameter and filters a stream so that results match the second parameter.

~~~~~~~~~~~~Python
from logpy import goalify
from sympy import ask
asko = goalify(ask)
~~~~~~~~~~~~

We construct a function to perform a single term rewrite step.  It creates and executes a brief LogPy program, discussed immediately afterwards.

~~~~~~~~~~Python
from logpy import run, lall

def rewrite_step(expr, rewrites):
    """ Possible rewrites of expr given relation of patterns """
    target, condition = var(), var()
    return run(None, target, lall(rewrites(expr, target, condition),
                                      asko(condition, True)))
~~~~~~~~~~

The `run` function asks for a lazily evaluated iterator (`None`) that returns reified values of the variable `target` that satisfy both of the following goals:
    
#### `rewrites(expr, target, condition)`

The LogPy Relation `rewrites` stores facts, in this case our rewrite patterns.  The facts are of the form `(source, target, condition)` and claim that a expression matching `source` can be rewritten as `target` if the boolean expression `condition` holds true.  For example rewrites might contain the facts
    
    (Abs(x),        x,      Q.positive(x))
    (exp(log(x)),   x,      Q.positive(x)),
    (log(exp(x)),   x,      Q.real(x)),

    
By placing the input, `expr`, in the source position we mandate that `expr` must match the `source` of the pattern.  The `rewrites` relation selects the set of potentially matching patterns and produces a stream of matchings.  The `target` and `condition` terms will be reified with these matchings during future computations.

For example if `expr` is the term `Abs(y**2)` then only the first pattern matches.  The logic variables `target` and `condition` reify to `y**2` and `Q.positive(y**2)` respectively.  The second and third patterns do not match because we can unify `Abs` to neither `exp` nor `log`.  In this case only one pattern in our collection yields a valid transformation.

#### `asko(condition, True)`

The `asko` goal further constrains results to those for which the `condition` of the pattern  evaluates to `True` under SymPy's `ask` routine.  This engages SymPy's logic system and the underlying SAT solver.  Through interoperation we gain access to and interact with a large body of pre-existing logic code.

If as above `expr` is `Abs(y**2)` then we ask SymPy if the boolean expression `Q.positive(y**2)` is true.  This might hold if, for example, we knew that the SymPy variable `y` was real and non-zero.  If this is so then we yield the value of `target`, in this case `y**2`; otherwise this function returns an empty iterator.

We return a lazy iterator of all target patterns such that the source pattern matches the input expression and that the condition of the pattern is satisfied.

#### Analysis

While the demands for logic programming and term matching in our problem are significant, interactions between pieces are always limited to just a few lines of code.  

Teaching LogPy to interact with SymPy and computations is a simple exercise.  The need for simultaneous expertise in both projects is brief.  Using LogPy to construct a term rewrite system is similarly brief, only a few lines in the function `rewrite_step`.

By supporting interoperation with preexisting data structures we were able to leverage the preexisting mathematical logic system in SymPy without significant hassle.

The implementation of the `rewrites` Relation determines matching performance.  Algorithmic code is a separate concern and not visible to the mathematical users.
