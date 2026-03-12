#!/bin/bash

# Update package lists and upgrade system
sudo apt update && sudo apt upgrade -y

# Install dependencies for Ruby
sudo apt install -y git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential \
libyaml-dev libncurses5-dev libffi-dev libgdbm-dev

# Install rbenv to manage Ruby versions
if ! command -v rbenv &> /dev/null; then
  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc
  source ~/.bashrc
fi

# Install ruby-build to compile Ruby
if [ ! -d ~/.rbenv/plugins/ruby-build ]; then
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
fi

# Install Ruby 2.6.6
rbenv install 2.6.6
rbenv global 2.6.6

# Verify Ruby installation
ruby -v

# Install Bundler 2.4.22
gem install bundler -v 2.4.22
bundle -v

# Install Docker (latest stable version)
sudo apt install -y ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify Docker installation
docker --version

# Install specific Docker Compose binary 2.39.2 (standalone, for compatibility)
sudo curl -L "https://github.com/docker/compose/releases/download/v2.39.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify Docker Compose installation
docker-compose --version

# Add user to docker group to run Docker without sudo
sudo usermod -aG docker $USER

# Inform user to log out and back in for group changes
echo "Please log out and log back in to apply Docker group changes, or run 'newgrp docker' in this terminal."