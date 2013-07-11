
tikz-images: tikz.md scripts/megatron-fill.py
	python scripts/megatron-fill.py

images/pdfs: images/*.svg images/*.dot
	python scripts/svg2pdf.py
	python scripts/dot2pdf.py

math-num: math-num-linalg.md math-num-linalg-validation.md linear-regression.md operation-ordering-matlab.md syrk.md cas.md sympy-inference.md tikz-images

times-fortran:
	 ~/Software/openmpi-1.6.4/bin/mpif90 image-scripts/profile_gemm.f90 -lblas -o image-scripts/profile_gemm.out
	 ~/Software/openmpi-1.6.4/bin/mpirun image-scripts/profile_gemm.out > image-scripts/profile_gemm_fortran.dat

lib.bib: library.bib library2.bib
	cat library.bib library2.bib > lib.bib

dissertation: images/pdfs dissertation.md math-num front.md lib.bib
	python scripts/include.py dissertation.md dissertation2.md
	python scripts/dollar.py dissertation2.md dissertation2.md
	pandoc dissertation2.md -o dissertation.tex --standalone -H tex/preamble-extra.tex -A tex/biblio.tex
	python scripts/inject-header.py dissertation.tex tex/header.tex 1 dissertation.tex
	pdflatex dissertation.tex
	bibtex dissertation.aux

nexus-10: dissertation
	bluetooth-sendto dissertation.pdf --device $$NEXUS_10

publish: dissertation 
	scp dissertation.pdf ankaa.cs.uchicago.edu:html/storage/dissertation.pdf

official: dissertation
	cat dissertation.tex 												 \
				| sed s/\\\\section/\\\\chapter/  							 \
				| sed s/subsection/section/          					 \
				| sed s/\\documentclass\\[\\]{article}/\\documentclass{ucetd}/ \
				| sed s/\\\\renewcommand.*$$/\\n/  						 \
				> tmp.dat												 \
		&& mv tmp.dat official.tex

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
