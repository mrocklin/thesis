
Background
----------

Computer algebra is the solution of mathematical problems via the manipulation of mathematical terms.  This contrasts with the more popular numerical methods.  Computer algebra methods maintain the mathematical meaning of their arguments longer, enabling sophisticated analysis farther along in the computation.  Unfortunately many real-world problems are intractible with symbolic methods, often due to irregular inputs; computing the heat flow through an engine requires a description of the shape of the engine which may be difficult to describe symbolically.  Symbolic methods are often preferable if analytic solutions exist because they retain substantially more information and may provide additional insight.  Their lack of robustness has largely relegated them to pure mathematics, cryptography, and education.


### History of CAS

The first computer algebra system, Macsyma\cite{Martin1971}, was developed in 1962.  Slowly the field grew both in academic scope and in software.  Commercial and open computer algebra systems like Maple and GAP began appearing in the 80s.  They were commonly used in pure mathematics research.  Some systems, like GAP, were specialized to particular fields (algebraic group theory in the case of GAP) while others were general.

Mathematica was initially released in 1988 and grew, alongside Maple, to include numeric solvers, creating an "all in one" development environment.  This trend was copied by the Sage project which serves as fully featured mathematical development environment within open software.


### Computation

The majority of computer algebra research is applied to the automated solution of problems in pure mathematics.  However, as early as 1988 computer algebra systems were used to automatically generate Fortran codes\cite{Florence1988}.  This subfield has remained relatively minor in the field but does recur often.  

Increasing disparity between FLOP and memory limits in modern architectures have favored the use of higher order computational methods in continuous systems.  These methods perform more work on fewer node points, providing more accurate computations with less memory access at the cost both of additional computation and substantially increased development time due to the complexity of the mathematics.  Computer algebra reduces this development cost.  With sufficient automation this cost can be almost eliminated, encouraging the automated analysis of a wide range of higher order methods.

This remains a small but exciting field that is able to leverage decades of computer algebra research to substantially mitigate the rising costs of scientific computation.
