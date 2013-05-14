#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

define smart~rule
  $(OUT)/$(NAME)/proguard.cfg:
	@mkdir -p $$(@D)
	@echo "# Generated by smart-make, don't edit me!" > $$@
	@echo "# Edit '$(PROGUARD)' instead!" >> $$@
	@echo "-libraryjars $(ANDROID_PLATFORM_LIB)" >> $$@
	@for L in $(LIBS.java); do echo "-libraryjars $$$$L" >> $$@ ; done
	@echo "-injars classes" >> $$@
	@echo "-outjars classes-obfuscated.jar" >> $$@
	@echo "-printmapping classes-obfuscated.map" >> $$@
	@echo "-include res.pro" >> $$@
	@echo "-include ../../$(PROGUARD)" >> $$@
  $(OUT)/$(NAME)/classes-obfuscated.jar: $(PROGUARD) \
     $(OUT)/$(NAME)/res.pro $(OUT)/$(NAME)/proguard.cfg \
     $(OUT)/$(NAME)/.classes
	@java -jar $(ANDROID.proguard)/lib/proguard.jar @$(OUT)/$(NAME)/proguard.cfg
endef #smart~rule

$(eval $(smart~rule))
