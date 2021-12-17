#!/bin/bash

set -e

images=$(ls -al | grep "drwxr"  | grep -v "\." | grep -vE "(k7s|pkg)" | awk '{print $NF}' | tr '\n' ' ')
for image in ${images[@]}
do
    # cat ${image}/Dockerfile | grep -E "^FROM" | awk '{print $2}' | xargs -I {} docker pull {}
    docker buildx build --push -t ysicing/${image} ${image}
    curl -s https://cr.hk1.godu.dev/pull\?image="ysicing/${image}"
done
