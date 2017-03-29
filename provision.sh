#!/bin/bash -ex

sudo \
  DOCKER_VER="1.12.3" \
  DOCKER_URL="https://apt.dockerproject.org/repo" \
  COMPOSE_VER="1.9.0" \
  DOCKER_USER=`whoami` \
  sh <<'EOF'

apt-key adv \
  --keyserver hkp://p80.pool.sks-keyservers.net:80 \
  --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

echo "deb $DOCKER_URL ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list

DEBIAN_FRONTEND=noninteractive \
  apt-get -y update && \
  apt-get -y upgrade

apt-get -y --force-yes install \
  docker-engine=${DOCKER_VER}-0~trusty \
  linux-image-extra-$(uname -r) \
  git make unzip vim

dpkg-divert \
  --local --divert /usr/bin/ack \
  --rename --add /usr/bin/ack-grep

cd /tmp
curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
unzip awscli-bundle.zip
apt-get -y purge unzip
./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
rm -rf awscli-bundle*

compose_url="https://github.com/docker/compose/releases/download"
compose_pkg="docker-compose-`uname -s`-`uname -m`"
curl -sSL "$compose_url/$COMPOSE_VER/$compose_pkg" > docker-compose
mv docker-compose /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

usermod -aG docker ${DOCKER_USER}
usermod -aG docker $(whoami)
echo dev-vm > /etc/hostname
EOF

ln -snf /vagrant/projects ~/projects

cat > ~/.bashrc <<'EOF'
export EDITOR=vim
EOF
