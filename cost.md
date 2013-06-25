
Cost
----

Scientific software is costly.  

Development occupies many working hours from highly trained citizens

Computations occupy resources (lots of flops and power)


#### This is surprising.  Problems behind scientific computation actually have a lot to rely on

Lots of shared structure.  Lots of mathematical theory.  Lots of algorithms. Long history of software development and good funding.


#### And yet scientists often start from near-scratch

Existing code may not be applied to novel problems for any of the following reasons

1.  It is not released or documented sufficiently
2.  The new researcher may not know to look for it
3.  It assumes too much about a previous application or architecture

Coding practices, package managers, and general software support/infrastructure from the general programming community have been alleviating some of these issues recently.  Tool support and dependency systems have enabled the widespread propagation of small general purpose utilities.

Unfortunately this development rarely extends to more sophisticated solutions.  Particularly this dissertation is concerned with the last issue in the context of sophisticated algorithms. 

3.  It assumes too much about a previous application or architecture

Older scientific software often assumes or "bakes-in" too much about its previous application.  E.g. Codes for the interaction of many particles may be specialized to molecular dynamics, limiting their applicability to similar problems in the simulation of stellar systems within globular clusters in astronomy.  Broadly useful code elements are often tightly and unnecessarily integrated into inappropriate code elements within a single codebase.  Extracting relevant components from irrelevant ones may be more difficult than simply writing the relevant components from scratch.  Unfortunately, this work may also suffer from the same flaw of integrating these general components into domain specific ones.

Incentives:  Scientists have little incentive to generalize their codes to other domains.  Existing incentives drive progress within a narrow scientific field, not within the broader field of scientific software.  Producing computational components applicable to foreign fields generally has marginal value.  Unfortunately this produces a prisoner's dilemma type situation with a globally suboptimal result.

