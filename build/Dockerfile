FROM ubuntu:jammy as build-nginx

LABEL maintainer="primoitt83@gmail.com"
 
COPY ${PWD}/nginx.sh / 
RUN chmod +x /nginx.sh && /nginx.sh

FROM ubuntu:jammy as build-ffmpeg

LABEL maintainer="primoitt83@gmail.com"

COPY ${PWD}/ffmpeg.sh /
COPY ${PWD}/copy-libs.sh /

RUN chmod +x /ffmpeg.sh && /ffmpeg.sh
RUN chmod +x /copy-libs.sh && /copy-libs.sh

##########################
# Build the release image.
FROM ubuntu:jammy

LABEL maintainer="primoitt83@gmail.com"

# Set default ports.
ENV HTTP_PORT 80
ENV HTTPS_PORT 443
ENV RTMP_PORT 1935

RUN apt update && apt install -y \
  ca-certificates \
  gettext \
  openssl \
  pcre2-utils \
  curl \
  alsa-utils

# Cleanup.
RUN apt-get clean autoclean
RUN apt-get autoremove --yes
RUN rm -rf /var/cache/* /tmp/* /var/lib/{apt,dpkg,cache,log}/

RUN mkdir -p /usr/lib/arm-linux-gnueabihf/pulseaudio

COPY --from=build-nginx /usr/local/nginx /usr/local/nginx
COPY --from=build-nginx /etc/nginx /etc/nginx
COPY --from=build-ffmpeg /usr/local /usr/local
COPY --from=build-ffmpeg /usr_lib/. /usr/lib
COPY --from=build-ffmpeg /usr_lib_arm-linux-gnueabihf/. /usr/lib/arm-linux-gnueabihf
COPY --from=build-ffmpeg /usr_lib_arm-linux-gnueabihf_pulseaudio/. /usr/lib/arm-linux-gnueabihf/pulseaudio

# Add NGINX path, config and static files.
ENV PATH "${PATH}:/usr/local/nginx/sbin"
COPY ./nginx.conf /etc/nginx/nginx.conf.template
RUN mkdir -p /opt/data && mkdir /www
COPY ./static /www/static

## nginx custom folder permissions for user nobody
RUN mkdir /opt/data/recordings && \
    mkdir /opt/data/hls && \
    mkdir /opt/data/logs

RUN chown nobody.65534 -R /opt/data
RUN chmod 775 -R /opt/data

EXPOSE 1935
EXPOSE 80
EXPOSE 443

CMD envsubst "$(env | sed -e 's/=.*//' -e 's/^/\$/g')" < \
  /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf && \
  nginx