
Kalman Filter
-------------

The [Kalman filter](http://en.wikipedia.org/wiki/Kalman_filter) is an algorithm to compute the Bayesian update of a normal random variable given a linear observation with normal noise.  It is commonly used when an uncertain quantity is updated with the results of noisy observations.  Both the prior and the observation are assumed to be normally distributed.  It is used in weather forecasting after weather stations report in with new measurements, in aircraft/car control to automatically adjust for changing external conditions, or in GPS navigation as the device updates position based on a variety of noisy GPS/cell tower signals.   It's ubiquitous, it's important, and it needs to be computed quickly and continuously.  It can also be completely defined with a pair of matrix expressions.

$$ \Sigma H^T \left(H \Sigma H^T + R\right)^{-1} \left(-data + H \mu\right) + \mu $$
$$ - \Sigma H^T \left(H \Sigma H^T + R\right)^{-1} H \Sigma + \Sigma $$

### Math Expressions

We define these expressions in SymPy

~~~~~~~~~~~~~~~Python
include [Kalman](kalman.py)
~~~~~~~~~~~~~~~

### Computation

We compiles these expressions into a computation.

~~~~~~~~~~~~~~~Python
comp = compile([mu, Sigma, H, R, data], [new_mu, new_Sigma], *assumptions)
~~~~~~~~~~~~~~~

\begin{figure}[htbp]
\centering
\includegraphics[width=.8\textwidth]{images/kalman-math}
\label{fig:kalman-math}
\end{figure}

\newpage

### Features 

We note two features of the computation

1.  Common-subexpressions are identified, computed once, and shared.  In particular we can see that $H \Sigma H^T + R$ is shared between the two outputs.
2.  This same subexpression is fed into a `POSV` routine for the solution of symmetric positive definite matrices.  The inference system determined that because $H$ is full rank, and $\Sigma$ and $R$ are symmetric positive definite that $H \Sigma H^T + R$ is symmetric positive definite.

The first benefit is trivial in traditional compiled systems but a substantial efficiency within scripting languages.  

The second benefit is more substantial.  Noticing that $H \Sigma H^T + R$ is symmetric positive definite requires both mathematical expertise and substantial attention to detail.  This optimization can easily be missed, even by an expert mathematical developer.  It is also numerically quite relevant.

### Experiment

How can we quantify the value of this sort of inference?  It allows us to improve the runtime / development time trade off.

One simple approach:  Lets remove intellect from our system and measure performance losses.
