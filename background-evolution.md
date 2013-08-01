
Evolution
---------

\label{sec:background-evolution}

Computational science predates software.  Numerical methods for the solution of critical problems have a rich history.  Iterative methods for the solution of non-linear systems have roots dating back to French artillerymen when officers attempted to hit a military target by making small adjustments to cannon angles and gunpowder quantities.  Because this target was often aiming back at them it was critical that the solution to the non-linear system be found with as few tries as possible.  During World War II machinery was specifically developed to aid in cryptanalysis at Bletchley Park to intercept war messages.  Modern scientific software often retains this same sense of urgency.  All efforts are focused on building and pushing modern hardware to its limits for the solution of a critical problem. 

While these efforts are both commendable and groundbreaking, they must often sacrifice general applicability in order to obtain peak performance.  As a result future endeavors are unable to benefit from past efforts. 


#### Static Libraries

Fortunately as trends in scientific computing emerge computer science communities are encouraged to produce generally applicable codes for use across many simulations.  Libraries like BLAS/LAPACK, FFTW, QUADPACK, ARPACK, etc., were created and refined early on and maintain relevance today.  These battle-hardened codes form a set of high-level primitive operations on which much of the core community relies.


#### Scripting Languages

As computers become more prevalent, the use of numeric methods expands into smaller and less computationally specialized disciplines and research groups.  Groups without formal training in writing scientific code may find historical systems and interfaces challenging.

Scripting languages like Matlab, R, and Python address this growing user group by providing high-level dynamic languages with permissive syntax and interactive use.  Unfortunately the lack of explicit types and a compilation step drastically reduces the performance of codes written within these languages.  Linking low-level performant codes (e.g. tuned matrix multiplication) to high-level routines (e.g. Matlab's `*` operator) bridges this gap on a small but expressive set of array primitives.  Scripting languages linked to low-level libraries are often sufficiently performant for many array programming tasks found in small research labs.


#### Open Source Scientific Ecosystems 

A broad userbase coupled with advances in online code sharing and relatively robust package managers has fostered a culture of open source scientific code publication.  Often the choice of language is made due to the location of preexisting scientific codebases rather than the features of the language itself.  Large scientific software ecosystems provide a scaffolding for several disciplines (R for Statistics, bioperl for Biology, SciPy for numerics).


#### Adaptation to Parallelism

The rise of shared, distributed, and many-core parallelism forces the development community to reevaluate its implementation.  Preexisting scientific software has substantial intellectual value.  Unfortunately the adaptation of this software to take advantage of parallel hardware seems both arduous and necessary.  Like old Fortran codes they are often called from other languages at great expense (e.g. using foreign function interfaces to call SciPy from Hadoop via Java.)


#### Return to Compilation

Performance issues on modern hardware have increased interest in the compilation of these dynamic languages.  At the time of writing, the scientific Python ecosystem supports the following active projects for compilation and interoperation of Python with low-level languages (largely for array programming.)

include [SciPy compiled languages](scipy-compiled-langs.md)

We include this list mainly to stress the number of projects in this effort.  This demonstrates both the community's commitment and a lack of organization.
