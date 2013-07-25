
## Matrix Rewriting in SymPy

\label{sec:matrix-rewriting-sympy}

By composing SymPy.matrices.expressions with LogPy we obtain much of the same intuitive functionality presented in the `matrix-algebra` project in Maude discussed in Section \ref{sec:matrix-rewriting-maude}.

We describe high-level mathematical transformations while restricting ourselves to the SymPy language.  Unfortunately because our solution is embedded in Python we can not achieve the same convenient syntax support provided by Maude (e.g. the `_is_` operator.)  Instead we encode a set of transformations in `(source, target, condition)` tuples of SymPy terms. 

We suffer the following degradation in readability in order to extract Maude, an exotic dependency.  We describe the content of the transformation without specialized syntax.

    Wanted:      inverse(X) = transpose(X) if X is orthogonal
    Delivered:  (inverse(X) , transpose(X) ,  Q.orthogonal(X))

We can then separately connect an external term rewrite system to transform these tuples into rewrite rules and use them to simplify matrix expressions.  In this work we use LogPy but in principle any term rewrite system should be sufficient.  As with the system in Maude we believe that extending the set of simplification relations is straightforward and approachable to a very broad community.  Additionally, this declarative nature allows us to swap out the term rewrite system backend should future development produce more mature solutions.


#### Example -- Determinants

We present mathematical information about determinants taken from the Matrix Cookbook \cite{Petersen2008} and encoded in the manner described above. 

~~~~~~~~~~~~~~Python
# Original,     Result,         Condition
(det(A),        0,              Q.singular(A)),
(det(A),        1,              Q.orthogonal(A)),
(Abs(det(A)),   1,              Q.unitary(A)),
(det(A*B),      det(A)*det(B),  Q.square(A)),
(det(BlockMatrix([[A,B],[C,D]])), det(A)*det(D - C*A.I*B), Q.invertible(A))
...
~~~~~~~~~~~~~~
