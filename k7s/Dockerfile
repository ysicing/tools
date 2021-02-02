FROM ysicing/debian as base

COPY k7s/release.sh /release.sh

COPY k7s/kube /kube

ARG K8SVER=v1.19.7

RUN chmod +x /release.sh \
    && /release.sh

FROM ysicing/debian

COPY --from=base /kube.tgz /