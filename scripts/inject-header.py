from sys import argv, exit

if len(argv) != 5:
    print "Usage: python %s template.tex header.tex injection_index output.tex"
    exit(1)

with open(argv[1]) as f:
    template_lines = f.readlines()

with open(argv[2]) as f:
    header_lines = f.readlines()

i = int(argv[3])
lines = template_lines[:i] + header_lines + template_lines[i:]

with open(argv[4], 'w') as f:
    for line in lines:
        f.write(line)
