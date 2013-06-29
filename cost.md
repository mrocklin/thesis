
Cost
----

Scientific software is costly.  

The computational solution of scientific problems often require expertise from a variety of scientific, mathematical, and computational fields; in addition they must be formally encoded into software.  This task is intrinsically difficult and therefore costly.  This cost is magnified because it is often done by a scientific researcher.  Such a researcher is often highly trained in another field (biology, physics) with only moderate training in software development.  This mismatch of training means that the task occupies many working hours from some of society's highly trained citizens.

#### This cost could be mitigated through reuse

Fortunately scientific problems often share structure.  For example many problems within the physical sciences often depend on the numerical solution of partial differential equations.  Other more broadly separated domains may still share lower-level structure.  These problems often benefit from rich and mature mathematical theory and are appropriate for sophisticated and well understood algorithms.  Society has had a long history funding and focusing on computational science.


#### And yet scientists often start from scratch

Existing code may not be applied to novel problems for any of the following reasons

1.  It is not released or documented sufficiently
2.  The new researcher may not know to look for it
3.  It assumes too much about a previous application or architecture

Coding practices, package managers, and general software support/infrastructure from the general programming community have been alleviating some of these issues recently.  Tool support and dependency systems have enabled the widespread propagation of small general purpose utilities.

Unfortunately this development rarely extends to more sophisticated solutions.  Particularly this dissertation is concerned with the last issue in the context of sophisticated algorithms. 

3.  It assumes too much about a previous application or architecture

Older scientific software often assumes or "bakes-in" too much about its previous application.  E.g. Codes for the interaction of many particles may be specialized to molecular dynamics, limiting their applicability to similar problems in the simulation of stellar systems within globular clusters in astronomy.  Broadly useful code elements are often tightly and unnecessarily integrated into inappropriate code elements within a single codebase.  Extracting relevant components from irrelevant ones may be more difficult than simply writing the relevant components from scratch.  Unfortunately, this work may also suffer from the same flaw of integrating these general components into domain specific ones.

Incentives:  Scientists have little incentive to generalize their codes to other domains.  Existing incentives drive progress within a narrow scientific field, not within the broader field of scientific software.  Producing computational components applicable to foreign fields generally has marginal value.  Unfortunately this produces a prisoner's dilemma type situation with a globally suboptimal result.
