FROM maven:3.5.2-jdk-8-slim as maven
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY . /usr/src/app
RUN mvn package

FROM anapsix/alpine-java:8
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY --from=maven /usr/src/app/target/hello-world-1.0-SNAPSHOT.jar /usr/src/app
ENTRYPOINT ["java", "-jar", "hello-world-1.0-SNAPSHOT.jar"]
