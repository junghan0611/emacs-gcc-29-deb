FROM ubuntu:22.04
WORKDIR /opt
ENV DEBIAN_FRONTEND=noninteractive

# GCC 버전 10. 20.04 기반이라 그렇군 (HAMONI)
# RUN apt install -y gcc-10 g++-10 libgccjit0 libgccjit-10-dev

RUN sed -i -re 's/([a-z]{2}.)?archive.ubuntu.com|security.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
RUN sed -i 's/# deb-src/deb-src/' /etc/apt/sources.list &&\
    apt-get update && apt-get install --yes --no-install-recommends  \
    apt-transport-https\
    ca-certificates\
    build-essential \
    autoconf \
    git \
    pkg-config \
    libgnutls28-dev \
    libasound2-dev \
    libacl1-dev \
    libgtk-3-dev \
    libgpm-dev \
    liblockfile-dev \
    libotf-dev \
    libsystemd-dev \
    libjansson-dev \
    libgccjit-11-dev \
    libgif-dev \
    librsvg2-dev  \
    libxml2-dev \
    libxpm-dev \
    libtiff-dev \
    libjbig-dev \
    libncurses-dev \
    liblcms2-dev \
    libwebp-dev \
    libsqlite3-dev \
    texinfo \
    libmagickcore-dev libmagickwand-dev \
    libjansson-dev \
    libjpeg-dev libgif-dev libpng-dev \
    libdbus-1-dev libgtk2.0-dev \
    libm17n-dev \
    libglib2.0-dev \
    libgirepository1.0-dev \
    libpoppler-dev \
    libpoppler-glib-dev \
    libz-dev \
    libxaw7-dev libxaw3dxft8-dev \
    libwebkit2gtk-4.0-dev \
    libtree-sitter-dev

# Clone emacs
RUN update-ca-certificates \
    && git clone --depth 1 https://git.savannah.gnu.org/git/emacs.git -b emacs-29 emacs \
    && mv emacs/* .

# Build
ENV CC="gcc-11"
RUN ./autogen.sh && ./configure \
    --prefix "/usr/local" \
    --with-json \
    --with-gnutls \
    --without-pop \
    --with-rsvg  \
    --without-mailutils \
    --with-sqlite3 \
    --with-png --with-jpeg --with-tiff --with-imagemagick=ifavailable \
    --with-tree-sitter=ifavailable \
    --with-cairo --with-lcms2 --with-modules --with-xwidgets --with-x-toolkit=gtk3 \
    --program-transform-name='s/^ctags$/ctags.emacs/' \
    --with-native-compilation=aot CFLAGS="-O2 -pipe"


RUN make -j $(nproc)

# Create package
RUN EMACS_VERSION=$(sed -ne 's/AC_INIT(\[GNU Emacs\], \[\([0-9.]\+\)\], .*/\1/p' configure.ac).$(date +%y.%m.%d.%H) \
    && make install prefix=/opt/emacs-gcc-gtk_${EMACS_VERSION}/usr/local \
    && mkdir emacs-gcc-gtk_${EMACS_VERSION}/DEBIAN && echo "Package: emacs-gcc-gtk\n\
Version: ${EMACS_VERSION}\n\
Section: base\n\
Priority: optional\n\
Architecture: amd64\n\
Depends: libtree-sitter0, libgif7, libotf1, libgccjit0, libgtk-3-0, librsvg2-2, libtiff5, libjansson4, libacl1, libgmp10, libwebp7, libsqlite3-0\n\
Conflicts: emacs\n\
Maintainer: Junghanacs\n\
Description: Emacs with native compilation, X11 gtk and tree-sitter\n\
    --with-json \
    --with-gnutls  \
    --without-pop \
    --with-rsvg  \
    --without-mailutils \
    --with-sqlite3 \
    --with-png --with-jpeg --with-tiff --with-imagemagick=ifavailable \
    --with-tree-sitter=ifavailable \
    --with-cairo --with-lcms2 --with-modules --with-xwidgets --with-x-toolkit=gtk3 \
    --program-transform-name='s/^ctags$/ctags.emacs/' \
    --with-native-compilation=aot CFLAGS='-O2 -pipe'" \
    >> emacs-gcc-gtk_${EMACS_VERSION}/DEBIAN/control \
    && echo "activate-noawait ldconfig" >> emacs-gcc-gtk_${EMACS_VERSION}/DEBIAN/triggers \
    && cd /opt \
    && dpkg-deb --build emacs-gcc-gtk_${EMACS_VERSION} \
    && mkdir /opt/deploy \
    && mv /opt/emacs-gcc-gtk_*.deb /opt/deploy
