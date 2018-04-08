# rpi-tomcat

Apache Tomcat image based on OpenJRE and Alpine build for Raspberry PI and potentially other ARM devices. Apache Tomcat Native Library is enabled for both Apache Portable Runtime (APR) and OpenSSL.

Verisons:
JRE: 1.8.0_151 
TC-Native: 1.2.16
OpenSSL: 1.0.2o-r0
APR: 1.6.3-r1

## How to use

The docker container can be executed as follows:

```bash
docker run -i -t mscatdk/rpi-tomcat
```

## Build process
git clone git@github.com:mscatdk/rpi-tomcat.git
cd rpi-tomcat

docker build . -t mscatdk/rpi-tomcat:latest
