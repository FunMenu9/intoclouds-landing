#!/bin/bash

echo "🚀 Деплой проекта IntoClouds"
echo "============================"

# Переход в директорию проекта
cd /var/www/intoclouds

# Клонирование проекта (замените на ваш репозиторий)
echo "📥 Клонирование проекта..."
# git clone https://github.com/your-username/intoclouds-landing.git .

# Если у вас нет Git репозитория, создаем проект вручную
echo "📁 Создание структуры проекта..."
mkdir -p {app,components,lib,public,strapi}

# Создание package.json
cat > package.json << 'EOF'
{
  "name": "intoclouds-landing",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start -p 3000",
    "lint": "next lint",
    "strapi:dev": "cd strapi && npm run develop",
    "strapi:build": "cd strapi && npm run build",
    "strapi:start": "cd strapi && npm run start"
  },
  "dependencies": {
    "next": "14.0.0",
    "react": "^18",
    "react-dom": "^18",
    "framer-motion": "^10.16.4",
    "lucide-react": "^0.292.0",
    "@radix-ui/react-slot": "^1.0.2",
    "@radix-ui/react-select": "^2.0.0",
    "class-variance-authority": "^0.7.0",
    "clsx": "^2.0.0",
    "tailwind-merge": "^2.0.0",
    "axios": "^1.6.0",
    "swr": "^2.2.4",
    "nodemailer": "^6.9.7"
  },
  "devDependencies": {
    "typescript": "^5",
    "@types/node": "^20",
    "@types/react": "^18",
    "@types/react-dom": "^18",
    "@types/nodemailer": "^6.4.14",
    "autoprefixer": "^10.0.1",
    "postcss": "^8",
    "tailwindcss": "^3.3.0",
    "eslint": "^8",
    "eslint-config-next": "14.0.0"
  }
}
EOF

# Установка зависимостей Next.js
echo "📦 Установка зависимостей Next.js..."
npm install

# Создание Strapi проекта
echo "📦 Создание Strapi проекта..."
cd strapi
npx create-strapi-app@latest . --quickstart --no-run
npm install @strapi/plugin-i18n
cd ..

# Создание .env.local
echo "🔧 Создание файла окружения..."
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
# PRODUCTION SETTINGS
# ===========================================
NODE_ENV=production
PORT=3000
STRAPI_PORT=1337
EOF

# Создание конфигурации PM2
echo "⚙️ Создание конфигурации PM2..."
cat > ecosystem.config.js << 'EOF'
module.exports = {
  apps: [
    {
      name: 'intoclouds-frontend',
      script: 'npm',
      args: 'start',
      cwd: '/var/www/intoclouds',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      env: {
        NODE_ENV: 'production',
        PORT: 3000
      }
    },
    {
      name: 'intoclouds-strapi',
      script: 'npm',
      args: 'run strapi:start',
      cwd: '/var/www/intoclouds',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      env: {
        NODE_ENV: 'production',
        PORT: 1337
      }
    }
  ]
}
EOF

echo "✅ Проект настроен!"
echo "📝 Следующие шаги:"
echo "1. Скопируйте файлы проекта в /var/www/intoclouds"
echo "2. Запустите: npm run build"
echo "3. Настройте Nginx"
echo "4. Запустите PM2"
