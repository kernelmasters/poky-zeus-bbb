FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://0002-Select-LCD_DATA14-pin-functionality-to-GPIO0_10-to-c.patch \
            file://0003-Select-LCD_DATA15-pin-functionality-to-GPIO0_11-to-r.patch \
"

UBOOT_SUFFIX = "img"
SPL_BINARY = "MLO"
