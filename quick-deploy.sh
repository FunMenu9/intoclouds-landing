#!/bin/bash

echo "⚡ Быстрый деплой IntoClouds"
echo "==========================="

# Загрузка на Git
echo "📤 Загрузка изменений на GitHub..."
git add .
git commit -m "Update: $(date '+%Y-%m-%d %H:%M:%S')"
git push origin main

echo "✅ Изменения загружены на GitHub!"
echo ""
echo "🔄 Теперь на сервере выполните:"
echo "cd /var/www"
echo "sudo rm -rf intoclouds"
echo "sudo git clone https://github.com/FunMenu9/intoclouds-landing.git intoclouds"
echo "sudo chown -R intoclouds:intoclouds intoclouds"
echo "cd intoclouds"
echo "sudo -u intoclouds npm install"
echo "sudo -u intoclouds npm run build"
echo "sudo -u intoclouds pm2 restart all"
