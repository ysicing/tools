FROM ysicing/god as gotools

RUN go install github.com/google/gops@latest

FROM ysicing/debian AS getkind

RUN  curl -s -L https://github.com/kubernetes-sigs/kind/releases/latest/download/kind-linux-amd64 -o ./kind-linux-amd64 && \
    mkdir -p /k7s/ && mv kind-linux-amd64 /k7s/kind && \
    chmod 777 /k7s/*

FROM ysicing/debian AS getk3s

RUN  curl -s -L https://github.com/k3s-io/k3s/releases/latest/download/k3s -o ./k3s && \
    mkdir -p /k7s/ && mv k3s /k7s/k3s && \
    chmod 777 /k7s/*

FROM ysicing/debian AS getkubectl

ENV K8S_VER=v1.25.3

RUN wget -q https://dl.k8s.io/$K8S_VER/kubernetes-server-linux-amd64.tar.gz && \
    tar zxf kubernetes-server-linux-amd64.tar.gz && \
    mkdir -p /k7s/ && cd kubernetes/server/bin && \
    mv kube-apiserver kube-controller-manager kube-scheduler /k7s/ && \
    mv kubelet kube-proxy kubectl /k7s/

FROM ysicing/debian AS gethelm

RUN curl -s -L https://get.helm.sh/helm-v3.10.1-linux-amd64.tar.gz -o /tmp/helm-linux-amd64.tar.gz && \
    mkdir -p /tmp/helm && \
    tar xzf /tmp/helm-linux-amd64.tar.gz -C /tmp/helm  --strip-components=1

FROM ysicing/debian AS getistio

ENV ISTIO_VER=1.15.2

RUN curl -s -L https://github.com/istio/istio/releases/download/${ISTIO_VER}/istio-${ISTIO_VER}-linux-amd64.tar.gz -o /tmp/istio-${ISTIO_VER}-linux.tar.gz && \
    mkdir -p /tmp/istio && \
    tar xzf /tmp/istio-${ISTIO_VER}-linux.tar.gz -C /tmp/istio  --strip-components=1

FROM ysicing/debian AS getetcd

ENV ETCD_VER=v3.5.5
# choose either URL
ENV DOWNLOAD_URL=https://storage.googleapis.com/etcd

RUN curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz && \
    mkdir /tmp/test-etcd && \
    tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/test-etcd --strip-components=1

FROM ysicing/debian

COPY sources.list /etc/apt/sources.list

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y apt-transport-https ca-certificates procps curl wget net-tools make jq nano \
    && rm -rf /var/lib/apt/lists/*

COPY --from=getkind /k7s/kind /root/bin/

COPY --from=getk3s /k7s/k3s /root/bin/

COPY --from=getkubectl /k7s/kubectl /root/bin/

COPY --from=gethelm /tmp/helm/helm /root/bin/

COPY --from=gotools /go/bin /root/bin

COPY --from=getistio /tmp/istio/bin/istioctl /root/bin

COPY --from=getetcd /tmp/test-etcd/etcdctl /root/bin
