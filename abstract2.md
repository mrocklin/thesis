
This thesis considers the scientific software ecosystem through the lens of software engineering.  We argue for looser coupling between mathematical and numeric codes.

This work lives on three levels of abstraction

*   A particular solution to static scheduling of numerical linear algebra
*   An analysis of that solution's loosely coupled and cohesive design
*   An analysis of how such solutions can be developed declaratively

Parallel solutions to numerical linear algebra present a challenging and important problem to society.  They simultaneously require a depth of understanding in several fields (challenge).  They also drive the majority of scientific and statistical software (impact).  Rapid changes in the hardware landscape have unsettled existing solutions to this problem, leading to substantial ongoing efforts within the numerics community.  We present a solution designed to adapt well to these changes and analyze it's performance.

This adaptability is due in large part to a modular design that separates the mathematical (constant) from the hardware (variable) concerns.  We motivate that this design can be more broadly applied to assist both with today's dynamic hardware environment and changing user demographics. 

The impact of mathematical expertise on scientific computing is substantial and widespread.  Unfortunately mathematics and science communities have limited ability to build formal software systems.  We approach this problem through logic and declarative programming techniques.  Our particular numerical linear algebra solution was carefully designed to separate algorithmic manipulations from mathematical expertise.  We discuss the tools necessary to enable this definition and show their application in other domains.
