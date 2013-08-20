
tikz-images: tikz.md scripts/megatron-fill.py
	python scripts/megatron-fill.py

images/pdfs: images/*.svg images/*.dot
	python scripts/svg2pdf.py
	python scripts/dot2pdf.py

times-fortran:
	 ~/Software/openmpi-1.6.4/bin/mpif90 image-scripts/profile_gemm.f90 -lblas -o image-scripts/profile_gemm.out
	 ~/Software/openmpi-1.6.4/bin/mpirun image-scripts/profile_gemm.out > image-scripts/profile_gemm_fortran.dat

commtimes:
	mpif90 image-scripts/timempi.f90 -o image-scripts/timempi.out
	mpirun --np 2 --hostfile hostfile image-scripts/timempi.out
	python image-scripts/plot_variation.py

lib.bib: library.bib library2.bib
	cat library.bib library2.bib > lib.bib

header-tmp.tex: tex/official-header.tex
	cat tex/official-header.tex \
		| sed s/[0-9]\.[0-9]*,[0-9]\.[0-9]*,[0-9]\.[0-9]*/0.00,0.00,0.00/g \
		> tex/header-tmp.tex


dissertation2.md: images/pdfs dissertation.md front.md lib.bib header-tmp.tex
	python scripts/include.py dissertation.md dissertation2.md
	python scripts/dollar.py dissertation2.md dissertation2.md

tech-report.tex: 
	python scripts/include.py tech-report.md tech-report2.md
	python scripts/dollar.py tech-report2.md tech-report2.md
	pandoc tech-report2.md -o tech-report.tex --standalone -H tex/header.tex

tech-report: tech-report.tex
	pdflatex tech-report.tex
	bibtex tech-report.aux

dissertation.tex: dissertation2.md
	pandoc dissertation2.md -o dissertation.tex
	cat tex/header-tmp.tex dissertation.tex tex/official-footer.tex \
				| sed s/\\\\section/\\\\chapter/  						 \
				| sed s/subsection/section/          					 \
				> tmp.dat												 \
		&& mv tmp.dat dissertation.tex

dissertation: dissertation.tex
	pdflatex dissertation.tex
	bibtex dissertation.aux

nexus-10: dissertation
	bluetooth-sendto dissertation.pdf --device $$NEXUS_10

publish: dissertation 
	scp dissertation.pdf ankaa.cs.uchicago.edu:html/storage/dissertation.pdf

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

