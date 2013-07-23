
Modularity
----------

\label{sec:modularity}

Modularity is a software principle that supports the separation of a software project into modules, each of which performs an individual and independent task.  This approach confers the following benefits:


#### Specialization of Labor 

When separation between modules aligns with separation between disciplines of expertise, modularity enables the specialization of labor, assigning each module to a different researcher with a different specialization.  In general we assume that it is easier to find a few experts in different fields than it is to find a single researcher who is an expert in all of those fields.

#### Evolution through Interchangeability

When modules are combined with an established interface they become interchangeable with other simultaneous efforts by different groups in the same domain.  Shared interfaces and interchangeability supports experimentation and eases evolution under changing contexts (such as changing hardware.)

#### Verification

Smaller pieces are simpler to test and verify.  Complex interactions between multiple fields within a single codebase may produce complex errors that are difficult to identify and resolve; leading potentially both to development frustration (at best), and incorrect science (at worst).  Verification at the module level allows most issues to be resolved in an isolated and more controlled setting.  Verification of modules and of interactions is often sufficient to ensure verification of a larger system.

#### Reuse

Scientific computing algorithms are often broadly shared across otherwise unrelated domains.  E.g. the algorithms for the solution of sparse linear systems may be equally applicable both to the time evolution of partial differential equations and the optimization of machine learning problems.  By separating out these components a larger community is able to both develop and benefit from the same software components.  This approach yields a higher quality product within all domains.

#### Obsolescence

Scientific software is often made obsolete either by the development of new methods, new hardware, new languages within the programming community, or even very rarely by new science or new mathematics.  The separation of these projects into modules isolates the obsolescence to only the few modules that must be replaced.  Because different elements of scientific computing evolve at different rates (e.g. hardware changes quickly while math changes slowly), this separation can avoid frequent rewrites of infrequently changing domains (e.g. mathematical elements may be allowed to persist from generation to generation.)
