def memoize(f):
    cache = dict()
    def memoized_f(*args):
        if args in cache:
            return cache[args]
        result = f(*args)
        cache[args] = result
        return result
    return memoized_f
