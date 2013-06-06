from sympy import MatrixSymbol, Symbol, Q, assuming, ZeroMatrix
from computations.matrices.blas import GEMM
from computations.profile import ProfileMPI
from computations.matrices.fortran.core import build

n = Symbol('n')
A = MatrixSymbol('A', n, n)
B = MatrixSymbol('B', n, n)

gemm = GEMM(1, A, B, 0, ZeroMatrix(n, n))
pgemm = ProfileMPI(gemm)

with assuming(Q.real_elements(A), Q.real_elements(B)):
    f = build(pgemm, [A, B], [pgemm.duration])

import numpy
nA = numpy.random.rand(1000, 1000)
nB = numpy.random.rand(1000, 1000)

times = [f(nA, nB) for i in range(1000)]

savetxt('profile_gemm.dat', times)

import pylab
f = pylab.figure(figsize=(10, 4))
pylab.plot(times)
pylab.ylabel('Duration (s)')
pylab.savefig('images/gemm-profile.pdf')

f = pylab.figure()
pylab.hist(times, bins=100)
pylab.xlabel('Duration (s)')
pylab.savefig('images/gemm-hist.pdf')
