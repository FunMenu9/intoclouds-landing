#!/bin/bash

echo "🎨 Настройка Sanity CMS для IntoClouds..."

# Установка Sanity CLI
npm install -g @sanity/cli

# Инициализация Sanity проекта
sanity init --project-id your-project-id --dataset production

# Установка зависимостей
npm install @sanity/client @sanity/image-url next-sanity @portabletext/react @sanity/vision sanity styled-components

# Создание .env.local
cat > .env.local << 'EOF'
# Sanity
NEXT_PUBLIC_SANITY_PROJECT_ID=your-project-id
NEXT_PUBLIC_SANITY_DATASET=production
NEXT_PUBLIC_SANITY_API_VERSION=2023-05-03

# SMTP (существующие настройки)
SMTP_HOST=mail.intoclouds.io
SMTP_PORT=465
SMTP_USER=dev@intoclouds.io
SMTP_PASS=K1dw1d123@
SMTP_FROM=dev@intoclouds.io
EOF

echo "✅ Sanity CMS настроен!"
echo "🚀 Запустите 'npm run dev' и перейдите на /studio для управления контентом"
