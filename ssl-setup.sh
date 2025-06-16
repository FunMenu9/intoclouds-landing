#!/bin/bash

echo "🔒 Настройка SSL сертификата"
echo "============================"

# Проверка домена
if [ -z "$1" ]; then
    echo "❌ Укажите домен: ./ssl-setup.sh your-domain.com"
    exit 1
fi

DOMAIN=$1

echo "🌐 Настройка SSL для домена: $DOMAIN"

# Установка Certbot
echo "📦 Установка Certbot..."
sudo apt install snapd -y
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot

# Создание символической ссылки
sudo ln -sf /snap/bin/certbot /usr/bin/certbot

# Получение SSL сертификата
echo "🔒 Получение SSL сертификата..."
sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN

# Проверка автообновления
echo "🔄 Настройка автообновления сертификата..."
sudo certbot renew --dry-run

echo "✅ SSL сертификат настроен!"
echo "🌐 Ваш сайт теперь доступен по HTTPS:"
echo "- https://$DOMAIN"
echo "- https://www.$DOMAIN"
