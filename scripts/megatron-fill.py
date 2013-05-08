keys = ['all', 'math', 'computation', 'pattern', 'search', 'megatron']

normal_fill = 5
special_fill = 30

fn = 'tikz'

with open(fn+'.md') as f:
    template = f.read()

for key in keys:
    with open("%s_%s.md"%(fn, key), 'w') as f:
        d = dict(zip(keys, [normal_fill]*len(keys)))
        d[key] = special_fill
        f.write(template % d)
