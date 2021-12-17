FROM ysicing/god as gotools

RUN go install github.com/google/gops@latest

FROM ysicing/debian

COPY --from=gotools /go/bin /root/bin