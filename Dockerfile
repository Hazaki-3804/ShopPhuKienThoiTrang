# Sử dụng image PHP 8.2 + FPM + Debian bullseye
FROM php:8.2-fpm-bullseye

WORKDIR /var/www/html

# Cài system deps cơ bản + Node 18 LTS
RUN apt-get update && apt-get install -y \
        libpq-dev \
        unzip \
        git \
        curl \
        gnupg2 \
        ca-certificates \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && docker-php-ext-install pdo_pgsql \
    && rm -rf /var/lib/apt/lists/*

# Cài Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy toàn bộ code
COPY . .

# Tạo thư mục writable cho Laravel
RUN mkdir -p storage/logs bootstrap/cache \
    && chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

# Cài PHP dependencies
USER www-data
RUN composer install --no-dev --optimize-autoloader --no-interaction
USER root

# Cài Node dependencies + build Vue/Vite
RUN npm ci \
    && npm run build \
    && npm prune --production \
    && rm -rf /root/.npm /root/.node-gyp

# Copy Nginx config (nếu có)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy script deploy nếu có
COPY 00-laravel-deploy.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/00-laravel-deploy.sh

# Chỉ expose port Render dùng
EXPOSE 8080

# Start PHP-FPM
CMD ["php-fpm"]
