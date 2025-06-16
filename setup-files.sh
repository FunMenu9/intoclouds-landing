#!/bin/bash

# Создание файла .env.local
cat > .env.local << 'EOF'
# SMTP Configuration
SMTP_HOST=mail.intoclouds.io
SMTP_PORT=465
SMTP_USER=dev@intoclouds.io
SMTP_PASS=K1dw1d123@
SMTP_FROM=dev@intoclouds.io

# Next.js
NEXTAUTH_URL=http://your-domain.com
NEXTAUTH_SECRET=your-secret-key-here
EOF

# Создание ecosystem.config.js для PM2
cat > ecosystem.config.js << 'EOF'
module.exports = {
  apps: [{
    name: 'intoclouds',
    script: 'npm',
    args: 'start',
    cwd: '/home/ec2-user/intoclouds',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    env: {
      NODE_ENV: 'production',
      PORT: 3000
    }
  }]
}
EOF

# Создание nginx конфигурации
sudo mkdir -p /etc/nginx/sites-available
sudo cat > /etc/nginx/sites-available/intoclouds << 'EOF'
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
EOF

echo "Файлы созданы успешно!"
EOF
