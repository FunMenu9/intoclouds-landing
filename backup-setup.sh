#!/bin/bash

echo "💾 Настройка системы бэкапов"
echo "============================"

# Создание директории для бэкапов
echo "📁 Создание директории для бэкапов..."
mkdir -p /var/www/intoclouds/backups

# Создание скрипта бэкапа
echo "📝 Создание скрипта бэкапа..."
cat > backup.sh << 'EOF'
#!/bin/bash

BACKUP_DIR="/var/www/intoclouds/backups"
DATE=$(date +%Y%m%d_%H%M%S)
PROJECT_DIR="/var/www/intoclouds"

echo "💾 Создание бэкапа: $DATE"

# Создание директории для текущего бэкапа
mkdir -p "$BACKUP_DIR/$DATE"

# Бэкап файлов проекта (исключая node_modules)
echo "📁 Бэкап файлов проекта..."
tar -czf "$BACKUP_DIR/$DATE/project_files.tar.gz" \
    --exclude="node_modules" \
    --exclude="strapi/node_modules" \
    --exclude=".next" \
    --exclude="strapi/.tmp" \
    --exclude="strapi/build" \
    --exclude="backups" \
    --exclude="logs" \
    -C "$PROJECT_DIR" .

# Бэкап базы данных Strapi
echo "🗄️ Бэкап базы данных Strapi..."
if [ -f "$PROJECT_DIR/strapi/.tmp/data.db" ]; then
    cp "$PROJECT_DIR/strapi/.tmp/data.db" "$BACKUP_DIR/$DATE/strapi_database.db"
fi

# Бэкап конфигурации Nginx
echo "🌐 Бэкап конфигурации Nginx..."
sudo cp /etc/nginx/sites-available/intoclouds "$BACKUP_DIR/$DATE/nginx_config"

# Бэкап PM2 конфигурации
echo "⚙️ Бэкап PM2 конфигурации..."
cp "$PROJECT_DIR/ecosystem.config.js" "$BACKUP_DIR/$DATE/"

# Создание информационного файла
cat > "$BACKUP_DIR/$DATE/backup_info.txt" << EOL
Бэкап IntoClouds
================
Дата: $(date)
Сервер: $(hostname)
IP: $(curl -s ifconfig.me)
Node.js: $(node --version)
PM2 процессы: $(pm2 jlist | jq length)
Размер проекта: $(du -sh $PROJECT_DIR | cut -f1)
EOL

# Удаление старых бэкапов (старше 7 дней)
echo "🗑️ Удаление старых бэкапов..."
find "$BACKUP_DIR" -type d -name "20*" -mtime +7 -exec rm -rf {} \; 2>/dev/null

echo "✅ Бэкап завершен: $BACKUP_DIR/$DATE"
echo "📊 Размер бэкапа: $(du -sh $BACKUP_DIR/$DATE | cut -f1)"
EOF

chmod +x backup.sh

# Создание скрипта восстановления
echo "📝 Создание скрипта восстановления..."
cat > restore.sh << 'EOF'
#!/bin/bash

if [ -z "$1" ]; then
    echo "❌ Укажите дату бэкапа: ./restore.sh YYYYMMDD_HHMMSS"
    echo "📋 Доступные бэкапы:"
    ls -la /var/www/intoclouds/backups/
    exit 1
fi

BACKUP_DATE=$1
BACKUP_DIR="/var/www/intoclouds/backups/$BACKUP_DATE"
PROJECT_DIR="/var/www/intoclouds"

if [ ! -d "$BACKUP_DIR" ]; then
    echo "❌ Бэкап не найден: $BACKUP_DIR"
    exit 1
fi

echo "🔄 Восстановление из бэкапа: $BACKUP_DATE"
echo "⚠️  ВНИМАНИЕ: Это перезапишет текущие файлы!"
read -p "Продолжить? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Отменено"
    exit 1
fi

# Остановка приложений
echo "🛑 Остановка приложений..."
pm2 stop all

# Восстановление файлов проекта
echo "📁 Восстановление файлов проекта..."
cd "$PROJECT_DIR"
tar -xzf "$BACKUP_DIR/project_files.tar.gz"

# Восстановление базы данных Strapi
echo "🗄️ Восстановление базы данных Strapi..."
if [ -f "$BACKUP_DIR/strapi_database.db" ]; then
    mkdir -p "$PROJECT_DIR/strapi/.tmp"
    cp "$BACKUP_DIR/strapi_database.db" "$PROJECT_DIR/strapi/.tmp/data.db"
fi

# Установка зависимостей
echo "📦 Установка зависимостей..."
npm install
cd strapi && npm install && cd ..

# Сборка проекта
echo "🔨 Сборка проекта..."
npm run build
cd strapi && npm run build && cd ..

# Запуск приложений
echo "🚀 Запуск приложений..."
pm2 start ecosystem.config.js

echo "✅ Восстановление завершено!"
pm2 status
EOF

chmod +x restore.sh

# Настройка автоматического бэкапа
echo "⏰ Настройка автоматического бэкапа..."
(crontab -l 2>/dev/null; echo "0 2 * * * /var/www/intoclouds/backup.sh >> /var/www/intoclouds/logs/backup.log 2>&1") | crontab -

echo "✅ Система бэкапов настроена!"
echo ""
echo "📝 Команды бэкапа:"
echo "- ./backup.sh         # Создать бэкап"
echo "- ./restore.sh DATE   # Восстановить бэкап"
echo "- ls backups/         # Список бэкапов"
echo ""
echo "⏰ Автоматический бэкап: каждый день в 02:00"
