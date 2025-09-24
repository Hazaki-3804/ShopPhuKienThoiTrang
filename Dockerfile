# # Image PHP có sẵn
# FROM php:8.2-fpm

# # Cài extension cần thiết
# RUN apt-get update && apt-get install -y \
#     libzip-dev unzip git curl nodejs npm \
#     && docker-php-ext-install zip pdo pdo_mysql

# # Cài Composer
# COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# # Tạo thư mục làm việc
# WORKDIR /var/www

# # Copy toàn bộ mã nguồn
# COPY . .

# # Cài dependency PHP
# RUN composer install --no-dev --optimize-autoloader

# # Build frontend Vue bằng Vite
# RUN npm install && npm run build

# # Laravel permission
# RUN chmod -R 775 storage bootstrap/cache

# # EXPOSE PORT cho Render
# EXPOSE 8080

# # Lệnh chạy Laravel
# CMD php artisan serve --host=0.0.0.0 --port=8080
FROM wyveo/nginx-php-fpm:php82  # Hoặc php82 tùy version Laravel của bạn

WORKDIR /var/www/html

COPY . .

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