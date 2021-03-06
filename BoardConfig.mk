#
# Copyright (C) 2007 The Android Open Source Project
# Copyright (C) 2012 The Cyanogenmod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# BoardConfig.mk
#
# Product-specific compile-time definitions.
#

TARGET_BOOTLOADER_BOARD_NAME := encore
TARGET_BOARD_PLATFORM := omap3

# inherit from the proprietary version
-include vendor/bn/encore/BoardConfigVendor.mk

# Target configuration (architecture/platform/board)
TARGET_ARCH := arm
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_VARIANT := cortex-a8
ARCH_ARM_HAVE_ARMV7A := true

COMMON_GLOBAL_CFLAGS += -DOMAP_ENHANCEMENT -DTARGET_OMAP3 -DOMAP_ENHANCEMENT_CPCAM

TARGET_SPECIFIC_HEADER_PATH := device/bn/encore/include

# System image configuration
TARGET_USERIMAGES_USE_EXT4 := true
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 461942784
BOARD_USERDATAIMAGE_PARTITION_SIZE := 987648000
BOARD_FLASH_BLOCK_SIZE := 4096

#WITH_DEXPREOPT := true

TARGET_RELEASETOOL_IMG_FROM_TARGET_SCRIPT := device/bn/encore/releasetools/encore_img_from_target_files
TARGET_RELEASETOOL_MAKE_RECOVERY_PATCH_SCRIPT := device/bn/encore/releasetools/encore_make_recovery_patch
TARGET_RELEASETOOL_OTA_FROM_TARGET_SCRIPT := device/bn/encore/releasetools/encore_ota_from_target_files
TARGET_SYSTEMIMAGE_USE_SQUISHER := true
TARGET_USE_FILE_OTA := true
TARGET_NOT_USE_GZIP_RECOVERY_RAMDISK := true
BOARD_CANT_BUILD_RECOVERY_FROM_BOOT_PATCH := true
TARGET_ALLOW_NON_PIE_EXECUTABLES := true
TARGET_NEEDS_NON_PIE_SUPPORT := true
TARGET_NO_RADIOIMAGE := true

# Kernel image configuration
KERNEL_TOOLCHAIN := $(ANDROID_BUILD_TOP)/prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/arm-eabi-4.8/bin
BOARD_KERNEL_CMDLINE := androidboot.console=ttyO0,115200n8 rw init=/init videoout=omap24xxvout omap_vout_mod.video1_numbuffers=6 omap_vout_mod.vid1_static_vrfb_alloc=y omap_vout_mod.video2_numbuffers=6 omap_vout_mod.vid2_static_vrfb_alloc=y omapfb.vram=0:8M no_console_suspend androidboot.selinux=permissive androidboot.hardware=encore
BOARD_KERNEL_BASE := 0x20000000
BOARD_KERNEL_IMAGE_NAME := uImage
BOARD_PAGE_SIZE := 0x00000800
BOARD_CUSTOM_BOOTIMG_MK := device/bn/encore/uboot-bootimg.mk
#BOARD_USES_UBOOT_MULTIIMAGE := true
TARGET_PROVIDES_RELEASETOOLS := true
# Include a 2ndbootloader
TARGET_BOOTLOADER_IS_2ND := true

SKIP_BOOT_JARS_CHECK := true

# Inline kernel building
TARGET_KERNEL_SOURCE := kernel/bn/encore
TARGET_KERNEL_CONFIG := encore_cm13_defconfig

TARGET_MODULES_SOURCE := "hardware/ti/wlan/mac80211/compat_wl12xx"

wifi_modules:
	make -C $(TARGET_MODULES_SOURCE) KERNEL_DIR=$(KERNEL_OUT) KLIB=$(KERNEL_OUT) KLIB_BUILD=$(KERNEL_OUT) ARCH=$(TARGET_ARCH) $(KERNEL_CROSS_COMPILE)
	mv hardware/ti/wlan/mac80211/compat_wl12xx/compat/compat.ko $(KERNEL_MODULES_OUT)
	mv hardware/ti/wlan/mac80211/compat_wl12xx/net/mac80211/mac80211.ko $(KERNEL_MODULES_OUT)
	mv hardware/ti/wlan/mac80211/compat_wl12xx/net/wireless/cfg80211.ko $(KERNEL_MODULES_OUT)
	mv hardware/ti/wlan/mac80211/compat_wl12xx/drivers/net/wireless/wl12xx/wl12xx.ko $(KERNEL_MODULES_OUT)
	mv hardware/ti/wlan/mac80211/compat_wl12xx/drivers/net/wireless/wl12xx/wl12xx_sdio.ko $(KERNEL_MODULES_OUT)
	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-unneeded $(KERNEL_MODULES_OUT)/compat.ko $(KERNEL_MODULES_OUT)/mac80211.ko $(KERNEL_MODULES_OUT)/cfg80211.ko $(KERNEL_MODULES_OUT)/wl12xx.ko $(KERNEL_MODULES_OUT)/wl12xx_sdio.ko

