
The UNIX Toolset
================

The UNIX toolset is often cited as a model of modularity.  It is a set of small programs that each perform exactly one general task.  Each of them receives and produces a stream of text which serves as a common and simple shared interface.  They can be composed together in a variety of ways to accomplish many common and unanticipated tasks that would be difficult to express in a general purpose programming language.

These functions were not designed with specific applications in mind but were instead designed to help with commonly occurring subproblems. The functionality of these programs rarely overlap.  

Whereas the numerical methods stack was hierarchical and separate layers depended strongly on others the UNIX toolset organization is flat and mostly independent.  We call systems like these *orthogonal*.

In many ways the UNIX toolset is like a physical toolset which contains tools not designed for specific tasks, but rather tools designed for commonly occurring types of issues (e.g. {Hammer: apply percussive force, Wrench: apply torsion, Oil: lubricate, Saw: cut thick things, Knife: cut thin things}.)  Products designed for specific tasks lack market longevity and are rarely found in an expert's toolbox.
