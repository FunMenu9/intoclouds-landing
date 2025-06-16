#!/bin/bash

echo "📊 Настройка мониторинга"
echo "======================="

# Установка htop для мониторинга системы
echo "📦 Установка htop..."
sudo apt install htop -y

# Создание скрипта мониторинга
echo "📝 Создание скрипта мониторинга..."
cat > monitor.sh << 'EOF'
#!/bin/bash

echo "📊 МОНИТОРИНГ INTOCLOUDS"
echo "======================="
echo "🕐 Время: $(date)"
echo ""

echo "💻 СИСТЕМА:"
echo "- Загрузка CPU: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)%"
echo "- Использование RAM: $(free -m | awk 'NR==2{printf "%.1f%%", $3*100/$2}')"
echo "- Свободное место: $(df -h / | awk 'NR==2{print $4}')"
echo ""

echo "🚀 PM2 ПРОЦЕССЫ:"
pm2 jlist | jq -r '.[] | "- \(.name): \(.pm2_env.status) (CPU: \(.monit.cpu)%, RAM: \(.monit.memory/1024/1024 | floor)MB)"'
echo ""

echo "🌐 NGINX:"
if systemctl is-active --quiet nginx; then
    echo "- Статус: ✅ Активен"
else
    echo "- Статус: ❌ Неактивен"
fi
echo ""

echo "🔗 ПОДКЛЮЧЕНИЯ:"
echo "- Активные соединения: $(ss -tuln | wc -l)"
echo "- Порт 80: $(ss -tuln | grep :80 | wc -l) соединений"
echo "- Порт 443: $(ss -tuln | grep :443 | wc -l) соединений"
echo ""

echo "📈 ЛОГИ (последние 5 строк):"
echo "Next.js:"
pm2 logs intoclouds-frontend --lines 5 --nostream 2>/dev/null | tail -5
echo ""
echo "Strapi:"
pm2 logs intoclouds-strapi --lines 5 --nostream 2>/dev/null | tail -5
EOF

chmod +x monitor.sh

# Установка jq для парсинга JSON
echo "📦 Установка jq..."
sudo apt install jq -y

# Создание cron задачи для мониторинга
echo "⏰ Настройка автоматического мониторинга..."
(crontab -l 2>/dev/null; echo "*/5 * * * * /var/www/intoclouds/monitor.sh >> /var/www/intoclouds/logs/monitor.log 2>&1") | crontab -

echo "✅ Мониторинг настроен!"
echo ""
echo "📝 Команды мониторинга:"
echo "- ./monitor.sh        # Текущий статус"
echo "- htop               # Интерактивный мониторинг"
echo "- pm2 monit          # Мониторинг PM2"
echo "- tail -f logs/monitor.log  # Логи мониторинга"
