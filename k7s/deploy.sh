#!/bin/bash

if [ ! -z "$1" ]; then
    exec $@
fi

MASTER_IP=${MASTER_IP:-11.11.11.11}
NODE_IP=${NODE_IP:-MASTER_IP}

if [ ! -z "$PASS" ]; then
    sealos init --passwd ${PASS} --repo registry.cn-hangzhou.aliyuncs.com/google_containers --master ${MASTER_IP} --node ${NODE_IP} --version 1.18.2 --pkg-url /kube.tgz
else
    sealos init --repo registry.cn-hangzhou.aliyuncs.com/google_containers --master ${MASTER_IP} --node ${NODE_IP} --version 1.18.2 --pkg-url /kube.tgz
fi

