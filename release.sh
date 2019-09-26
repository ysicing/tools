#!/bin/bash 

set -e

base=${1:-./.release}

releasedir=$base
rm -fr $releasedir
mkdir -p $releasedir

get_localbin(){
    echo "copy local bin"
    cp -a local/* ${releasedir}
    command -v curl || (
        apt update
        apt install -y curl
    )
}

get_etcd(){
    local etcd_ver=v3.4.1
    local google_url=https://storage.googleapis.com/etcd
    download_url=${google_url}

    rm -f /tmp/etcd-${etcd_ver}-linux-amd64.tar.gz
    rm -rf /tmp/test-etcd && mkdir -p /tmp/test-etcd

    curl -s -L ${download_url}/${etcd_ver}/etcd-${etcd_ver}-linux-amd64.tar.gz -o /tmp/etcd-${etcd_ver}-linux-amd64.tar.gz
    tar xzf /tmp/etcd-${etcd_ver}-linux-amd64.tar.gz -C /tmp/test-etcd --strip-components=1
    echo "copy etcd"
    cp /tmp/test-etcd/etcdctl  ${releasedir}
    chmod +x ${releasedir}/etcd*
}

get_helm(){
    local helm_ver=v3.0.0-beta.3
    rm -f /tmp/helm-${helm_ver}-linux-amd64.tar.gz
    rm -rf /tmp/helm && mkdir -p /tmp/helm 
    curl -s -L https://storage.googleapis.com/kubernetes-helm/helm-${helm_ver}-linux-amd64.tar.gz -o /tmp/helm-${helm_ver}-linux-amd64.tar.gz
    tar xzf /tmp/helm-${helm_ver}-linux-amd64.tar.gz -C /tmp/helm  --strip-components=1
    echo "copy helm"
    cp -a /tmp/helm/helm ${releasedir}
}

get_dockercompose(){
    local dc_ver=1.25.0-rc2
    curl -L https://github.com/docker/compose/releases/download/${dc_ver}/docker-compose-Linux-x86_64 -o ${releasedir}/docker-compose
    echo "download docker-compose ${dc_ver}"
    chmod +x ${releasedir}/docker-compose
}

get_calicoctl(){
    local calico_ver=v3.9.0
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

get_trivy(){
    local trivy_ver=0.1.6
    curl -s -L https://github.com/aquasecurity/trivy/releases/download/v${trivy_ver}/trivy_${trivy_ver}_Linux-64bit.tar.gz  -o /tmp/trivy_${trivy_ver}_Linux-64bit.tar.gz
    tar xzf /tmp/trivy_${trivy_ver}_Linux-64bit.tar.gz -C /tmp/trivy --strip-components=1
    echo "copy trivy"
    cp -a /tmp/trivy/trivy ${releasedir}
}

download(){
    get_localbin
    get_etcd
    get_helm
    get_frpx
    get_dockercompose
    get_calicoctl
    get_ctop
    get_trivy
    ls -al ${releasedir}/*
}

build(){
    cd ${releasedir}
    tar zcf pkg.tgz `find . -maxdepth 1 | sed 1d`
    cat > Dockerfile <<EOF
FROM alpine:3.8
COPY pkg.tgz /
EOF
    docker build -t ysicing/tools .
}

case $1 in
    *)
        download
        build
        echo "run <docker run --rm -v /usr/local/bin:/sysdir ysicing/tools tar zxf /pkg.tgz -C /sysdir> for install"
    ;;
esac
