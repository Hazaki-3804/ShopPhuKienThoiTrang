# Image PHP có sẵn
FROM php:8.2-fpm

# Cài extension cần thiết
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpq-dev \
    unzip \
    git \
    curl \
    nodejs \
    npm \
    && docker-php-ext-install zip pdo_pgsql pgsql

# Cài Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Tạo thư mục làm việc
WORKDIR /var/www

# Copy toàn bộ mã nguồn
COPY . .

# Cài dependency PHP
RUN composer install --no-dev --optimize-autoloader 

# Build frontend Vue bằng Vite
RUN npm install && npm run build

# Laravel permission
RUN chmod -R 775 storage bootstrap/cache

# EXPOSE PORT cho Render
EXPOSE 8080

# Lệnh chạy Laravel
CMD php artisan serve --host=0.0.0.0 --port=8080
