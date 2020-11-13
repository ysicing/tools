FROM ysicing/debian AS getk8s

ENV KD_VER=v0.9.0

RUN wget https://github.com/kubernetes-sigs/kind/releases/download/${KD_VER}/kind-linux-amd64 && \
    mkdir -p /k7s/ && mv kind-linux-amd64 /k7s/kind && \
    chmod 777 /k7s/*

FROM ysicing/debian

COPY --from=getk8s /k7s/kind /usr/local/bin/

CMD [ "kind", "--help" ]
