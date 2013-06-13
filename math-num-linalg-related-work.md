
Related Work
------------

\label{sec:math-num-linalg-background}

Both the broad applicability of this domain and the performance improvments from expert treatment have made it the target of substantial academic study and engineering efforts.

### Statically compiled libraries - BLAS/LAPACK

### Autotuning - ATLAS

### Heterogeneous computing - Magma

### Automated methods - FLAME

BLAS/LAPACK, Magma, and FLAME all build custom treatments of linear algebra in order to create high performance libraries.  Unfortunately there is duplication and an inability to share the intermediate logic with other projects.  

### Symbolic Linear Algebra

Full featured computer algebra systems like Mathematica and Maple traditionally support explicitly defined matrices where each element is a scalar expression. 

$$ \left[\begin{smallmatrix}\cos{\left (2 \right )} & - \sin{\left (\theta \right )}\\\sin{\left (\theta \right )} & \cos{\left (\theta \right )}\end{smallmatrix}\right] $$ 

Given such a matrix they are able to compute whether that particular matrix is symmetric, orthogonal, etc....  However these systems are unable to discuss matrix algebra abstractly, considering "a symmetric n by n matrix" without explicitly specifying its elements.

However there are add-ons for Mathematica, notably xAct, which solve variations.  xAct\cite{xact} defines and reasons about tensor expressions in a purely abstract and geometrical (coordinate free) manner.  This approach is in the same vein as SymPy.Matrix.Expressions but in a different application.

Several treatments of matrix computations exist as libraries for Coq, an automated theorem prover.
