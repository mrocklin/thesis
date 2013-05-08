
LogPy
-----

\label{sec:logpy}

LogPy is an implementation of [miniKanren](http://kanren.sourceforge.net/)\cite{byrd} in Python.

Our implementation adds the additional foci

1.  Associative Commutative matching
2.  Efficient indexing of relations of expression patterns
3.  Composability with pre-existing Python projects

The first two have mature implementations elsewhere; my work here is largely in implementation.  

The third point of ease of composability bears mention.  The majority of logic programming attempts in Python have not acheived penetration due to, I suspect, unrealistic demands on potential interoperation.  They require that any client project use their types/classes within their codebase.  LogPy was developped simultaneously with multiple client projects with large and inflexible pre-existing codebases.  As a result it makes minimal demands for interoperation, significantly increasing its relevance.  

*Is this worth discussing?*

