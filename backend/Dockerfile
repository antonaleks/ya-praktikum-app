# build
FROM maven:3.8.2-openjdk-16-slim as builder
# задаём переменную VERSION, которая будет использоваться для сборки проекта
ARG VERSION=${VERSION}
WORKDIR /usr/src/app
COPY *.xml ./
RUN curl https://storage.yandexcloud.net/cloud-certs/CA.pem -o YandexInternalRootCA.crt \
    && mvn dependency:resolve -Dversion.application=${VERSION}
COPY ./src ./src

RUN mvn package -Dversion.application=${VERSION} -Dmaven.repo.local=.m2/repository

# release
FROM openjdk:16-jdk-alpine
ARG VERSION=${VERSION}
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
     --from=builder /usr/src/app/target/sausage-store-${VERSION}.jar ./sausage-store.jar
EXPOSE ${BACKEND_PORT}
# приложение будет запускаться под пользователем jaruser
USER jaruser
ENTRYPOINT dumb-init java -jar -Dmyserver.bindPort=${BACKEND_PORT} ./sausage-store.jar