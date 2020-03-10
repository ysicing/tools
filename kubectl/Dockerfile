FROM alpine:3.10 AS getk8s

ENV K8S_VER=v1.17.3

RUN wget https://dl.k8s.io/$K8S_VER/kubernetes-server-linux-amd64.tar.gz && \
    tar zxf kubernetes-server-linux-amd64.tar.gz && \
    mkdir -p /k7s/ && cd kubernetes/server/bin && \
    mv kube-apiserver kube-controller-manager kube-scheduler /k7s/ && \
    mv kubelet kube-proxy kubectl /k7s/ && \
    wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 && \
    chmod 777 /k7s/*

FROM alpine:3.10

COPY --from=getk8s /k7s/kubectl /usr/local/bin/

ENTRYPOINT [ "kubectl" ]

CMD [ "--help" ]