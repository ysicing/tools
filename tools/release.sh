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

get_localgobin(){
    echo "copy local go bin"
    chmod +x /opt/gobin/* 
    cp -a /opt/gobin/*  ${releasedir}
}

get_etcd(){

    ETCD_VER=v3.4.13

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
    local helm_ver=v3.3.2
    rm -f /tmp/helm-${helm_ver}-linux-amd64.tar.gz
    rm -rf /tmp/helm && mkdir -p /tmp/helm 
    curl -s -L https://get.helm.sh/helm-${helm_ver}-linux-amd64.tar.gz -o /tmp/helm-${helm_ver}-linux-amd64.tar.gz
    tar xzf /tmp/helm-${helm_ver}-linux-amd64.tar.gz -C /tmp/helm  --strip-components=1
    echo "copy helm"
    cp -a /tmp/helm/helm ${releasedir}
}

get_helmv2(){
    local helm_ver=v2.16.11
    rm -f /tmp/helm-${helm_ver}-linux-amd64.tar.gz
    rm -rf /tmp/helm && mkdir -p /tmp/helm 
    curl -s -L https://get.helm.sh/helm-${helm_ver}-linux-amd64.tar.gz -o /tmp/helm-${helm_ver}-linux-amd64.tar.gz
    tar xzf /tmp/helm-${helm_ver}-linux-amd64.tar.gz -C /tmp/helm  --strip-components=1
    echo "copy helmv2"
    mv /tmp/helm/helm /tmp/helm/helmv2 
    cp -a /tmp/helm/helmv2 ${releasedir}
}

get_dockercompose(){
    local dc_ver=1.27.3
    curl -L https://github.com/docker/compose/releases/download/${dc_ver}/docker-compose-Linux-x86_64 -o ${releasedir}/docker-compose
    echo "download docker-compose ${dc_ver}"
    chmod +x ${releasedir}/docker-compose
}

get_calicoctl(){
    local calico_ver=v3.14.2
    curl -s -L https://github.com/projectcalico/calicoctl/releases/download/${calico_ver}/calicoctl-linux-amd64 -o ${releasedir}/calicoctl
    echo "download calicoctl ${calico_ver}"
    chmod +x ${releasedir}/calicoctl
}

get_ctop(){
    local ctop_ver=0.7.3
    curl -s -L https://github.com/bcicen/ctop/releases/download/v${ctop_ver}/ctop-${ctop_ver}-linux-amd64 -o ${releasedir}/ctop
    echo "download ctop ${ctop_ver}"
    chmod +x ${releasedir}/ctop
}

get_istio(){
    local istio_ver=1.7.1
    rm -f /tmp/istio-${istio_ver}-linux.tar.gz
    rm -rf /tmp/istio && mkdir -p /tmp/istio 
    curl -s -L https://github.com/istio/istio/releases/download/${istio_ver}/istio-${istio_ver}-linux-amd64.tar.gz -o /tmp/istio-${istio_ver}-linux.tar.gz
    tar xzf /tmp/istio-${istio_ver}-linux.tar.gz -C /tmp/istio  --strip-components=1
    echo "copy istio"
    cp -a /tmp/istio/bin/istioctl ${releasedir}
}

get_osm(){
    local osm_ver=v0.3.0
    rm -f /tmp/osm-${osm_ver}-linux-amd64.tar.gz
    rm -rf /tmp/osm && mkdir -p /tmp/osm
    curl -s -L https://github.com/openservicemesh/osm/releases/download/${osm_ver}/osm-${osm_ver}-linux-amd64.tar.gz -o /tmp/osm-${osm_ver}-linux-amd64.tar.gz
    tar xf /tmp/osm-${osm_ver}-linux-amd64.tar.gz -C /tmp/osm --strip-components=1 
    echo "copy osm"
    cp -a /tmp/osm/osm ${releasedir}
}

get_linkerd2(){
    local linkerd2_ver=stable-2.8.1
    curl -s -L https://github.com/linkerd/linkerd2/releases/download/${linkerd2_ver}/linkerd2-cli-${linkerd2_ver}-linux -o ${releasedir}/linkerd
    echo "download linkerd2 ${linkerd2_ver}"
    chmod +x ${releasedir}/linkerd
}

get_k3s(){
    local k3s_ver=v1.16.15+k3s1
    curl -s -L  https://github.com/rancher/k3s/releases/download/${k3s_ver}/k3s -o ${releasedir}/k3s
    echo "download k3s ${k3s_ver}"
    chmod +x ${releasedir}/k3s
}

get_critools(){
    local critools_ver=v1.19.0
    curl -s -L https://github.com/kubernetes-sigs/cri-tools/releases/download/${critools_ver}/crictl-${critools_ver}-linux-amd64.tar.gz -o /tmp/crictl-${critools_ver}-linux-amd64.tar.gz
    echo "download critools ${critools_ver}"
    tar xzf /tmp/crictl-${critools_ver}-linux-amd64.tar.gz -C /tmp/
    echo "copy critools"
    cp -a /tmp/crictl ${releasedir}
}

download(){
    get_localgobin
    get_localbin
    get_etcd
    get_helm
    get_helmv2
    get_dockercompose
    get_calicoctl
    get_ctop
    get_istio
    get_linkerd2
    get_osm
    get_k3s
    get_critools
 
    ls -al ${releasedir}/*
}

build(){
    cd ${releasedir}
    tar zcf pkg.tgz `find . -maxdepth 1 | sed 1d`
    if [ ! -f "/.dockerenv" ]; then
    cat > Dockerfile <<EOF
FROM alpine
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
