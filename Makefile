all: handout-python.pdf handout-kotlin.pdf

handout-python.pdf: handout-python.tex handout.tex
	pdflatex handout-python.tex
	pdflatex handout-python.tex
	pdflatex handout-python.tex

handout-kotlin.pdf: handout-kotlin.tex handout.tex
	pdflatex handout-kotlin.tex
	pdflatex handout-kotlin.tex
	pdflatex handout-kotlin.tex
