FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://0001-Setup-U-boot-Environment.patch"

UBOOT_SUFFIX = "img"
SPL_BINARY = "MLO"
