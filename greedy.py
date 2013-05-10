
from itertools import chain
def greedy(children, objective, isvalid, node):
    """ Greedy guided depth first search

    Returns:  a lazy iterator of nodes

    children    :: a -> [a]     --  Children of node
    objective   :: a -> score   --  Quality of node
    isvalid     :: a -> bool    --  Successful leaf of tree
    """
    if isvalid(node):
        return iter([node])

    f = partial(greedy, children, objective, isvalid)
    options = sorted(children(node), key=objective)
    streams = map(f, options)

    return it.chain(*streams)
