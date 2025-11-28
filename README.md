# Terraform + Kafka Deployment

## Описание
Развертывание виртуальной машины в VK Cloud с установкой Kafka кластера using Terraform и Docker Compose.

## Архитектура
- **ВМ**: Ubuntu 22.04, 20GB ceph-ssd, зона MS1
- **Kafka**: Брокер на порту 29092
- **Zookeeper**: На порту 22181

## Файлы
- `*.tf` - Terraform конфигурация
- `docker-compose.yml` - Kafka и Zookeeper
- `install-kafka.sh` - Скрипт автоматической установки

## Развертывание
1. `terraform apply` - Создать ВМ
2. `./install-kafka.sh` - Установить Docker и Kafka
