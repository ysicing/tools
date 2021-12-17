FROM ysicing/debian AS getkind

RUN  curl -s -L https://github.com/kubernetes-sigs/kind/releases/latest/download/kind-linux-amd64 -o ./kind-linux-amd64 && \
    mkdir -p /k7s/ && mv kind-linux-amd64 /k7s/kind && \
    chmod 777 /k7s/*

FROM ysicing/debian AS getk3s

RUN  curl -s -L https://github.com/k3s-io/k3s/releases/latest/download/k3s -o ./k3s && \
    mkdir -p /k7s/ && mv k3s /k7s/k3s && \
    chmod 777 /k7s/*

FROM ysicing/debian AS getkubectl

ENV K8S_VER=v1.21.5

RUN wget -q https://dl.k8s.io/$K8S_VER/kubernetes-server-linux-amd64.tar.gz && \
    tar zxf kubernetes-server-linux-amd64.tar.gz && \
    mkdir -p /k7s/ && cd kubernetes/server/bin && \
    mv kube-apiserver kube-controller-manager kube-scheduler /k7s/ && \
    mv kubelet kube-proxy kubectl /k7s/ 

FROM ysicing/debian AS gethelm

RUN curl -s -L https://get.helm.sh/helm-v3.7.2-linux-amd64.tar.gz -o /tmp/helm-linux-amd64.tar.gz && \
    mkdir -p /tmp/helm && \
    tar xzf /tmp/helm-linux-amd64.tar.gz -C /tmp/helm  --strip-components=1 

FROM ysicing/debian

COPY --from=getkind /k7s/kind /usr/local/bin/

COPY --from=getk3s /k7s/k3s /usr/local/bin/

COPY --from=getkubectl /k7s/kubectl /usr/local/bin/

COPY --from=gethelm /tmp/helm /usr/local/bin/

CMD [ "kind", "--help" ]
