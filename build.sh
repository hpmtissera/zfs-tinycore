#!/usr/bin/env bash

echo -e "This script will build ZFS for Tiny Core:10.0-x86_64 (Kernel: 4.19.10-tinycore64)\n"

ZFS_VERSION=$1

if [ "$ZFS_VERSION" = "" ]; then
   echo -n "Enter the ZFS version number to build [ex: zfs-0.8.0-rc3]: "
   read ZFS_VERSION
fi

if [ "$ZFS_VERSION" = "" ]; then
   echo "Error: Must specify desired ZFS version"
   echo " eg: ./build.sh zfs-0.8.0-rc3"
   exit 1
fi

docker build -t zfs-build .
docker run --volume "$(pwd):/opt/build" --cidfile=containerid  -u root zfs-build sh -c "/opt/build/build-zfs.sh ${ZFS_VERSION}"

CONTAINER_ID=$(cat containerid)
docker cp ${CONTAINER_ID}:/zfs-4.19.10-tinycore64.tcz ./
docker rm -f ${CONTAINER_ID}
rm containerid
