#!/bin/bash 

set -e

base=${1:-./.release}

releasedir=$base
rm -fr $releasedir
mkdir -p $releasedir

get_calicocni(){
    local CALICO_VER=v3.7.0
    curl -s -L https://github.com/projectcalico/cni-plugin/releases/download/$CALICO_VER/calico-amd64 -o ${releasedir}/calico
    curl -s -L https://github.com/projectcalico/cni-plugin/releases/download/$CALICO_VER/calico-ipam-amd64 -o ${releasedir}/calico-ipam
    echo "download calico cni ${CALICO_VER}"
    chmod +x ${releasedir}/calico
    chmod +x ${releasedir}/calico-ipam
}

get_cniplugins(){
    local cni_ver=v0.7.5
    curl -s -L https://github.com/containernetworking/plugins/releases/download/$cni_ver/cni-plugins-amd64-$cni_ver.tgz -o /tmp/cni-${cni_ver}-linux-amd64.tar.gz
    tar xzf /tmp/cni-${cni_ver}-linux-amd64.tar.gz -C ${releasedir}  --strip-components=1
}

download(){
    get_calicocni
    get_cniplugins
    ls -al ${releasedir}/*
}

build(){
    cd ${releasedir}
    tar zcf cni.tgz `find . -maxdepth 1 | sed 1d`
    cat > Dockerfile <<EOF
FROM alpine:3.8
COPY cni.tgz /
EOF
    docker build -t spanda/cni .
}

case $1 in
    *)
        download
        build
        echo "run <docker run --rm -v /opt/cni/bin:/sysdir spanda/cni tar zxf /cni.tgz -C /sysdir> for install"
    ;;
esac
