#!/bin/bash 

set -e

base=${1:-./.release}

releasedir=$base
rm -fr $releasedir
mkdir -p $releasedir

get_localbin(){
    echo "copy local bin"
    cp -a local/* ${releasedir}
}

get_etcd(){
    local etcd_ver=v3.4.0
    local google_url=https://storage.googleapis.com/etcd
    # local github_url=https://github.com/coreos/etcd/releases/download
    download_url=${google_url}

    rm -f /tmp/etcd-${etcd_ver}-linux-amd64.tar.gz
    rm -rf /tmp/test-etcd && mkdir -p /tmp/test-etcd

    curl -s -L ${download_url}/${etcd_ver}/etcd-${etcd_ver}-linux-amd64.tar.gz -o /tmp/etcd-${etcd_ver}-linux-amd64.tar.gz
    tar xzf /tmp/etcd-${etcd_ver}-linux-amd64.tar.gz -C /tmp/test-etcd --strip-components=1
    echo "copy etcd"
    cp /tmp/test-etcd/etcd*  ${releasedir}
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
    cp -a /tmp/helm/tiller ${releasedir}
}

get_frpx(){
    local frpx_ver=0.29.0
    rm -f /tmp/frp_${frpx_ver}_linux_amd64.tar.gz
    rm -rf /tmp/frpx && mkdir -p /tmp/frpx
    curl -s -L https://github.com/fatedier/frp/releases/download/v${frpx_ver}/frp_${frpx_ver}_linux_amd64.tar.gz -o /tmp/frp_${frpx_ver}_linux_amd64.tar.gz
    tar xzf /tmp/frp_${frpx_ver}_linux_amd64.tar.gz -C /tmp/frpx --strip-components=1
    echo "copy frps/frpc"
    cp -a /tmp/frpx/frps ${releasedir}
    cp -a /tmp/frpx/frpc ${releasedir}
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

#get_dry(){
#    local dry_ver=v0.9-beta.10
#    curl -s -L https://github.com/moncho/dry/releases/download/${dry_ver}/dry-linux-amd64 -o ${releasedir}/dry
#    echo "download dry ${dry_ver}"
#    chmod +x ${releasedir}/dry
#}

#get_imgreg(){
#    local reg_ver=v0.16.0
#    local img_ver=v0.5.6
#    curl -s -L https://github.com/genuinetools/reg/releases/download/${reg_ver}/reg-linux-amd64 -o ${releasedir}/reg
#    curl -s -L https://github.com/genuinetools/img/releases/download/${img_ver}/img-linux-amd64 -o ${releasedir}/img
#    echo "download img/reg tools"
#    chmod +x ${releasedir}/reg
#    chmod +x ${releasedir}/img
#}

#get_kubeprompt(){
#    curl -s -L https://rainbond-pkg.oss-cn-shanghai.aliyuncs.com/util/kube-prompt -o ${releasedir}/kube-prompt
#    chmod +x ${releasedir}/kube-prompt
#}

get_brook(){
    local brook_ver=v20190601
    curl -s -L https://github.com/txthinking/brook/releases/download/${brook_ver}/brook -o ${releasedir}/brook
    chmod +x ${releasedir}/brook
}

get_kustomize(){
    local kustomize_ver=3.1.0
    curl -s -L https://github.com/kubernetes-sigs/kustomize/releases/download/v${kustomize_ver}/kustomize_${kustomize_ver}_linux_amd64 -o ${releasedir}/kustomize
    chmod +x ${releasedir}/kustomize
}

#get_k8s(){
#    local k8s_ver=v1.14.1
#    curl -s -L https://storage.googleapis.com/kubernetes-release/release/${k8s_ver}/bin/linux/amd64/hyperkube -o ${releasedir}/hyperkube
#    chmod +x ${releasedir}/hyperkube
#}

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
   #get_dry
    #get_imgreg
    #get_kubeprompt
    get_brook
    get_kustomize
    #get_k8s
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
    docker build -t spanda/pkg .
}

case $1 in
    *)
        download
        build
        echo "run <docker run --rm -v /usr/local/bin:/sysdir spanda/pkg tar zxf /pkg.tgz -C /sysdir> for install"
    ;;
esac
