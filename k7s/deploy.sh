#!/bin/bash

if [ ! -z "$1" ]; then
    exec $@
fi

MASTER_IP=${MASTER_IP:-11.11.11.11}
MTU=${MTU:-1440}

if [ -z $NODE_IP ]; then
    OPTCMD="--master ${MASTER_IP}"
else
    OPTCMD="--master ${MASTER_IP} --node ${NODE_IP}"
fi

if [ ! -z "$PASS" ]; then
    sealos init --passwd ${PASS} --mtu ${MTU}  --repo registry.cn-beijing.aliyuncs.com/k7scn ${OPTCMD} --version 1.18.4 --pkg-url /kube.tgz
else
    sealos init --mtu ${MTU} --repo registry.cn-beijing.aliyuncs.com/k7scn ${OPTCMD} --version 1.18.4 --pkg-url /kube.tgz
fi

