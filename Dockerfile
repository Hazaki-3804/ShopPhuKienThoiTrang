# Node 18 LTS + PHP 8.2-FPM base (simplified)
FROM php:8.2-fpm-bullseye

WORKDIR /var/www/html

# PHP deps
RUN apt-get update && apt-get install -y libpq-dev unzip git curl \
    && docker-php-ext-install pdo_pgsql \
    && rm -rf /var/lib/apt/lists/*

# Node 18 LTS
RUN curl -fsSL https://nodejs.org/dist/v18.20.1/node-v18.20.1-linux-x64.tar.xz \
    | tar -xJ -C /usr/local --strip-components=1

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy project
COPY . .

# Writable dirs
RUN mkdir -p storage bootstrap/cache \
    && chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

# Install PHP deps
USER www-data
RUN composer install --no-dev --optimize-autoloader --no-interaction
USER root

# Node deps + build
ENV NODE_OPTIONS=--openssl-legacy-provider
RUN npm ci && npm run build && npm prune --production

EXPOSE 9000
CMD ["php-fpm"]
