def compile(inputs, outputs, *assumptions):
    """
    Produce computation from mathematical expressions and logical assumptions
    """
    c = Identity(*outputs)

    isvalid = lambda comp: set(comp.inputs).issubset(inputs)

    with assuming(*assumptions):      # SymPy assumptions are globally available
        stream = greedy(children, objective, isvalid, c)# all valid computations
        result = next(stream)                           # first valid computtion

    return result
