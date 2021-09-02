HOMEPAGE = "https://github.com/kernelmasters"
DESCRIPTION = "U-Boot, a boot loader for Embedded boards based on PowerPC, \
ARM, MIPS and several other processors, which can be installed in a boot \
ROM and used to initialize and test the hardware or to download and run \
application code."
SECTION = "bootloaders"
DEPENDS += "flex-native bison-native"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=30503fd321432fc713238f582193b78e"
PE = "1"

# We use the revision in order to avoid having to fetch it from the
# repo during parse
SRCREV = "c3929a23a38d0aaa46e1fabd50c9486de41452e3"

SRC_URI = "git://github.com/kernelmasters/beagleboneblack-uboot.git"

S = "${WORKDIR}/git"
