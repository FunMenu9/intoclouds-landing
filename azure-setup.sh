#!/bin/bash

echo "🚀 Настройка IntoClouds на Azure VM"
echo "=================================="

# Обновление системы
echo "📦 Обновление системы..."
sudo apt update && sudo apt upgrade -y

# Установка Node.js 18.x
echo "📦 Установка Node.js..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Проверка версий
echo "✅ Проверка версий:"
node --version
npm --version

# Установка PM2 глобально
echo "📦 Установка PM2..."
sudo npm install -g pm2

# Установка Nginx
echo "📦 Установка Nginx..."
sudo apt install nginx -y

# Установка Git
echo "📦 Установка Git..."
sudo apt install git -y

# Установка SQLite (для Strapi)
echo "📦 Установка SQLite..."
sudo apt install sqlite3 -y

# Создание пользователя для приложения
echo "👤 Создание пользователя intoclouds..."
sudo useradd -m -s /bin/bash intoclouds
sudo usermod -aG sudo intoclouds

# Создание директории для проекта
echo "📁 Создание директории проекта..."
sudo mkdir -p /var/www/intoclouds
sudo chown intoclouds:intoclouds /var/www/intoclouds

echo "✅ Базовая настройка завершена!"
echo "🔄 Переключитесь на пользователя intoclouds: sudo su - intoclouds"
