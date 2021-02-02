#!/bin/bash

set -e

images=$(ls -al | grep "drwxr"  | grep -v "\." | awk '{print $NF}' | tr '\n' ' ')
for image in ${images[@]}
do
    cat ${image}/Dockerfile | grep FROM | awk '{print $2}' | xargs -I {} docker pull {}
    if [ ${image} != "pkg" ]; then  
        docker build -t ysicing/${image}:1.19.7 ${image}
    else
        docker build -t ysicing/${image}:1.19.7 -f ${image}/Dockerfile .
        docker push ysicing/${image}:1.19.7
        curl -s https://cr.hk1.godu.dev/pull\?name="ysicing/${image}:1.19.7"\&nocache=true
    fi
done