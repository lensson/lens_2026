#FROM openjdk:8-jdk-alpine
FROM openjdk:17.0.2-jdk
MAINTAINER lensson.zhen@gmail.com
ARG JAR_FILE
# jar/opt
COPY ${JAR_FILE} /opt/app.jar
# /data
ENV DATAPATH /data
# /data
VOLUME $DATAPATH
#
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/opt/app.jar"]
EXPOSE 8043
