
full.md: title.md introduction.md nwp.md uq-methods.md numerics.md unix.md
	cat title.md introduction.md nwp.md uq-methods.md numerics.md unix.md > full.md
	python scripts/dollar.py full.md full.md

full.tex: full.md full.md tex/preamble-extra.tex tex/biblio.tex
	pandoc full.md -o full.tex --standalone -H tex/preamble-extra.tex -A tex/biblio.tex

images/pdfs: images/*.svg images/*.dot
	python scripts/svg2pdf.py
	python scripts/dot2pdf.py

pdf: full.tex images/*.svg
	pdflatex full.tex

math-num: math-num-linalg-performance.md math-num-linalg-design.md linear-regression.md operation-ordering-matlab.md syrk.md 

outline: images/pdfs outline.md math-num
	python scripts/include.py outline.md outline2.md
	python scripts/dollar.py outline2.md outline2.md
	pandoc outline2.md -o outline.tex --standalone -H tex/preamble-extra.tex -A tex/biblio.tex
	pdflatex outline.tex


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
