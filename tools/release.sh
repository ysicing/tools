#!/bin/bash 

set -ex

base=${1:-./.release}

releasedir=$base
rm -fr $releasedir
mkdir -p $releasedir

get_localbin(){
    echo "copy local bin"
    chmod +x local/* 
    cp -a local/* ${releasedir}
    command -v curl || (
        apt update
        apt install -y curl
    )
}

get_etcd(){

    ETCD_VER=v3.3.18

    # choose either URL
    GOOGLE_URL=https://storage.googleapis.com/etcd
    GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
    DOWNLOAD_URL=${GITHUB_URL}

    rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
    rm -rf /tmp/test-etcd && mkdir -p /tmp/test-etcd

    curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
    tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/test-etcd --strip-components=1
    echo "copy etcd"
    cp /tmp/test-etcd/etcdctl  ${releasedir}
    cp /tmp/test-etcd/etcd  ${releasedir}
    chmod +x ${releasedir}/etcd*
}

get_helm(){
    local helm_ver=v3.0.2
    rm -f /tmp/helm-${helm_ver}-linux-amd64.tar.gz
    rm -rf /tmp/helm && mkdir -p /tmp/helm 
    curl -s -L https://get.helm.sh/helm-${helm_ver}-linux-amd64.tar.gz -o /tmp/helm-${helm_ver}-linux-amd64.tar.gz
    tar xzf /tmp/helm-${helm_ver}-linux-amd64.tar.gz -C /tmp/helm  --strip-components=1
    echo "copy helm"
    cp -a /tmp/helm/helm ${releasedir}
}

get_dockercompose(){
    local dc_ver=1.25.1-rc1
    curl -L https://github.com/docker/compose/releases/download/${dc_ver}/docker-compose-Linux-x86_64 -o ${releasedir}/docker-compose
    echo "download docker-compose ${dc_ver}"
    chmod +x ${releasedir}/docker-compose
}

get_calicoctl(){
    local calico_ver=v3.11.1
    curl -s -L https://github.com/projectcalico/calicoctl/releases/download/${calico_ver}/calicoctl-linux-amd64 -o ${releasedir}/calicoctl
    echo "download calicoctl ${calico_ver}"
    chmod +x ${releasedir}/calicoctl
}

get_ctop(){
    local ctop_ver=0.7.2
    curl -s -L https://github.com/bcicen/ctop/releases/download/v${ctop_ver}/ctop-${ctop_ver}-linux-amd64 -o ${releasedir}/ctop
    echo "download ctop ${ctop_ver}"
    chmod +x ${releasedir}/ctop
}

get_kompose(){
    local kompose_ver=v1.20.0
    curl -s -L https://github.com/kubernetes/kompose/releases/download/${kompose_ver}/kompose-linux-amd64 -o ${releasedir}/kompose
    echo "download kompose ${kompose_ver}"
    chmod +x ${releasedir}/kompose
}

download(){
    get_localbin
    get_etcd
    get_helm
    get_dockercompose
    get_calicoctl
    get_ctop
    get_kompose
    ls -al ${releasedir}/*
}

build(){
    cd ${releasedir}
    tar zcf pkg.tgz `find . -maxdepth 1 | sed 1d`
    if [ ! -f "/.dockerenv" ]; then
    cat > Dockerfile <<EOF
FROM alpine:3.8
COPY pkg.tgz /
EOF
    docker build -t ysicing/tools .
    fi
}

case $1 in
    *)
        download
        build
        echo "run <docker run --rm -v /usr/local/bin:/sysdir ysicing/tools tar zxf /pkg.tgz -C /sysdir> for install"
    ;;
esac
