from numpy import *
from pylab import *
sizes = loadtxt('image-scripts/data/sizes.dat', skiprows=1)
times_send = loadtxt('image-scripts/data/times_send.dat')
times_recv = loadtxt('image-scripts/data/times_recv.dat')
groups = times_send.reshape(100, 100)
ssizes = sizes.reshape(100, 100).mean(1)

figure()
xlabel('Bytes')
ylabel('Relative Variation (unitless)')
loglog(ssizes*8, groups.std(1) / groups.mean(1))
savefig('images/communication-variation.pdf')

figure()
xlabel('Bytes')
ylabel('Communication Time (s)')
loglog(sizes, times_recv, '.')
savefig('images/communication-time.pdf')
