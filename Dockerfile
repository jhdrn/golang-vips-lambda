FROM lambci/lambda:build-go1.x

WORKDIR /build

ARG VIPS_VERSION=8.8.4

ENV WORKDIR="/build"
ENV INSTALLDIR="/opt"
ENV VIPS_VERSION=$VIPS_VERSION

# Install deps for libvips. Details: https://libvips.github.io/libvips/install.html
#
RUN yum install -y \
  gtk-doc \
  gobject-introspection \
  gobject-introspection-devel

# Clone repo and checkout version tag.
#
RUN git clone git://github.com/libvips/libvips.git && \
  cd libvips && \
  git checkout "v${VIPS_VERSION}"

# Compile from source.
#
RUN cd ./libvips && \
  CC=clang CXX=clang++ \
  ./autogen.sh \
  --prefix=${INSTALLDIR} \
  --disable-static && \
  make install && \
  echo /opt/lib > /etc/ld.so.conf.d/libvips.conf && \
  ldconfig

# Copy only needed files to new share/lib and share/bin
#
RUN mkdir -p share/lib && \
  cp -a $INSTALLDIR/lib/libvips.so* $WORKDIR/share/lib/
RUN mkdir -p share/bin && \
  cp -a $INSTALLDIR/bin/vips $WORKDIR/share/bin/ && \
  cp -a $INSTALLDIR/bin/vipsheader $WORKDIR/share/bin/ && \
  cp -a $INSTALLDIR/bin/vipsedit $WORKDIR/share/bin/ && \
  cp -a $INSTALLDIR/bin/vipsthumbnail $WORKDIR/share/bin/

# Create sym links for ruby-ffi gem's `glib_libname` and `gobject_libname` to work.
#RUN cd ./share/lib/ && \
#  ln -s /usr/lib64/libglib-2.0.so.0 libglib-2.0.so && \
#  ln -s /usr/lib64/libgobject-2.0.so.0 libgobject-2.0.so

# Zip up contents so final `lib` and `bin` can be placed in /opt layer.
#
RUN cd ./share && \
  zip --symlinks -r libvips.zip .
