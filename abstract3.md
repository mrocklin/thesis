
Development in computational science is both accelerated and burdened by changing hardware and diffusion into new disciplines.  Hardware advances in parallelism give potential the solution of increasingly large problems.  Diffusion of computational methods into smaller and new labs multiplies this potential across many disciplines.

This potential is limited by scientists ability to develop software solutions in these new fields for this new hardware.  Increasingly the largest obstacle to discovery becomes the lack of expertise of the isolated scientific software developer.  New computational power brings complex architectures and challenging programming models.  New domains bring novice scientific programmers without a strong tradition of software engineering.

Fortunately these new developers exist in a larger ecosystem of scientific software.  A healthy ecosystem is able to select and distribute quality computational solutions to a variety of scientific problems, thus enabling overall discovery.  

This dissertation discusses the health of the current scientific computing ecosystem and the resulting costs and benefits on scientific discovery.  It promotes software modularity within the scientific context.  To support this argument it considers automated linear algebra, a well studied problem, as a case study.  A prototype software system adhering strictly to the principles of modularity is produced and its costs and benefits are analyzed.

We produce a system for the automatic generation of numerical linear algebra programs.  This system consists of loosely coupled modules which draw from computer algebra, compilers, logic programming, and static scheduling.  Each domain is implemented in isolation.  We find that this separation eases development by single-field experts, is robust to obsolesense, enables reuse, and is easily extensible.
