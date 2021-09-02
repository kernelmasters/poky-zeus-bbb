FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://0001-Select-LCD_DATA14-pin-functionality-to-enable-GPIO0_.patch"

UBOOT_SUFFIX = "img"
SPL_BINARY = "MLO"
