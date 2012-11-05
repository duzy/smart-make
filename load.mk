#
#    Copyright (C) 2012, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
smart.me = $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
smart.root := $(smart.me)
smart.stack :=
smart.list :=
smart.export :=
smart.settle_root :=
smart.context.names := SM.MK NAME SRCDIR \
  MODULES SUBDIRS SOURCES PROGRAM LIBRARY REQUIRES \
  SETTLE_ROOT SETTLE \
  CFLAGS CXXFLAGS GOFLAGS ASFLAGS ARFLAGS LDFLAGS FULLLIBS LOADLIBS LIBADD \
  DEFINES INCLUDES INSTALLS INSTALL_PATH \
  APK PACKAGE PLATFORM LIBS SUPPORTS

define smart.internal
$(eval MAKEFILE_LIST := $(filter-out $(lastword $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))
endef #smart.internal

SMART.MK = $(SM.MK)
SMART.DECLARE := $(smart.root)/declare.mk
SMART.RULES := $(smart.root)/pend.mk

$(smart.internal)
ROOT := $(smart.me)
OUT = $(ROOT)/out

smart~error :=

#
#  @param: smart~fun
#  
define smart~defun
$(eval \
ifdef smart~fun
define $(smart~fun)
$$(eval \
   smart~error :=
   smart~result :=
   include $(smart.root)/funs/$(smart~fun)
   ifneq ($$(smart~error),)
     $$$$(error $(smart~fun): $$(smart~error))
   endif
  )$$(smart~result)
endef
endif
 )
endef #smart~defun

$(foreach smart~fun,\
    $(notdir $(filter-out %~,$(wildcard $(smart.root)/funs/smart.*))),\
    $(smart~defun))

smart~defun :=

.SUFFIXES:

PHONY := modules settle clean
ROOT.MK := $(wildcard $(ROOT)/sm.mk)
ifdef ROOT.MK
  include $(ROOT.MK)
else
  ROOT.MK := $(or $(wildcard $(ROOT)/smart),$(wildcard $(ROOT)/smart.mk))
  ifdef ROOT.MK
    MAKEFILE_LIST += $(ROOT.MK)
    include $(SMART.DECLARE)
    include $(ROOT.MK)
    include $(SMART.RULES)
  endif #ROOT.MK
endif #ROOT.MK

#$(warning info: $(smart.list))

define smart~unique
$(eval \
  ifdef $1
    smart~unique.v := $($1)
    $1 :=
    $$(foreach _,$$(smart~unique.v),$$(if $$(filter $$_,$$($1)),,$$(eval $1 += $$_)))
    $1 := $$(strip $$($1))
    smart~unique.v :=
  endif
 )
endef #smart~unique
#$(let (foo,abcdef),(bar,123456))

define smart~rules
$(eval \
  $(foreach @name,$(smart~sm),$(smart.restore))
  include $(smart.root)/rules.mk
 )
endef #smart~rules

$(foreach smart~sm,$(smart.list),$(smart~rules))

smart~rules :=

.DEFAULT_GOAL := modules
