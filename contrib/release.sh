#!/bin/bash 

set -ex

base=${1:-./.release}

releasedir=$base
rm -fr $releasedir
mkdir -p $releasedir

get_localbin(){
    echo "copy local bin"
    chmod +x local/* 
    cp -a local/* ${releasedir}
    command -v curl || (
        apt update
        apt install -y curl
    )
}


build(){
    cd ${releasedir}
    tar zcf pkg.tgz `find . -maxdepth 1 | sed 1d`
    if [ ! -f "/.dockerenv" ]; then
    cat > Dockerfile <<EOF
FROM alpine
COPY pkg.tgz /
EOF
    docker build -t ysicing/ctools .
    fi
}

case $1 in
    *)
        get_localbin
        build
        echo "run <docker run --rm -v /usr/local/bin:/sysdir ysicing/ctools tar zxf /pkg.tgz -C /sysdir> for install"
    ;;
esac
