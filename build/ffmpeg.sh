#!/bin/sh
export DEBIAN_FRONTEND=noninteractive
apt update

apt install -y \
  coreutils \
  wget \
  openssl libssl-dev \
  ca-certificates \
  bash \
  tar \
  autoconf automake \
  libtool \
  diffutils \
  cmake meson \
  git \
  yasm nasm \
  build-essential \
  ninja-build \
  pkg-config \
  texinfo \
  zlib1g-dev \
  bzip2 \
  libxml2-dev \
  expat \
  fontconfig libfontconfig-dev \
  libfreetype-dev \
  libgraphite2-dev \
  libglib2.0-dev \
  libtiff-dev \
  libjpeg-turbo8-dev \
  libpng-dev \
  libgif-dev \
  libharfbuzz-dev \
  libfribidi-dev \
  libbrotli-dev \
  libsoxr-dev \
  tcl-dev \
  numactl \
  libcunit1-dev \
  libfftw3-dev fftw3-dev \
  libsamplerate-dev \
  libvo-amrwbenc-dev \
  libsnappy-dev \
  xxd \
  xz-utils \
  alsa alsa-utils alsa-tools \
  pulseaudio pulseaudio-utils libpulse-dev
  
##linux-headers
##bsd-compat-headers
  
CFLAGS="-O3 -static-libgcc -fno-strict-overflow -fstack-protector-all -fPIC"
CXXFLAGS="-O3 -static-libgcc -fno-strict-overflow -fstack-protector-all -fPIC"
LDFLAGS="-Wl,-z,relro,-z,now"
WGET_OPTS="--retry-on-host-error --retry-on-http-error=429,500,502,503"
TAR_OPTS="--no-same-owner --extract --file"

## mpp
cd /opt && \
git clone -b jellyfin-mpp --depth=1 https://github.com/nyanmisaka/mpp.git rkmpp && \
cd rkmpp && \
mkdir rkmpp_build && \
cd rkmpp_build && \
cmake -DCMAKE_C_COMPILER="/usr/bin/gcc" -DCMAKE_CXX_COMPILER="/usr/bin/g++" -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DBUILD_TEST=OFF ..
make -j $(nproc) && \
make install

## libdrm
cd /opt && \
git clone git://anongit.freedesktop.org/git/mesa/drm && \
cd drm && \
meson build --default-library static && \
cd build && \
ninja install

## rkrga
cd /opt && \
git clone -b jellyfin-rga --depth=1 https://github.com/nyanmisaka/rk-mirrors.git rkrga && \
meson setup rkrga rkrga_build --prefix=/usr --libdir=lib --buildtype=release --default-library=static -Dcpp_args=-fpermissive -Dlibdrm=false -Dlibrga_demo=false && \
meson configure rkrga_build && \
ninja -C rkrga_build install

## libyuv
# git clone https://chromium.googlesource.com/libyuv/libyuv/ && \
# cd libyuv && \
# cmake -DCMAKE_BUILD_TYPE="Release" -DBUILD_SHARED_LIBS=OFF && \
# make -j$(nproc) && make install 

## libass
LIBASS_VERSION=0.17.1
LIBASS_URL="https://github.com/libass/libass/releases/download/$LIBASS_VERSION/libass-$LIBASS_VERSION.tar.gz"
LIBASS_SHA256=d653be97198a0543c69111122173c41a99e0b91426f9e17f06a858982c2fb03d

cd /opt && \
wget $WGET_OPTS -O libass.tar.gz "$LIBASS_URL" && \
echo "$LIBASS_SHA256  libass.tar.gz" | sha256sum --status -c - && \
tar $TAR_OPTS libass.tar.gz && \
cd libass-* && ./configure --disable-shared --enable-static && \
make -j$(nproc) && make install

## lame
MP3LAME_VERSION=3.100
MP3LAME_URL="https://sourceforge.net/projects/lame/files/lame/$MP3LAME_VERSION/lame-$MP3LAME_VERSION.tar.gz/download"
MP3LAME_SHA256=ddfe36cab873794038ae2c1210557ad34857a4b6bdc515785d1da9e175b1da1e

cd /opt && \
wget $WGET_OPTS -O lame.tar.gz "$MP3LAME_URL" && \
echo "$MP3LAME_SHA256  lame.tar.gz" | sha256sum --status -c - && \
tar $TAR_OPTS lame.tar.gz && \
cd lame-* && ./configure --disable-shared --enable-static --enable-nasm --disable-gtktest --disable-cpml --disable-frontend && \
make -j$(nproc) install

## opus
OPUS_VERSION=1.4
OPUS_URL="https://github.com/xiph/opus/releases/download/v$OPUS_VERSION/opus-$OPUS_VERSION.tar.gz"
OPUS_SHA256=c9b32b4253be5ae63d1ff16eea06b94b5f0f2951b7a02aceef58e3a3ce49c51f

cd /opt && \
wget $WGET_OPTS -O opus.tar.gz "$OPUS_URL" && \
echo "$OPUS_SHA256  opus.tar.gz" | sha256sum --status -c - && \
tar $TAR_OPTS opus.tar.gz && \
cd opus-* && ./configure --disable-shared --enable-static --disable-extra-programs --disable-doc && \
make -j$(nproc) install

