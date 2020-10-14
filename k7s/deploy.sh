#!/bin/bash

set -e

if [ "$1" == "bash" ]; then
    exec /bin/bash
fi

if [ "$1" == "init" ]; then
    [ -d "/root/.sealos" ] && (
        # [ -f "/root/.sealos/kube.tgz" ] && rm -rf /root/.sealos/kube.tgz
        mv /root/.sealos /root/.sealos.$(date +%Y%m%d%H)
    )
    mkdir -p /root/.sealos
    cp -a /kube.tgz /root/.sealos/kube.tgz
    exec sealos init --repo registry.cn-beijing.aliyuncs.com/k7scn --version 1.19.3 --pkg-url /root/.sealos/kube.tgz ${@:2}
else
    exec sealos join ${@:2}
fi

