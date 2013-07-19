from numpy import *
from pylab import *
sizes = loadtxt('image-scripts/data/sizes.dat', skiprows=1)
times_send = loadtxt('image-scripts/data/times_send.dat')
times_recv = loadtxt('image-scripts/data/times_recv.dat')
groups = times_send.reshape(100, 100)
ssizes = sizes.reshape(100, 100).mean(1)
bytes = ssizes * 8

figure()
xlabel('Bytes')
ylabel('Relative Variation (unitless)')
loglog(ssizes*8, groups.std(1) / groups.mean(1))
savefig('images/communication-variation.pdf')

invband, latency = polyfit(sizes*8, times_recv, 1, w=1./sizes)
model = lambda bytes: latency + bytes*invband

figure()
xlabel('Bytes')
ylabel('Communication Time (s)')
loglog(sizes*8, times_recv, '.')
loglog(sizes*8, model(sizes*8))
legend(['Data', 'Model'])
title('Latency: %.1e Bandwidth: %.1e'%(latency, 1./invband))
savefig('images/communication-time.pdf')
