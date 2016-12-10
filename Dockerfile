FROM lsiobase/alpine.python.arm64
MAINTAINER smdion <me@seandion.com> ,sparklyballs

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# install packages
RUN \
 apk add --no-cache \
	ffmpeg \
	mc

# install build packages
RUN \
 apk add --no-cache --virtual=build-dependencies \
	g++ \
	gcc \
	make && \

# compile shntool
 mkdir -p \
	/tmp/shntool && \
 curl -o \
 /tmp/shntool-src-tar.gz -L \
	http://www.etree.org/shnutils/shntool/dist/src/shntool-3.0.10.tar.gz && \
 tar xf \
 /tmp/shntool-src-tar.gz -C \
	/tmp/shntool --strip-components=1 && \
 rm -rf \
	/tmp/shntool/config.guess \
	/tmp/shntool/config.sub && \
 curl -o \
 /tmp/shntool/config.guess \
	'http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD' && \
 curl -o \
 /tmp/shntool/config.sub \
	'http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD' && \
 chmod +x \
	/tmp/shntool/config.guess \
	/tmp/shntool/config.sub && \
 cd /tmp/shntool && \
 ./configure \
	--infodir=/usr/share/info \
	--localstatedir=/var \
	--mandir=/usr/share/man \
	--prefix=/usr \
	--sysconfdir=/etc && \
 make && \
 make install && \

# cleanup
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/tmp/* \
	/usr/lib/*.la

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8181
VOLUME /config /downloads /music
