
Conclusion
==========

\label{sec:conclusion}

This dissertation promotes the value of modularity in scientific computing, primarily through the construction of a modular system for the generation of mathematically informed numerical linear algebra codes.  We have highlighted cases where modularity is particularly relevant in scientific computing due to the abnormally high demands and opportunities from deep expertise.  We hope that this work motivates the use of modularity even in tightly coupled domains.  Additionally, software components included in this work are useful in general applications and are published online with liberal licenses.


Challenges to Modularity
------------------------

We take a moment to point out the technical challenges to modular development within modern contexts.  This is separate from what we see as the two primary challenges of lack of incentives and lack of training.


#### Coupled Testing and Source

Testing code is of paramount importance to the development of robust and trusted software.  Modern practices encourage the simultaneous development of tests alongside source code.  I believe that this practice unnecessarily couples tests, which serve as a de facto interface for the functionality of code, to one particular implementation of source code.  This promotes one implementation above others and stifles adoption of future attempts at implementing the same interface.

Additionally, as software increases in modularity packages become more granular.  It is not clear how to test interactions between packages if tests are coupled to particular source repositories.  Thus, we propose the separation of testing code into first class citizens of package ecosystems.


#### Package Management

Software is often packaged together in order to reduce the cost of configuration, build, and installation.  As modern ecosystems develop more robust package managers this cost decreases, thus enabling finer granularity and increased modularity.  Multi-lingual ecosystems without good standards on versioning can complicate this issue substantially.  Package management and installation tools such as pip/easy_install (Python) and CRAN (R) have alleviated these problems for many novice users.  They continue to break under more complex situations.  Further development into this field is necessary before wide-spread use of fine-grained modularity is possible.


Analytics
---------

This dissertation argues for the value of modularity.  Though it is difficult to quantitatively measure this value, it may be that such a quantitative measure would help to raise the issue among non-enthusiast programmer communities.

To this end I suggest the quantitative study of the scientific software ecosystem.  Pervasive use of version control (e.g. `git`) and the recent popularity of online source control communities (e.g. `github`) provide a rich dataset by which we can quantify relationships among code and developers.  Relationships between projects (which projects use what others) can be found from dependency managers (e.g. PyPI, Clojars). Relationships within code (which functions use which others) can be found by parsing the source.  Relationships between developers and code (who built what and how much work did it take) can be found from commit logs.  Relationships between developers (who talks to whom) can be found from online communities (e.g. `github`).

These relationships describe a large complex graph.  The code elements of this graph can be analyzed for modularity as defined in a complex networks sense\cite{Clauset2004}.  The commit logs can be analyzed to attribute cost to various elements of code.

This process has at least the following two benefits:

*   By assigning a value to programmer time and identifying modular elements we may be able to attribute an added cost of tightly coupled, unmodular code.
*   By looking at download counts and dependency graphs we can attribute impact factors to projects, teams, or individual developers.  By publishing an impact factor that benefits from good software engineering we hope to encourage better practices in the future.

Understanding and expertise precede optimization.


Achievements
------------

We summarize key achievements contained in this work.  These contributions are either concrete software contributions or general demonstrations of principles.

### Software

Concrete software contributions include the following:

#### SymPy Matrix Expressions

An extension of a computer algebra system to matrix algebra including both a general language and a robust inference system.  It serves as repository for commonly used theory of the style found in the popular Matrix Cookbook.  We demonstrated the value of this theory in the creation of numerical computations.

#### Computations

A high level encapsulation of popular low-level libraries, particularly BLAS/LAPACK, MPI, and FFTW.  This system lifts the de-facto scientific programming primitives to a level that is more accessible to non-expert users.  It also serves as a high-level target for automated systems, encapsulating many of the simple decisions made in traditional compilation.

#### Term, LogPy

The `term` and `logpy` libraries support the composition of logic programming with pre-existing software projects within the Python ecosystem.  In particular they enable the high-level description of small transformations of terms directly within the syntax of the host language.

#### Conglomerate

We compose the above three elements to translate mathematical matrix expressions into low-level Fortran code that makes sophisticated use of low-level libraries.  This conglomerate project brings the power of mature but aging libraries into new communities without a tradition in low-level software.  It serves as a repository for the expertise of numerical analysis.

#### Static Schedulers

We provide a high-level interface and two isolated implementations of static schedulers for heterogeneous parallel computing.

#### SymPy.stats

An extension of SymPy enables the expression of uncertainty in mathematical models.  The abstraction of random variables allows the concepts of uncertainty to compose cleanly with other elements of the computer algebra system.  This module is the first such system within a general computer algebra system.  By relying on and translating to other well used interfaces (like integral expressions) it is able to be broadly accessible while tightening its development scope enabling single-field statisticians to have broad impact in a range of applications.


### Principles

This dissertation demonstrates the value of small composable software modules that align themselves with existing specialist communities.  Experiments in this dissertation focused on the ease with which systems to select and implement sophisticated methods could be developed once the software system was properly separated.  We showed how experts in linear algebra, numerical libraries, and statistics could each provide improvements that significantly impacted numerical performance.  Each of these improvements was trivial for someone within that field and did not depend on simultaneous expertise in other fields.

As the scope of computational science continues to expand we believe that adaptation to developer demographics will increase in importance.
