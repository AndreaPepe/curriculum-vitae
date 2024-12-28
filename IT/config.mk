# Set to "y" to run pdflatex with -interaction=batchmode
# SILENT?=y

# Set to "y" to compile in draft mode
# DRAFT?=n

# Set to "y" to compile showing notes (this overwrites DRAFT)
# NOTES?=n

# Final name of you document (without .pdf extension)
FILENAME?=CV_Pepe_Andrea_IT

# Main LaTex source file (without .tex extension)
SOURCEFILE?=main

# Set this to a valid number to generate a warning if your document has more
# pages than this number
MAXPAGES?=1

# Aspell language
SPLANG?=italian

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
# EXTRABIBS?=

# The image directory; it will be recursively explored
IMG_DIR?=img

# Image file extensions
IMG_EXT?=jpg png pdf eps

# Top directory for bib files (recursively explored)
# BIB_DIR?=.

# Top directory for LaTex files (recursively explored)
TEX_DIR?=.
