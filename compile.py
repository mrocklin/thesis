def compile(inputs, outputs, *assumptions):
    """ Compile math expressions to computation """
    c = Identity(*outputs)

    def isvalid(comp):
        return set(comp.inputs).issubset(inputs)

    with assuming(*assumptions):      # SymPy assumptions available
        stream = greedy(children, objective, isvalid, c)
        result = next(stream)

    return result
