[![Build Status](https://travis-ci.org/ysicing/tools.svg?branch=master)](https://travis-ci.org/ysicing/tools)

# tools
常见二进制或者脚本封装

## 常用工具

```bash
etcdctl v3.4.1
helm v3.0.0-beta.3
docker-compose 1.25.0-rc2
calicoctl v3.9.0
ctop 0.7.2
trivy 0.1.6
```

# usage

```
docker run --rm -v /usr/local/bin:/sysdir ysicing/tools tar zxf /pkg.tgz -C /sysdir
```

