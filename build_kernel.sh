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
export CROSS_COMPILE="ccache /home/khaon/android/kernel/linaro-4.9/bin/arm-eabi-";
export MKBOOTIMG=/home/khaon/android/kernel/mkbootimg_tools/mkboot;
export MKBOOTIMG_TOOLTS_ZIMAGE_JF_FOLDER=/home/khaon/android/kernel/mkbootimg_tools/boot-jf

echo "${txtbld} Removing old zImage ${txtrst}";
make mrproper;
rm $PACKAGEDIR/zImage;
rm arch/arm/boot/zImage;

echo "${bldblu} Making the kernel ${txtrst}";
make lineageos_jf_defconfig;

make -j4;

if [ -e $KERNELDIR/arch/arm/boot/zImage ]; then

	echo " ${bldgrn} Kernel built !! ${txtrst}";

	export curdate=`date "+%m-%d-%Y"`;

	cp $KERNELDIR/arch/arm/boot/zImage $MKBOOTIMG_TOOLTS_ZIMAGE_JF_FOLDER/kernel

	cd $PACKAGEDIR;

	echo "${txtbld} Make AnyKernel flashable archive ${txtrst} "
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