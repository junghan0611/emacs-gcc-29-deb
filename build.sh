#!/usr/bin/env sh

# 여기 보고 한다.
# https://github.com/Riey/kime
sudo docker build --file Dockerfile --tag emacs-gcc-29:git .
sudo docker run --name emacs-gcc-29 emacs-gcc-29:git
sudo docker cp emacs-gcc-29:/opt/deploy .

# 72M emacs-gcc-gtk_29.0.90.23.05.11.08.deb

# How to docker isntall on ubuntu https://docs.docker.com/engine/install/ubuntu/
