#!/bin/bash

echo "📤 Загрузка проекта на Git"
echo "=========================="

# Инициализация Git репозитория (если еще не инициализирован)
if [ ! -d ".git" ]; then
    echo "🔧 Инициализация Git репозитория..."
    git init
fi

# Добавление всех файлов
echo "📁 Добавление файлов..."
git add .

# Создание коммита
echo "💾 Создание коммита..."
COMMIT_MESSAGE="Complete IntoClouds project - $(date '+%Y-%m-%d %H:%M:%S')"
git commit -m "$COMMIT_MESSAGE"

# Добавление remote origin (замените на ваш репозиторий)
echo "🔗 Настройка remote origin..."
echo "Введите URL вашего Git репозитория (например: https://github.com/username/intoclouds.git):"
read REPO_URL

if [ ! -z "$REPO_URL" ]; then
    # Удаляем существующий origin если есть
    git remote remove origin 2>/dev/null || true
    
    # Добавляем новый origin
    git remote add origin "$REPO_URL"
    
    # Устанавливаем upstream для main ветки
    git branch -M main
    
    # Пушим на GitHub
    echo "🚀 Загрузка на GitHub..."
    git push -u origin main --force
    
    echo "✅ Проект успешно загружен на Git!"
    echo "🌐 Репозиторий: $REPO_URL"
else
    echo "❌ URL репозитория не указан"
    exit 1
fi
