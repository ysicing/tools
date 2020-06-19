#!/bin/bash

if [ ! -z "$1" ]; then
    exec $@
fi

MASTER_IP=${MASTER_IP:-11.11.11.11}

if [ -z $NODE_IP ]; then
    OPTCMD="--master ${MASTER_IP}"
else
    OPTCMD="--master ${MASTER_IP} --node ${NODE_IP}"
fi

if [ ! -z "$PASS" ]; then
    sealos init --passwd ${PASS} --repo registry.cn-hangzhou.aliyuncs.com/google_containers ${OPTCMD} --version 1.18.4 --pkg-url /kube.tgz
else
    sealos init --repo registry.cn-hangzhou.aliyuncs.com/google_containers ${OPTCMD} --version 1.18.4 --pkg-url /kube.tgz
fi

