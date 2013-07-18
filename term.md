
Term
----

\label{sec:term}

Term rewrite systems generally operate on a specific language of terms.  In traditional logic programming languages like Prolog this term language is custom-built for and included within the logic programming system, enabling tight integration between terms and computational infrastructure.  However a custom term language limits interoperation with other term-based systems (like computer algebra systems).  Systems like miniKanren resolve this problem by describing terms with simple s-expressions, enabling broad interoperation with projects that use that same representation within its intended host language, Scheme.  

S-expressions are not idiomatic within the Python ecosystem and few projects define terms in this way.  The intended object oriented approach to this problem is to create an interface class and have client classes implement this interface if they want to interoperate with term manipulation codes.

Unfortunately the Python ecosystem lacks a common interface for term representation in the standard sense.  The lowest common shared denominator is the Python `object`.


### Interface

`Term` is a Python library to establish such an interface for terms.  It provides the following functions:

Function     Type                           Description              
------------ -----------------------------  ------------------------------
`op`         `term -> operator`             The operator of a term
`args`       `term -> [term]`               The children or arguments of a term
`new`        `operator, [term] -> term`     Construct a new term
`isleaf`     `term -> bool`                 Is this term a leaf?
`isvar`      `term -> bool`                 Is this term a meta-variable?

These functions serve as a general interface.  Client codes must somehow implement this interface for their objects.  Utility codes can build functionality from these functions. 

The `term` library also provides utility functions for search and unification. 


### Composition

In Python most systems that manipulate terms (like existing logic programming projects) create an interface which must be inherited by objects if they want to use the functionality of the system.  This approach requires both foresight and coordination with the client projects.  It is difficult to convince project organizers to modify their code, particularly if that code is pre-existing and well entrenched.

Term was designed to interoperate with legacy systems where changing the client codebases to subclass from `term` classes is not an option.  In particular, `term` was designed to simultaneously support two computer algebra systems, SymPy and Theano.  Both of these projects are sufficiently entrenched to bar the possibility of changing the underlying data structures.  This application constraint forced a design which makes minimal demands for interoperation; ease of composition is a core tenet.

To achieve interoperation we need to know how to do the following:

1.  Implement the `new, op, args, isleaf` interface for a client object 
2.  Identify meta variables with `isvar`

#### `new, op, args, isleaf`

To be useful in a client codebase we must specify how to interact with client types as terms.  These can be added after code import time in two ways:

*   Dispatch on global registries
*   Dynamic manipulation of client classes (monkey patching)

The functions `new, op, args, and isleaf` query appropriate global registries and search for the methods `_term_new`, `_term_op`, `_term_args`, `_term_isleaf` on their input objects.  These method names are intended to be monkey-patched onto client classes if they do not yet exist.  This patching is done dynamically at runtime.  This patching is possible after import time only due to Python's permissive and dynamic object model.  This practice is dangerous in general only if other projects use the same names.

Because most Python objects can be completely defined by their type and attribute dictionary the following methods are usually sufficient for any Python object that doesn't use advanced features.

~~~~~~~~~~~Python
def _term_op(term):
    return type(term)

def _term_args(term):
    return term.__dict__

def _term_new(op, args):
    obj = object.__new__(op)
    obj.__dict__.update(args)
    return obj
~~~~~~~~~~~

These methods can then be attached after client code has been imported:

~~~~~~~~~~~Python
def termify(cls):
    cls._term_op    = _term_op
    cls._term_args  = _term_args
    cls._term_new   = classmethod(_term_new)

from client_code import ClientClass
termify(ClientClass)  # mutation
~~~~~~~~~~~

In this way any Python object may be regarded as a compound term.  We provide a single `termify` function to mutate classes defined under the standard object model.  Operationally we provide a more comprehensive function to handle common variations from the standard model (e.g. the use of `__slots__`)

Note that the Python objects themselves are traversed, not a translation (we do not call `_term_op, _term_args` exhaustively before execution.)  Keeping the objects intact enables users to debug their code with familiar data structures and enables the use of client code *within* term traversals.  This method will be useful later when we leverage SymPy's existing mathematical inference system within an external logic program.


#### Variable identification -- `isvar`

Meta variables denote sub-terms that can match any other term.  Within existing Python logic programming projects meta variables are traditionally identified by their type.  Python objects of the class `term.Var` are considered to be meta-variables.  However, interaction with user defined classes may require the injection of a meta-variable as an attribute into an arbitrary Python object.  It is possible that that object will perform checks that reject the inclusion of a `term.Var` object.  For example, in user-written code for an Account object it is feasible that a balance attribute will be checked to be of type `float`.  To match against a balance we need some way to make a `float` a meta-variable.

To resolve this issue we rely on a carefully managed set of global variables.  We make unique and rare values (e.g. `-9999.9`) and place them in a globally accessible collection.  Membership in this collection connotes meta-variable-ness.  To avoid the normal confusion caused by global collections we manage this set with Python context managers/coroutines.

~~~~~~~~~~~~~~Python
_meta_variables = set()

@contextmanager
def variables(*variables):
    old = _meta_variables.copy()            # Save old set
    _meta_variables.update(set(variables))  # Inject new variables

    yield                                   # Yield control to `with` block

    _meta_variables.clear()                 # Delete current set
    _meta_variables.update(old)             # Load old set
~~~~~~~~~~~~~~

In the example below we find the name of the account-holder with 100 dollars.  The generic Python string "NAME" is used as a meta-variable.
The `variables` context manager places `"NAME"` into a global collection and then yields control to the code within the subsequent block.  Code within that block is executed and queries this collection.  Membership in the collection is equivalent to being a meta-variable.  After the completion of the `with variables` block the global collection is reset to its original value, commonly the empty set.  This approach allows the use of arbitrarily typed values as meta-variables, further enabling interoperation.

~~~~~~~~~~~~~~Python
>>> from term import termify, variables, unify 
>>> from bank import Account
>>> termify(Account)

>>> acct  = Account(name="Alice", balance=100)
>>> query = Account(name="NAME",  balance=100)
>>> vars  = ["NAME"]

>>> with variables(*vars):
...     print unify(acct, query, {})
{"NAME": "Alice"}

>>> print unify(acct, query, {})    # Does not unify outside the with block 
False
~~~~~~~~~~~~~~

Term is able to seamlessly interoperate with a generic client code with little setup.
