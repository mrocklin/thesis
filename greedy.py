from itertools import imap

def chain(seqs):
    """ Chain a sequence of sequences

    >>> list(chain([1, 2], [3, 4]))
    [1, 2, 3, 4]
    """
    for seq in seqs:
        for item in seq:
            yield item

def greedy(children, objective, isvalid, node):
    """ Greedy guided depth first search.  Returns iterator """
    if isvalid(node):
        return iter([node])

    f = partial(greedy, children, objective, isvalid)
    options = sorted(children(node), key=objective)
    streams = imap(f, options)

    return chain(streams)
