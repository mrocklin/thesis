
## Motivating Problem - Numerical Methods for Uncertainty Propagation

\label{sec:uq-methods}

We present the problem of numerical uncertainty propagation and how recent advances in algorithms and hardware motivate a second look at an older class of algorithms.  We find that the evaluation of a simple thesis on these algorithms presents unfortunate challenges.  We use this failure as motivation for high level languages.


### Uncertainty Propagation

Consider a differentiable function $f$ that transforms elements in $\mathbb{R}^n \rightarrow \mathbb{R}^n$.  Given the action of $f$ on a single point we want to understand the action of $f$ on a distribution.  This is pictured in \ref{fig:uq-13} where one might imagine $f$ as the time evolution of a simple 2-D fluid flow problem with advection moving towards the upper right.  If $f$ is non-linear then a simple distribution at the starting time may deform at the final time. 

\begin{figure}[htbp]
\centering
\includegraphics[width=.4\textwidth]{images/uq-1}
\includegraphics[width=.4\textwidth]{images/uq-3}
\label{fig:uq-13}
\end{figure}

When $f$ is non-linear analytic solutions to this problem may be difficult to compute.  Today one traditionally samples the initial distribution, independently evolves each point with $f$, and then computes sample statistics (mean and covariance) to gain insight about the final distribution.

When the domain is high dimensional or when $f$ is expensive to compute care is taken in the selection of initial sample points.  This is common in many important applications.  In \cite{mrocklin-masters-thesis} we discuss the case when $f$ is an expensive weather forecasting code.  The analysis community has developed numerical methods to provide error bounds on certain choices of input points given certain commonly valid assumptions on $f$.  The sample points are typically chosen to lie somewhere along the principle singular vectors of the initial covariance matrix (corresponding to points along the major and minor axes of the corresponding ellipse in Fig. \ref{fig:uq-13}).

Historically this problem has had two popular solutions.  The sampling method discussed above is a simplified version of what became the Unscented and then Ensemble Kalman Filter, a method in wide use today.  

Previous to these methods a simpler theory motivated the use of evolving the initial covariance matrix directly using the derivative $f'$.  This approach was deemed inferior to sampling methods for two reasons

1.  Derivative codes are either difficult or expensive to obtain
2.  Through clever selection of input points judicious use of the full 
    non-linear function $f$ can provide higher-order accuracy

Linear derivative methods were both inconvenient and less accurate. 

### Recent Advances Challenge Assumptions

Recent years have seen two important advances, each of which has disrupted the landscape of algorithm development

#### Automatic Differentiation

Given a program that computes $f(x)$ it is now easy to produce a second program that computes $f(x)'(\delta x)$.  In many important cases this invalidates the first of the two original reasons to select sampling over derivative methods.  Derivatives are now convenient. 

#### SIMD Hardware

Recent advances in GPGPU or more generally manycore computing have radically reduced the costs of certain repetitive operations.  This change may apply to the problem of uncertainty propagation.

\begin{figure}[htbp]
\centering
\includegraphics[width=.8\textwidth]{images/uq-4}
\end{figure}

Sampling methods apply the non-linear function $f$ to unrelated inputs.  The computations that result may share nothing in common.  Alternatively, derivative methods apply the same linear derivative code $f'$ to a set of vectors collected within a single matrix.  The computation performed on the different vectors is identical and may benefit both from SIMD parallelism and, in certain computations, from memory locality often gained in matrix-matrix computations.  This motivates the following thesis

*Disruptions of SIMD parallelism and automatic differentiation might sufficiently reduce the development and runtime cost of linear derivative methods for uncertainty propagation so that they are again competitive with non-linear high-order-accuracy sampling methods.*


### Evaluation

Evaluation of this thesis depends on a few concepts. 

1.  Numerical methods for evolving Dynamical Systems, i.e. knowledge of $f$
2.  Uncertainty / Statistics
3.  Automatic differentiation
4.  Matrix computations
5.  CPU and GPU implementation expertise

Insight for the thesis is well contained within the context of methods for uncertainty propagation.  Testing the validity of the thesis however relies on the ability to write high quality CPU and GPU codes.  Demographically we have many statisticians interested in uncertainty propagation and many experienced CUDA developers.  However there are relatively few researchers who are familiar with both disciplines.  As a result this question has largely gone unanswered, despite its simplicity at a high level within each individual domain.

\begin{figure}[htbp]
\centering
\includegraphics[width=.6\textwidth]{images/venn-uq-cuda}
\label{fig:venn-uq-cuda}
\end{figure}
