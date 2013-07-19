from numpy import loadtxt

fort_times = loadtxt('image-scripts/profile_gemm_fortran.dat')
py_times = loadtxt('image-scripts/profile_gemm.dat')

import pylab
f = pylab.figure()
pylab.hist(fort_times, bins=100)
pylab.xlabel('Duration (s)')
pylab.title('GEMM Runtimes')
ax = pylab.axis()
pylab.savefig('images/gemm-hist-fortran.pdf')

f = pylab.figure()
pylab.hist(py_times, bins=100)
pylab.xlabel('Duration (s)')
pylab.title('GEMM Runtimes')
pylab.axis(ax)
pylab.savefig('images/gemm-hist.pdf')

f = pylab.figure(figsize=(10, 4))
pylab.plot(py_times)
pylab.ylabel('Duration (s)')
pylab.title('GEMM Runtimes')
ax = pylab.axis()
pylab.savefig('images/gemm-profile.pdf')

f = pylab.figure(figsize=(10, 4))
pylab.plot(fort_times)
pylab.ylabel('Duration (s)')
pylab.title('GEMM Runtimes')
pylab.axis(ax)
pylab.savefig('images/gemm-profile-fortran.pdf')

f = pylab.figure()
pylab.hist(fort_times, bins=100)
pylab.hist(py_times, bins=100)
pylab.legend(["Fortran", "Python"])
pylab.xlabel('Duration (s)')
pylab.title('GEMM Runtimes')
pylab.savefig('images/gemm-hist-both.pdf')

f = pylab.figure(figsize=(10, 4))
pylab.plot(fort_times)
pylab.plot(py_times)
pylab.legend(["Fortran", "Python"])
pylab.title('GEMM Runtimes')
pylab.ylabel('Duration (s)')
pylab.savefig('images/gemm-profile-both.pdf')
