#!/bin/bash

# global install script for all support modules to reference
set -xe
NAME=${1}
FOLDER=$(dirname $(readlink -f $0))

x86_cfg='configure/CONFIG_SITE.Common.linux-x86_64'
rtems_cfg='configure/CONFIG_SITE.Common.RTEMS-beatnik'
support_x86=${SUPPORT}/${NAME}/${x86_cfg}
support_rtems=${SUPPORT}/${NAME}/${rtems_cfg}

echo "support_x86: ${support_x86}"

# for RTEMS builds don't build for the host architecture, target only
if [[ $EPICS_TARGET_ARCH == "RTEMS"* ]]; then
    touch ${support_x86} ${support_rtems}
    sed -i '/VALID_BUILDS/d' ${support_x86}
    echo "VALID_BUILDS=Host" >> ${support_x86}
    sed -i '/CROSS_COMPILER_TARGET_ARCHS/d' ${support_rtems}
    echo "CROSS_COMPILER_TARGET_ARCHS=RTEMS-beatnik" >> ${support_rtems}
fi

# prepare *.bob, *.pvi, *.ibek.support.yaml for access outside the container.
ibek support generate-links ${FOLDER}