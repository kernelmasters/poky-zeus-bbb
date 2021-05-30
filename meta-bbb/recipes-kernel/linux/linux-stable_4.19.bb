require linux-stable.inc

COMPATIBLE_MACHINE = "beaglebone"

KERNEL_DEVICETREE ?= " \
    km-bbb-am335x.dtb \
"

LINUX_VERSION = "4.19"
LINUX_VERSION_EXTENSION = "-km-bbb"

FILESEXTRAPATHS_prepend := "${THISDIR}/linux-stable-${LINUX_VERSION}:"

S = "${WORKDIR}/git"

PV = "4.19.94"
SRCREV = "58ac7b864e15789f208b285202bbc31c91edd259"
SRC_URI = " \
    git://github.com/kernelmasters/beagleboneblack-kernel.git \
    file://defconfig \
    file://0001-Setup-Kernel-Environment.patch \
    file://0002-Mux-Config-in-DTS-LCD_DATA_13.GPIO0_9-LCD_DATA14.GPI.patch \
    file://0005-Enter-Switch-GPIO11-Raising-Edge-Interrupt-porting-o.patch \
"
