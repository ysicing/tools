# tools

[![Build Status](https://travis-ci.org/ysicing/tools.svg?branch=master)](https://travis-ci.org/ysicing/tools)

常见二进制或者脚本封装

## tools list

```bash
etcdctl
helm
docker-compose
calicoctl
ctop
```

## usage

```bash
docker run --rm -v /usr/local/bin:/sysdir ysicing/tools tar zxf /pkg.tgz -C /sysdir
#  大陆
docker run --rm -v /usr/local/bin:/sysdir registry.cn-beijing.aliyuncs.com/k7scn/tools tar zxf /pkg.tgz -C /sysdir
```

## upgrade

```bash
upgrade-tools
```
