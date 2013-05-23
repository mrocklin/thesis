computations_for = partial(rewrite_step, rewrites=computes)
def children(comp):
    """ Compute next options in tree of possible algorithms """
    atomics = sum(map(computations_for, comp.inputs), ())
    return map(comp.__add__, atomics)
