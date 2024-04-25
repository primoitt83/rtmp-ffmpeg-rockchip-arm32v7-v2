#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt update

# Build dependencies.
apt install -y \
  ca-certificates \
  curl wget \
  linux-libc-dev libc6-dev \
  libgcc-11-dev \
  build-essential \
  musl-dev \
  openssl libssl-dev \
  pcre2-utils libpcre2-dev\
  pkg-config \
  zlib1g-dev

NGINX_VERSION=1.23.1
NGINX_RTMP_VERSION=1.2.2
MAKEFLAGS="-j4"

# Get nginx source.
cd /tmp
wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
  tar zxf nginx-${NGINX_VERSION}.tar.gz && \
  rm nginx-${NGINX_VERSION}.tar.gz

# Get nginx-rtmp module.
wget https://github.com/arut/nginx-rtmp-module/archive/v${NGINX_RTMP_VERSION}.tar.gz && \
  tar zxf v${NGINX_RTMP_VERSION}.tar.gz && \
  rm v${NGINX_RTMP_VERSION}.tar.gz

# Compile nginx with nginx-rtmp module.
cd /tmp/nginx-${NGINX_VERSION} && \
  ./configure \
  --prefix=/usr/local/nginx \
  --add-module=/tmp/nginx-rtmp-module-${NGINX_RTMP_VERSION} \
  --conf-path=/etc/nginx/nginx.conf \
  --with-threads \
  --with-file-aio \
  --with-http_ssl_module \
  --with-debug \
  --with-http_stub_status_module \
  --with-cc-opt="-Wimplicit-fallthrough=0" && \
  make -j4 && \
  make install