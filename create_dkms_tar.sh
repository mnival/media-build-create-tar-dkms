#!/bin/bash

cd $(dirname $0)
_PWD="$(pwd)"
_TODAY="$(date +"%Y%m%d")"
if [ -z "$1" ]; then
  KERNEL_VERSION="$(uname -r | grep -oP "^[0-9]*\.[0-9]*")"
else
  ERNEL_VERSION="$1"
fi

_DIR="$(ls -1d ../media-build-${_TODAY}.* 2>/dev/null | egrep "media-build-${_TODAY}.[0-9]+$")"
if [ $? -ne 0 ]
then
	PACKAGE_VERSION="${_TODAY}.1"
else
	_NUM="$(echo "${_DIR}" | awk 'BEGIN{FS="."; } {print $4}' | sort -rnu | head -n 1)"
	PACKAGE_VERSION="${_TODAY}.$(expr ${_NUM} + 1)"
fi

set -e

DKMS_NAME="media-build-${PACKAGE_VERSION}"
DKMS_TAR_NAME="${DKMS_NAME}.dkms_src.tgz"

if [ -d ${_PWD}/../${DKMS_NAME} ]
then
	rm -r ${_PWD}/../${DKMS_NAME}
fi

mkdir -p ${_PWD}/../${DKMS_NAME}
cd ${_PWD}/../${DKMS_NAME}
git clone git://linuxtv.org/media_build.git
cd media_build

make download
wget "https://github.com/torvalds/linux/compare/v${KERNEL_VERSION}...s-moch:saa716x-${KERNEL_VERSION}.diff"

cd ${_PWD}

tar_files="*.inc "
tar_files+="build_all.sh "
tar_files+="dkms.conf "
tar_files+="gen_dkms_dyn_conf.sh "
tar_files+="Makefile.dkms "
tar_files+="README_dkms "
tar_files+="handle_updated_modules.sh "
tar_files+="dkms_updated_modules.conf "
tar_files+="config-media-build "

cp -p ${tar_files} ../${DKMS_NAME}/media_build/
cd ${_PWD}/../${DKMS_NAME}/media_build
echo "PACKAGE_VERSION=${PACKAGE_VERSION}" > dkms_ver.conf

tar_dirs="backports "
tar_dirs+="devel_scripts "
tar_dirs+="linux "
tar_dirs+="v4l "

tar_files+="COPYING "
tar_files+="INSTALL "
tar_files+="Makefile "
tar_files+="handle_updated_modules.sh "
tar_files+="dkms_updated_modules.conf "
tar_files+="dkms_ver.conf "
tar_files+="v${KERNEL_VERSION}...s-moch:saa716x-${KERNEL_VERSION}.diff "

tar -czf ${DKMS_TAR_NAME} ${tar_dirs} ${tar_files}
mv ${DKMS_TAR_NAME} ${_PWD}/../
