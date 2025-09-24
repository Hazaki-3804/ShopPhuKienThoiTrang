# Base PHP 8.2 + FPM
FROM php:8.2-fpm-bullseye

WORKDIR /var/www/html

# Cài system dependencies + PostgreSQL driver + unzip/git/curl
RUN apt-get update && apt-get install -y \
        libpq-dev \
        unzip \
        git \
        curl \
        gnupg2 \
    && docker-php-ext-install pdo_pgsql \
    && rm -rf /var/lib/apt/lists/*

# Cài Node 18 LTS (binary, tránh repo key issues)
RUN curl -fsSL https://nodejs.org/dist/v18.20.1/node-v18.20.1-linux-x64.tar.xz | tar -xJ -C /usr/local --strip-components=1 \
    && node -v \
    && npm -v

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

# Copy Nginx config (nếu có)
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY 00-laravel-deploy.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/00-laravel-deploy.sh

EXPOSE 8080

CMD ["php-fpm"]
