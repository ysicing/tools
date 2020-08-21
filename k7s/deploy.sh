#!/bin/bash

if [ ! -z "$1" ]; then
    exec $@
fi

MASTER_IP=${MASTER_IP:-11.11.11.11}
MTU=${MTU:-1440}
K8sVersion=${K8sVersion:-1.18.8}

if [ "$K8sVersion"x == "latest"x ]; then
    K8sVersion=1.18.8
fi

if [ -z $NODE_IP ]; then
    OPTCMD="--master ${MASTER_IP}"
else
    OPTCMD="--master ${MASTER_IP} --node ${NODE_IP}"
fi

if [ ! -z "$PASS" ]; then
    sealos init --passwd ${PASS} --mtu ${MTU}  --repo registry.cn-beijing.aliyuncs.com/k7scn ${OPTCMD} --version ${K8sVersion} --pkg-url /kube.tgz
else
    sealos init --mtu ${MTU} --repo registry.cn-beijing.aliyuncs.com/k7scn ${OPTCMD} --version ${K8sVersion} --pkg-url /kube.tgz
fi

