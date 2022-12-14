#! /bin/bash
#Если свалится одна из команд, рухнет и весь скрипт
set -xe
#Перезаливаем дескриптор сервиса на ВМ для деплоя
sudo cp -rf sausage-store-backend.service /etc/systemd/system/sausage-store-backend.service
sudo rm -f /home/jarservice/sausage-store.jar||true
#Переносим артефакт в нужную папку
curl -u ${NEXUS_REPO_USER}:$(echo $NEXUS_REPO_PASS | base64 -d) -o sausage-store.jar ${NEXUS_REPO_BACKEND_URL}/com/yandex/practicum/devops/sausage-store/${VERSION}/sausage-store-${VERSION}.jar
sudo cp ./sausage-store.jar /home/jarservice/sausage-store.jar||true #"jar||true" говорит, если команда обвалится — продолжай
echo "LOG_PATH=/opt/log/" > /etc/default/sausage-store-backend
echo "REPORT_PATH=/var/www-data/htdocs/" >> /etc/default/sausage-store-backend
echo "SPRING_DATASOURCE_URL=$SPRING_DATASOURCE_URL" >> /etc/default/sausage-store-backend
echo "VAULT_HOST=$VAULT_HOST" >> /etc/default/sausage-store-backend
echo "VAULT_TOKEN=$VAULT_TOKEN" >> /etc/default/sausage-store-backend
echo "BACKEND_PORT=$BACKEND_PORT" >> /etc/default/sausage-store-backend

#Устанавливаем сертификаты для подключения к БД
#postgres
mkdir -p ~/.postgresql && \
wget "https://storage.yandexcloud.net/cloud-certs/CA.pem" -O ~/.postgresql/root.crt && \
chmod 0600 ~/.postgresql/root.crt
#mongo
sudo mkdir -p /usr/local/share/ca-certificates/Yandex && \
sudo wget "https://crls.yandex.net/allCAs.pem" -O /usr/local/share/ca-certificates/Yandex/YandexInternalRootCA.crt
#Обновляем конфиг systemd с помощью рестарта
sudo systemctl daemon-reload
#Перезапускаем сервис сосисочной
sudo systemctl restart sausage-store-backend