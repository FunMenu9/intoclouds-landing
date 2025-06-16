#!/bin/bash

echo "📤 Загрузка проекта IntoClouds на GitHub"
echo "======================================="

# Настройка Git пользователя
echo "🔧 Настройка Git пользователя..."
git config --global user.name "FunMenu9"
git config --global user.email "dev@intoclouds.io"

# Инициализация Git репозитория (если еще не инициализирован)
if [ ! -d ".git" ]; then
    echo "🔧 Инициализация Git репозитория..."
    git init
fi

# Создание .gitignore
echo "📝 Создание .gitignore..."
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Next.js
.next/
out/
build/

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Logs
logs/
*.log

# Runtime data
pids/
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/

# Dependency directories
jspm_packages/

# Optional npm cache directory
.npm

# Optional REPL history
.node_repl_history

# Output of 'npm pack'
*.tgz

# Yarn Integrity file
.yarn-integrity

# dotenv environment variables file
.env

# Strapi
strapi/.tmp/
strapi/build/
strapi/node_modules/
strapi/.env

# Backups
backups/

# PM2
.pm2/

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db
EOF

# Добавление всех файлов
echo "📁 Добавление файлов..."
git add .

# Создание коммита
echo "💾 Создание коммита..."
COMMIT_MESSAGE="Complete IntoClouds Landing Page - $(date '+%Y-%m-%d %H:%M:%S')"
git commit -m "$COMMIT_MESSAGE"

# Создание репозитория на GitHub (нужно будет создать вручную)
echo "🌐 Настройка GitHub репозитория..."
echo ""
echo "ВАЖНО: Создайте репозиторий на GitHub:"
echo "1. Перейдите на https://github.com"
echo "2. Войдите под логином: FunMenu9"
echo "3. Нажмите 'New repository'"
echo "4. Назовите репозиторий: intoclouds-landing"
echo "5. Сделайте его публичным"
echo "6. НЕ добавляйте README, .gitignore или лицензию"
echo "7. Нажмите 'Create repository'"
echo ""
read -p "Нажмите Enter после создания репозитория на GitHub..."

# Добавление remote origin
REPO_URL="https://github.com/FunMenu9/intoclouds-landing.git"
echo "🔗 Настройка remote origin: $REPO_URL"

# Удаляем существующий origin если есть
git remote remove origin 2>/dev/null || true

# Добавляем новый origin
git remote add origin "$REPO_URL"

# Устанавливаем upstream для main ветки
git branch -M main

# Пушим на GitHub с аутентификацией
echo "🚀 Загрузка на GitHub..."
echo "Введите пароль: K1dw1d123"
git push -u origin main

echo "✅ Проект успешно загружен на GitHub!"
echo "🌐 Репозиторий: $REPO_URL"
echo ""
echo "📋 Следующие шаги:"
echo "1. Скопируйте URL репозитория: $REPO_URL"
echo "2. Запустите на сервере: ./server-reinstall.sh"
