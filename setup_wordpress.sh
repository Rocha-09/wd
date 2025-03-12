#!/bin/bash

# 设置域名和邮箱
DOMAIN="defenseconsulting.me"
EMAIL="ericshum2025@outlook.com"

# 创建docker-compose.yml文件
cat <<EOF > docker-compose.yml
version: '3.7'

services:
  wordpress:
    image: wordpress:latest
    depends_on:
      - db
      - nginx
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress
    volumes:
      - wordpress_data:/var/www/html

  db:
    image: mysql:5.7
    environment:
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress
      MYSQL_ROOT_PASSWORD: root_password
    volumes:
      - db_data:/var/lib/mysql

  nginx:
    image: nginx:latest
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf
      - ./letsencrypt:/etc/letsencrypt
      - ./certbot/www:/var/www/certbot
    depends_on:
      - wordpress

  certbot:
    image: certbot/certbot
    volumes:
      - ./letsencrypt:/etc/letsencrypt
      - ./certbot/www:/var/www/certbot

volumes:
  wordpress_data:
  db_data:

networks:
  default:
    driver: bridge
EOF

# 创建Nginx配置文件
cat <<EOF > ./nginx.conf
server {
    listen 80;
    server_name $DOMAIN;

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        return 301 https://\$host\$request_uri;
    }
}

server {
    listen 443 ssl;
    server_name $DOMAIN;

    ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;

    location / {
        proxy_pass http://wordpress:80;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# 启动Docker服务
docker-compose up -d

# 等待服务初始化
sleep 30

# 使用Certbot获取证书
docker-compose run --rm certbot certonly --webroot --webroot-path=/var/www/certbot -d $DOMAIN --email $EMAIL --agree-tos --no-eff-email

# 重新加载Nginx配置
docker-compose exec nginx nginx -s reload

echo "WordPress 已成功设置并运行在 https://$DOMAIN"
