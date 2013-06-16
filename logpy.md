
LogPy
-----

include [TikZ](tikz_pattern.md)

\label{sec:logpy}

LogPy is a general purpose logic programming library for Python.  It implements a varient of [miniKanren](http://kanren.sourceforge.net/)\cite{byrd2010}, a language originally implemented in a subset of Scheme.  [Comprehensive documentation](http://github.com/logpy/logpy/tree/master/docs)\cite{logpy} for LogPy is available online.  

The construction of LogPy was motivated by duplicated efforts in SymPy and Theano, two computer algebra systems in Python.  Both SymPy and Theano built special purpose modules to define and apply optimiations to their built-in mathematical and computational data structures.  LogPy aims to replace these modules.

This context motivates the following developments onto miniKanren.

1.  Associative Commutative matching
2.  Support for matching against many patterns
3.  Simple composition with pre-existing Python projects


### Basic Design - Goals

LogPy programs are built up of *goals*.  Goals produce and manage streams of substitutions.

    goal :: substitution -> [substitution]

#### Example
    
    >>> x = var('x')
    >>> a_goal = eq(x, 1)

This goal uses `eq`, a goal constructor, to require that the logic variable `x` unifies to `1`.  As previously mentioned goals are functions from single substitutions to sequences of substitutions.  In the case of `eq` this stream has either one or zero elements

    >>> a_goal({})      # require no other constraints
    ({~x: 1},)
    >>> a_goal({x: 2})  # require that x maps to 2 and that eq(x, 1)
    ()

### Basic Design - Goal Combinators

LogPy provides logical goal combinators to manage the union and intersection of streams.

#### Example

We specify that $x \in \{1, 2, 3\}$ and that $x \in \{2, 3, 4\}$ with the goals `g1` and `g2` respectively.

    >>> g1 = membero(x, (1, 2, 3))
    >>> g2 = membero(x, (2, 3, 4))

    >>> for s in g1({}):
    ...     print s
    {~x: 1}
    {~x: 2}
    {~x: 3}

To find all substitutions that satisfy *both* goals we can feed each element of one stream into the other.  

    >>> for s in g1({}):
    ...     for ss in g2(s):
    ...         print ss
    {~x: 2}
    {~x: 3}

Logic programs can have many goals in complex hierarchies.  Writing explicit for loops quickly becomes tedious.  Instead LogPy provides functions to combine goals logically.  

    combinator :: [goals] -> goal

Two important logical goal combinators are logical all `lall` and logical any `lany`.

    >>> for s in lall(g1, g2)({}):
    ...     print s
    {~x: 2}
    {~x: 3}
    
    >>> for s in lany(g1, g2)({}):
    ...     print s
    {~x: 1}
    {~x: 2}
    {~x: 3}
    {~x: 4}


### Composition

LogPy is designed to interoperate with legacy Python codes.  

A programming language operates on a language of terms.  In traditional logic programming languages like Prolog this term language is custom-built for and included within the logic programming system, enabling tight integration between terms and computational infrastructure.  However a custom term language limits interoperability with other term-based systems (like computer algebra systems).  miniKanren, the language implemented by LogPy, resolves this problem by describing terms with simple s-expressions, enabling broad interoperation with projects within its intended host language, Scheme.  While LogPy supports the manipulation of s-expressions (using Python tuples) this choice is not natural within the Python ecosystem.

S-expressions are not idiomatic within the Python ecosystem and few projects (if any) define terms in this way.  Other logic programming systems in Python (do I need software citations here?) create custom classes both for logic variables and compound terms which operate well within their own infrastructure but do not adhere to any standard interface.  The intended object oriented approach is for client projects to subclass these logic programming classes if they want to interoperate with the logic programming system.

This approach does not easily enable composition with legacy codes.  LogPy is designed to interoperate with legacy systems where changing the client codebases to subclass from logic classes is not an option.  In particular LogPy was designed to simultaneously support two computer algebra systems, SymPy and Theano.  Both of these projects are sufficiently entrenched to bar the possibility of changing the underlying data structures.  This application constraint forced a design which makes minimal demands for interoperation; easy of composition is a core tenet.  We believe that this is a significant contribution of this project.

*LogPy is not intended to work with its own term syntax.  Instead it supports interoperation with domain specific term languages*.  This thesis discusses a computer algebra term rewrite system.  The term language is taken directly from the SymPy computer algebra system; mathematics is not reinvented within the logic programming system.

To achieve interoperation we need to know how to do the following:

1.  `unify` and `reify` against client types
2.  Identify logic variables (TODO: miniKanren uses this term - John says to use meta-variable)

#### `unify` and `reify`

To be useful in a client codebase we must specify how to `unify` and `reify` objects of the client's types.  We provide the following two options:

*   Rogue Methods - Using Python's permissive type system we attach `_as_logpy(self)`  and `_from_logpy(data)` methods onto client classes *after* import time.
*   Protocols - we create, add to, and check a global registry of `unify` and `reify` functions.  Internally we provide double and single dispatch on type for `unify` and `reify` respectively.

The first approach of rogue methods is simple and effective, if perhaps slightly caustic.  The method `_as_logpy` transforms the client object into types that LogPy can handle natively, notably `tuple`s and `dict`s.  Because most Python objects can be completely defined by their type and attribute dictionary the following methods are usually sufficient for any Python object that doesn't use advanced features.

~~~~~~~~~~~Python
def _as_logpy(self):
    return (type(self), self.__dict__)

def _from_logpy((typ, data)):
    obj = object.__new__(typ)
    obj.__dict__.update(data)
    return obj
~~~~~~~~~~~

These methods can then be attached *after* client code has been imported

~~~~~~~~~~~Python
def logify(cls):
    cls._as_logpy = _as_logpy
    cls._from_logpy = staticmethod(_from_logpy)

from client_code import ClientClass
logify(ClientClass)
~~~~~~~~~~~

In this way any Python object may be regarded as a compound term and manipulated by LogPy.  We provide a single `logify` function to mutate classes defined under the standard object model.  In operation we provide a more complex function to handle common variations from the standard model (e.g. the use of `__slots__`)

This approach builds up an interface in the following way.  LogPy handles terms built up of tuples and dictionaries natively.  As we have just seen a standard Python object may be expanded into a compound term using tuples and dicts.  We can mark those classes which we want to treat as operators in a logic programming sense using the `logify` function; otherwise objects are treated as constants or as variables (see next section for discussion of variables.)  Python inheritance is hijacked to mark broad sets of operations (e.g. `ClientSubClass` also has the methods `_as_logpy`, and `_from_logpy`.

Note that the Python objects themselves are traversed, not a translation (we do not call `_as_logpy` exhaustively before the logic program executes.)  Keeping the objects intact enables users to debug their code with familiar data structures and enables the use of client code *within* the logic program.


#### Variable identification

Logic variables (TODO: meta variables) denote subterms that can match any other term.  Traditionally logic variables are identified by their type.  Python objects of the class `logpy.Var` are considered to be logic variables.  However interaction with user defined classes may require the injection of a logic variable as an attribute in an arbitrary Python object.  It is possible that that object will perform checks that reject the inclusion of a LogPy `Var`.  For example in user-written code for an Account object it is feasible that a balance attribute will be checked to be of type `float`.  To match against a balance we need some way to make a `float` a logic variable.

To resolve this issue we rely on a carefully managed set of global variables.  We make unique and rare values (e.g. `-9999.9`) and place them in a globally accessible collection.  Membership in this collection connotes logic variable.  To avoid the normal confusion caused by global collections we manage this set with Python context managers/coroutines.

~~~~~~~~~~~~~~Python
_logic_variables = set()

@contextmanager
def variables(*variables):
    old = _logic_variables.copy()            # Save old set
    _logic_variables.update(set(variables))  # Inject new variables

    yield                                           # Yield control to `with` block

    _logic_variables.clear()                 # Delete current set
    _logic_variables.update(old)             # Load old set
~~~~~~~~~~~~~~

In the example below we fin the name of the account-holder with 100 dollars.  The generic Python string "NAME" is used as a logic variable.
The `variables` context manager places `"NAME"` into a global collection and then yields control to the code within the subsequent block.  Code within that block is executed and queries this collection.  Membership in the collection equivalent to being a logic variable.  After the completion of the `with variables` block the global collection is reset to its original value, commonly the empty set.  This allows the use of arbitrarily typed values as logic variables, further enabling interoperation.

~~~~~~~~~~~~~~Python
>>> from logpy import logify, variables, run, membero
>>> from bank import Account
>>> logify(Account)

>>> accts = [Account(name="Alice", balance=100),
             Account(name="Bob"  , balance=70)]

>>> query =  Account(name="NAME",  balance=100)
>>> vars = ["NAME"]

>>> with variables(*vars):
...     print run(1, "NAME", membero(query, accts))
(Alice,)
~~~~~~~~~~~~~~

Logpy is able to seemlessly interoperate with a generic client code with little setup.
