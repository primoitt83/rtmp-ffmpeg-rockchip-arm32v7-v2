#!/bin/sh

mkdir /usr_lib
mkdir /usr_lib_arm-linux-gnueabihf
mkdir /usr_lib_arm-linux-gnueabihf_pulseaudio

# fisrt copy loop
for file in `echo libasound.so.2 \
  libasound.so.2.0.0 \
  libasyncns.so.0 \
  libasyncns.so.0.3.1 \
  libbrotlicommon.so \
  libbrotlicommon.so.1 \
  libbrotlicommon.so.1.0.9 \
  libbrotlidec.so \
  libbrotlidec.so.1 \
  libbrotlidec.so.1.0.9 \
  libbsd.so.0 \
  libbsd.so.0.11.5 \
  libbz2.so.1 \
  libbz2.so.1.0.4 \
  libdbus-1.so.3 \
  libdbus-1.so.3.19.13 \
  libexpat.so \
  libexpat.so.1 \
  libexpat.so.1.8.7 \
  libFLAC.so.8 \
  libFLAC.so.8.3.0 \
  libfontconfig.so \
  libfontconfig.so.1 \
  libfontconfig.so.1.12.0 \
  libfreetype.so \
  libfreetype.so.6 \
  libfreetype.so.6.18.1 \
  libfribidi.so \
  libfribidi.so.0 \
  libfribidi.so.0.4.0 \
  libgcc_s.so.1 \
  libglib-2.0.so \
  libglib-2.0.so.0 \
  libglib-2.0.so.0.7200.4 \
  libgraphite2.so \
  libgraphite2.so.3 \
  libgraphite2.so.3.2.1 \
  libharfbuzz.so \
  libharfbuzz.so.0 \
  libharfbuzz.so.0.20704.0 \
  libjpeg.so \
  libjpeg.so.8 \
  libjpeg.so.8.2.2 \
  liblzma.so \
  liblzma.so.5 \
  liblzma.so.5.2.5 \
  libmd.so.0 \
  libmd.so.0.0.5 \
  libogg.so.0 \
  libogg.so.0.8.5 \
  libopus.so.0 \
  libopus.so.0.8.0 \
  libpcre2-8.so \
  libpcre2-8.so.0 \
  libpcre2-8.so.0.10.4 \
  libpng16.so \
  libpng16.so.16 \
  libpng16.so.16.37.0 \
  libsndfile.so.1 \
  libsndfile.so.1.0.31 \
  libstdc++.so.6 \
  libstdc++.so.6.0.30 \
  libvorbisenc.so.2 \
  libvorbisenc.so.2.0.12 \
  libvorbis.so.0 \
  libvorbis.so.0.4.9 \
  libXau.so.6 \
  libXau.so.6.0.0 \
  libxcb-shm.so.0 \
  libxcb-shm.so.0.0.0 \
  libxcb.so.1 \
  libxcb.so.1.1.0 \
  libXdmcp.so.6 \
  libXdmcp.so.6.0.0 \
  libpulse.so.0.24.1 \
  libpulse.so.0 \
  libpulse.so \
  librockchip_mpp.so \
  librockchip_vpu.so.0 \
  librockchip_vpu.so.1 \
  librockchip_mpp.so.1 \
  librockchip_vpu.so \
  librockchip_mpp.so.0`; do \
  cp /usr/lib/arm-linux-gnueabihf/$file /usr_lib_arm-linux-gnueabihf; done

# second copy loop
for file in `echo librga.so \
  librga.so.2 \
  librga.so.2.1.0`; do \
  cp /usr/lib/$file /usr_lib; done

# third copy loop
for file in `echo libpulsecommon-15.99.so \
  libpulsecore-15.99.so \
  libpulsedsp.so`; do \
  cp /usr/lib/arm-linux-gnueabihf/pulseaudio/$file /usr_lib_arm-linux-gnueabihf_pulseaudio; done