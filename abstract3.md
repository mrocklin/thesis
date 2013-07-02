
Development in computational science is both accelerated and burdened by changing hardware and diffusion into new disciplines.  Hardware advances in parallelism give the potential for the solution of increasingly large problems.  Diffusion of computational methods into smaller and more diverse groups multiplies this potential across new disciplines.

This potential is limited by scientists' ability to develop software solutions in these new fields for this new hardware.  Increasingly the largest obstacle to discovery becomes the lack of expertise of the isolated scientific software developer.  New computational power brings complex architectures and challenging programming models.  New domains bring a community of novice scientific programmers without a strong tradition of software engineering.

Fortunately these new developers exist in a larger ecosystem of scientific software.  A healthy ecosystem is able to select and distribute quality computational solutions to a variety of scientific problems, thus enabling overall discovery.  

This dissertation discusses the health of the current scientific computing ecosystem and the resulting costs and benefits on scientific discovery.  It promotes software modularity within the scientific context for the optimization of global efficiency.  To support this argument it considers a case study in automated linear algebra, a well studied problem with mature practioners.  We produce and analyze a prototype software system which adheres strictly to the principles of modularity.

We produce a system for the automatic generation of numerical linear algebra programs from mathematical inputs.  This system consists of loosely coupled modules which draw from computer algebra, compilers, logic programming, and static scheduling.  Each domain is implemented in isolation.  We find that this separation eases development by single-field experts, is robust to obsolesense, enables reuse, and is easily extensible.
