FROM ysicing/k7s:1.19.7 as k7slocal

FROM ysicing/alpine

COPY --from=k7slocal /kube.tgz /