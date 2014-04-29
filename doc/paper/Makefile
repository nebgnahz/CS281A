LATEX = pdflatex
DVIPDF = dvipdfm
SPELL = aspell
TEX = main
PDF = $(TEX).pdf
BIBTEX = bibtex
TEXFILES = $(wildcard *.tex)
SOURCES = $(wildcard *.tex) $(wildcard *.bib)

default: pdf

help:
	$(info using default filename: $(TEX).tex, you can edit it in this Makefile)
	$(info   - open, for Mac OS X Preview)
	$(info   - view, for machines with Acrobat)
	$(info   - clean, remove all intermediate files)

pdf: $(SOURCES)
	$(LATEX) $(TEX); $(BIBTEX) $(TEX); $(LATEX) $(TEX); $(LATEX) $(TEX);

main.pdf: pdf

check: $(TEXFILES)
	$(SPELL) check $(TEXFILES)

open: $(PDF)
	open $(TEX).pdf

view: pdf
	acroread $(TEX).pdf

clean:
	$(RM) -rf *.aux *.blg *.dvi *.log *.toc *.lof *.lot *.cb *.bbl $(TEX).ps $(TEX).pdf *~ *.out auto/
