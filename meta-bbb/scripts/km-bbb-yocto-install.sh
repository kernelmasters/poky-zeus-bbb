#!/bin/bash -e

##############################################
############     READ This  ##################
# Run the below command, output of this script file is copied in to "km-bbb-kernel-build.log" file it is useful for further analysis.
# $ ./km-bbb-kernel-install.sh | tee km-bbb-kernel-install.log
##############################################

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
NC='\033[0m'              # No Color
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

BRedU='\033[4;31m'         # Underline
clear
temp=$USER
echo "User Name:$temp"
check_mmc () {
        FDISK=$(LC_ALL=C fdisk -l 2>/dev/null | grep "Disk ${media}:" | awk '{print $2}')

        if [ "x${FDISK}" = "x${media}:" ] ; then
                echo ""
                echo "I see..."
                echo ""
                echo "lsblk:"
                lsblk | grep -v sr0
                echo ""
                unset response
                echo -ne "${Green}Are you 100% sure, on selecting [${media}] (y/n)? ${NC}"
                read response
                if [ "x${response}" != "xy" ] ; then
                        exit
                fi
                echo ""
        else
                echo ""
                echo -e "${Red}Are you sure? I Don't see [${media}], here is what I do see...${NC}"
                echo ""
                echo "lsblk:"
                lsblk | grep -v sr0
                echo ""
                echo -e "${Green}Permission Denied. Run with sudo"
                exit
        fi

}
    SRCDIR=~/poky-zeus-bbb/build/tmp/deploy/images/beaglebone
  
MLO_uboot_copy_sd()
{

#       echo -e "${Green}-----------------------------${NC}"
        echo "Zeroing out Drive"
        echo -e "${Green}-----------------------------${NC}"
        #        dd if=/dev/zero of=${media} bs=1M count=100 || drive_error_ro
        #        sync
        #       dd if=${media} of=/dev/null bs=1M count=100
        #       sync
        echo Using dd to place bootloader on drive

        echo -e "${Green}-----------------------------${NC}"
        echo -e "${Red}MLO: dd if=MLO of=/dev/sdc count=2 seek=1 bs=128k  ${NC}"
                dd if=${SRCDIR}/MLO of=${media} count=2 seek=1 bs=128k
        echo -e "${Green}-----------------------------${NC}"

        echo -e "${Green}-----------------------------${NC}"
        echo -e "${Red}u-boot.img: dd if=u-boot.img of=/dev/sdc count=4 seek=1 bs=384k${NC}"
                dd if=${SRCDIR}/u-boot.img of=${media} count=4 seek=1 bs=384k
        echo -e "${Green}-----------------------------${NC}"

}



unmount_all_drive_partitions () {

	     echo ""
        echo "Unmounting Partitions"
        echo "-----------------------------"

        NUM_MOUNTS=$(mount | grep -v none | grep "${media}" | wc -l)

##      for (i=1;i<=${NUM_MOUNTS};i++)
        for ((i=1;i<=${NUM_MOUNTS};i++))
        do
                DRIVE=$(mount | grep -v none | grep "${media}" | tail -1 | awk '{print $1}')
                umount ${DRIVE} >/dev/null 2>&1 || true
        done
}


if [ -z "$1" ]; then
	echo -e "${Green}usage: sudo $(basename $0) [--mmc /dev/sdX]${NC}"
fi
# parse commandline options
while [ ! -z "$1" ] ; do
        case $1 in
        -h|--help)
		echo "usage: sudo $(basename $0) --mmc /dev/sdX "
                ;;
	--mmc)
		media=$2
		check_mmc
		unmount_all_drive_partitions
		MLO_uboot_copy_sd
		sudo mkdir -p /mnt/rootfs
	        sudo mount ${media}1 /mnt/rootfs/

		echo -e "${Purple}tar -xvf console-*.tar.xz -C  /mnt/rootfs/${NC}"
		sudo tar -xvf ${SRCDIR}/console-image-beaglebone-*.tar.xz -C  /mnt/rootfs/
		#ls  /mnt/rootfs/lib/modules/ >  abc
		#KERNEL_UTS=$(cat "./abc" | awk '{print $1}' | sed 's/\"//g' )

		KERNEL_UTS=4.19.94-km-bbb
		#cd /mnt/rootfs/boot/
		sudo rm /mnt/rootfs/boot/*.dtb
		
		echo -e "${Purple}mkdir -p dtbs/${KERNEL_UTS}${NC}"
		sudo mkdir -p /mnt/rootfs/boot/dtbs/${KERNEL_UTS}

		echo -e "${Purple}sudo mv km-bbb-am335x.dtb /mnt/rootfs/boot/dtbs/${KERNEL_UTS}/${NC}"
		sudo cp ${SRCDIR}/km-bbb-am335x.dtb /mnt/rootfs/boot/dtbs/${KERNEL_UTS}/km-bbb-am335x.dtb
		echo -e "${Purple}sudo mv zImage-${KERNEL_UTS}  /mnt/rootfs/boot/vmlinuz-${KERNEL_UTS}${NC}"
		sudo cp ${SRCDIR}/zImage  /mnt/rootfs/boot/vmlinuz-${KERNEL_UTS}

		sudo  echo "uname_r=${KERNEL_UTS}" > /mnt/rootfs/boot/uEnv.txt
		sudo  echo "board_no=1" >> /mnt/rootfs/boot/uEnv.txt

		echo -e "${Purple}Syncing ...${NC}"
		sync
		unmount_all_drive_partitions
		cd -
		;;
        esac
        shift
done
