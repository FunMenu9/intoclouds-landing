#!/bin/bash

echo "🚀 Полный деплой IntoClouds на Azure VM"
echo "======================================"

# Проверка, что мы в правильной директории
if [ ! -f "package.json" ]; then
    echo "❌ Файл package.json не найден. Убедитесь, что вы в корне проекта."
    exit 1
fi

# Остановка существующих процессов PM2
echo "🛑 Остановка существующих процессов..."
pm2 stop all || true
pm2 delete all || true

# Установка зависимостей
echo "📦 Установка зависимостей..."
npm install

# Сборка Next.js приложения
echo "🔨 Сборка Next.js приложения..."
npm run build

# Сборка Strapi
echo "🔨 Сборка Strapi..."
cd strapi
npm install
npm run build
cd ..

# Создание директории для логов
echo "📁 Создание директории для логов..."
mkdir -p logs

# Запуск приложений через PM2
echo "🚀 Запуск приложений через PM2..."
pm2 start ecosystem.config.js

# Сохранение конфигурации PM2
echo "💾 Сохранение конфигурации PM2..."
pm2 save

# Настройка автозапуска PM2
echo "🔄 Настройка автозапуска PM2..."
pm2 startup

echo "✅ Деплой завершен!"
echo ""
echo "📊 Статус приложений:"
pm2 status

echo ""
echo "🌐 Ваш сайт доступен по адресу:"
echo "- Frontend: http://$(curl -s ifconfig.me)"
echo "- Strapi Admin: http://$(curl -s ifconfig.me)/admin"
echo ""
echo "📝 Полезные команды:"
echo "- pm2 status          # Статус приложений"
echo "- pm2 logs            # Логи всех приложений"
echo "- pm2 restart all     # Перезапуск всех приложений"
echo "- sudo nginx -t       # Проверка конфигурации Nginx"
echo "- sudo systemctl status nginx  # Статус Nginx"
