from sympy import Symbol, MatrixSymbol, latex

n       = Symbol('n')                   # Number of variables in state
k       = Symbol('k')                   # Number of variables in observation
mu      = MatrixSymbol('mu',    n, 1)   # Mean of current state
Sigma   = MatrixSymbol('Sigma', n, n)   # Covariance of current state
H       = MatrixSymbol('H',     k, n)   # Measurement operator
R       = MatrixSymbol('R',     k, k)   # Covariance of measurement noise
data    = MatrixSymbol('data',  k, 1)   # Observed measurement data

# Updated mean
newmu   = mu + Sigma*H.T * (R + H*Sigma*H.T).I * (H*mu - data)
# Updated covariance
newSigma= Sigma - Sigma*H.T * (R + H*Sigma*H.T).I * H * Sigma

assumptions = (Q.positive_definite(Sigma), Q.symmetric(Sigma),
               Q.positive_definite(R), Q.symmetric(R), Q.fullrank(H))
