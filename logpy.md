
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

LogPy is designed to interoperate with legacy Python codes.  While LogPy traditionally uses trees of tuples to define terms it is also able to interoperate with user-defined types.  LogPy was designed to simultaneously support two computer algebra systems, SymPy and Theano.  Both of these projects are sufficiently entrenched to bar the possibility of changing the underlying data structures.  

While several logic programming projects exist in the Python each requires client projects to adopt specific logic variable types.  LogPy makes no such requirement.  LogPy was developed simultaneously with multiple client projects with large and inflexible pre-existing codebases.  As a result it makes minimal demands for interoperation, significantly increasing its relevance. 

To achieve interoperation we need to know how to do the following:

1.  `unify` and `reify` against client types
2.  Identify logic variables

#### `unify` and `reify`

To be useful in a client codebase we must specify how to `unify` and `reify` objects of the client's types.  We provide the following two options:

*   Rogue Methods - Using Python's permissive type system we attach `_as_logpy(self)`  and `_from_logpy(data)` methods onto client classes *after* import time.
*   Protocols - we create, add to, and check a global registry of `unify` and `reify` functions.  Internally we provide double and single dispatch on type for `unify` and `reify` respectively.

The first approach of rogue methods is simple and effective, if perhaps slightly caustic.  The method `_as_logpy` transforms the client object into types that LogPy can handle natively, notably `tuple`s and `dict`s.  Because most Python objects can be completely defined by their type and attribute dictionary the following methods are usually sufficient for any Python object that doesn't use advanced features.

    def _as_logpy(self):
        return (type(self), self.__dict__)

    def _from_logpy((typ, data)):
        obj = object.__new__(typ)
        obj.__dict__.update(data)
        return obj

These methods can then be attached *after* client code has been imported

    >>> from client_code import ClientClass
    >>> ClientClass._as_logpy = _as_logpy
    >>> ClientClass._from_logpy = staticmethod(_from_logpy)

In this way any Python object may be regarded as a term and manipulated by LogPy


#### Variable identification

Logic variables denote subterms that can match any other term.  In traditional LogPy programs they are identified as objects of the class `logpy.Var`.  Interation with client codes requires that attributes of client objects also be considered as logic variables. If client codes type-check inputs they may reject the inclusion of LogPy `Var`s as attributes within their objects.

To resolve this issue we rely on a carefully managed set of global variables.  To avoid the normal confusion caused by global collections we manage this set with Python context managers.

~~~~~~~~~~~~~~Python
>>> from bank import Account
>>> acct    = Account(name="Alice", id=123)   # A user defined object
>>> pattern = Account(name="NAME",  id=-1)

>>> with variables("NAME", -1):
...     print run(1, "NAME", eq(pattern, acct))
(Alice,)
~~~~~~~~~~~~~~

The `variables` context manager places `"NAME"` and `-1` into a global collection and then yields control to the code within the subsequent block.  Code within that block is executed and queries this collection.  Membership in the collection equivalent to being a logic variable.  After the completion of the `with variables` block the global collection is reset to its original value, commonly the empty set.


### Example - SymPy Interaction

\label{sec:logpy-sympy-interaction}

LogPy can be trained to interact with SymPy terms with the following code

~~~~~~~~~~~~~~Python
def _as_logpy(self):
    return (self.func, self.args)

def _from_logpy((func, args)):
    return func(*args)

from sympy import Basic
Basic._as_logpy = _as_logpy
Basic._from_logpy = staticmethod(_from_logpy)
~~~~~~~~~~~~~~

