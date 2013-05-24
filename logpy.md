
LogPy
-----

include [TikZ](tikz_pattern.md)

\label{sec:logpy}

LogPy is a general purpose logic programming library for Python.  It implements a varient of [miniKanren](http://kanren.sourceforge.net/)\cite{byrd}, a language written in a subset of Scheme.  [Comprehensive documentation](http://github.com/logpy/logpy/tree/master/docs)\cite{logpy} is available online.  LogPy adds the additional foci to miniKanren.

1.  Associative Commutative matching
2.  Efficient indexing of relations of expression patterns
3.  Simple composition with pre-existing Python projects

We use LogPy to implement a simple term rewrite system within the scientific Python ecosystem.  Our solution is minimally intrusive and supports interoperation with legacy codes.

The third focus above about ease of composition bears mention.  The majority of logic programming attempts in Python have not acheived penetration due to, I suspect, unrealistic demands on potential interoperation.  They require that any client project use their types/classes within their codebase.  LogPy was developped simultaneously with multiple client projects with large and inflexible pre-existing codebases.  As a result it makes minimal demands for interoperation, significantly increasing its relevance.


### Associative Commutative Matching

LogPy solves the associative commutative matching problem in the following way.

TODO?

### Composition

LogPy was designed for interoperation with legacy codes.  While LogPy traditionally uses trees of tuples to define terms it is also able to interoperate with user-defined types.  LogPy was designed to simultaneously support two computer algebra systems, SymPy and Theano, both of which are sufficiently entrenched to bar the possibility of changing the underlying data structures.

Fundamental functions like `unify`, `reify` and their associative-commutative versions must understand how to interact with these new types.  In fullest generality each function-type pair requires specific treatment.  Unfortunately neither core codebase would permit special introduction of these interactions.  It is not possible to include every potential interaction in LogPy; this solution requires that every client developer has access to the LogPy codebase.  Alternatively standard object oriented solutions on the client side (e.g. implementing a `unify` method for each client class) may not be feasible.

*presumably this is a general problem that has a name*

*is this at all interesting? it's mostly a programming consideration.  I have more written here but I'm not sure it's appropriate.*


### SymPy Interactions

Mathematical patterns are stored as tuples of SymPy terms 

~~~~~~~~~~~~Python
patterns = [
    (Abs(x),        x,      Q.positive(x)),
    (exp(log(x)),   x,      Q.positive(x)),
    (log(exp(x)),   x,      Q.real(x)),
    ...    
          ]
~~~~~~~~~~~~

These can later be injected into a LogPy relation

~~~~~~~~~~~~Python
from logpy import IndexedRelation as Relation
from logpy import facts
rewrites = Relation('rewrites')
facts(rewrites, *patterns)
~~~~~~~~~~~~

This relation stores the patterns for use in logic programs.  It will be discussed in the next section.

Note that the definition of the mathematical patterns used only SymPy and pure Python; the interaction with LogPy is well isolated.  In the future more mature algorithmic solutions can replace the LogPy interaction easily without necessitating changes in the mathematical code.  Removing such connections enables components to survive obsolesence of neighboring components.  We avoid "weakest link in the chain" survivability by removing unnecessary connections between modules.

### Term Rewriting

We use LogPy to construct a Python function to perform a single term rewrite step in SymPy

~~~~~~~~~~Python
from logpy import goalify, run
from sympy import ask
asko = goalify(ask)

def rewrite_step(expr, rewrites):
    """ Possible rewrites of expr given relation of patterns """
    target, condition = var(), var()
    return run(None, target, (rewrites, expr, target, condition),
                             (asko, condition, True))
~~~~~~~~~~

The `run` function asks for a lazily evaluated iterator (`None`) that returns reified values of the variable `target` that satisfy the following goals:
    
#### `(rewrites, expr, target, condition)`

The LogPy Relation `rewrites` stores facts, in this case our rewrite patterns.  Our facts are that one term can rewrite to another under a condition.  This is stored internally as a `(source, target, condition)` tuple like `(Abs(x), x, Q.positive(x))`.  By placing the input, `expr`, in the source position we mandate that `expr` must unify to the `source` of the pattern (e.g. `Abs(x)`).  The `target` and `condition` patterns are then reified with the matching that results from the `expr--source` unification.  

For example if `expr` is `Abs(y**2)` then `target` reifies to `y**2` and `condition` reifies to `Q.positive(y**2)`.

#### `(asko, condition, True)`

The `asko` goal constrains results to those for which the `condition` of the pattern  (generally `Q.positive(x)`, in our example `Q.positive(y**2)`) evaluates to `True` under SymPy's `ask` routine.  This engages SymPy's logic system and the underlying SAT solver.  Through interoperation we gain access to and interact with a large body of pre-existing logic code.

We return a lazy iterator of all target patterns such that the source pattern matches the input expression and that the condition of the pattern is satisfied.


### Analysis

While the demands for logic programming and term matching in our problem are significant, interactions between pieces are always limited to just a few lines of code.  

Teaching LogPy to interact with SymPy and `computations` is a simple exercise.  The need for simultaneous expertise in both projects is brief.  Using LogPy to construct a term rewrite system is similarly brief, only a few lines in the function `rewrite_step`.

The implementation of the `rewrites` Relation determines matching performance.  Algorithmic code is a completely separate concern and not visible to the mathematical users.