## librtmp
LIBRTMP_URL="https://git.ffmpeg.org/rtmpdump.git"
LIBRTMP_COMMIT=f1b83c10d8beb43fcc70a6e88cf4325499f25857

cd /opt && \
git clone "$LIBRTMP_URL" && \
cd rtmpdump && git checkout $LIBRTMP_COMMIT && \
# Patch/port librtmp to openssl 1.1
for _dlp in dh.h handshake.h hashswf.c; do \
  wget $WGET_OPTS https://raw.githubusercontent.com/microsoft/vcpkg/38bb87c5571555f1a4f64cb4ed9d2be0017f9fc1/ports/librtmp/${_dlp%.*}.patch; \
  patch librtmp/${_dlp} < ${_dlp%.*}.patch; \
done && \
make SYS=posix SHARED=off -j$(nproc) install

## libspeex
SPEEX_VERSION=1.2.1
SPEEX_URL="https://github.com/xiph/speex/archive/Speex-$SPEEX_VERSION.tar.gz"
SPEEX_SHA256=beaf2642e81a822eaade4d9ebf92e1678f301abfc74a29159c4e721ee70fdce0

cd /opt && \
wget $WGET_OPTS -O speex.tar.gz "$SPEEX_URL" && \
echo "$SPEEX_SHA256  speex.tar.gz" | sha256sum --status -c - && \
tar $TAR_OPTS speex.tar.gz && \
cd speex-Speex-* && ./autogen.sh && ./configure --disable-shared --enable-static && \
make -j$(nproc) install

## libwebp
LIBWEBP_VERSION=1.3.2
LIBWEBP_URL="https://github.com/webmproject/libwebp/archive/v$LIBWEBP_VERSION.tar.gz"
LIBWEBP_SHA256=c2c2f521fa468e3c5949ab698c2da410f5dce1c5e99f5ad9e70e0e8446b86505

cd /opt && \
wget $WGET_OPTS -O libwebp.tar.gz "$LIBWEBP_URL" && \
echo "$LIBWEBP_SHA256  libwebp.tar.gz" | sha256sum --status -c - && \
tar $TAR_OPTS libwebp.tar.gz && \
cd libwebp-* && ./autogen.sh && ./configure --disable-shared --enable-static --with-pic --enable-libwebpmux --disable-libwebpextras --disable-libwebpdemux --disable-sdl --disable-gl --disable-png --disable-jpeg --disable-tiff --disable-gif && \
make -j$(nproc) install
  
## lib_fdkaac
FDK_AAC_VERSION=2.0.2
FDK_AAC_URL="https://github.com/mstorsjo/fdk-aac/archive/v$FDK_AAC_VERSION.tar.gz"
FDK_AAC_SHA256=7812b4f0cf66acda0d0fe4302545339517e702af7674dd04e5fe22a5ade16a90

cd /opt && \
wget $WGET_OPTS -O fdk-aac.tar.gz "$FDK_AAC_URL" && \
echo "$FDK_AAC_SHA256  fdk-aac.tar.gz" | sha256sum --status -c - && \
tar $TAR_OPTS fdk-aac.tar.gz && \
cd fdk-aac-* && ./autogen.sh && ./configure --disable-shared --enable-static && \
make -j$(nproc) install

## libx264
X264_URL="https://code.videolan.org/videolan/x264.git"
X264_VERSION=31e19f92f00c7003fa115047ce50978bc98c3a0d

cd /opt && \
git clone "$X264_URL" && \
cd x264 && \
git checkout $X264_VERSION && \
./configure --enable-pic --enable-static --disable-cli --disable-lavf --disable-swscale && \
make -j$(nproc) install

## ffmpeg-rockchip
cd /opt && \
git clone --depth=1 https://github.com/nyanmisaka/ffmpeg-rockchip.git ffmpeg && \
cd ffmpeg && \
./configure \
--pkg-config-flags="--static" \
--extra-cflags="-fopenmp" \
--extra-ldflags="-fopenmp -Wl,-z,stack-size=2097152" \
--toolchain=hardened \
--extra-libs="-lpthread -lm" \
--ld="g++" \
--disable-debug \
--disable-ffplay \
--disable-shared \
--disable-doc \
--enable-static \
--enable-gpl \
--enable-nonfree \
--enable-version3 \
--enable-libdrm \
--enable-rkmpp \
--enable-rkrga \
--enable-libfdk-aac \
--enable-libx264 \
--enable-neon \
--enable-fontconfig \
--enable-indev=alsa \
--enable-outdev=alsa \
--enable-libpulse \
--enable-libass \
--enable-libfreetype \
--enable-libfribidi \
--enable-libmp3lame \
--enable-libopus \
--enable-librtmp \
--enable-libspeex \
--enable-libwebp \
--enable-libx264 \
--enable-openssl \
|| (cat ffbuild/config.log ; false) \
&& make -j$(nproc) install


# ## Run copy-libs script
# COPY ./copy-libs.sh /
# WORKDIR /
# RUN chmod +x copy-libs.sh
# RUN ./copy-libs.sh

# # Cleanup.
# rm -rf /var/cache/* /tmp/*