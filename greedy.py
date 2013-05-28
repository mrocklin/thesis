from itertools import imap, chain

def greedy(children, objective, isvalid, node):
    """ Greedy guided depth first search.  Returns iterator """
    if isvalid(node):
        return iter([node])

    f = partial(greedy, children, objective, isvalid)
    kids = sorted(children(node), key=objective)
    streams = imap(f, kids)

    return chain(streams)
