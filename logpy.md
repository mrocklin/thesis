
LogPy
-----

include [TikZ](tikz_pattern.md)

\label{sec:logpy}

LogPy is a general purpose logic programming library for Python.  It implements a variant of `miniKanren`\cite{byrd2010}, a language originally implemented in a subset of Scheme.  Comprehensive documentation for LogPy is available online\cite{logpy}.

The construction of LogPy was motivated by duplicated efforts in SymPy and Theano, two computer algebra systems in Python.  Both SymPy and Theano built special purpose modules to define and apply optimisations to their built-in mathematical and computational data structures.  LogPy aims to replace these modules.  The desire to deliver functionality to two inflexible codebases forced the creation of the `term` system described in Section \ref{sec:term}.  LogPy provides functionality on top of the `term` interface.


#### Basic Design - Goals

LogPy programs are built up of *goals*.  Goals produce and manage streams of substitutions.

    goal :: substitution -> [substitution]

#### Example
    
    >>> x = var('x')
    >>> a_goal = eq(x, 1)

This goal uses `eq`, a goal constructor, to require that the logic variable `x` unifies to `1`.  As previously mentioned goals are functions from single substitutions to sequences of substitutions.  In the case of `eq` this stream has either one or zero elements:

    >>> a_goal({})      # require no other constraints
    ({~x: 1},)
    >>> a_goal({x: 2})  # require that x maps to 2 and that eq(x, 1)
    ()

#### Basic Design - Goal Combinators

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

Logic programs can have many goals in complex hierarchies.  Writing explicit for loops quickly becomes tedious.  Instead, LogPy provides functions to combine goals logically.  

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

#### User Syntax

These combinators and goals are accessed with the `run` function as in miniKanren:

    >>> run(0, x, lall(membero(x, (1, 2, 3)),
    ...                membero(x, (2, 3, 4)))
    (2, 3)

    >>> run(0, x, lany(membero(x, (1, 2, 3)),
    ...                membero(x, (2, 3, 4)))
    (1, 2, 3, 4)

include [Pattern-LogPy](pattern-logpy.md)
