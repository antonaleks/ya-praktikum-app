#!/bin/sh
if [ $(docker --context sausage-store ps -f name=blue -f health=healthy -q) ];
then
  ENV="green";
  OLD="blue";
else
  ENV="blue";
  OLD="green";
fi

echo "Starting "$ENV" container"
docker-compose --context sausage-store pull $ENV
docker-compose --context sausage-store up -d --force-recreate $ENV

echo "Waiting..."
until [ $(docker --context sausage-store ps -f name=$ENV -f health=healthy -q) ];
do
  sleep 1;
done;

echo "Stopping "$OLD" container"
docker-compose --context sausage-store stop $OLD