#!/bin/bash

if [ ! -z "$1" ]; then
    exec $@
fi

MASTER_IP=${MASTER_IP:-192.168.100.101}

if [ ! -z "$PASS" ]; then
    sealos init --passwd ${PASS} --repo registry.cn-hangzhou.aliyuncs.com/google_containers --master ${MASTER_IP} --version 1.18.2 --pkg-url /root/kube.tgz
else
    sealos init --repo registry.cn-hangzhou.aliyuncs.com/google_containers --master ${MASTER_IP} --version 1.18.2 --pkg-url /root/kube.tgz
fi

