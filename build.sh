#!/usr/bin/env sh
# docker build --file Dockerfile
#  docker build -t konstare/emacs-gcc-pgtk:latest .
# id=$(docker create anacs/emacs-gcc-pgtk)
# docker cp $id:/opt/deploy .

# 여기 보고 한다.
# https://github.com/Riey/kime
sudo docker build --file Dockerfile --tag emacs-gcc-29:git .


# docker build --file build-docker/<distro path>/Dockerfile --tag kime-build:git .
# docker run --name kime kime-build:git
# docker cp kime:/opt/kime-out/kime.tar.xz .
# if you want to build deb package try this command instead
# docker cp kime:/opt/kime-out/kime_amd64.deb .

# How to docker isntall on ubuntu https://docs.docker.com/engine/install/ubuntu/
