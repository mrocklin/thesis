
Mathematical Code Generation
----------------------------

\label{sec:cas-code-generation}

Numerical code is often used to evaluate and solve mathematical problems.  Frequently human users translate high-level mathematics directly into low-level code.  In this section we motivate the use of computer algebra systems to serve as an intermediate step.  This confers the following benefits.

1.  Automated systems can leverage mathematics deeper in the compilation system
2.  Human error is reduced
3.  Multiple backends can be used

We will demonstrate this with interactions between SymPy as discussed in section \ref{sec:sympy-software} and Theano\cite{theano2010}, a library for the generation of mathematical codes in C and CUDA.

### Radial Wave Function

Computer algebra systems often have strong communities in the physical sciences.  We use SymPy to quickly generate a radial wavefunction corresponding to `n = 6` and `l = 2` for Carbon (`Z = 6`).

~~~~~~~~~~~~~~~~Python
from sympy.physics.hydrogen import R_nl
from sympy.abc import x
n, l, Z = 6, 2, 6
expr = R_nl(n, l, x, Z)
print latex(expr)
~~~~~~~~~~~~~~~~

$$\frac{1}{210} \sqrt{70} x^{2} \left(- \frac{4}{3} x^{3} + 16 x^{2} - 56 x + 56\right) e^{- x}$$

As a case study, we generate code to evaluate this expression and its derivative on an array of real values.


### Simplification

We show the expression, its derivative, and SymPy's simplification of that derivative.  In each case we quantify the complexity of the expression by the number of algebraic operations.

#### The target expression


$$\frac{1}{210} \sqrt{70} x^{2} \left(- \frac{4}{3} x^{3} + 16 x^{2} - 56 x + 56\right) e^{- x}$$

    expr
    Operations:  17

#### It's derivative


$$ \frac{1}{210} \sqrt{70} x^{2} \left(- 4 x^{2} + 32 x - 56\right) e^{- x} - \frac{1}{210} \sqrt{70} x^{2} \left(- \frac{4}{3} x^{3} + 16 x^{2} - 56 x + 56\right) e^{- x} + \frac{1}{105} \sqrt{70} x \left(- \frac{4}{3} x^{3} + 16 x^{2} - 56 x + 56\right) e^{- x} $$

    expr.diff(x)
    Operations:  48

#### The result of `simplify`on the derivative


$$ \frac{2}{315} \sqrt{70} x \left(x^{4} - 17 x^{3} + 90 x^{2} - 168 x + 84\right) e^{- x} $$
    
    simplify(expr.diff(x))
    Operations:  18

Note the significant cancellation.


### Bounds on the Cost of Differentiation

Algorithmic scalar differentiation is a simple transformation.  The system must know how to transform all of the elementary functions (`exp, log, sin, cos, polynomials, etc...`) as well as the chain rule; nothing else is required.  Theorems behind automatic differentiation state that the cost of a derivative will be at most five times the cost of the original.  In this case we're guaranteed to have at most `17*5 == 85` operations in the derivative computation; this holds in our case because `48 < 85`.

However, derivatives are often far simpler than this upper bound.  We see that after simplification the operation count of the derivative is `18`, only one more than the original.  This is common in practice.


### Experiment

We compute the derivative of our radial wavefunction and then simplify the result.  Both SymPy and Theano are capable of these transformations.  We perform these operations using both of the following methods:

*   SymPy's symbolic derivative and simplify routines 
*   Theano's automatic derivative and computation optimization routines

We then compare the two results and evaluate by counting the number of required operations.

In SymPy we create both an unevaluated derivative and a fully evaluated and SymPy-simplified version.  We translate each to Theano, simplify within Theano, and then count the number of operations both before and after simplification.  In this way we can see the value added by both SymPy's and Theano's optimizations.


#### Theano Only

$$ \frac{1}{210} \sqrt{70} x^{2} \left(- 4 x^{2} + 32 x - 56\right) e^{- x} - \frac{1}{210} \sqrt{70} x^{2} \left(- \frac{4}{3} x^{3} + 16 x^{2} - 56 x + 56\right) e^{- x} + \frac{1}{105} \sqrt{70} x \left(- \frac{4}{3} x^{3} + 16 x^{2} - 56 x + 56\right) e^{- x} $$

    Operations:                              40
    Operations after Theano Simplification:  21

#### SymPy + Theano

$$ \frac{2}{315} \sqrt{70} x \left(x^{4} - 17 x^{3} + 90 x^{2} - 168 x + 84\right) e^{- x} $$ 

    Operations:                              13
    Operations after Theano Simplification:  10

#### Analysis

On its own Theano produces a derivative expression that is about as complex as the unsimplified SymPy version.  Theano simplification then does a surprisingly good job, roughly halving the amount of work needed (`40 -> 21`) to compute the result.  If you dig deeper however you find that this isn't because it was able to algebraically simplify the computation (it wasn't), but rather because the computation contained several common sub-expressions.  The Theano version looks a lot like the unsimplified SymPy version.  Note the common sub-expressions like `56*x`.

The pure-SymPy simplified result is again substantially more efficient (`13` operations).  Interestingly, Theano is still able to improve on this, again not because of additional algebraic simplification, but rather due to constant folding.  The two projects simplify in orthogonal ways.


### Simultaneous Computation

When we compute both the expression and its derivative simultaneously we find substantial benefits from using the two projects together.


#### Theano Only

$$ \begin{pmatrix}\frac{\partial}{\partial x}\left(\frac{1}{210} \sqrt{70} x^{2} \left(- \frac{4}{3} x^{3} + 16 x^{2} - 56 x + 56\right) e^{- x}\right), & \frac{1}{210} \sqrt{70} x^{2} \left(- \frac{4}{3} x^{3} + 16 x^{2} - 56 x + 56\right) e^{- x}\end{pmatrix} $$

    Operations:                              57
    Operations after Theano Simplification:  24

#### SymPy + Theano

$$ \begin{pmatrix}\frac{2}{315} \sqrt{70} x \left(x^{4} - 17 x^{3} + 90 x^{2} - 168 x + 84\right) e^{- x}, & \frac{1}{210} \sqrt{70} x^{2} \left(- \frac{4}{3} x^{3} + 16 x^{2} - 56 x + 56\right) e^{- x}\end{pmatrix} $$

    Operations:                              27
    Operations after Theano Simplification:  17

The combination of SymPy's scalar simplification and Theano's common sub-expression optimization yields a significantly simpler computation than either project could do independently.

To summarize:

 Project            operation count 
----------------- ------------------
 SymPy                    27         
 Theano                   24         
 SymPy+Theano             17         


### Conclusion 

Similarly to SymPy, Theano transforms graphs to mathematically equivalent but computationally more efficient representations.  It provides standard compiler optimizations like constant folding, and common sub-expressions as well as array specific optimizations elementwise element-wise operation fusion.  

Because users regularly handle mathematical terms, Theano also provides a set of optimizations to simplify some common scalar expressions.  For example, Theano will convert expressions like `x*y/x` to `y`.  In this sense it overlaps with SymPy's `simplify` functions.  This section demonstrates that SymPy's scalar simplifications are more powerful than Theano's and that their use can result in significant improvements.  This shouldn't be surprising.  Sympians are devoted to scalar simplification to a degree that far exceeds the Theano community's devotion to this topic.

These experiments mostly contain polynomials and exponentials.  In this sense they are trivial from a computer algebra perspective.  Computer algebra systems are capable of substantially more sophisticated analyses.
