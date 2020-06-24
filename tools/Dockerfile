FROM ysicing/ergo AS ergo

FROM ysicing/gotools AS gotools

FROM ysicing/core:latest AS builder

COPY . /opt

COPY --from=ergo /usr/local/bin/ergo /opt/local/ergo

COPY --from=gotools /root/bin /opt/gobin

RUN chmod +x /opt/release.sh \
    && cd /opt \
    && /opt/release.sh

FROM ysicing/alpine

COPY --from=builder /opt/.release/pkg.tgz /