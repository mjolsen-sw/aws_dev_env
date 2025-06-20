#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg lsb-release

sudo snap install docker

# Add ubuntu user to docker group
sudo usermod -aG docker ubuntu

sudo systemctl enable docker
sudo systemctl start docker