#!/bin/bash

echo "⚡ Быстрое обновление IntoClouds"
echo "==============================="

# Коммит и деплой одной командой
git add .
git commit -m "Quick update: $(date '+%Y-%m-%d %H:%M:%S')"

# Перезапуск приложения
pm2 restart all

echo "✅ Обновление завершено!"
pm2 status
