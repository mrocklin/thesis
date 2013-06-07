
LogPy
-----

include [TikZ](tikz_pattern.md)

\label{sec:logpy}

LogPy is a general purpose logic programming library for Python.  It implements a varient of [miniKanren](http://kanren.sourceforge.net/)\cite{byrd2010}, a language originally implemented in a subset of Scheme.  [Comprehensive documentation](http://github.com/logpy/logpy/tree/master/docs)\cite{logpy} for LogPy is available online.  LogPy adds the additional foci to miniKanren.

1.  Associative Commutative matching
2.  Efficient indexing of relations of expression patterns
3.  Simple composition with pre-existing Python projects

The third focus above about ease of composition bears mention.  The majority of logic programming attempts in Python have not acheived penetration due to, I suspect, unrealistic demands on potential interoperation.  They require that any client project use their types/classes within their codebase.  LogPy was developped simultaneously with multiple client projects with large and inflexible pre-existing codebases.  As a result it makes minimal demands for interoperation, significantly increasing its relevance.  *Relevant?*


### Basic Design

*How much should I write about this?  It isn't novel but may be necessary to understand the rest.*


### Associative Commutative Matching

This has been well studied in literature.  My solution is a bit more naive.  

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

These can later be injected into a LogPy relation.

~~~~~~~~~~~~Python
from logpy import TermIndexedRelation as Relation
from logpy import facts
rewrites = Relation('rewrites')
facts(rewrites, *patterns)
~~~~~~~~~~~~

This relation stores the patterns for use in logic programs.  It will be discussed in the next section.

For now note that the definition of the mathematical patterns used only SymPy and pure Python; the interaction with LogPy is well isolated.  In the future more mature algorithmic solutions can replace the LogPy interaction easily without necessitating changes in the mathematical code.  Removing such connections enables components to survive obsolesence of neighboring components.  We avoid "weakest link in the chain" survivability by removing unnecessary connections between modules.


### Analysis

While the demands for logic programming and term matching in our problem are significant, interactions between pieces are always limited to just a few lines of code.  

Teaching LogPy to interact with SymPy and `computations` is a simple exercise.  The need for simultaneous expertise in both projects is brief.  Using LogPy to construct a term rewrite system is similarly brief, only a few lines in the function `rewrite_step`.

By supporting interoperation with preexisting data structures we were able to leverage the preexisting mathematical logic system in SymPy without significant hassle.

The implementation of the `rewrites` Relation determines matching performance.  Algorithmic code is a completely separate concern and not visible to the mathematical users.
