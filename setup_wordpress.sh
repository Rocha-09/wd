services:
  wordpress:
    image: wordpress:latest
    depends_on:
      - db
    ports:
      - "80:80"
      - "443:443"
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress
    volumes:
      - wordpress_data:/var/www/html
      - ./letsencrypt:/etc/letsencrypt
      - ./nginx.conf:/etc/nginx/conf.d/default.conf

  db:
    image: mysql:5.7
    environment:
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress
      MYSQL_ROOT_PASSWORD: root_password
    volumes:
      - db_data:/var/lib/mysql

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
