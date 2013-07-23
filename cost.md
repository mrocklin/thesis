
Cost
----

\label{sec:cost}

Scientific software is costly.  

Scientific software is costly because it is difficult. The computational solution of scientific problems often require expertise from a variety of scientific, mathematical, and computational fields; in addition they must be formally encoded into software.  This task is intrinsically difficult and therefore costly.  

Scientific software is costly also because it is done by researchers with poorly matched training.  The cost is magnified because it is often done by a non-computational but academic researcher.  Such a researcher is often highly trained in another field (biology, physics) with only moderate training in software development.  This mismatch of training and task means that the task occupies many working hours from some of society's highly trained citizens.  It is like hiring a lawyer to fix a plumbing problem.  The lawyer is only somewhat competent at the task but still charges high rates.


#### The cost of scientific software could be mitigated through reuse

Fortunately scientific problems often share structure.  Large parts of the solutions for one scientific problem may apply to a large number of other relevant problems.  This is more likely within the same field but can occur even in strikingly different domains.  The simulation of galaxies within a globular cluster is distinct from the simulation of molecules within a liquid.

#### The cost of scientific software could be mitigated through mathematics

These problems also often benefit from rich and mature mathematical theory built up over centuries.  This theory can inform the efficient solution of scientific problems, often transforming very challenging computational tasks into mathematically equivalent but computationally trivial ones.

#### And yet scientists often start from scratch

Existing code may not be applied to novel problems for any of the following reasons

1.  It is not released to the public or is insufficiently documented
2.  The new researcher may not know to look for it
3.  It integrates too many details about the previous application or architecture

Coding practices, package managers, and general software support/infrastructure from the general programming community have alleviated many of these issues recently.  Tool support and dependency systems have enabled the widespread propagation of small general purpose utilities.  A culture of open source scientific code sharing around accessible scripting languages has drastically lowered the bar to obtaining, building, and integrating foreign code.

Unfortunately this development rarely extends to more sophisticated solutions.  Particularly, this dissertation is concerned with the last issue in the context of sophisticated algorithms; existing code often integrates too many details about the previous application or architecture.

Older scientific software often assumes or "bakes-in" too much about its original application.  E.g. Codes for the interaction of many particles may be specialized to molecular dynamics, limiting their applicability to similar problems in the simulation of stellar systems within globular clusters in astronomy.  Broadly useful code elements are often tightly and unnecessarily integrated into application-specific code elements within a single codebase.  Extracting relevant components from irrelevant ones may be more difficult than simply writing the relevant components from scratch.  Unfortunately, this rewritten work may continue to suffer from the original flaw of integrating general components into domain specific ones.  As a result the same algorithm ends up implemented again and again in several marginally different scientific projects, each at a substantial cost to society.

#### Incentives 

Unfortunately scientists have little incentive to generalize their codes to other domains.  Existing incentives drive progress within a narrow scientific field, not within the broader field of scientific software.  Producing computational components applicable to foreign fields generally has only marginal value within any individual scientist's career.  Unfortunately this situtation produces a prisoner's dilemma type situation with a globally suboptimal result.

It is the position of this dissertatino that the construction of a base of modular software can shift incentives to tip the prisonner's dilemma situation towards the global optimum.
