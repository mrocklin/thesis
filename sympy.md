
SymPy
-----

\label{sec:sympy-software}

A computer algebra system is composed of a data structure to represent mathematical expressions in a computer, a syntax for the idiomatic construction of trees by mathematical users, and a collection of functions for common mathematical routines.

SymPy \cite{sympy} is a computer algebra system embedded in the Python language.  It implements these pieces as follows

### Operators

Both SymPy operators and SymPy literal types are implemented as Python classes.

~~~~~~~~~~Python
# Literal Types
class Symbol(Expr):
    ...
class Integer(Expr):
    ...

# Operators
class Add(Expr):
    ...
class Mul(Expr):
    ...
class Log(Expr):
    ...
~~~~~~~~~~

Literal and variable terms are instantiated as Python objects.  Standard Python variables are used for indentifying information.

~~~~~~~~~~Python
one = Integer(1)  # 1 is a Python int
x = Symbol('x')   # 'x' is a Python string
~~~~~~~~~~

Compound terms are also instantiated as Python objects which contain SymPy terms as children

~~~~~~~~~~Python
y = Add(x, 1)
z = Mul(3, Add(x, 5), Log(y))
~~~~~~~~~~

Every term can be fully described by its type and its children which are stored as an instance variable, `.args`

~~~~~~~~~~Python
>>> type(y)
Add
>>> y.args
(x, 1)
~~~~~~~~~~

At the lowest level SymPy manipulations are then just Python functions which inspect these terms, manipulate them with Python statements, and return the new versions.


### Syntax and Printing

\label{sec:sympy-syntax}

Reading and writing terms like `z = Mul(3, Add(x, 5), Log(y))` can quickly become cumbersome, particularly for mathematical users when they generate large complex equations.  

Because SymPy is embedded in a pre-existing language it can not define its own grammar but must instead restrict itself to the expressiveness of the host language.  For term writing convenience classes for operators and literals overload hooks for Python operator syntax like `__add__` and `__mul__`.  For reading convenience these classes overload hooks for interactive printing like `__str__`.  SymPy also implements printers for LaTeX and unicode which can be called on by the ubiquitous ipython console and notebook tools.  Together these provide an intuitive interactive experience for mathematical users

~~~~~~~~~~Python
>>> from sympy import Symbol, log, exp, simplify
>>> x = Symbol('x')
>>> y = log(3*exp(x + 2))
>>> print y
log(3*exp(x + 2))

>>> print simplify(y)
x + log(3) + 2
~~~~~~~~~~
