SECTION = "devel"
SUMMARY = "Linux Trace Toolkit KERNEL MODULE"
DESCRIPTION = "The lttng-modules 2.0 package contains the kernel tracer modules"
LICENSE = "LGPLv2.1 & GPLv2 & MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=c4613d1f8a9587bd7b366191830364b3 \
                    file://gpl-2.0.txt;md5=751419260aa954499f7abaabaa882bbe \
                    file://lgpl-2.1.txt;md5=243b725d71bb5df4a1e5920b344b86ad \
                    "

inherit module

COMPATIBLE_HOST = '(x86_64|i.86|powerpc|aarch64|mips|nios2|arm|riscv).*-linux'

SRC_URI = "https://lttng.org/files/${BPN}/${BPN}-${PV}.tar.bz2 \
           file://Makefile-Do-not-fail-if-CONFIG_TRACEPOINTS-is-not-en.patch \
           file://BUILD_RUNTIME_BUG_ON-vs-gcc7.patch \
           "

SRC_URI[md5sum] = "3e9ed67a2da17edf93194f8a5e75a246"
SRC_URI[sha256sum] = "d0ba614a9cac3daf8ac034837f8b786e6be2ce0242aeecef7096bed5e03b762c"

export INSTALL_MOD_DIR="kernel/lttng-modules"

EXTRA_OEMAKE += "KERNELDIR='${STAGING_KERNEL_DIR}'"

do_install_append() {
	# Delete empty directories to avoid QA failures if no modules were built
	find ${D}/${nonarch_base_libdir} -depth -type d -empty -exec rmdir {} \;
}

python do_package_prepend() {
    if not os.path.exists(os.path.join(d.getVar('D'), d.getVar('nonarch_base_libdir')[1:], 'modules')):
        bb.warn("%s: no modules were created; this may be due to CONFIG_TRACEPOINTS not being enabled in your kernel." % d.getVar('PN'))
}

BBCLASSEXTEND = "devupstream:target"
LIC_FILES_CHKSUM_class-devupstream = "file://LICENSE;md5=c4613d1f8a9587bd7b366191830364b3"
DEFAULT_PREFERENCE_class-devupstream = "-1"
SRC_URI_class-devupstream = "git://git.lttng.org/lttng-modules;branch=stable-2.10 \
           file://Makefile-Do-not-fail-if-CONFIG_TRACEPOINTS-is-not-en.patch \
           file://BUILD_RUNTIME_BUG_ON-vs-gcc7.patch \
           "
SRCREV_class-devupstream = "b34304f146ea234ea764580d7ce1b03d05a215f9"
PV_class-devupstream = "2.10.14+git${SRCPV}"
S_class-devupstream = "${WORKDIR}/git"
SRCREV_FORMAT ?= "lttng_git"
