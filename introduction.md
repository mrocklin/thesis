Introduction
============


The development and execution of scientific codes is both critical to society and challenging to scientific software developers.  When critical applications require faster solutions the development community often turns to more powerful computational hardware.  Unfortunately the full use of high performance hardware by scientific software developers has become more challenging in recent years due to changing hardware models.  In particular, power constraints have favored increased parallelism over increased clock speeds, triggering a paradigm shift in programming and algorithm models.  As a result squeezing progress out of continued hardware development is becoming increasingly challenging.

An alternative approach to reduce solution times is to rely on sophisticated methods over sophisticated hardware.  One strives to reduce rather than to accelerate the computation necessary to obtain the desired scientific result.  Computationally challenging problems can often be made trivial by exposing and leveraging special structure of the problem at hand.  Problems that previously required weeks on a super-computer may only require hours or minutes on a standard workstation once the appropriate method is found to match the structure of the problem.

Unfortunately the use of expert methods suffers from many of the same drawbacks as the use of large scale parallelism.  In particular the use of expert methods depends on comprehensive and deep understanding of expertise in the fields relevant to the particular computation.  Optimizations requiring this expertise can be equally inaccessible as the optimizations of high performance parallel hardware.  Expert solutions may depend on theories requiring several years of advanced study.  As a result universal deep expertise is as inconceivable as universal knowledge of advanced low-level parallel programming techniques.

Historically we solve this problem by having experts build automated systems to apply their methods more universally.  Just as we develop systems like Hadoop or parallel languages to automate the use of parallel hardware we may also develop systems to automate the selection and implementation of expert solutions.  This approach enables the work of the expert few to benefit the applications of the naive many.  A small group of domain experts bent on automation may accelerate the work of thousands.

The traditional approach of automation is to have domain experts build automated systems themselves.  For domains such as parallel programming this approach is feasible because a significant subset of the parallel programming community is also well versed in the advanced programming techniques necessary to construct automated systems; it is easy to find simultaneous experts in parallelism and automation.  Unfortunately this situation may not be the case for various mathematical or scientific theories.  It may be difficult to find an individual or group of researchers with simultaneous deep expertise both in a particular mathematical domain and in the practice of automation and dissemination through software engineering.

Multi-disciplinary work compounds the problem for the need of simultaneous expertise.  When many domains of expertise are simultaneously required it often becomes impossible to find an individual or working group that can competently satisfy all domains.  In the rare case where such a team is formed, such as in the case of critical operations (e.g. defense, meteorology), the resulting work is rarely transferable to even slightly different configurations of domains.  Tragically, important applications for which all expertise to solve the problem efficiently is known often go unsolved because that expertise is never collected in the same research unit.  While elements of expertise may be trivially accessible to particular specialists, localizing the complete set of necessary expertise may be challenging.  The only novelty and challenges to many of today's applications is the challenge of coordination.

The problem of many-domain expertise distribution aligns well with the software principle of modularity, particularly when the interfaces between modules align well with the demographic distribution of expertise.  The principle of modularity proposes the separation of software systems into separable components such that each component solves exactly one concern.  Relationships between elements within a module should be dense while relationships between inter-module elements should be sparse.  Software engineering communities support this principle due to its benefits in testing, extensibility, reuse, and interoperation.  

In the context of communities like scientific software engineering we add the following to the list of benefits for modularity; *demographically aligned modules increase the qualified development pool*.  This claim is particularly true when the development pool consists largely of specialists, as is the case in the academic research environment.  Developers may only easily contribute to a software package when the scope of that package is within their expertise.  When the developer pool consists largely of specialists then even a moderately inter-disciplinary module may exclude most developers.  This situation is particularly unfortunate because those same excluded specialists may have valuable expertise for critical subparts of the problem.  The separation of a software package into demographically aligned modules enables contributions from single-field experts.  In fields where expertise is largely siloed (as in many scientific fields) this benefit can be substantial.


In summary: 

*   We should look towards sophisticated methods alongside sophisticated hardware.
*   We should disseminate these methods to applications through automation.
*   Interdisciplinary applications and a lack of software engineering tradition in the sciences encourage the use of a modular design that separates different domains into different software packages.
*   In particular, the practice of automation should itself be separated from the formal description of mathematical expertise.

The rest of this chapter discusses traits of the scientific computing ecosystem in more detail and isolation.  Sections \ref{sec:value} and \ref{sec:cost} discuss the value and cost of computing to society at large.  Sections \ref{sec:modularity} and \ref{sec:expertise} outline the challenges of the distribution of expertise and the benefits of modular software design.  This dissertation investigates these concepts through linear algebra, a paragon application; this will application be introduced in section \ref{sec:introduction-nla}.  Finally in Sections \ref{sec:contributions} and \ref{sec:overview} we concretely outline the contributions and outline of the work that follows.

include [Value](value.md)

include [Cost](cost.md)

include [Modularity](modularity.md)

include [Expertise](expertise.md)

include [Numerical Linear Algebra](introduction-nla.md)

include [Contributions](contributions.md)

include [Overview](overview.md)
