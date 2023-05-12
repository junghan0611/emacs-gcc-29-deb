FROM ubuntu:22.04
WORKDIR /opt
ENV DEBIAN_FRONTEND=noninteractive

RUN sed -i -re 's/([a-z]{2}.)?archive.ubuntu.com|security.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
RUN sed -i 's/# deb-src/deb-src/' /etc/apt/sources.list &&\
    apt-get update && apt-get install --yes --no-install-recommends  \
    apt-transport-https\
    ca-certificates\
    build-essential \
    fonts-noto-color-emoji fonts-symbola fonts-naver-d2coding \
    fonts-noto-cjk \
    sqlite3 ripgrep fd-find locate \
    gcc-11 g++-11 libgccjit0 libgccjit-11-dev \
    autoconf \
    wget \
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
    libwebkit2gtk-4.0-dev
RUN wget https://github.com/tree-sitter/tree-sitter/archive/v0.20.8.tar.gz \
    && tar xzf v0.20.8.tar.gz && cd tree-sitter-0.20.8 && make -j && make install
# RUN echo "/usr/local/lib/" >> /etc/ld.so.conf
RUN export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/
RUN ldconfig

# Clone emacs
RUN update-ca-certificates \
    && git clone --depth 1 https://git.savannah.gnu.org/git/emacs.git -b emacs-29 emacs \
    && mv emacs/* .

# Build
ENV CC="gcc-11" CXX="g++-11"
RUN ./autogen.sh && ./configure \
    --prefix "/usr/local" \
    --with-json \
    --with-gnutls \
    --without-pop \
    --with-rsvg  \
    --without-mailutils \
    --with-sqlite3 \
    --with-png --with-jpeg --with-tiff --with-imagemagick=ifavailable \
    --with-tree-sitter \
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
Depends: fonts-noto-color-emoji, fonts-symbola, fonts-naver-d2coding, fonts-noto-cjk, texinfo, libjansson4, imagemagick, sqlite3, ripgrep, fd-find, locate, aspell, libgif7, libotf1, libgccjit0, libgtk-3-0, librsvg2-2, libtiff5, libjansson4, libacl1, libgmp10, libwebp7, libsqlite3-0\n\
Maintainer: Junghanacs\n\
Description: Emacs with native compilation, X11 gtk and tree-sitter\n\
    --with-json \
    --with-gnutls  \
    --without-pop \
    --with-rsvg  \
    --without-mailutils \
    --with-sqlite3 \
    --with-png --with-jpeg --with-tiff --with-imagemagick=ifavailable \
    --with-tree-sitter \
    --with-cairo --with-lcms2 --with-modules --with-xwidgets --with-x-toolkit=gtk3 \
    --program-transform-name='s/^ctags$/ctags.emacs/' \
    --with-native-compilation=aot CFLAGS='-O2 -pipe'" \
    >> emacs-gcc-gtk_${EMACS_VERSION}/DEBIAN/control \
    && echo "activate-noawait ldconfig" >> emacs-gcc-gtk_${EMACS_VERSION}/DEBIAN/triggers \
    && cd /opt \
    && dpkg-deb --build emacs-gcc-gtk_${EMACS_VERSION} \
    && mkdir /opt/deploy \
    && mv /opt/emacs-gcc-gtk_*.deb /opt/deploy
