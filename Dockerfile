FROM alpine:3.5

MAINTAINER opsxcq <opsxcq@thestorm.com.br>

RUN apk --no-cache add dnsmasq

VOLUME /etc/dnsmasq

EXPOSE 53 53/udp
ENTRYPOINT ["dnsmasq", "-k"]
