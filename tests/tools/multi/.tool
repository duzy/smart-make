discard := $(shell echo "$(NAME),$(SRCDIR),$(SM.MK),$(lastword $(MAKEFILE_LIST))" >> visit.log)
discard := $(shell echo "$(SRCDIR),$(lastword $(MAKEFILE_LIST)),$(TOOL)" >> tools.log)
ifdef TOOL
  $(error TOOL is not empty: "$(TOOL)")
endif
TOOL := gcc
