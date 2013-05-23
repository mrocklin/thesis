order = [FFTW, POSV, GESV, LASWP, SYRK, SYMM, GEMM, AXPY]
def objective(comp):
    """ Cost of a computation `comp` - lower is better """
    if isinstance(comp, CompositeComputation):
        return sum(map(objective, comp.computations))
    else:
        return order.index(type(comp))
