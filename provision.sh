#!/bin/bash

DOCKER_VER="1.8.1-0~trusty"
COMPOSE_SRC="https://github.com/docker/compose/releases/download"
COMPOSE_VER="1.4.0"
COMPOSE_PKG="docker-compose-`uname -s`-`uname -m`"

sudo sh <<EOF
apt-key adv \
  --keyserver hkp://p80.pool.sks-keyservers.net:80 \
  --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' > /etc/apt/sources.list.d/docker.list

DEBIAN_FRONTEND=noninteractive \
  apt-get -y update && apt-get -y upgrade

apt-get -y --force-yes --no-install-recommends install \
  docker-engine=${DOCKER_VER} \
  linux-image-extra-$(uname -r) \
  git-core \
  make \
  ack-grep \
  vim

dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep

curl -o /usr/local/bin/ack http://beyondgrep.com/ack-2.04-single-file
chmod 0775 /usr/local/bin/ack

curl -sSL ${COMPOSE_SRC}/${COMPOSE_VER}/${COMPOSE_PKG} > /tmp/docker-compose
mv /tmp/docker-compose /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

usermod -aG docker $(whoami)

echo dev-vm > /etc/hostname
EOF

ln -snf /vagrant/projects ~/projects

cat > ~/.bashrc <<'EOF'
export EDITOR=vim
EOF
