# FROM ysicing/god as sealosbuild

# WORKDIR /go/src

# ENV GOPROXY="https://goproxy.cn,direct"

# RUN git clone https://github.com/ysicing/sealos.git --depth 1 -b 1.18-talk && cd sealos && ./build.sh 1.18-talk

FROM ysicing/ergo AS ergo

FROM ysicing/gotools AS gotools

FROM ysicing/core AS builder

COPY . /opt

COPY --from=ergo /usr/local/bin/ergo /opt/local/ergo

COPY --from=gotools /root/bin /opt/gobin

# COPY --from=sealosbuild /go/src/sealos/sealos /opt/local/sealos

RUN chmod +x /opt/release.sh \
    # && chmod +x  /opt/local/sealos \
    && chmod +x /opt/local/ergo \
    && cd /opt \
    && /opt/release.sh

FROM ysicing/alpine

COPY --from=builder /opt/.release/pkg.tgz /