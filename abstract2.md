
This thesis considers the scientific software ecosystem through the lens of software engineering.  We argue for looser coupling between mathematical and numeric codes.

We pose solutions at three levels of abstraction

*   A particular solution to high performance numerical linear algebra on heterogeneous hardware
*   An analysis of that solution's loosely coupled and cohesive design
*   A proposal for how such solutions can be developed declaratively

Parallel solutions to numerical linear algebra present a challenging and important problem to society.  They simultaneously require a depth of understanding in several fields (challenge).  They also drive the majority of scientific and statistical software (impact).  Rapid changes in the hardware landscape have unsettled existing solutions to this problem, leading to substantial ongoing efforts within the numerics community.  We present a solution designed to adapt well to these changes and analyze it's performance.

This adaptability is due in large part to a modular design that separates the mathematical (constant) from the hardware (variable) concerns.  We motivate that this design can be broadly applied in other domains to assist both with today's dynamic hardware environment and changing user demographics.

The impact of mathematical expertise on scientific computing is substantial and widespread.  Unfortunately mathematics and science communities have limited trained manpower to build the software systems to share this expertise with others.  We approach this problem through logic and declarative programming techniques.  We show how our particular numerical linear algebra solution was designed to separate algorithmic manipulations from mathematical expertise.  We discuss the tools necessary to enable this definition and show their application in other domains.
