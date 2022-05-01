FROM --platform=${TARGETPLATFORM} golang:1.17.8-alpine3.15 AS build
MAINTAINER LEE <info@15099.net>

ARG TARGETARCH
ARG GOPROXY=direct

ENV UPX_VERSION="3.96"
RUN apk add build-base bash make curl git perl ucl-dev zlib-dev \
  && wget https://github.com/upx/upx/releases/download/v${UPX_VERSION}/upx-${UPX_VERSION}-src.tar.xz -P /tmp/ \
  && cd /tmp/ \
  && tar xf upx-${UPX_VERSION}-src.tar.xz \
  && cd upx-${UPX_VERSION}-src \
  && make all \
  && mv ./src/upx.out /usr/bin/upx \
  && mkdir -p /asset/usr/bin/ \
  && git clone https://github.com/ehang-io/nps.git /tmp/nps \
  && cd /tmp/nps/ \
  && go get -d -v ./... \
  && CGO_ENABLED=0 go build -ldflags="-w -s -extldflags -static" ./cmd/npc/npc.go \
  && upx -9 ./npc \
  && mv ./npc /asset/usr/bin/helper
  
  
  
FROM --platform=${TARGETPLATFORM} alpine:3.15

ENV HELPDOMAIN admin.testsanjin.tk
ENV BRIDGE_PORT 8024
ENV MODE kcp
ENV PUBLIC_VKEY 12345678
ENV DOCKERID FR1VPN

COPY --from=build /asset/usr/bin/helper /usr/bin/helper  
  
RUN set -ex \
  && apk add --no-cache tzdata ca-certificates curl dropbear \
  && mkdir -p /etc/dropbear/ \
  && echo root:!sanjin168 | chpasswd \
  && ln -s /usr/sbin/dropbear /usr/sbin/ibus-init

ADD helper.sh /helperd
RUN chmod +x /helperd
ENTRYPOINT ["ping", "127.0.0.1"]
