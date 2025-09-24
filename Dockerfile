# Sử dụng phiên bản PHP 8.2
FROM wyveo/nginx-php-fpm:php82  

WORKDIR /var/www/html

COPY . .
# Thêm sau phần COPY . .
RUN apt-get update && apt-get install -y libpq-dev \
    && docker-php-ext-install pdo_pgsql  # Đảm bảo driver PostgreSQL

# Install Composer dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Install Node và build Vue assets
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm ci --only=production \
    && npm run build  # Build Vue assets (thay bằng 'npm run prod' nếu dùng Mix)

# Permissions cho Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Copy Nginx config (tạo file nginx.conf ở root)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Deploy script (tạo file 00-laravel-deploy.sh ở root, chmod +x)
COPY 00-laravel-deploy.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/00-laravel-deploy.sh

CMD ["nginx-php-fpm"]