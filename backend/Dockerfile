# build
FROM maven:3.8.2-openjdk-16-slim as builder
# задаём переменную VERSION, которая будет использоваться для сборки проекта
WORKDIR /usr/src/app
COPY *.xml ./
RUN mvn dependency:go-offline -Dmaven.test.skip -Dmaven.repo.local=.m2/repository
COPY ./src ./src
RUN mvn package -Dmaven.test.skip -Dmaven.repo.local=.m2/repository -Dversion.application=latest
RUN curl https://storage.yandexcloud.net/cloud-certs/CA.pem -o YandexInternalRootCA.crt
# release
FROM openjdk:16-jdk-alpine
ENV BACKEND_PORT=8080
WORKDIR /app
COPY --from=builder /usr/src/app/YandexInternalRootCA.crt .
# подкидываем CA-сертификат Яндекса в хранилище сертификатов для Java
# создаём пользователя jaruser
RUN keytool -importcert -file YandexInternalRootCA.crt \
    -alias yandex -cacerts -storepass changeit -noprompt \
    && rm -rf YandexInternalRootCA.crt \
    && addgroup --system jaruser \
    && adduser -S -s /bin/false -G jaruser jaruser -D -H \
    && apk add --no-cache dumb-init==1.2.5-r0
COPY --chown=jaruser:jaruser \
     --from=builder /usr/src/app/target/sausage-store-latest.jar ./sausage-store.jar
EXPOSE ${BACKEND_PORT}
# приложение будет запускаться под пользователем jaruser
USER jaruser
ENTRYPOINT dumb-init java -jar -Dmyserver.bindPort=${BACKEND_PORT} ./sausage-store.jar
