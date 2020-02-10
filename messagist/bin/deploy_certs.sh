#!/usr/bin/env bash

set -e

mkdir -vp ${DOCKER_CERT_PATH}
for i in ca cert key; do 
    eval "echo \"\$DEPLOY_${i^^}\"" > ${DOCKER_CERT_PATH}/${i}.pem
    echo "Exported bytes: $(wc -c ${DOCKER_CERT_PATH}/${i}.pem)"
done
