FROM alpine:3.7 as builder

RUN apk update && \
    apk upgrade && \
    apk add openjdk8 apr openssl apr-dev openssl-dev build-base && \
    rm -rf /var/cache/apk/* && \
    mkdir /data

ENV JAVA_HOME /usr/lib/jvm/default-jvm
ENV APP_VERSION 1.2.16

WORKDIR /data

RUN wget http://mirrors.rackhosting.com/apache/tomcat/tomcat-connectors/native/${APP_VERSION}/source/tomcat-native-${APP_VERSION}-src.tar.gz && \
    gunzip tomcat-native-${APP_VERSION}-src.tar.gz && \
    tar -xvf tomcat-native-${APP_VERSION}-src.tar && \
    cd tomcat-native-${APP_VERSION}-src/native && \
    ./configure --with-apr=/usr/bin/apr-1-config --with-ssl=/usr/include/openssl --disable-openssl-version-check && \
    make && \
    make install


FROM mscatdk/rpi-java:jre-1.8.0_151

ENV TOMCAT_TEMP_FILE=/tmp/tomcat.tar.gz

ENV APP_USER=tomcat
ENV APP_HOME=/usr/share/tomcat
ENV APP_VERSION=8.5.29

RUN apk update && \
    apk upgrade && \
    apk add apr openssl && \
    rm -rf /var/cache/apk/*

RUN addgroup -S ${APP_USER} && adduser -S -D -g '' -s /bin/bash -G ${APP_USER} ${APP_USER} && \
    wget "http://mirrors.dotsrc.org/apache/tomcat/tomcat-8/v${APP_VERSION}/bin/apache-tomcat-${APP_VERSION}.tar.gz" -O ${TOMCAT_TEMP_FILE} && \
    tar xzf ${TOMCAT_TEMP_FILE} && \
    mv apache-tomcat-${APP_VERSION} ${APP_HOME} && \
    rm -f ${TOMCAT_TEMP_FILE} && \
    rm -rf ${APP_HOME}/webapps/* && \
    chown -R ${APP_USER}:${APP_USER} ${APP_HOME} && \
    mkdir -p /usr/local/apr/lib

COPY --from=builder /usr/local/apr/lib/* /usr/local/apr/lib/

COPY config/setenv.sh ${APP_HOME}/bin/setenv.sh

USER ${APP_USER}

VOLUME ${APP_HOME}/webapps
WORKDIR ${APP_HOME}

EXPOSE 8009 8080

ENTRYPOINT ["/usr/share/tomcat/bin/catalina.sh"]
CMD ["run"]
