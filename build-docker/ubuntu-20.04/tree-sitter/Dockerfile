FROM ubuntu:20.04
WORKDIR /opt
ENV DEBIAN_FRONTEND=noninteractive

# GCC 버전 10. 20.04 기반이라 그렇군 (HAMONI)

RUN sed -i -re 's/([a-z]{2}.)?archive.ubuntu.com|security.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
RUN sed -i 's/# deb-src/deb-src/' /etc/apt/sources.list &&\
    apt-get update && apt-get install --yes --no-install-recommends  \
    apt-transport-https\
    ca-certificates\
    build-essential \
    gcc-10 g++-10 libgccjit0 libgccjit-10-dev \
    autoconf \
    wget \
    cmake \
    git \
    pkg-config

ENV CC="gcc-10" CXX="g++-10"
RUN wget https://github.com/tree-sitter/tree-sitter/archive/v0.20.8.tar.gz \
    && tar xzf v0.20.8.tar.gz && cd tree-sitter-0.20.8 && make -j

# Create package
RUN \
    && make install DESTDIR=/opt/libtree-sitter_0.20.8/ \
    && mkdir /opt/libtree-sitter_0.20.8/DEBIAN && echo "Package: libtree-sitter_0.20.8\n\
Version: 0.20.8\n\
Section: libs\n\
Priority: optional\n\
Architecture: amd64\n\
Conflicts: libc6\n\
Maintainer: Junghanacs\n\
Description: libtree-sitter\n\" \
    >> /opt/libtree-sitter_0.20.8/DEBIAN/control \
    && echo "activate-noawait ldconfig" >> /opt/libtree-sitter_0.20.8/DEBIAN/triggers \
    && cd /opt \
    && dpkg-deb --build libtree-sitter_0.20.8 \
    && mkdir /opt/deploy \
    && mv /opt/libtree-sitter_*.deb /opt/deploy
