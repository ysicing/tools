#!/bin/bash

set -ex

k8s_ver=${K8SVER:-v1.18.18}

base=${1:-/kube}

get_kube(){
    # local k8s_ver=v1.18.18
    rm -f /tmp/kubernetes-${k8s_ver}-server-linux-amd64.tar.gz
    rm -rf /tmp/k8s && mkdir -p /tmp/k8s 
    curl -s -L https://dl.k8s.io/${k8s_ver}/kubernetes-server-linux-amd64.tar.gz -o /tmp/kubernetes-${k8s_ver}-server-linux-amd64.tar.gz
    tar xzf /tmp/kubernetes-${k8s_ver}-server-linux-amd64.tar.gz -C /tmp/k8s  --strip-components=1
    echo "copy k8s"
    cp -a /tmp/k8s/server/bin/kubelet ${base}/bin/
    cp -a /tmp/k8s/server/bin/kubeadm ${base}/bin/
    cp -a /tmp/k8s/server/bin/kubectl ${base}/bin/
}

get_crictl() {
    local VERSION="v1.20.0"
    curl -L https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-${VERSION}-linux-amd64.tar.gz --output /tmp/crictl-${VERSION}-linux-amd64.tar.gz
    tar zxvf /tmp/crictl-$VERSION-linux-amd64.tar.gz -C ${base}/bin/
    rm -f /tmp/crictl-$VERSION-linux-amd64.tar.gz
}

download(){
    get_kube
    get_crictl 
    ls -al ${releasedir}/*
}

tgz(){
    cd /
    tar zcvf kube.tgz kube
}

download
tgz
