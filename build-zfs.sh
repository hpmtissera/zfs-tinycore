#!/usr/bin/env bash

set -e

ZFS_VERSION=$1
TC_KERNEL_VERSION=4.19.10-tinycore64

if [ "$ZFS_VERSION" = "" ]; then
   echo "Error: Must specify desired ZFS version."
   exit 1
fi

git clone https://github.com/zfsonlinux/zfs.git
cd zfs
git checkout ${ZFS_VERSION} -b ${ZFS_VERSION}
./autogen.sh && ./configure
make -s -j$(nproc)
cd ..

mkdir zfs-${TC_KERNEL_VERSION}
mkdir -p zfs-${TC_KERNEL_VERSION}/usr/local/bin
mkdir -p zfs-${TC_KERNEL_VERSION}/usr/local/lib
mkdir -p zfs-${TC_KERNEL_VERSION}/usr/local/lib/modules/${TC_KERNEL_VERSION}/kernel/fs/zfs

mkdir extra
cd extra
mkdir avl icp lua nvpair spl unicode zcommon zfs
cd ..

cp zfs/module/avl/zavl.ko extra/avl/zavl.ko
cp zfs/module/icp/icp.ko extra/icp/icp.ko
cp zfs/module/lua/zlua.ko extra/lua/
cp zfs/module/nvpair/znvpair.ko extra/nvpair/
cp zfs/module/spl/spl.ko extra/spl/
cp zfs/module/unicode/zunicode.ko extra/unicode/
cp zfs/module/zcommon/zcommon.ko extra/zcommon/
cp zfs/module/zfs/zfs.ko extra/zfs/

mv extra/* zfs-${TC_KERNEL_VERSION}/usr/local/lib/modules/${TC_KERNEL_VERSION}/kernel/fs/zfs
rm -rf extra

cp zfs/lib/libnvpair/.libs/libnvpair.so.1.0.1 zfs-${TC_KERNEL_VERSION}/usr/local/lib
cp zfs/lib/libuutil/.libs/libuutil.so.1.0.1 zfs-${TC_KERNEL_VERSION}/usr/local/lib
cp zfs/lib/libzfs/.libs/libzfs.so.2.0.0 zfs-${TC_KERNEL_VERSION}/usr/local/lib
cp zfs/lib/libzfs_core/.libs/libzfs_core.so.1.0.0 zfs-${TC_KERNEL_VERSION}/usr/local/lib

cd zfs-${TC_KERNEL_VERSION}/usr/local/lib

ln -s libnvpair.so.1.0.1 libnvpair.so.1
ln -s libuutil.so.1.0.1 libuutil.so.1
ln -s libzfs.so.2.0.0 libzfs.so.2
ln -s libzfs_core.so.1.0.0 libzfs_core.so.1

cd -

cp zfs/cmd/zfs/.libs/zfs zfs-${TC_KERNEL_VERSION}/usr/local/bin
cp zfs/cmd/zpool/.libs/zpool zfs-${TC_KERNEL_VERSION}/usr/local/bin

mksquashfs zfs-${TC_KERNEL_VERSION} zfs-${TC_KERNEL_VERSION}.tcz
