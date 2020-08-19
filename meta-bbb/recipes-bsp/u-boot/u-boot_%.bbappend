FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://0001-Enable-multi-boot-menu-km_bootmenu-option-in-yocto-p.patch"

UBOOT_SUFFIX = "img"
SPL_BINARY = "MLO"
