#!/bin/bash

sudo apt update -y
sudo apt install -y docker.io jq
sudo apt-get install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# 3️⃣ Login to ECR
AWS_REGION="us-east-1"
ACCOUNT_ID="730335522871"
ECR_REPO="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/navneet-petclinic-backend"
sudo aws ecr get-login-password --region $AWS_REGION | sudo docker login --username AWS --password-stdin $ECR_REPO
# 4️⃣ Pull the image
sudo docker pull $ECR_REPO:latest
# 5️⃣ Fetch secrets from AWS Secrets Manager
SECRET_JSON=$(aws secretsmanager get-secret-value \
 --secret-id navneet/petclinic/backend/env \
 --region $AWS_REGION \
 --query SecretString \
 --output text)
SPRING_DATASOURCE_URL=$(echo $SECRET_JSON | jq -r '.SPRING_DATASOURCE_URL')
SPRING_DATASOURCE_USERNAME=$(echo $SECRET_JSON | jq -r '.SPRING_DATASOURCE_USERNAME')
SPRING_DATASOURCE_PASSWORD=$(echo $SECRET_JSON | jq -r '.SPRING_DATASOURCE_PASSWORD')
# 6️⃣ Run the container with environment variables
sudo docker run -d \
 --network host \
 --name petclinic-backend \
 -p 9966:9966 \
 -e SPRING_DATASOURCE_URL="$SPRING_DATASOURCE_URL" \
 -e SPRING_DATASOURCE_USERNAME="$SPRING_DATASOURCE_USERNAME" \
 -e SPRING_DATASOURCE_PASSWORD="$SPRING_DATASOURCE_PASSWORD" \
 $ECR_REPO:latest
