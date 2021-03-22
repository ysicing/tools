FROM ysicing/god as sealosbuild

WORKDIR /go/src

ENV GOPROXY="https://goproxy.cn,direct"

RUN git clone https://github.com/ysicing/sealos.git --depth 1 -b 1.18-talk && cd sealos && ./build.sh 1.18-talk

FROM ysicing/debian as base

COPY k7s/release.sh /release.sh

COPY k7s/kube /kube

COPY --from=sealosbuild /go/src/sealos/sealos /kube/bin/sealos

ARG K8SVER=v1.18.17

RUN chmod +x /release.sh \
    && /release.sh

FROM ysicing/debian

COPY --from=base /kube.tgz /

COPY --from=sealosbuild /go/src/sealos/sealos /usr/local/bin/sealos

COPY k7s/deploy.sh /deploy.sh

RUN chmod +x /deploy.sh /usr/local/bin/sealos

ENTRYPOINT [ "/deploy.sh" ]