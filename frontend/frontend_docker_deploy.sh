#!/bin/bash
set +e
cat > .env <<EOF
BACKEND_URL=${BACKEND_URL}
EOF
docker network create -d bridge sausage_network || true
docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD ${DOCKER_REGISTRY}
docker pull ${CI_REGISTRY_IMAGE}/${DOCKER_FRONTEND_NAME}:latest
docker stop ${DOCKER_FRONTEND_NAME} || true
docker rm ${DOCKER_FRONTEND_NAME} || true
set -e
docker run -d --name ${DOCKER_FRONTEND_NAME} \
    --network=sausage_network \
    --restart always \
    --pull always \
    --env-file .env \
    ${CI_REGISTRY_IMAGE}/${DOCKER_FRONTEND_NAME}:latest