FROM ysicing/alpine

COPY k7s/kube.tgz /

COPY k7s/deploy.sh /deploy.sh

COPY tools/local/sealos /bin/sealos

RUN chmod +x /deploy.sh /bin/sealos

ENTRYPOINT [ "/deploy.sh" ]