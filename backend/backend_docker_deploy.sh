#!/bin/bash
set +e
cat > .env <<EOF
SPRING_DATASOURCE_URL=${SPRING_DATASOURCE_URL}
LOG_PATH=/app/log
REPORT_PATH=/app/log
BACKEND_PORT=${BACKEND_PORT}
EOF
docker network create -d bridge sausage_network || true
docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD ${DOCKER_REGISTRY}
docker pull ${CI_REGISTRY_IMAGE}/${DOCKER_BACKEND_NAME}:latest
docker stop ${DOCKER_BACKEND_NAME} || true
docker rm ${DOCKER_BACKEND_NAME} || true
set -e
docker run -d --name ${DOCKER_BACKEND_NAME} \
    --network=sausage_network \
    --restart always \
    --pull always \
    --env-file .env \
    ${CI_REGISTRY_IMAGE}/${DOCKER_BACKEND_NAME}:latest