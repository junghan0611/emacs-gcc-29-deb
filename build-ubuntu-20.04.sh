#!/usr/bin/env sh

sudo docker build --file ./build-docker/ubuntu-20.04/Dockerfile --tag emacs-gcc-29:git .
sudo docker run --name emacs-gcc-29 emacs-gcc-29:git
sudo docker cp emacs-gcc-29:/opt/deploy .

# 72M emacs-gcc-gtk_29.0.90.23.05.11.08.deb

# sudo docker build --file ./build-docker/ubuntu-20.04/tree-sitter/Dockerfile --tag tree-sitter_0.20.8:git .
# sudo docker run --name tree-sitter_0.20.8 tree-sitter_0.20.8:git
# sudo docker cp tree-sitter_0.20.8:/opt/deploy .
