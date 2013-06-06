from numpy import loadtxt

times = loadtxt('image-scripts/profile_gemm.dat')

import pylab
f = pylab.figure(figsize=(10, 4))
pylab.plot(times)
pylab.ylabel('Duration (s)')
pylab.savefig('images/gemm-profile-fortran.pdf')

f = pylab.figure()
pylab.hist(times, bins=100)
pylab.xlabel('Duration (s)')
pylab.savefig('images/gemm-hist-fortran.pdf')
