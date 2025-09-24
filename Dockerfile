FROM node:18-bullseye AS builder

WORKDIR /var/www/html

# Cài PHP + extensions
RUN apt-get update && apt-get install -y \
        php8.2-cli php8.2-fpm php8.2-pgsql unzip git curl \
    && rm -rf /var/lib/apt/lists/*

# Cài Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy code
COPY . .

# Tạo writable dirs cho Laravel
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

# Stage production
FROM php:8.2-fpm-bullseye

WORKDIR /var/www/html

COPY --from=builder /var/www/html /var/www/html

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY 00-laravel-deploy.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/00-laravel-deploy.sh

EXPOSE 8080

CMD ["php-fpm"]
