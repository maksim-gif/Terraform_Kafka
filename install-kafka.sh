#!/bin/bash

set -e

echo "=========================================="
echo "🚀 Automated Docker & Kafka Deployment"
echo "=========================================="
echo ""

# Получаем внешний IP
HOST_IP=$(curl -s ifconfig.me || curl -s ipinfo.io/ip || echo "localhost")
echo "Detected external IP: $HOST_IP"

# Установка Docker
echo "Installing Docker..."
apt-get update
apt-get install -y docker.io

# Установка Docker Compose
echo "Installing Docker Compose..."
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose

# Настройка пользователя Docker
echo "Setting up Docker for user: ubuntu"
usermod -aG docker ubuntu

# Создание docker-compose.yml
echo "Creating docker-compose.yml..."
cat > /home/ubuntu/docker-compose.yml << EOF
services:
  zookeeper:
    image: confluentinc/cp-zookeeper:7.4.0
    container_name: zookeeper
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
    ports:
      - "22181:2181"
    restart: unless-stopped

  kafka:
    image: confluentinc/cp-kafka:74.0
    container_name: kafka
    depends_on:
      - zookeeper
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka:9092,PLAINTEXT_HOST://${HOST_IP}:29092
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
    ports:
      - "29092:29092"
    restart: unless-stopped
EOF

# Запуск Kafka кластера
echo "Starting Kafka cluster..."
cd /home/ubuntu
docker-compose up -d

# Ждем запуска
echo "Waiting for services to start..."
sleep 30

# Проверка статуса
echo "Checking container status:"
docker-compose ps

# Проверка Kafka
echo "Testing Kafka cluster..."
docker-compose exec kafka kafka-broker-api-versions --bootstrap-server localhost:9092
docker-compose exec kafka kafka-topics --bootstrap-server localhost:9092 --create --topic test-topic --partitions 1 --replication-factor 1

echo "Current topics:"
docker-compose exec kafka kafka-topics --bootstrap-server localhost:9092 --list

echo ""
echo "=========================================="
echo "🎉 DEPLOYMENT COMPLETED SUCCESSFULLY!"
echo "=========================================="
echo ""
echo "Kafka Cluster Details:"
echo "   Broker:    ${HOST_IP}:29092"
echo "   Zookeeper: ${HOST_IP}:22181"
echo ""
echo "Test from remote machine:"
echo "   docker run -it --rm confluentinc/cp-kafka:7.4.0 kafka-topics --bootstrap-server ${HOST_IP}:29092 --list"
