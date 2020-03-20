FROM ysicing/core:latest AS builder

COPY . /opt

RUN chmod +x /opt/release.sh \
    && cd /opt \
    && /opt/release.sh

FROM alpine:3.10

COPY --from=builder /opt/.release/pkg.tgz /
