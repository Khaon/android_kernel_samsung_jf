#!/bin/sh

# Colorize and add text parameters
red=$(tput setaf 1) # red
grn=$(tput setaf 2) # green
cya=$(tput setaf 6) # cyan
txtbld=$(tput bold) # Bold
bldred=${txtbld}$(tput setaf 1) # red
bldgrn=${txtbld}$(tput setaf 2) # green
bldblu=${txtbld}$(tput setaf 4) # blue
bldcya=${txtbld}$(tput setaf 6) # cyan
txtrst=$(tput sgr0) # Reset

export KERNELDIR=`readlink -f .`;
export PARENT_DIR=`readlink -f ..`;
export ANY_KERNEL=/home/khaon/android/kernel/AnyKernel2;
export ARCH=arm;
export CCACHE_DIR=/home/khaon/.ccache;
export PACKAGEDIR=/home/khaon/android/kernel/Packages;
export MKBOOT=/home/khaon/android/kernel/mkbootimg_tools/mkboot;
export MKBOOT_FOLDER=/home/khaon/android/kernel/mkbootimg_tools;
export MKBOOT_TOOLS_ZIMAGE_JF_FOLDER=/home/khaon/android/kernel/mkbootimg_tools/boot-jf;
export DEFCONFIG=lineageos_jf_defconfig;
export TOOLCHAIN_PATH="/home/khaon/android/kernel/linaro-4.9/bin/arm-eabi-";
export CROSS_COMPILE="ccache ${TOOLCHAIN_PATH}";

#Looking if folders and toolchains are found
if [ ! -d $DIRECTORY ]; then
	echo "${red}The package dir folder doesn't exists, creating it";
	mkdir -p $PACKAGEDIR;
fi;
if [ ! -e "${TOOLCHAIN_PATH}gcc" ]; then
	echo "${red} There is no toolchain found, exiting";
	exit;
fi;

echo "${txtbld} Removing old zImage ${txtrst}";
make mrproper;
rm $PACKAGEDIR/zImage;
rm arch/arm/boot/zImage;

echo "${bldblu} Making the kernel ${txtrst}";
make $DEFCONFIG;

make -j4;

if [ -e $KERNELDIR/arch/arm/boot/zImage ]; then

	echo " ${bldgrn} Kernel built !! ${txtrst}";

	export curdate=`date "+%m-%d-%Y"`;

	cp $KERNELDIR/arch/arm/boot/zImage $MKBOOT_TOOLS_ZIMAGE_JF_FOLDER/kernel;
	$MKBOOT $MKBOOT_TOOLS_ZIMAGE_JF_FOLDER $MKBOOT_FOLDER/boot-$curdate.img;

	cd $PACKAGEDIR;

	echo "${txtbld} Making AnyKernel flashable archive ${txtrst} "
	echo "";
	rm UPDATE-AnyKernel2-khaon-kernel-jf-nougat*.zip;
	cd $ANY_KERNEL;
	cp $KERNELDIR/arch/arm/boot/zImage zImage;
	mkdir -p $PACKAGEDIR;
	zip -r9 $PACKAGEDIR/UPDATE-AnyKernel2-khaon-kernel-jf-nougat-"${curdate}".zip * -x README UPDATE-AnyKernel2.zip .git *~;
	cd $KERNELDIR;
else
	echo "KERNEL DID NOT BUILD! no zImage exist"
fi;