
Managing Rule Sets
------------------

\label{sec:trs-managing-rule-sets.md}

The properties of the sets of rules impact the performance of compilation.  The possibility of pathological properties like cycles or non-terminating sequences call into question the feasibility of these methods.  A poor rule set combined with a naive rule coordination system has little value.  Even when pathological graph motifs are absent the large numbers of redundant rules that occur in mathematical theories (e.g. integration) can result in very poor search times.  These problems can be mitigated either directly by the domain practitioner or through automated systems.

In many cases domain knowledge to mitigate this issue may be readily available to the rule specifier.  Many mathematical theories outline a clear direction of simplicity.  For as long as transformations proceed monotonically under such an objective function, problems like cycles may be easily avoided.  Pre-existing rule systems like RUBI \cite{Rich2009} for indefinite integration and Fu et. al's work\cite{Fu2006} on trigonometric simplification both take care to outline such directions explicitly.  In the case of Fu, they even go so far as to separate the rule set into separate stages which should be applied sequentially.  The specification of control by domain experts is orthogonal to the design presented here but may have significant value for performance.

These problems may also be approached abstractly through automated methods.  The identification of cycles is often possible by looking only at the structure of the terms without semantic understanding of the domain.  This approach is orthogonal to the domain-specific approach and can supply valuable checks on domain practitioners solutions.  These methods become increasingly valuable as these methods are used by a wider population of non-experts.  The Maude Sufficient Completeness Checker\cite{Hendrix2005} is such an automated analysis system.
