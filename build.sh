#!/bin/bash

set -e

images=$(ls -al | grep "drwxr"  | grep -v "\." | awk '{print $NF}' | tr '\n' ' ')
for image in ${images[@]}
do
    cat ${image}/Dockerfile | grep FROM | awk '{print $2}' | xargs -I {} docker pull {}
    if [ ${image} != "k7s" ]; then  
        docker build -t ysicing/${image} ${image}
    else
        docker build -t ysicing/${image} -f ${image}/Dockerfile .
        docker tag ysicing/${image} ysicing/${image}:1.19.2
        docker push ysicing/${image}:1.19.2
         curl -s https://cr.hk2.godu.dev/pull\?name="ysicing/${image}:1.19.2"\&nocache=true
    fi    
    docker push ysicing/${image}
    curl -s https://cr.hk2.godu.dev/pull\?name="ysicing/${image}"\&nocache=true
done