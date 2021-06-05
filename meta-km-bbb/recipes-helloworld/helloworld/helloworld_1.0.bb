require helloworld.inc
SECTION = "helloworld"
DEPENDS = ""
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b2424aed282074c27f97c20dcbf25df3"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"
S = "${WORKDIR}/git"
inherit autotools
