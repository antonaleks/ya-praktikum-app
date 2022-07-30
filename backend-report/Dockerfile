FROM maven:3.8-openjdk-16 as builder
#Create build directory
WORKDIR /usr/src/app
COPY *.xml ./
RUN mvn dependency:go-offline -Dmaven.test.skip -Dmaven.repo.local=.m2/repository
COPY ./src ./src
RUN mvn package -Dmaven.test.skip -Dmaven.repo.local=.m2/repository -Dversion.application=latest

FROM openjdk:16

#Create app directory
WORKDIR /usr/src/app

RUN curl https://storage.yandexcloud.net/cloud-certs/CA.pem -o YandexInternalRootCA.crt && \
    keytool -importcert -file YandexInternalRootCA.crt -alias yandex -cacerts -storepass changeit -noprompt && \
    rm -f YandexInternalRootCA.crt

COPY --from=builder /usr/src/app/target/sausage-store-report-latest.jar sausage-store-report.jar

ENTRYPOINT ["java", "-jar", "./sausage-store-report.jar", "--service.port=8081"]
EXPOSE 8081