TARGET_KERNEL_MODULES := wifi_modules

# Conserve memory in the Dalvik heap
# Details: https://github.com/CyanogenMod/android_dalvik/commit/15726c81059b74bf2352db29a3decfc4ea9c1428
TARGET_ARCH_LOWMEM := true

# HW Graphics (EGL fixes + webkit fix)
BOARD_EGL_CFG := device/bn/encore/egl.cfg
USE_OPENGL_RENDERER := true
ENABLE_WEBGL := true

TARGET_RUNNING_WITHOUT_SYNC_FRAMEWORK := true

# for frameworks/native/opengl/libs
# disable use of unsupported EGL_KHR_gl_colorspace extension
BOARD_EGL_WORKAROUND_BUG_10194508 := true

# lame egl patch
# We do this on low-end devices only because it allows us to enable
# h/w acceleration in the systemui process while keeping the
# memory usage down.
BOARD_EGL_SYSTEMUI_PBSIZE_HACK := true


# for frameworks/native/libs/gui
# disable use of EGL_KHR_fence_sync extension, since it slows things down
COMMON_GLOBAL_CFLAGS += -DDONT_USE_FENCE_SYNC

# for frameworks/native/services/surfaceflinger
# use EGL_IMG_context_priority extension, which helps performance
COMMON_GLOBAL_CFLAGS += -DHAS_CONTEXT_PRIORITY

# OMAP3 HWC: disable use of YUV overlays
# Prevents stuttering/compositing artifacts and sync loss during video playback
TARGET_OMAP3_HWC_DISABLE_YUV_OVERLAY := true

# Storage
BOARD_VOLD_MAX_PARTITIONS := 8
BOARD_VOLD_EMMC_SHARES_DEV_MAJOR := true
TARGET_USE_CUSTOM_LUN_FILE_PATH := "/sys/class/android_usb/android0/f_mass_storage/lun%d/file"

# Connectivity - Wi-Fi
USES_TI_MAC80211 := true
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
WPA_SUPPLICANT_VERSION           := VER_0_8_X
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_wl12xx
BOARD_WLAN_DEVICE                := wl12xx_mac80211
WIFI_DRIVER_MODULE_PATH          := "/system/lib/modules/wl12xx_sdio.ko"
WIFI_DRIVER_MODULE_NAME          := "wl12xx_sdio"
WIFI_FIRMWARE_LOADER             := ""
COMMON_GLOBAL_CFLAGS             += -DUSES_TI_MAC80211
BOARD_WIFI_SKIP_CAPABILITIES     := true

# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_TI := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/bn/encore/bluetooth

# Audio
BOARD_USES_ALSA_AUDIO := true
#BOARD_USES_LEGACY_ALSA_AUDIO:= true

# If you'd like to build the audio components from source instead of using
# the prebuilts, uncomment BOARD_USES_ALSA_AUDIO := true above and add the
# following repositories to your manifest:
#
# <project name="steven676/android_hardware_alsa_sound" path="hardware/alsa_sound" remote="github" revision="jellybean-for-encore" />
# <project name="steven676/android_external_alsa-lib" path="external/alsa-lib" remote="github" revision="jellybean" />
#
# Also see encore.mk for further instructions.

# MultiMedia defines
USE_CAMERA_STUB := true
BOARD_USES_TI_OMAP_MODEM_AUDIO := false
HARDWARE_OMX := true

BOARD_USES_SECURE_SERVICES := true

# SELinux stuff
BOARD_SEPOLICY_DIRS += \
    device/bn/encore/sepolicy

# Boot animation
TARGET_BOOTANIMATION_PRELOAD := true
TARGET_BOOTANIMATION_TEXTURE_CACHE := true
TARGET_BOOTANIMATION_USE_RGB565 := true

# Recovery options

BOARD_CUSTOM_RECOVERY_KEYMAPPING := ../../device/bn/encore/recovery/recovery_keys.c
BOARD_CUSTOM_RECOVERY_UI := ../../device/bn/encore/recovery/recovery_ui.c
TARGET_RECOVERY_PRE_COMMAND := "/system/bin/update_bcb.sh"
TARGET_RECOVERY_FSTAB := device/bn/encore/fstab.encore
RECOVERY_FSTAB_VERSION := 2

#Config for building TWRP
DEVICE_RESOLUTION := 1024x600
RECOVERY_TOUCHSCREEN_SWAP_XY := true
RECOVERY_TOUCHSCREEN_FLIP_Y := true
TW_NO_REBOOT_BOOTLOADER := true
TW_NO_REBOOT_RECOVERY := true
TW_INTERNAL_STORAGE_PATH := "/emmc"
TW_INTERNAL_STORAGE_MOUNT_POINT := "emmc"
TW_EXTERNAL_STORAGE_PATH := "/sdc"
TW_EXTERNAL_STORAGE_MOUNT_POINT := "sdc"

TARGET_TI_HWC_HDMI_DISABLED := true
