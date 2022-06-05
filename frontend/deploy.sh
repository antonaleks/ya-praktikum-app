#! /bin/bash
#Если свалится одна из команд, рухнет и весь скрипт
set -xe
#Перезаливаем дескриптор сервиса на ВМ для деплоя
sudo cp -rf sausage-store-frontend.service /etc/systemd/system/sausage-store-frontend.service
sudo rm -rf /home/front-user/dist||true
#Переносим артефакт в нужную папку
curl -u ${NEXUS_REPO_USER}:$(echo $NEXUS_REPO_PASS | base64 -d) -o sausage-store.tar.gz ${NEXUS_REPO_FRONTEND_URL}/sausage-store-front/sausage-store/$VERSION/sausage-store-$VERSION.tar.gz
sudo tar -xf ./sausage-store.tar.gz --strip-components 2 -C /home/front-user/front||true
#Обновляем конфиг systemd с помощью рестарта
sudo systemctl daemon-reload
#Перезапускаем сервис сосисочной
sudo systemctl restart sausage-store-frontend