#!/bin/bash

# Usage:
# History:
#

virt-install \
--connect qemu:///system \
--network bridge=cloudbr0,model=e1000 \
--name centos \
--ram=512 \
--vcpus=1 \
--disk path=centos65x64.img \
--cdrom CentOS-6.5-x86_64-minimal.iso \
--force