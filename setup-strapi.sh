#!/bin/bash

echo "🚀 Настройка Strapi CMS для IntoClouds..."

# Создание директории для Strapi
mkdir -p strapi
cd strapi

# Инициализация Strapi проекта
npx create-strapi-app@latest . --quickstart --no-run

# Установка дополнительных плагинов
npm install @strapi/plugin-i18n

# Возврат в корневую директорию
cd ..

# Установка зависимостей для Next.js
npm install axios swr

# Создание .env.local
cat > .env.local << 'EOF'
# ===========================================
# STRAPI CMS CONFIGURATION
# ===========================================
NEXT_PUBLIC_STRAPI_URL=http://localhost:1337
STRAPI_API_TOKEN=your-api-token-here

# ===========================================
# SMTP EMAIL CONFIGURATION  
# ===========================================
SMTP_HOST=mail.intoclouds.io
SMTP_PORT=465
SMTP_USER=dev@intoclouds.io
SMTP_PASS=K1dw1d123@
SMTP_FROM=dev@intoclouds.io

# ===========================================
# STRAPI DATABASE (для продакшена)
# ===========================================
DATABASE_CLIENT=sqlite
DATABASE_FILENAME=.tmp/data.db

# Для PostgreSQL (рекомендуется для продакшена):
# DATABASE_CLIENT=postgres
# DATABASE_HOST=localhost
# DATABASE_PORT=5432
# DATABASE_NAME=intoclouds_strapi
# DATABASE_USERNAME=strapi_user
# DATABASE_PASSWORD=your_password

# ===========================================
# STRAPI SECURITY
# ===========================================
APP_KEYS=your-app-key-1,your-app-key-2,your-app-key-3,your-app-key-4
API_TOKEN_SALT=your-api-token-salt
ADMIN_JWT_SECRET=your-admin-jwt-secret
TRANSFER_TOKEN_SALT=your-transfer-token-salt
JWT_SECRET=your-jwt-secret
EOF

# Создание скрипта запуска
cat > start-strapi.sh << 'EOF'
#!/bin/bash

echo "🚀 Запуск Strapi CMS..."

# Переход в директорию Strapi
cd strapi

# Запуск в режиме разработки
npm run develop

echo "✅ Strapi запущен на http://localhost:1337/admin"
EOF

chmod +x start-strapi.sh

# Создание скрипта для продакшена
cat > deploy-strapi.sh << 'EOF'
#!/bin/bash

echo "🚀 Деплой Strapi в продакшен..."

cd strapi

# Сборка для продакшена
npm run build

# Запуск в продакшене
npm run start

echo "✅ Strapi запущен в продакшене"
EOF

chmod +x deploy-strapi.sh

echo "✅ Strapi CMS настроен!"
echo ""
echo "📋 Следующие шаги:"
echo "1. Запустите: ./start-strapi.sh"
echo "2. Откройте: http://localhost:1337/admin"
echo "3. Создайте админ аккаунт"
echo "4. Настройте контент-типы"
echo "5. Добавьте контент"
echo ""
echo "🔧 Для продакшена:"
echo "1. Настройте PostgreSQL"
echo "2. Обновите переменные окружения"
echo "3. Запустите: ./deploy-strapi.sh"
