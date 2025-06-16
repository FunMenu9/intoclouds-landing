#!/bin/bash

echo "🔥 Настройка файрвола Azure VM"
echo "=============================="

# Установка UFW (если не установлен)
echo "📦 Установка UFW..."
sudo apt install ufw -y

# Сброс правил UFW
echo "🔄 Сброс правил UFW..."
sudo ufw --force reset

# Разрешение SSH (важно!)
echo "🔑 Разрешение SSH..."
sudo ufw allow ssh
sudo ufw allow 22

# Разрешение HTTP и HTTPS
echo "🌐 Разрешение HTTP/HTTPS..."
sudo ufw allow 80
sudo ufw allow 443

# Разрешение портов для разработки (опционально)
echo "🔧 Разрешение портов для разработки..."
sudo ufw allow 3000  # Next.js
sudo ufw allow 1337  # Strapi

# Включение UFW
echo "🔥 Включение файрвола..."
sudo ufw --force enable

# Проверка статуса
echo "📊 Статус файрвола:"
sudo ufw status verbose

echo "✅ Файрвол настроен!"
echo ""
echo "📋 Открытые порты:"
echo "- 22 (SSH)"
echo "- 80 (HTTP)"
echo "- 443 (HTTPS)"
echo "- 3000 (Next.js - для разработки)"
echo "- 1337 (Strapi - для разработки)"
