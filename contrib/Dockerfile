FROM ysicing/core:latest AS builder

COPY . /opt

RUN chmod +x /opt/release.sh \
    && cd /opt \
    && /opt/release.sh

FROM ysicing/alpine

COPY --from=builder /opt/.release/pkg.tgz /
