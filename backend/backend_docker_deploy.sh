#!/bin/bash
set +e
cat > .env <<EOF
SPRING_DATASOURCE_URL=${SPRING_DATASOURCE_URL}
SPRING_DATASOURCE_USERNAME=${SPRING_DATASOURCE_USERNAME}
SPRING_DATASOURCE_PASSWORD=${SPRING_DATASOURCE_PASSWORD}
SPRING_DATA_MONGODB_URI=${SPRING_DATA_MONGODB_URI}
LOG_PATH=/opt/log/
REPORT_PATH=/opt/log/
BACKEND_PORT=${BACKEND_PORT}
EOF
docker network create -d bridge sausage_network || true
docker pull ${DOCKER_REGISTRY}/sausage-store/${DOCKER_BACKEND_NAME}:latest
docker stop ${DOCKER_BACKEND_NAME} || true
docker rm ${DOCKER_BACKEND_NAME} || true
set -e
docker run -d --name ${DOCKER_BACKEND_NAME} \
    --network=sausage_network \
    --restart always \
    --pull always \
    --env-file .env \
    ${DOCKER_REGISTRY}/sausage-store/${DOCKER_BACKEND_NAME}:latest