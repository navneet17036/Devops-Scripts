#!/bin/bash

sudo apt update -y
sudo apt-get install docker.io -y
sudo apt-get install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install


REGION="us-east-1"
ACCOUNT_ID="730335522871"
REPO_NAME="navneet-petclinic-frontend"


sudo aws ecr get-login-password --region $REGION | sudo docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

sudo docker pull $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO_NAME:latest

sudo docker run -d -p 80:80 $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO_NAME:latest
