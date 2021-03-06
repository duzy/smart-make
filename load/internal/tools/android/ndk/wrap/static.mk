NDK_BUILD_TYPE := static
NDK_BUILD_TARGETS :=
$(foreach 1,$(APP_ABI),$(eval NDK_BUILD_TARGETS += obj/local/$1/lib$(LOCAL_MODULE:lib%=%).a))

NDK_EXPORT := yes

define smart~export_static
  $(OUT)/.export/$(NAME)/Android.mk: $(NDK_BUILD_TARGETS:%=$(SRCDIR)/%) \
    $(smart.root)/internal/android/ndkbuild/static.mk
	@mkdir -p $$(@D)
	@echo "# Generated by smart, don't edit!" > $$@
	@echo 'LOCAL_PATH := $$$$(call my-dir)' >> $$@
	@echo 'include $$$$(CLEAR_VARS)' >> $$@
	@echo 'LOCAL_MODULE := $(LOCAL_MODULE)' >> $$@
	@echo 'LOCAL_SRC_FILES := ../../../$(SRCDIR)/obj/local/$$$$(TARGET_ARCH_ABI)/lib$$$$(LOCAL_MODULE).a' >> $$@
	@echo 'LOCAL_EXPORT_C_INCLUDES := $(LOCAL_EXPORT_C_INCLUDES:%=$(PWD)/$(SRCDIR)/%)' >> $$@
	@echo 'LOCAL_EXPORT_LDLIBS := $(LOCAL_EXPORT_LDLIBS)' >> $$@
	@echo 'include $$$$(PREBUILT_STATIC_LIBRARY)' >> $$@
	@echo "exported: $(NAME)/Android.mk"
endef #smart~export_static
$(eval $(smart~export_static))
smart~export_static :=
