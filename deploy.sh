#!/bin/bash

echo "🚀 Деплой IntoClouds..."

# Переход в директорию проекта
cd /home/ec2-user/intoclouds

# Остановка приложения
pm2 stop intoclouds || true

# Установка зависимостей
npm install

# Сборка проекта
npm run build

# Запуск через PM2
pm2 start ecosystem.config.js

# Сохранение PM2 конфигурации
pm2 save
pm2 startup

echo "✅ Деплой завершен!"
echo "🌐 Сайт доступен по адресу: http://your-server-ip"
