#!/bin/bash

echo "🚀 ПОЛНАЯ НАСТРОЙКА INTOCLOUDS НА AZURE VM"
echo "=========================================="
echo ""

# Проверка прав root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Запустите скрипт с правами root: sudo ./complete-setup.sh"
    exit 1
fi

# Получение IP адреса
PUBLIC_IP=$(curl -s ifconfig.me)
echo "🌐 Публичный IP: $PUBLIC_IP"
echo ""

# Шаг 1: Базовая настройка системы
echo "📦 ШАГ 1: Базовая настройка системы"
echo "===================================="
./azure-setup.sh

# Шаг 2: Настройка файрвола
echo ""
echo "🔥 ШАГ 2: Настройка файрвола"
echo "============================"
./setup-firewall.sh

# Шаг 3: Настройка Nginx
echo ""
echo "🌐 ШАГ 3: Настройка Nginx"
echo "========================="
./setup-nginx.sh

# Переключение на пользователя intoclouds для деплоя
echo ""
echo "👤 ШАГ 4: Деплой проекта"
echo "========================"
echo "Переключаемся на пользователя intoclouds..."

# Копирование скриптов для пользователя intoclouds
cp deploy-project.sh /var/www/intoclouds/
cp deploy-full.sh /var/www/intoclouds/
cp monitoring-setup.sh /var/www/intoclouds/
cp backup-setup.sh /var/www/intoclouds/
chown intoclouds:intoclouds /var/www/intoclouds/*.sh
chmod +x /var/www/intoclouds/*.sh

# Выполнение деплоя от имени пользователя intoclouds
sudo -u intoclouds bash -c "cd /var/www/intoclouds && ./deploy-project.sh"

echo ""
echo "📊 ШАГ 5: Настройка мониторинга"
echo "==============================="
sudo -u intoclouds bash -c "cd /var/www/intoclouds && ./monitoring-setup.sh"

echo ""
echo "💾 ШАГ 6: Настройка бэкапов"
echo "==========================="
sudo -u intoclouds bash -c "cd /var/www/intoclouds && ./backup-setup.sh"

echo ""
echo "✅ НАСТРОЙКА ЗАВЕРШЕНА!"
echo "======================"
echo ""
echo "🌐 Ваш сайт будет доступен по адресу:"
echo "- Frontend: http://$PUBLIC_IP"
echo "- Strapi Admin: http://$PUBLIC_IP/admin"
echo ""
echo "📝 Следующие шаги:"
echo "1. Скопируйте файлы вашего проекта в /var/www/intoclouds"
echo "2. Настройте переменные окружения в .env.local"
echo "3. Запустите: sudo -u intoclouds bash -c 'cd /var/www/intoclouds && ./deploy-full.sh'"
echo "4. Настройте домен и SSL: ./ssl-setup.sh your-domain.com"
echo ""
echo "🔧 Полезные команды:"
echo "- sudo -u intoclouds pm2 status    # Статус приложений"
echo "- sudo -u intoclouds ./monitor.sh  # Мониторинг системы"
echo "- sudo -u intoclouds ./backup.sh   # Создать бэкап"
echo "- sudo systemctl status nginx      # Статус Nginx"
echo ""
echo "📋 Файлы конфигурации:"
echo "- Nginx: /etc/nginx/sites-available/intoclouds"
echo "- PM2: /var/www/intoclouds/ecosystem.config.js"
echo "- Env: /var/www/intoclouds/.env.local"
echo ""
echo "🎉 Удачного деплоя!"
