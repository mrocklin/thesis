def compile(inputs, outputs, *assumptions):
    """ Compile math expressions to computation """
    c = Identity(*outputs)

    def isvalid(comp):
        return set(comp.inputs).issubset(inputs)

    with assuming(*assumptions):      # SymPy assumptions are globally available
        stream = greedy(children, objective, isvalid, c) # all valid computations
        result = next(stream)                            # first valid computation

    return result
