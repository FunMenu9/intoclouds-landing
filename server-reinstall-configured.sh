#!/bin/bash

echo "🔄 Полная переустановка IntoClouds на сервере"
echo "============================================"

# URL репозитория
REPO_URL="https://github.com/FunMenu9/intoclouds-landing.git"

echo "📥 Клонирование из: $REPO_URL"

# Остановка всех PM2 процессов
echo "🛑 Остановка PM2 процессов..."
pm2 stop all 2>/dev/null || true
pm2 delete all 2>/dev/null || true

# Переход в родительскую директорию
cd /var/www

# Создание бэкапа (если нужно)
if [ -d "intoclouds" ]; then
    echo "💾 Создание бэкапа старого проекта..."
    sudo mv intoclouds intoclouds_backup_$(date +%Y%m%d_%H%M%S)
fi

# Клонирование проекта
echo "📥 Клонирование проекта с GitHub..."
sudo git clone "$REPO_URL" intoclouds

# Установка прав доступа
echo "🔐 Установка прав доступа..."
sudo chown -R intoclouds:intoclouds intoclouds
cd intoclouds

# Выполнение команд от имени пользователя intoclouds
echo "👤 Настройка проекта..."
sudo -u intoclouds bash << 'EOF'

echo "📦 Установка зависимостей..."
npm install

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

# Strapi (если используется)
NEXT_PUBLIC_STRAPI_URL=http://localhost:1337
STRAPI_API_TOKEN=your-api-token-here
ENVEOF

echo "🔨 Сборка проекта..."
npm run build

echo "📁 Создание директории для логов..."
mkdir -p logs

echo "🚀 Запуск через PM2..."
pm2 start ecosystem.config.js

echo "💾 Сохранение конфигурации PM2..."
pm2 save

EOF

echo "✅ Проект успешно переустановлен!"
echo ""
echo "📊 Статус приложений:"
sudo -u intoclouds pm2 status

echo ""
echo "🌐 Ваш сайт доступен по адресу:"
PUBLIC_IP=$(curl -s ifconfig.me)
echo "http://$PUBLIC_IP"

echo ""
echo "📝 Полезные команды:"
echo "sudo -u intoclouds pm2 status    # Статус приложений"
echo "sudo -u intoclouds pm2 logs      # Просмотр логов"
echo "sudo -u intoclouds pm2 restart all  # Перезапуск"
