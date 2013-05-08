
Declarative Programming
=======================

\label{sec:declarative}

Mathematical experts often lack training to produce efficient modular software.  Discuss how the projects above made use of declarative techniques to separate mathematical expertise from algorithmic term rewriting.  

------------- ---------------------------------------------------------------
 Background   Stratego/XT, Maude, miniKanren (a simple embedding in Scheme).
              Considerations about term rewrite systems.                                        

 Approach     [Strategies](http://github.com/logpy/strategies) and 
              [LogPy](http://github.com/logpy/logpy), 
              implementations of miniKanren and Stratego in Python 

 Results      Look at use of these systems in above work 
              and in other work in Theano
------------- ---------------------------------------------------------------

In intend to refactor Theano, a library/compiler for array computation used primarily by machine learning groups, to depend on LogPy, my Prolog-ish clone, and Strategies, my Stratego clone.  Perhaps something worth writing about will come out of this.  They have a rudimentary system to write down compiler optimizations.  It's clear that this system is not sufficiently simple to be used by any but their most senior developers.


### Motivation

Separation of mathematical logic and algorithmic control aligns well with the distribution of expertise within scientific computing.


### Background

#### Logic Programming

#### Term Rewrite Systems

#### Control Flow

include [LogPy](logpy.md)

### Strategies

Strategies is a mimicry of [Stratego](http://strategoxt.org/)\cite{stratego} in Python.
