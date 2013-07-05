
Conclusion
==========

\label{sec:conclusion}

This thesis has promoted the value of modularity within scientific computing, primarily through the construction of a modular system for the generation of mathematically informed generation of numerical linear algebra codes.  We have highlighted cases where modularity is particularly relevant in scientific computing due to the abnormally high demands and opportunities from deep expertise.

We hope that this work motivates the use of modularity even in tightly coupled domains.  

Additionally, software components included in this work are useful in general applications and are published online with liberal licenses. 


Challenges to Modularity
------------------------

We take a moment to point out the technical challenges to modular development within modern contexts.  This is separate from what we see as the primary challenges of lack of incentives and lack of training.


### Coupled Testing and Source

Testing code is of paramount importance to the development of robust and trusted software.  Modern practices encourage the simultaneous development of tests alongside source code.  I believe that this practice unnecessarily couples tests, which serve as a defacto interface for the functionality of code, to one particular implementaiton of source code.  This promotes one implementation above others and stifles future attempts. 

Additionally, as software increases in modularity packages become more granular.  It is not clear how to test interactions between packages if tests are coupled to particular source repositories.

Thus, we propose the separation of testing code into first class citizens of package ecosystems.


### Package Management

Software is often packaged together in order to reduce the cost of configuration, build, and installation.  As modern ecosystems develop more robust package managers this cost decreases, enabling finer granularity and increased modularity.  Multi-lingual ecosystems without good standards on versioning can complicate this issue substantially.  Package management and installation tools like pip/easy_install (Python), and CRAN (R) have alleviated these problems for many novice users.  They continue to break under more complex situations.  Further development into this field is necessary before fine-grained modularity becomes possible.


Analytics
---------

This disseration argues for the value of modularity.  The author believes in this principle due to personal experience, intution, reasoning, and the opinions of others in the community.  Unfortunately it is difficult to quantitatively measure this value.  It may be that such a quantitative measure would help to raise the issue among non-enthusiast programmer communities.

To this end I suggest the quantative study of the scientific software ecosystem.  Pervasive use of version control (e.g. `git`) and the recent popularity of online source control communities (e.g. `github`) provide an rich dataset by which we can quantify relationships among code and developers.  

Relationships between projects (what projects use what others) can be found from dependency managers (e.g. PyPI, Clojars). Relationships within code (which functions use which others) can be found by parsing the source.  Relationships between developers and code (who built what and how much work did it take) can be found from commit logs.  Relationships between developers (who talks to whom) can be found from online communities (e.g. `github`).  

These relations fill a large complex graph.  The code elements of this graph can be analyzed for modularity as defined in a complex networks sense\cite{Clauset2004}.  The commit logs can be analyzed to attribute cost to various elements of code.

This process has at least the following two benefits

*   By assigning a value to programmer time and identifying modular elements we may be able to attribute an added cost of tightly coupled, unmodular code.
*   By looking at download counts and dependency graphs we can attribute impact factors to projects, teams, or individual developers.  By publishing an impact factor that benefits from good software engineering we hope to incentivize better practices in the future.

Understanding and expertise precede optimization.
