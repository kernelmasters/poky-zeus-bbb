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
"
