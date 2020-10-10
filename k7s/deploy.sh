#!/bin/bash

[ -f "/root/.sealos/kube.tgz" ] && rm -rf /root/.sealos/kube.tgz || mkdir -p /root/.sealos

cp -a /kube.tgz /root/.sealos/kube.tgz

exec sealos init --repo registry.cn-beijing.aliyuncs.com/k7scn --version 1.19.2 --pkg-url /root/.sealos/kube.tgz $@
