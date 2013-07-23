
SymPy Stats
-----------

\label{sec:sympy-stats}

The components and concepts discussed above are applicable to domains outside of numerical linear algebra.  In past work\cite{Rocklin2012b} we support uncertainty modeling in computer algebra systems through the addition of a random variable type.  The random variable abstraction allows existing computer algebra functionality to compose cleanly with the notions of probability and statistics.  In this section we'll discuss of the design in that system relevant for the discussion of modularity and show how work on term rewrite systems in this document is able to apply to that older project. 


#### Composition in SymPy.stats

We enable the expression of uncertain systems in computer algebra through the addition of a random variable type.  A random variable is an algebraic symbol attached to a probability space with a defined probability distribution.  Expressions containing random variables themselves become random.  Expressions containing multiple random variables exist over joint probability distributions.  The addition of conditions restricts the space over which these distributions have support.  Queries on random expressions generate deterministic computations.  

SymPy.stats leverages existing SymPy objects to describe these concepts.  Distributions are described with scalar expressions, joint and conditional probability spaces with SymPy sets, and results with SymPy integral expressions.  SymPy.stats offloads difficult computations onto other, more heavily curated systems, which was the motivating design principle of this project.


#### Example

We generate a random variable distributed with a normal distribution with mean $\mu$ and variance $\sigma^2$.

~~~~~~~~~~~~Python
>>> mu = Symbol('mu', real=True)
>>> sigma = Symbol('sigma', positive=True)
>>> X = Normal('X', mu, sigma)
~~~~~~~~~~~~

We query for the probability that this variable is above some value y

~~~~~~~~~~~~Python
>>> P(X > y)
~~~~~~~~~~~~

$$\frac{1}{2} \operatorname{erf}{\left (\frac{\sqrt{2} \left(\mu - y\right)}{2 \sigma} \right )} + \frac{1}{2}$$

Internally this operation produces a definite integral

~~~~~~~~~~~~Python
>>> P(X > y, evaluate=False)
~~~~~~~~~~~~

$$\int_{0}^{\infty} \frac{\sqrt{2} e^{- \frac{\left(z - \mu + y\right)^{2}}{2 \sigma^{2}}}}{2 \sqrt{\pi} \sigma}\, dz$$

SymPy.stats then relies on SymPy's internal integration routines to evaluate the integral.

For more complex queries SymPy.stats uses other SymPy utilities like equation solving and differentiation to manipulate queries on random expressions into the correct integrals

~~~~~~~~~~~~Python
>>> P(X**2 + 1 > y, evaluate=False)
~~~~~~~~~~~~

$$ \int_{0}^{\infty} \frac{\sqrt{2} \left(e^{2 \frac{\mu \sqrt{z + y - 1}}{\sigma^{2}}} + 1\right) e^{\frac{- z - \mu^{2} - 2 \mu \sqrt{z + y - 1} - y + 1}{2 \sigma^{2}}} \left\lvert{\frac{1}{\sqrt{z + y - 1}}}\right\rvert}{4 \sqrt{\pi} \sigma}\, dz $$

#### Benefits

SymPy.stats tries to be as thin a layer as possible, transforming random expressions into integral expressions and no further.  This transformation is simple and robust for a large class of expressions.  It does not attempt to solve the entire computational problem on its own through, for example, the generation of Monte Carlo codes.  

Fortunately its output language, integral expressions, are widely supported.  Integration techniques benefit from a long and rich history including both analytic and numeric techniques.  By robustly transforming queries on random expressions into integral expressions and then stepping aside, `sympy.stats` enables the entire integration ecosystem access to the domain of uncertainty.


#### Rewrite Rules

We show how rewrite rules, applied by LogPy, can supply a valuable class of information not commonly found in computer algebra systems.

Consider two standard normal random variables

~~~~~~~~~~~~Python
>>> X = Normal('X', 0, 1)
>>> Y = Normal('Y', 0, 1)
~~~~~~~~~~~~

SymPy is able to compute their densities trivially (these are known internally).

~~~~~~~~~~~~Python
>>> pdf = density(X)
>>> pdf(z)
~~~~~~~~~~~~

