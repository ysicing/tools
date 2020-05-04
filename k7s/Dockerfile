FROM ysicing/alpine

COPY k7s/kube.tgz /

COPY k7s/deploy.sh /deploy.sh

COPY tools/local/sealos /usr/local/bin/sealos

RUN chmod +x /deploy.sh /usr/local/bin/sealos

ENTRYPOINT [ "/deploy.sh" ]