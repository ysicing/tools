#!/bin/bash

set -e
images=$(ls -al | grep "drwxr"  | grep -v "\." | awk '{print $NF}' | tr '\n' ' ')
for image in ${images[@]}
do
    cat ${image}/Dockerfile | grep FROM | awk '{print $2}' | xargs -I {} docker pull {}
    docker build -t ysicing/${image} ${image}
    docker push ysicing/${image}
    echo ${image}
    curl -s https://cr.hk2.godu.dev/pull\?name="ysicing/${image}"
done