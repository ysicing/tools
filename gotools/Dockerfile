FROM ysicing/dgo as gotools

# ENV GOPROXY=https://goproxy.cn

RUN go get -u github.com/google/gops

FROM ysicing/debian

COPY --from=gotools /go/bin /root/bin