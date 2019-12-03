FROM alpine:3.9 AS getbin

ENV K8S_VER=v1.16.3 \
    CNI_VER=v0.8.3

RUN wget https://dl.k8s.io/$K8S_VER/kubernetes-server-linux-amd64.tar.gz && \
    tar zxf kubernetes-server-linux-amd64.tar.gz && \
    mkdir -p /k7s/ && cd kubernetes/server/bin && \
    mv kube-apiserver kube-controller-manager kube-scheduler /k7s/ && \
    mv kubelet kube-proxy kubectl /k7s/ && \
    wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 && \
    wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 && \
    wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64 && \
    mv cfssl_linux-amd64 /k7s/cfssl && \
    mv cfssljson_linux-amd64 /k7s/cfssljson && \
    mv cfssl-certinfo_linux-amd64 /k7s/cfssl-certinfo && \
    \
    wget https://github.com/containernetworking/plugins/releases/download/$CNI_VER/cni-plugins-linux-amd64-$CNI_VER.tgz && \
    mkdir /cni && tar zxf cni-plugins-linux-amd64-$CNI_VER.tgz -C /cni && \
    cd /cni && mv bridge flannel host-local loopback portmap tuning /k7s && \
    cd / && rm -rf cni* && \
    cd /k7s/ && \
    tar zcf pkg.tgz `find . -maxdepth 1 | sed 1d`

FROM alpine:3.9

COPY --from=getbin /k7s/pkg.tgz /
