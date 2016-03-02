#!/bin/bash -ex

sudo \
  DOCKER_VER="1.10.2" \
  COMPOSE_VER="1.6.0" \
  DOCKER_USER=`whoami` \
  sh <<'EOF'
apt-key adv \
  --keyserver hkp://p80.pool.sks-keyservers.net:80 \
  --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' \
  > /etc/apt/sources.list.d/docker.list

DEBIAN_FRONTEND=noninteractive \
  apt-get -y update && \
  apt-get -y upgrade && \
  apt-get purge lxc-docker && \
  apt-get -y --force-yes --no-install-recommends install \
    docker-engine=${DOCKER_VER}-0~trusty \
    linux-image-extra-$(uname -r) \
    git-core \
    make \
    ack-grep \
    vim

dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep

COMPOSE_URL="https://github.com/docker/compose/releases/download"
COMPOSE_PKG="docker-compose-`uname -s`-`uname -m`"

curl -sSL "$COMPOSE_URL/$COMPOSE_VER/$COMPOSE_PKG" > /tmp/docker-compose
mv /tmp/docker-compose /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

usermod -aG docker ${DOCKER_USER}
usermod -aG docker $(whoami)

echo dev-vm > /etc/hostname
EOF

ln -snf /vagrant/projects ~/projects

cat > ~/.bashrc <<'EOF'
export EDITOR=vim
EOF
