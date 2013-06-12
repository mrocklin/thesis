
from logpy import run, lall, variables

def rewrite_step(expr, rewrites):
    """ Possible rewrites of expr given relation of patterns """
    target, condition = var(), var()
    with variables(*vars):
        return run(None, target, lall(rewrites(expr, target, condition),
                                          asko(condition, True)))
