#!/bin/bash

echo "🔄 Полная переустановка проекта на сервере"
echo "=========================================="

# Получение URL репозитория
echo "Введите URL вашего Git репозитория:"
read REPO_URL

if [ -z "$REPO_URL" ]; then
    echo "❌ URL репозитория не указан"
    exit 1
fi

# Остановка всех PM2 процессов
echo "🛑 Остановка PM2 процессов..."
pm2 stop all || true
pm2 delete all || true

# Переход в родительскую директорию
cd /var/www

# Создание бэкапа (если нужно)
if [ -d "intoclouds" ]; then
    echo "💾 Создание бэкапа..."
    sudo mv intoclouds intoclouds_backup_$(date +%Y%m%d_%H%M%S)
fi

# Клонирование проекта
echo "📥 Клонирование проекта..."
sudo git clone "$REPO_URL" intoclouds

# Установка прав доступа
echo "🔐 Установка прав доступа..."
sudo chown -R intoclouds:intoclouds intoclouds
cd intoclouds

# Переключение на пользователя intoclouds для дальнейших операций
echo "👤 Переключение на пользователя intoclouds..."
sudo -u intoclouds bash << 'EOF'

# Установка зависимостей
echo "📦 Установка зависимостей..."
npm install --production

# Сборка проекта
echo "🔨 Сборка проекта..."
npm run build

# Создание .env.local
echo "🔧 Создание .env.local..."
cat > .env.local << 'ENVEOF'
# SMTP Configuration
SMTP_HOST=mail.intoclouds.io
SMTP_PORT=465
SMTP_USER=dev@intoclouds.io
SMTP_PASS=K1dw1d123@
SMTP_FROM=dev@intoclouds.io

# Production Settings
NODE_ENV=production
PORT=3000
ENVEOF

# Создание директории для логов
mkdir -p logs

# Запуск через PM2
echo "🚀 Запуск через PM2..."
pm2 start ecosystem.config.js

# Сохранение конфигурации PM2
pm2 save

# Настройка автозапуска
pm2 startup

EOF

echo "✅ Проект успешно переустановлен!"
echo ""
echo "📊 Статус приложений:"
sudo -u intoclouds pm2 status

echo ""
echo "🌐 Ваш сайт доступен по адресу:"
echo "http://$(curl -s ifconfig.me)"
