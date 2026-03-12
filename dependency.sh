#!/bin/bash

set -e

echo "Updating system..."
sudo apt update -y

echo "Installing base dependencies..."
sudo apt install -y build-essential curl git ca-certificates gnupg \
libssl-dev libreadline-dev zlib1g-dev libyaml-dev libffi-dev \
libgdbm-dev libncurses5-dev libtool bison autoconf

########################################
# Install Ruby 3.2.3
########################################

echo "Installing Ruby 3.2.3..."

cd /tmp
curl -O https://cache.ruby-lang.org/pub/ruby/3.2/ruby-3.2.3.tar.gz
tar -xzf ruby-3.2.3.tar.gz
cd ruby-3.2.3

./configure
make -j$(nproc)
sudo make install

echo "Ruby installed:"
ruby -v

########################################
# Install Bundler
########################################

echo "Installing Bundler 2.4.22..."
gem install bundler -v 2.4.22

echo "Bundler installed:"
bundler -v

########################################
# Install Docker 29.1.3
########################################

echo "Installing Docker..."

sudo install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
| sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo $VERSION_CODENAME) stable" \
| sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update

sudo apt install -y docker-ce docker-ce-cli containerd.io

sudo usermod -aG docker $USER

echo "Docker installed:"
docker --version

########################################
# Install Docker Compose v5.0.1
########################################

echo "Installing Docker Compose v5.0.1..."

sudo curl -L \
https://github.com/docker/compose/releases/download/v5.0.1/docker-compose-linux-x86_64 \
-o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

echo "Docker Compose installed:"
docker-compose --version

########################################

echo "Installation Complete!"
echo "Ruby:"
ruby -v

echo "Bundler:"
bundler -v

echo "Docker:"
docker --version

echo "Docker Compose:"
docker-compose --version