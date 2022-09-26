#!/bin/sh

#########################
#  VM running in ubuntu #
#########################

sudo apt update -y && sudo apt upgrade -y

sudo apt install -y docker.io openjdk-11-jdk

sudo systemctl enable docker
sudo systemctl start docker

sudo usermod -aG docker $USER

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update
sudo apt install jenkins -y

sudo su
usermod -aG docker jenkins
usermod -aG root jenkins
sudo systemctl restart jenkins


