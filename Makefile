
full.md: title.md introduction.md nwp.md uq-methods.md numerics.md unix.md
	cat title.md introduction.md nwp.md uq-methods.md numerics.md unix.md > full.md
	python scripts/dollar.py full.md full.md

full.tex: full.md full.md tex/preamble-extra.tex tex/biblio.tex
	pandoc full.md -o full.tex --standalone -H tex/preamble-extra.tex -A tex/biblio.tex

tikz-images: tikz.md scripts/megatron-fill.py
	python scripts/megatron-fill.py

images/pdfs: images/*.svg images/*.dot
	python scripts/svg2pdf.py
	python scripts/dot2pdf.py

pdf: full.tex images/*.svg
	pdflatex full.tex

math-num: math-num-linalg.md math-num-linalg-validation.md linear-regression.md operation-ordering-matlab.md syrk.md cas.md sympy-inference.md tikz-images

times-fortran:
	 ~/Software/openmpi-1.6.4/bin/mpif90 image-scripts/profile_gemm.f90 -lblas -o image-scripts/profile_gemm.out
	 ~/Software/openmpi-1.6.4/bin/mpirun image-scripts/profile_gemm.out > image-scripts/profile_gemm_fortran.dat

lib.bib: library.bib library2.bib
	cat library.bib library2.bib > lib.bib

outline: images/pdfs outline.md math-num front.md lib.bib
	python scripts/include.py outline.md outline2.md
	python scripts/dollar.py outline2.md outline2.md
	pandoc outline2.md -o outline.tex --standalone -H tex/preamble-extra.tex -A tex/biblio.tex
	python scripts/inject-header.py outline.tex tex/header.tex 1 outline.tex
	pdflatex outline.tex
	bibtex outline.aux


publish: outline 
	scp outline.pdf ankaa.cs.uchicago.edu:html/storage/outline.pdf

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
