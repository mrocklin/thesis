
LogPy
-----

include [TikZ](tikz_pattern.md)

\label{sec:logpy}

LogPy is an implementation of [miniKanren](http://kanren.sourceforge.net/)\cite{byrd}, a general purpose logic programming language, in Python.  [Comprehensive documentation](http://github.com/logpy/logpy/tree/master/docs)\cite{logpy} is available online.  We use LogPy to implement a rudimentary term rewrite system within the scientific Python ecosystem.  Our solution is minimally intrusive and supports interoperation with legacy codes.

Our implementation adds the additional foci

1.  Associative Commutative matching
2.  Efficient indexing of relations of expression patterns
3.  Composability with pre-existing Python projects

The first two have mature implementations elsewhere; my work here is largely in implementation.  

The third point of ease of composability bears mention.  The majority of logic programming attempts in Python have not acheived penetration due to, I suspect, unrealistic demands on potential interoperation.  They require that any client project use their types/classes within their codebase.  LogPy was developped simultaneously with multiple client projects with large and inflexible pre-existing codebases.  As a result it makes minimal demands for interoperation, significantly increasing its relevance.  


### Associative Commutative Matching

LogPy solves the associative commutative matching problem in the following way.

TODO?

### Composability

LogPy was designed for interoperation with legacy codes.  While LogPy traditionally uses trees of tuples to define terms it is also able to interoperate with user-defined types.  LogPy was designed to simultaneously support two computer algebra systems, SymPy and Theano, both of which are sufficiently entrenched to bar the possibility of changing the underlying data structures.

Fundamental functions like `unify`, `reify` and their associative-commutative versions must understand how to interact with these new types.  In fullest generality each function-type pair requires specific treatment yet neither core codebase would permit special introduction of these interactions.  It is not possible to include every potential interaction in LogPy; this solution requires that every client developer has access to the LogPy codebase.  Alternatively standard object oriented solutions on the client side (e.g. implementing a `unify` method for each client class) may not be feasible.

*presumably this is a general problem that has a name*

#### Interactions by Type -- Methods

We can store the function-type interactions as methods on the class.  In particular LogPy functions look for and use `_as_tuple` and `_from_tuple` methods if they exist.  This is the traditional object oriented solution.  We believe that these two methods are the minimum necessary interaction between the class and LogPy.

Additionally, in the case of raw Python objects we provide generic methods.  A Python object can, in the common case, be fully described by its class, which contains all methods/functions, and its `__dict__` attribute, which contains all fields.  Both of these datatypes can be handled natiely by LogPy.

~~~~~~~~~~Python
def _as_tuple(self):
    return (type(self), self.__dict__)

def _from_tuple((cls, attributess)):
    obj = object.__new__(cls)
    obj.__dict__.update(attributes)
    return obj
~~~~~~~~~~

#### Interactions by Type without Permission -- Methods and Metaprogramming

\label{sec:logpy-computations-interaction}

It may be difficult to add these methods to the client source code directly.  Pre-existing codebases may be inaccessible or mature projects may resist even slight changes to core data structures.  Fortuntely the permissivity of Python enables users to add these methods *after* code has been imported.

Here we register the above functions `_as_tuple` and `_From_tuple` to a generic Python class.

~~~~~~~~~~Python
def register(cls):
    cls._as_tuple = _as_tuple
    cls._from_tuple = staticmethod(_from_tuple)
~~~~~~~~~~

Below we show the necessary code to affect the `Computation` classes presented in \ref{sec:computations}.

~~~~~~~~~~Python
from computations.core import Computation, CompositeComputation, Identity

Computation._as_tuple = lambda self: (type(self), self.inputs, self.outputs)
Identity._as_tuple = lambda self: (type(self), self.inputs)
CompositeComputation._as_tuple = lambda self: (type(self),) + self.computations

Computation._from_tuple = staticmethod(lambda (t, ins, outs): t(ins, outs))
Identity._from_tuple = staticmethod(lambda (t, ins): t(ins))
CompositeComputation.from_tuple = staticmethod(lambda tup: tup[0](*tup[1:]))
~~~~~~~~~~

#### Interactions by function - Protocols

In rare cases affecting the client types may be alltogether disallowed.  This occurs for built-in types like `dict` and `slice` and when client code depends on introspection of their classes.  For these cases we explicitly create registries for methods to `unify` and `reify` various types.  In this sense we index function-type pairs first by the function (e.g. `unify`) then by type (e.g. `dict`).  

*Is this worth discussing?*

#### Interactions with Associative/Commutivity

Associative-Commutative code assumes that the head of each tuple is the operator while the tail is a set of arguments.  Associative and commutative checks are done by consulting specific LogPy relations.  

The following code asserts that the class `CompositeComputation` may be treated as an associative commutative operator.

~~~~~~~~~~Python
from logpy import fact
from logpy.assoccomm import commutative, associative

fact(commutative, CompositeComputation)
fact(associative, CompositeComputation)
~~~~~~~~~~

### Term Rewriting

We use LogPy to construct a Python function to perform a single term rewrite step in SymPy

~~~~~~~~~~Python
from logpy.goals import goalify
from sympy import ask
asko = goalify(ask)

def rewrite_step(expr, rewrites):
    """ Possible rewrites of expr given relation of patterns """
    target, condition = var(), var()
    return run(None, target, (rewrites, expr, target, condition),
                             (asko, condition, True))
~~~~~~~~~~

The `run` function asks for a lazily evaluated iterator (`None`) that returns reified values of the variable `target` that satisfy the following two conditions:
    
    (rewrites, expr, target, condition)

`rewrites`, a LogPy `Relation`, stores facts.  Our facts are that one term can rewrite to another under a condition.  This is stored internally as a `(source, target, condition)` tuple like `(Abs(x), x, Q.positive(x))`.  By placing the input, `expr`, in the source position we mandate that `expr` must unify to the `source` of the pattern (e.g. `Abs(x)`).  The `target` and `condition` patterns are then reified with the matching that results from the `expr--source` unification.  

    (asko, condition, True)

The `asko` goal constrains results to those for which the `condition` of the pattern  (e.g. `Q.positive(x)`) evaluates to `True` under SymPy's `ask` routine.

We return a lazy iterator of all target patterns such that the source pattern matches the input expression and that the condition of the pattern is satisfied.

### Analysis

While the demands for logic programming and term matching in our problem are significant, interactions between pieces are always limited to just a few lines of code.  

Teaching LogPy to interact with SymPy and `computations` is a simple exercise, restricted to only a few lines of code to define `_as_tuple` and `_from_tuple` methods as in section \ref{sec:logpy-computations-interaction}.  The need for simultaneous expertise in both projects is brief.  Using LogPy to construct a term rewrite system is similarly brief, only a few lines in the function `rewrite_step`

The implementation of the `rewrites` Relation determines matching performance.  Algorithmic code is a completely separate concern and not visible to the mathematical users.

The mathematical patterns can be stored separately as a list of straight Python tuples 

~~~~~~~~~~~~Python
patterns = [(Abs(x),    x,      Q.positive(x)),
            (x + 0,     x,      True), 
            ... ]
~~~~~~~~~~~~

These can later be injected into a LogPy relation

~~~~~~~~~~~~Python
from logpy import IndexedRelation as Relation
from logpy import facts
rewrites = Relation('rewrites')
facts(rewrites, *patterns)

options = rewrite_step(expr, rewrites)
...
~~~~~~~~~~~~

And so we have not tied the mathematics to the choice of using LogPy.  In the future more mature algorithmic solutions can replace it without necessitating changes in mathematical code.  Removing such connections enables components to survive obsolesence of neighboring components.  We avoid "weakest link in the chain" survivability by removing unnecessary connections between modules.
