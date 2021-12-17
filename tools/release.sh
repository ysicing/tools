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

get_etcdctl(){

    ETCD_VER=v3.5.1

    # choose either URL
    GOOGLE_URL=https://storage.googleapis.com/etcd
    GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
    DOWNLOAD_URL=${GOOGLE_URL}

    rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
    rm -rf /tmp/test-etcd && mkdir -p /tmp/test-etcd

    curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
    tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/test-etcd --strip-components=1
    echo "copy etcd"
    cp /tmp/test-etcd/etcdctl  ${releasedir}
    chmod +x ${releasedir}/etcd*
    ${releasedir}/etcdctl -h | grep version || exit 1
}

get_helm(){
    local helm_ver=v3.7.2
    rm -f /tmp/helm-${helm_ver}-linux-amd64.tar.gz
    rm -rf /tmp/helm && mkdir -p /tmp/helm 
    curl -s -L https://get.helm.sh/helm-${helm_ver}-linux-amd64.tar.gz -o /tmp/helm-${helm_ver}-linux-amd64.tar.gz
    tar xzf /tmp/helm-${helm_ver}-linux-amd64.tar.gz -C /tmp/helm  --strip-components=1
    echo "copy helm"
    cp -a /tmp/helm/helm ${releasedir}
    chmod +x ${releasedir}/helm
    ${releasedir}/helm -h | grep version || exit 1
}

# get_helmv2(){
#     local helm_ver=v2.17.0
#     rm -f /tmp/helm-${helm_ver}-linux-amd64.tar.gz
#     rm -rf /tmp/helm && mkdir -p /tmp/helm 
#     curl -s -L https://get.helm.sh/helm-${helm_ver}-linux-amd64.tar.gz -o /tmp/helm-${helm_ver}-linux-amd64.tar.gz
#     tar xzf /tmp/helm-${helm_ver}-linux-amd64.tar.gz -C /tmp/helm  --strip-components=1
#     echo "copy helmv2"
#     mv /tmp/helm/helm /tmp/helm/helmv2 
#     cp -a /tmp/helm/helmv2 ${releasedir}
#     chmod +x ${releasedir}/helmv2
#     ${releasedir}/helmv2 -h | grep version || exit 1
# }

get_dockercompose(){
    curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o ${releasedir}/docker-compose
    echo "download docker-compose"
    chmod +x ${releasedir}/docker-compose
    ${releasedir}/docker-compose version
}

# get_calicoctl(){
#     local calico_ver=v3.14.2
#     curl -s -L https://github.com/projectcalico/calicoctl/releases/download/${calico_ver}/calicoctl-linux-amd64 -o ${releasedir}/calicoctl
#     echo "download calicoctl ${calico_ver}"
#     chmod +x ${releasedir}/calicoctl
#     ${releasedir}/calicoctl -h | grep version || exit 1
# }

get_ctop(){
    local ctop_ver=0.7.6
    curl -s -L https://github.com/bcicen/ctop/releases/download/${ctop_ver}/ctop-${ctop_ver}-linux-amd64 -o ${releasedir}/ctop
    echo "download ctop ${ctop_ver}"
    chmod +x ${releasedir}/ctop
    ${releasedir}/ctop -v | grep version || exit 1
}

get_istio(){
    local istio_ver=1.12.1
    rm -f /tmp/istio-${istio_ver}-linux.tar.gz
    rm -rf /tmp/istio && mkdir -p /tmp/istio 
    curl -s -L https://github.com/istio/istio/releases/download/${istio_ver}/istio-${istio_ver}-linux-amd64.tar.gz -o /tmp/istio-${istio_ver}-linux.tar.gz
    tar xzf /tmp/istio-${istio_ver}-linux.tar.gz -C /tmp/istio  --strip-components=1
    echo "copy istio"
    cp -a /tmp/istio/bin/istioctl ${releasedir}
    chmod +x ${releasedir}/istioctl
    ${releasedir}/istioctl -h | grep version || exit 1
}

# get_getistio(){
#     local getistio_ver=v1.0.5
#     rm -f /tmp/getistio_${getistio_ver}_linux_amd64.tar.gz
#     curl -s -L https://github.com/tetratelabs/getistio/releases/download/${getistio_ver}/getistio_linux_amd64.tar.gz -o /tmp/getistio_${getistio_ver}_linux_amd64.tar.gz
#     pushd /tmp
#     tar xf /tmp/getistio_${getistio_ver}_linux_amd64.tar.gz
#     popd
#     echo "copy getistio"
#     cp -a /tmp/getistio ${releasedir}
#     chmod +x ${releasedir}/getistio
#     ${releasedir}/getistio -h | grep version || exit 1
# }