$$ \frac{\sqrt{2} e^{- \frac{1}{2} z^{2}}}{2 \sqrt{\pi}} $$

Using equation solving and differentiation SymPy.stats is able to compute densities of random expressions containing these random variables

~~~~~~~~~~~~Python
>>> pdf = density(2*X)
>>> pdf(z)
~~~~~~~~~~~~

$$ \frac{\sqrt{2} e^{- \frac{1}{8} z^{2}}}{4 \sqrt{\pi}} $$ 

SymPy.stats uses existing analytic integration code to marginalize over multivariate probability spaces, supporting interactions between different random variables.

~~~~~~~~~~~~Python
>>> simplify(density(X+Y)(z))
~~~~~~~~~~~~

$$ \frac{e^{- \frac{1}{4} z^{2}}}{2 \sqrt{\pi}} $$

This system is robust and can handle a wide variety of non-linear equations.

~~~~~~~~~~~~Python
>>> density(X**2)(z)
~~~~~~~~~~~~

$$ \frac{\sqrt{2} e^{- \frac{1}{2} z} \left\lvert{\frac{1}{\sqrt{z}}}\right\rvert}{2 \sqrt{\pi}} $$

The next expression however generates an integral that is too complex for the analytic integration routine.  We display the unevaluated integral.

~~~~~~~~~~~~Python
>>> density(X**2 + Y**2)(z)
~~~~~~~~~~~~

$$ \int_{-\infty}^{\infty} \frac{\sqrt{2} e^{- \frac{1}{2} X^{2}} \int_{-\infty}^{\infty} \frac{\sqrt{2} e^{- \frac{1}{2} Y^{2}} \delta\left(X^{2} + Y^{2} - z\right)}{2 \sqrt{\pi}}\, dY}{2 \sqrt{\pi}}\, dX $$

This result is to be expected.  The integrals involved in analytic uncertainty modeling quickly become intractable.  At this point we may send this integral to one of the many available numeric systems.


#### Applying Statistical Expertise

A moderately well trained statistician can immediately supply the following solution to the previous, intractable problem.

$$ \frac{1}{2} e^{- \frac{1}{2} z} $$

Statisticians are not more able to evaluate integrals, rather they apply domain knowledge at the higher statistical level.  When $X$ and $Y$ are standard normal random variables the expression $X^2 + Y^2$ has a chi-squared distribution with two degrees of freedom.  This distribution has the known form above.  SymPy.stats actually knows this form internally, but was unable to recognize that $X^2 + Y^2$ followed this distribution.

This relation is just one of an extensive set of relations on univariate distributions.  An extensive and well managed collection exists at `http://www.math.wm.edu/~leemis/chart/UDR/UDR.html`.  Additional information has been generated by the group that maintains `APPL`, "An Probabalistic Programming Language" \cite{Len2001}.

The application of high-level expertise simplifies this problem and avoides an intractable problem at a lower level.


#### Rewrite Rules

Rules for the simplification of such expressions can be written down in SymPy as follows

~~~~~~~~~~~~Python
patterns = [
    (Normal('X', 0, 1),                         StandardNormal('X'),        True),
    (StandardNormal('X')**2,                    ChiSquared('X', 1),         True),
    (ChiSquared('X', m) + ChiSquared('Y', n),   ChiSquared('X', n + m),     True),
    ...
    ]
~~~~~~~~~~~~

Note that these rules are only valid within a `Density` operation when the user is querying for the distribution of the expression.  They are not true in general because they destroy the notion of which distributions correspond to which random variables in the system (note the loss of `'Y'` in the last pattern).

These expressions are clear to a statistical user, even if that user is unfamiliar with computer algebra.


#### Conclusion

The automated application of domain expertise at a high level simplifies the eventual computation required at lower-levels.  This idea extends throughout many fields of mathematics and the sciences.  Declarative techniques allow large pre-existing knowledgebases to be encoded by domain experts and facilitate the expression of this expertise.  Systems like LogPy are generally applicable within computer algebra, not only within the scope of numerical linear algebra.
