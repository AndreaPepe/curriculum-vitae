# Author:       Andrea Pepe     <pepe.andmj@gmail.com>
# Last update:  Dec 25th, 2024
# Version:      1.0.0

############################# Please Do Not Edit ##############################
SHELL:=/bin/bash

thisfile_path := $(realpath $(lastword $(MAKEFILE_LIST)))
thisfile_dir := $(dir $(thisfile_path))

LATEXCOMPILE := $(thisfile_dir)/latexcompile
ifneq (y, $(shell test -x $(LATEXCOMPILE) && echo "y"))
$(error "$(LATEXCOMPILE) not found or not executable!")
endif

-include config.mk
###############################################################################

SILENT?=y
DRAFT?=n
NOTES?=n

# Final name for your document
FILENAME?=document

# Main LaTex file (without .tex extension)
SOURCEFILE?=main

# This Makefile can give you a warning if your document is too long. If the
# following variable is left empty, no check is performed on the number of
# pages
MAXPAGES?=

# Aspell language
SPLANG?=english

# If you use "multibib" package, please set here the name of the extra bibs
#
# Example:
# 	\usepackage{multibib}
# 	\newcites{jour,conf}{%
# 		JournalBibTitle,%
# 		ConferenceBibTitle}
#
# 	then set:
# 	EXTRABIBS=jour conf
#
# 	otherwise leave it blank
EXTRABIBS?=

# The image directory; it will be recursively explored
IMG_DIR?=img

# Image file extensions
IMG_EXT?=jpg png pdf eps

# Top directory for bib files (recursively explored)
BIB_DIR?=.

# Top directory for LaTex files (recursively explored)
TEX_DIR?=.

############################ Do Not Edit Below ################################
BIBFILES=$(shell $(LATEXCOMPILE) --filelist $(BIB_DIR) bib)
TEXFILES=$(shell $(LATEXCOMPILE) --filelist $(TEX_DIR) tex)
IMGFILES=$(shell $(LATEXCOMPILE) --filelist $(IMG_DIR) $(IMG_EXT))
DATE:=$(shell date +%Y%m%d%H%M%S)

PDFOPT:=$(shell which qpdf 2>/dev/null)
ifeq (,$(PDFOPT))
	PDFOPT:=cp
endif

TARGET=$(FILENAME:%=%.pdf)

LOG=$(shell basename "$(SOURCEFILE:%=%.log)")

# latexcompile commands
_COMPILE := $(LATEXCOMPILE) --compile
COMPILE := $(_COMPILE) --multipleruns
COMPILE_SINGLE := $(_COMPILE) --singlerun

SHOWLOG := $(LATEXCOMPILE) --log
SHOW := $(LATEXCOMPILE) --show
CHECKPAGES := $(LATEXCOMPILE) --checkpages

SHOWERRORS := $(SHOWLOG) --error $(LOG)
SPELLCHECK := aspell -t -d $(SPLANG)

ifeq ($(DRAFT),y)
	PDFLATEX_OPTIONS=
	FILENAME:=$(FILENAME)-draft
else
	PDFLATEX_OPTIONS=\\def\\nodraft
endif

ifeq ($(NOTES),y)
	PDFLATEX_OPTIONS+=\\def\\shownotes
	FILENAME:=$(FILENAME)-notes
else
	PDFLATEX_OPTIONS+=
endif

ifeq ($(SILENT),y)
	INTERACTION=-interaction=batchmode
else
	INTERACTION=
endif


###### Begin Targets ######
all: $(TARGET)
	@$(SHOWLOG) --short $(LOG)
ifneq (,$(MAXPAGES))
	@$(CHECKPAGES) $(FILENAME:%=%.pdf) $(MAXPAGES)
endif

showlog: $(LOG)
	@$(SHOWLOG) --long $^

%.bbl: %.tex $(BIBFILES)
	@$(COMPILE_SINGLE) $(SOURCEFILE) $(DATE) $(INTERACTION) 	\
		$(PDFLATEX_OPTIONS) || ( $(SHOWERRORS) && false )
	@bibtex $(BIBFILES)
ifneq (,$(EXTRABIBS))
	$(foreach extrabib, $(EXTRABIBS), bibtex $(extrabib); )
endif

$(FILENAME).pdf: $(SOURCEFILE).pdf
	@$(PDFOPT) $^ $(FILENAME:%=%.pdf)

ifeq (,$(BIBFILES))
$(SOURCEFILE).pdf: $(TEXFILES) $(IMGFILES)
	@$(COMPILE_SINGLE) $(SOURCEFILE) $(DATE) $(INTERACTION) 	\
		$(PDFLATEX_OPTIONS) || ( $(SHOWERRORS) && false )
else
$(SOURCEFILE).pdf: $(SOURCEFILE).bbl $(TEXFILES) $(IMGFILES)
	@$(COMPILE) $(SOURCEFILE) $(DATE) $(INTERACTION) 		\
		$(PDFLATEX_OPTIONS) || ( $(SHOWERRORS) && false )
endif

spellcheck:
	for f in $(TEXFILES); do $(SPELLCHECK) -c $$f; done

show: all
	@$(SHOW) $(FILENAME).pdf &

# Quick build: no bibtex, no toc, no pdf optimization
dev: $(SOURCEFILE)-dev.pdf

$(SOURCEFILE)-dev.pdf: $(TEXFILES) $(IMGFILES)
	@$(COMPILE_SINGLE) $(SOURCEFILE) $(DATE) $(INTERACTION) 	\
		$(PDFLATEX_OPTIONS) || ( $(SHOWERRORS) && false )
	@mv $(SOURCEFILE).pdf $(SOURCEFILE)-dev.pdf

showdev: dev
	@$(SHOW) $(FILENAME)-dev.pdf &

clean:
	$(RM) -f *~ *.dvi *.aux *.log *.out *.blg *.bbl *.lof *.lot *.toc
	$(RM) -f *.maf *.nlo *.mtc *.mtc? *.backup *.snm *.nav *.vrb
	$(RM) -f $(SOURCEFILE:%=%.pdf) *.bak $(SOURCEFILE)-dev.pdf

distclean: clean
	$(RM) -f $(TARGET)


.DEFAULT_GOAL:=all
.PRECIOUS: %.bbl %.pdf
.PHONY: all showlog spellcheck show dev showdev clean distclean
.SILENT: show showdev
