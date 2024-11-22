# Create a Home Cyber Lab and Intercept User Credentials
Created by: Stephen Hayes and Kevin Seldomridge

This document will take you through creating three docker containers, a web server, an attacker and an ubuntu user. The web server represents a legitimate web server that serves up a web page a user can log in to. The attacker will act as a malicious server that is designed to steal login credentials after hacking the config files of the legitimate web server.

There are two ways to do this, manually or through the autmated code in this repository. We will show you both ways.
## Docker Crash Course
```
# Install Docker
apt-get update
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
docker

# Show all running containers
docker ps

# Show all docker containers created from baseline images
docker ps -a

# Show all docker images
docker images
```
## Manual Home Lab Creation
### Create the cyberNet Network
```
# Create a network the containers can connect to
docker network create -d bridge cyberNet --subnet 172.20.0.0/16 --gateway 172.20.0.1
```
### Create the Containers
#### The Ubuntu Container
Open a new terminal window to create the Ubuntu container and install its dependencies
##### Create and run the Ubuntu Container
```
# Pull the latest ubuntu image to your machine
docker pull ubuntu:latest

# run the ubuntu image with the name ubuntu_machine in interactive terminal mode
# --name: the name of the container
# -it: run in interactive terminal mode
docker run --name ubuntu_machine --network cyberNet --ip 172.20.0.3 -it ubuntu
```
##### Install Ubuntu dependencies
```
# Update apt
apt-get update

# Install iproute2, iputils-ping
apt-get install iproute2 iputils-ping curl
```
#### The Web Server Container
Open a new terminal window to create the Web Server container and install its dependencies
##### Create and run the Web Server Container
```
# Pull the latest nginx image to your machine
docker pull nginx:latest

# run the nginx image with the name web_server
# -it: Interactive terminal mode
# -p: map ports to host machine
docker run --name web_server --network cyberNet --ip 172.20.0.4 -it -p 80:80 -p 443:443 nginx /bin/sh
```
##### Install Web Server dependencies
```
# Update apt
apt-get update

# Install iproute2, iputils-ping, openssl, net-tools
apt-get install iproute2 iputils-ping openssl net-tools
```
#### The Attacker Container
Open a new terminal window to create the Attacker container and install its dependencies
##### Create and run the Attacker Container
```
# Pull the latest leplusorg/kali image to your machine
docker pull leplusorg/kali:latest

# run the ubuntu image with the name ubuntu_machine in interactive terminal mode
# --name: the name of the container
# -it: run in interactive terminal mode
docker run --name attacker --network cyberNet --ip 172.20.0.2 -it leplusorg/kali
```
##### Install Attacker dependencies
```
# Update apt
apt-get update

# Install iproute2, iputils-ping, python3, python3-pip
apt-get install iproute2 iputils-ping python3 python3-pip
```