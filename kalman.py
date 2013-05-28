from sympy import Symbol, MatrixSymbol, latex

n       = Symbol('n')                   # Number of variables in our system/current state
k       = Symbol('k')                   # Number of variables in the observation
mu      = MatrixSymbol('mu', n, 1)      # Mean of current state
Sigma   = MatrixSymbol('Sigma', n, n)   # Covariance of current state
H       = MatrixSymbol('H', k, n)       # A measurement operator on current state
R       = MatrixSymbol('R', k, k)       # Covariance of measurement noise
data    = MatrixSymbol('data', k, 1)    # Observed measurement data

newmu   = mu + Sigma*H.T * (R + H*Sigma*H.T).I * (H*mu - data)      # Updated mean
newSigma= Sigma - Sigma*H.T * (R + H*Sigma*H.T).I * H * Sigma       # Updated covariance

assumptions = (Q.positive_definite(Sigma), Q.symmetric(Sigma),
               Q.positive_definite(R), Q.symmetric(R), Q.fullrank(H))
