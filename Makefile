
full.md: title.md introduction.md
	cat title.md introduction.md > full.md
	python scripts/dollar.py full.md full.md

full.tex: full.md full.md tex/preamble-extra.tex tex/biblio.tex
	pandoc full.md -o full.tex --standalone -H tex/preamble-extra.tex -A tex/biblio.tex

pdf: full.tex
	pdflatex full.tex

publish: pdf
	scp full.pdf ankaa.cs.uchicago.edu:html/tempspace/thesis.pdf

clean:
	rm -f *.aux
	rm -f *.log
	rm -f *.out
	rm -f *.tex
	rm -f full*.md
	rm -f *.pdf
	rm -f tmp/*.md
	rm -f lib.bib
	rm -f *.bbl
	rm -f *.blg
