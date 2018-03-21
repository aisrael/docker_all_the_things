FROM maven:3.5.2-jdk-8-slim as builder
RUN mkdir -p /usr/src/app/lib
WORKDIR /usr/src/app
COPY . /usr/src/app
RUN mvn dependency:build-classpath && \
  cat target/.classpath |\
  awk -F: '{for (i = 0; ++i <= NF;) print  $i }'|\
  while read f; do cp "$f" lib/; done
RUN mvn package

FROM anapsix/alpine-java:8
EXPOSE 8080
RUN mkdir -p /usr/src/app/lib
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app/lib/* /usr/src/app/lib/
COPY --from=builder /usr/src/app/target/*.jar /usr/src/app/lib/
ENTRYPOINT [ "java", "-cp", "/usr/src/app/lib/*", "com.example.Main" ]
