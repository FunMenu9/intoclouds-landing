#!/bin/bash

echo "🚀 Git-based deployment for IntoClouds"
echo "======================================"

# Проверка, что мы в правильной директории
if [ ! -f "package.json" ]; then
    echo "❌ package.json не найден. Создайте проект сначала."
    exit 1
fi

# Остановка PM2 процессов
echo "🛑 Остановка PM2 процессов..."
pm2 stop all || true

# Добавление изменений в Git
echo "📝 Добавление изменений в Git..."
git add .

# Коммит изменений
echo "💾 Создание коммита..."
read -p "Введите сообщение коммита (или нажмите Enter для автоматического): " commit_message
if [ -z "$commit_message" ]; then
    commit_message="Update: $(date '+%Y-%m-%d %H:%M:%S')"
fi

git commit -m "$commit_message"

# Установка зависимостей
echo "📦 Установка зависимостей..."
npm install

# Сборка проекта
echo "🔨 Сборка проекта..."
npm run build

# Запуск через PM2
echo "🚀 Запуск через PM2..."
pm2 start ecosystem.config.js

# Сохранение PM2 конфигурации
pm2 save

echo "✅ Деплой завершен!"
echo "📊 Статус приложений:"
pm2 status

echo ""
echo "🌐 Сайт доступен по адресу: http://$(curl -s ifconfig.me)"
