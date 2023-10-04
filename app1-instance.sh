#!/bin/bash
REPO_URL='https://github.com/MUKIT22/vprofile-project'
COMPOSE_VERSION='latest'

# Clone the repo using git clone command
sudo git clone "$REPO_URL"

# Change directory to the project directory using cd command
cd vprofile-project

sudo git checkout containers

# Install required packages
sudo apt update -y
sudo apt install docker.io -y
sudo apt install python3-pip -y
sudo curl -L "https://github.com/docker/compose/releases/download/v2.1.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Create directory for apt keyrings
sudo apt install docker-compose -y

# Run docker-compose up using docker-compose command
sudo docker-compose up -d