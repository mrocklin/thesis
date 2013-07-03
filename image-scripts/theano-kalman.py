from computations.matrices.examples import kalman
from sympy.printing.theanocode import theano_function
f = theano_function(kalman.inputs,
                    kalman.outputs,
                    {i: 'float64' for i in kalman.inputs})
import theano
theano.printing.pydotprint(f, format='dot', outfile='images/theano-kalman')

