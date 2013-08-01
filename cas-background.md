
Background
----------

\label{sec:cas-background}

Computer algebra is the solution of mathematical problems via the manipulation of mathematical terms.  This symbolic approach contrasts with the more popular numerical methods of computation.  Computer algebra methods maintain the mathematical meaning of their arguments longer, enabling sophisticated analysis further along in the computation.  Unfortunately, many real-world problems are intractable using symbolic methods, often due to irregular inputs.  For example computing the heat flow through an engine requires a description of the shape of the engine, which may be difficult to describe symbolically.  Even if purely symbolic inputs are available symbolic solutions often suffer from expensive combinatorial blowup.  Symbolic methods are often preferable if analytic solutions exist because they retain substantially more information and may provide additional insight.  Their lack of robustness has largely relegated them to pure mathematics, cryptography, and education.


#### History of Computer Algebra 

The first computer algebra system (CAS), Macsyma\cite{Martin1971}, was developed in 1962.  The field grew slowly both in academic scope and in software.  Commercial and open computer algebra systems like Maple and GAP began appearing in the 1980s.  These were primarily used in pure mathematics research.  Some systems were specialized to particular fields while others were general.  For example GAP was specialized to algebraic group theory while Maple remained generally applicable.  The community around a project often defined its function more than the language design.

The popular solution Mathematica was initially released in 1988 and grew, alongside Maple, to include numeric solvers, creating an "all in one" development environment.  This trend was copied by the Sage project which serves as a fully featured mathematical development environment within the open software community.


#### Computation

The majority of computer algebra research applies automated methods within pure mathematics.  However, as early as 1988 computer algebra systems were also used to generate computational codes in Fortran\cite{Florence1988}.  The automated numerical computation subfield has remained minor but persistent within the CAS community.

Increasing disparity between FLOP and memory limits in modern architectures increasingly favor higher order computational methods.  These methods perform more work on fewer node points, providing more accurate computations with less memory access at the cost both of additional computation and substantially increased development time.  This development time is largely due to increased mathematical expression complexity and the increased demand of theoretical knowledge (e.g. knowing the attributes of a particular class of polynomials.)

For example Simpson's rule for numeric quadrature can replace the rectangle or trapezoidal methods.  In the common case of fairly smooth functions Simpson's rule achieves $O(\delta x^3)$ errors rather than $O(\delta x)$ or $O(\delta x^2)$ for the rectangle and trapezoidal rules respectively.  This comes at the following costs:

*   Computation:  Simpson's rule evaluates three points on each interval instead of two.  It also uses extra scalar multiplications.
*   Development:  Simpson's rule is less intuitive.  Parabolic fits to node points are significantly less intuitive both visually and symbolically than quadrilateral or trapezoidal approximations.

Increased FLOP/Memory ratios hide the cost of extra computation.  Computer algebra can hide the cost of development and mathematical understanding.  With sufficient automation this cost can be almost eliminated, encouraging the automated analysis and use of a wide range of higher order methods.

Computer algebra for automated computation remains a small but exciting field that is able to leverage decades of computer algebra and mathematical research to substantially mitigate the rising costs of mathematically complex scientific computation.  This growth is orthogonal to contemporary developments in hardware.
