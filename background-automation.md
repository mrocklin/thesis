
### Automation

\label{sec:background-automation}

We often use compilers like `gcc` to automatically translate low-level human readable codes like C to machine code.  In general a compiler transforms code from one language to another.  Usually this transformation moves from high to low-level codes, moving from human comprehension to machine comprehension.  During this transformation compilers often apply optimizations on the high-level code known to increase performance at the low level.  For example `gcc` might perform optimizations like constant folding or loop unrolling if it is able to infer that they are applicable in the source code.  Compilers from higher level languages may be able to better infer and encode higher-level optimizations.

Domain specific languages extend the idea of automated translation of code to application domains.  These often translate between a high-level language intended for domain practionioners into a low-level language intended for efficient computation.  Domain specific languages exist for a wide variety of domains ranging from hard science to web development.  Below we highlight some cases in numerical computing relevant to this work.

The FEniCS project\cite{LoggMardalEtAl2012a} is a collection of software packages for the automated solution of differential equations.  It translates a mathematical description differential equations, meshes, boundary conditions, etc. into a sparse matrix problem that is solved with low-level and parallel code.

Spiral\cite{Puschel2005} compiles a high-level description of a signals processing system into low-level C code optimiezed for particular specification of computational hardware.  Notably Spiral also uses internal rewrite rules, much in line with the methods that we will present in \label{sec:term-rewrite-system}.

The Tensor Contraction Engine\cite{Hirata2003} accelerates quantum chemistry problems by encoding and leveraging tensor contractions inspired by physical laws.  Like Sprial, TCE includes hardware specific optimizations alongside mathematical ones, fitting tile sizes comfortably within the computational hardware's memory hierarchy.

Built-to-Order BLAS\cite{BTO:ComposedLinAlgKernels} enables the fusion of high-level operations within the BLAS family, reducing the number of requisite passes over memory.

Work by Bientinesi and Fabregat\cite{CLAK-VECPAR12, CLAK-IJHPCA} translates matrix expressions into a sequence of appropriate BLAS and LAPACK calls, selecting calls based on mathematical inference provided by rules encoded into Mathematica.  They also TODO: **Add more here**  This work is similar to the work we present in Sections \label{sec:computations},\label{sec:voltron}.

Automation has long been used in general purpose programming to facilitate the creation of efficient low-level code by those not sufficiently expert to create it by hand.  When we elevate this idea to higher levels of abstraction it is well poised to assist with the training disparity in scientific computing.

In each of the cases above, the automated system was built more-or-less from scratch by mature teams that were simultaneously skilled both in a particular domain and in software engineering.  While these projects demonstrate the value of this particular mixture of expertise, their stories also demonstrate the high requirements to accomplish such a project and put it into production to the assistance of that domain.

Just as these projects listed above strive to automate a particular domain there exists various metaprogramming projects which strive to automate the automation of domains.  We discuss these efforts further in Section \ref{sec:trs-background}.
