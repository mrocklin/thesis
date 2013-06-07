
### Implementing a Term Rewrite System in LogPy

We implement a rudimentary term rewrite system in LogPy, a general purpose logic programming library for Python.  We chose this approach instead of one of the mature systems mentioned in Section \ref{sec:pattern-previous-work} in order to limit the number of dependencies that are uncommon within the scientific computing ecosystem.

We use LogPy to implement a simple term rewrite system within the scientific Python ecosystem.  Our solution is minimally intrusive and supports interoperation with legacy codes.


\label{sec:term-rewriting}

We use LogPy to construct a Python function to perform a single term rewrite step in SymPy

~~~~~~~~~~Python
from logpy import goalify, run
from sympy import ask
asko = goalify(ask)

def rewrite_step(expr, rewrites):
    """ Possible rewrites of expr given relation of patterns """
    target, condition = var(), var()
    return run(None, target, rewrites(expr, target, condition),
                             asko(condition, True))
~~~~~~~~~~

The `run` function asks for a lazily evaluated iterator (`None`) that returns reified values of the variable `target` that satisfy the following goals:
    
#### `rewrites(expr, target, condition)`

The LogPy Relation `rewrites` stores facts, in this case our rewrite patterns.  The facts are of the form `(source, target, condition)` and claim that a expression matching `source` can be rewritten as `target` if the boolean expression `condition` holds true.  For example rewrites might contain the facts
    
    (Abs(x),        x,      Q.positive(x))
    (exp(log(x)),   x,      Q.positive(x)),
    (log(exp(x)),   x,      Q.real(x)),

    
By placing the input, `expr`, in the source position we mandate that `expr` must match the `source` of the pattern.  The `rewrites` relation selects the set of potentially matching patterns and produces a stream of matchings.  The `target` and `condition` terms will be reified with these matchings during future computations.

For example if `expr` is the term `Abs(y**2)` then only the first pattern matches.  The logic variables `target` and `condition` reify to `y**2` and `Q.positive(y**2)` respectively.  The second and third patterns do not match because we can unify `Abs` to neither `exp` nor 'log'.  In this case only one pattern in our collection yields a valid transformation.

#### `asko(condition, True)`

The `asko` goal further constrains results to those for which the `condition` of the pattern  evaluates to `True` under SymPy's `ask` routine.  This engages SymPy's logic system and the underlying SAT solver.  Through interoperation we gain access to and interact with a large body of pre-existing logic code.

If as above `expr` is `Abs(y**2)` then we ask SymPy if the boolean expression `Q.positive(y**2)` is true.  This might hold if, for example, we knew that the SymPy variable `y` was real and non-zero.  If this is so then we yield the value of `target`, in this case `y**2`.

We return a lazy iterator of all target patterns such that the source pattern matches the input expression and that the condition of the pattern is satisfied.

#### Analysis

While the demands for logic programming and term matching in our problem are significant, interactions between pieces are always limited to just a few lines of code.  

Teaching LogPy to interact with SymPy and `computations` is a simple exercise.  The need for simultaneous expertise in both projects is brief.  Using LogPy to construct a term rewrite system is similarly brief, only a few lines in the function `rewrite_step`.

By supporting interoperation with preexisting data structures we were able to leverage the preexisting mathematical logic system in SymPy without significant hassle.

The implementation of the `rewrites` Relation determines matching performance.  Algorithmic code is a completely separate concern and not visible to the mathematical users.
