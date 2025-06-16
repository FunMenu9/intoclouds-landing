#!/bin/bash

# Установка Nginx
# Для Amazon Linux 2
sudo amazon-linux-extras install nginx1 -y

# Для Ubuntu
# sudo apt install nginx -y

# Запуск и автозапуск Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Создание символической ссылки
sudo ln -s /etc/nginx/sites-available/intoclouds /etc/nginx/sites-enabled/

# Удаление дефолтного сайта
sudo rm -f /etc/nginx/sites-enabled/default

# Проверка конфигурации
sudo nginx -t

# Перезапуск Nginx
sudo systemctl restart nginx

echo "Nginx установлен и настроен!"
