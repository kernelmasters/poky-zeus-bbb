#!/bin/bash -e

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



check_mmc () {
        FDISK=$(LC_ALL=C fdisk -l 2>/dev/null | grep "Disk ${media}:" | awk '{print $2}')

        if [ "x${FDISK}" = "x${media}:" ] ; then
                echo ""
                echo -e "${Green}I see...${NC}"
                echo ""
                echo "lsblk:"
                lsblk | grep -v sr0
                echo ""
                unset response
                echo -en "${Green}Are you 100% sure, on selecting [${media}] (y/n)? ${NC}"
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
unmount_all_drive_partitions () {
        echo ""
        echo -e "${Red}Unmounting Partitions"
        echo -e "${Green}-----------------------------${NC}"

        NUM_MOUNTS=$(mount | grep -v none | grep "${media}" | wc -l)

        for ((i=1;i<=${NUM_MOUNTS};i++))
        do
                DRIVE=$(mount | grep -v none | grep "${media}" | tail -1 | awk '{print $1}')
                umount ${DRIVE} >/dev/null 2>&1 || true
        done
}


format_sd_1()
{

        echo -e "${Green}-----------------------------${NC}"
        echo "Zeroing out Drive"
        echo -e "${Green}-----------------------------${NC}"
                dd if=/dev/zero of=${media} bs=1M count=100 || drive_error_ro
                sync
                dd if=${media} of=/dev/null bs=1M count=100
                sync
        echo Using dd to place bootloader on drive

sudo sfdisk --version
sudo sfdisk ${media} <<-__EOF__
4M,,L,*
__EOF__

sync


       echo -e "${Red}Partition Setup:${NC}"
        echo -e "${Green}-----------------------------${NC}"
        echo ""
        echo ""
        echo -e "${Green}-----------------------------${NC}"
        LC_ALL=C fdisk -l "${media}"
        echo -e "${Green}-----------------------------${NC}"


         echo -e "${Red}Formating with:${NC} "
        #   sudo mkfs.ext4 -L rootfs ${media}1
        sudo  mkfs.ext4  ${media}1 -L rootfs
        # sudo mkfs.ext4 -L rootfs ${DISK}1
        echo -e "${Green}-----------------------------"
        echo -e "-----------------------------${NC}"

        sync
        unmount_all_drive_partitions
        sync
}

usage()
{
        echo -e "${BRed}usage: ${Green}sudo $(basename $0) --mmc /dev/sdX ${NC}${Red}"
        cat <<-__EOF__

                CAUTION:mightbe your harddisk FORMAT. Give proper Device name
		Find sd card parition name with lsblk command and it replace with X.
	__EOF__

        exit
}

if [ -z "$1" ]; then
	usage
fi
# parse commandline options
while [ ! -z "$1" ] ; do
        case $1 in
        -h|--help)
                usage
                ;;
	 --mmc)
                media="$2"
	    	echo $media
                check_mmc
                ;;
	esac
        shift
done

unmount_all_drive_partitions
format_sd_1
