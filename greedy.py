from itertools import imap, chain

def greedy(children, objective, isvalid, node):
    """ Greedy guided depth first search.  Returns iterator """
    if isvalid(node):
        return iter([node])

    kids = sorted(children(node), key=objective)
    streams = (greedy(children, objective isvalid, kid) for kid in kids)

    return chain.from_iterator(streams)