# get_osm(){
#     local osm_ver=v0.8.4
#     rm -f /tmp/osm-${osm_ver}-linux-amd64.tar.gz
#     rm -rf /tmp/osm && mkdir -p /tmp/osm
#     curl -s -L https://github.com/openservicemesh/osm/releases/download/${osm_ver}/osm-${osm_ver}-linux-amd64.tar.gz -o /tmp/osm-${osm_ver}-linux-amd64.tar.gz
#     tar xf /tmp/osm-${osm_ver}-linux-amd64.tar.gz -C /tmp/osm --strip-components=1 
#     echo "copy osm"
#     cp -a /tmp/osm/osm ${releasedir}
#     chmod +x ${releasedir}/osm
#     ${releasedir}/osm -h | grep version || exit 1
# }

# get_linkerd2(){
#     local linkerd2_ver=stable-2.10.2
#     curl -s -L https://github.com/linkerd/linkerd2/releases/download/${linkerd2_ver}/linkerd2-cli-${linkerd2_ver}-linux-amd64 -o ${releasedir}/linkerd
#     echo "download linkerd2 ${linkerd2_ver}"
#     chmod +x ${releasedir}/linkerd
#     ${releasedir}/linkerd -h | grep version || exit 1
# }

# get_k8e(){
#     local k8e_ver=v1.19.14+k8e2
#     curl -s -L https://github.com/xiaods/k8e/releases/download/${k8e_ver}/k8e -o ${releasedir}/k8e
#     echo "download k8e ${k8e_ver}"
#     chmod +x ${releasedir}/k8e
#     ${releasedir}/k8e -h | grep version || exit 1
# }

# get_k3s(){
#     local k3s_ver=v1.21.5+k3s1
#     curl -s -L https://github.com/rancher/k3s/releases/download/${k3s_ver}/k3s -o ${releasedir}/k3s
#     echo "download k3s ${k3s_ver}"
#     chmod +x ${releasedir}/k3s
#     ${releasedir}/k3s -h | grep version || exit 1
# }

# get_k0s(){
#     local k0s_ver=v1.21.2+k0s.1
#     curl -s -L https://github.com/k0sproject/k0s/releases/download/${k0s_ver}/k0s-${k0s_ver}-amd64 -o ${releasedir}/k0s
#     echo "download k0s ${k0s_ver}"
#     chmod +x ${releasedir}/k0s
#     ${releasedir}/k0s -h | grep version || exit 1
# }

# get_k0sctl(){
#     local k0sctl_ver=v0.8.4
#     curl -s -L https://github.com/k0sproject/k0sctl/releases/download/${k0sctl_ver}/k0sctl-linux-x64 -o ${releasedir}/k0sctl
#     echo "download k0sctl ${k0sctl_ver}"
#     chmod +x ${releasedir}/k0sctl
#     ${releasedir}/k0sctl -h | grep version || exit 1
# }


get_critools(){
    local critools_ver=v1.22.0
    curl -s -L https://github.com/kubernetes-sigs/cri-tools/releases/download/${critools_ver}/crictl-${critools_ver}-linux-amd64.tar.gz -o /tmp/crictl-${critools_ver}-linux-amd64.tar.gz
    echo "download critools ${critools_ver}"
    tar xzf /tmp/crictl-${critools_ver}-linux-amd64.tar.gz -C /tmp/
    echo "copy critools"
    cp -a /tmp/crictl ${releasedir}
}

get_mc() {
    curl -s -L https://dl.min.io/client/mc/release/linux-amd64/mc -o ${releasedir}/mc
    echo "download mc"
    chmod +x ${releasedir}/mc
}

get_cilium() {
    curl -s -L --remote-name-all https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz -o /tmp/cilium-linux-amd64.tar.gz
    tar xzf /tmp/cilium-linux-amd64.tar.gz -C /tmp/
    cp -a /tmp/cilium ${releasedir}
    chmod +x ${releasedir}/cilium
    ${releasedir}/cilium -h | grep version || exit 1
}

get_ergo() {
    curl -s -L https://github.com/ysicing/ergo/releases/latest/download/ergo_linux_amd64 -o /tmp/ergo
    cp -a /tmp/ergo ${releasedir}
    chmod +x ${releasedir}/ergo
    ${releasedir}/ergo version
}

download(){
    get_localgobin
    get_localbin
    get_etcdctl
    get_helm
    # get_helmv2
    get_dockercompose
    # get_calicoctl
    get_ctop
    get_istio
    # get_getistio
    # get_osm
    # get_linkerd2
    # get_k3s
    # get_k8e
    # get_k0s
    # get_k0sctl
    get_critools
    get_mc
    get_ergo
    get_cilium
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
