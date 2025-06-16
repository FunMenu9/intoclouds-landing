#!/bin/bash

echo "🌐 Настройка Nginx для IntoClouds"
echo "================================="

# Создание конфигурации Nginx
echo "📝 Создание конфигурации Nginx..."
sudo tee /etc/nginx/sites-available/intoclouds > /dev/null << 'EOF'
server {
    listen 80;
    server_name _;

    # Основное приложение Next.js
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        proxy_read_timeout 86400;
    }

    # Strapi CMS
    location /admin {
        proxy_pass http://localhost:1337;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    # Strapi API
    location /api {
        proxy_pass http://localhost:1337;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Статические файлы Strapi
    location /uploads {
        proxy_pass http://localhost:1337;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Gzip сжатие
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied expired no-cache no-store private must-revalidate auth;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/javascript;

    # Безопасность
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;

    # Логи
    access_log /var/log/nginx/intoclouds.access.log;
    error_log /var/log/nginx/intoclouds.error.log;
}
EOF

# Активация сайта
echo "🔗 Активация сайта..."
sudo ln -sf /etc/nginx/sites-available/intoclouds /etc/nginx/sites-enabled/

# Удаление дефолтного сайта
echo "🗑️ Удаление дефолтного сайта..."
sudo rm -f /etc/nginx/sites-enabled/default

# Проверка конфигурации
echo "✅ Проверка конфигурации Nginx..."
sudo nginx -t

if [ $? -eq 0 ]; then
    echo "✅ Конфигурация Nginx корректна"
    
    # Перезапуск Nginx
    echo "🔄 Перезапуск Nginx..."
    sudo systemctl restart nginx
    sudo systemctl enable nginx
    
    echo "✅ Nginx настроен и запущен!"
else
    echo "❌ Ошибка в конфигурации Nginx"
    exit 1
fi
