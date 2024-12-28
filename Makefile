############################# Please Do Not Edit ##############################
SHELL:=/bin/bash

thisfile_path := $(realpath $(lastword $(MAKEFILE_LIST)))
thisfile_dir := $(dir $(thisfile_path))
###############################################################################

# Each directory contains a language version of the same CV
DIRS?=EN IT
TARGETS=$(DIRS:%=CV_Pepe_Andrea_%.pdf)
_INNER_TARGETS=$(foreach d, $(DIRS), $d/CV_Pepe_Andrea_$d.pdf)

all: $(TARGETS)
	@echo ""
	@echo "Done!"

$(TARGETS): $(TARGETS:CV_Pepe_Andrea_%.pdf=%)
	@cp $(@:CV_Pepe_Andrea_%.pdf=%)/$@ $@ 

$(DIRS): $(_INNER_TARGETS)

$(_INNER_TARGETS):
	+make -C $(dir $@)

clean: $(DIRS:%=%-clean)
	@$(RM) -f *.log
	@$(RM) -f $(TARGETS)

$(DIRS:%=%-clean):
	+make -C $(@:%-clean=%) distclean

.DEFAULT_GOAL:=all
.PHONY: all clean $(DIRS) $(DIRS:%=%-clean)
