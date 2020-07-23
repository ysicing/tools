FROM ysicing/debian as base

COPY k7s/release.sh /release.sh

COPY k7s/kube /kube

COPY tools/local/sealos /kube/bin/sealos

ARG K8SVER=v1.18.6

RUN chmod +x /release.sh \
    && /release.sh

FROM ysicing/debian

COPY --from=base /kube.tgz /

COPY --from=base /kube/bin/sealos /usr/local/bin/sealos

COPY k7s/deploy.sh /deploy.sh

RUN chmod +x /deploy.sh /usr/local/bin/sealos

ENTRYPOINT [ "/deploy.sh" ]