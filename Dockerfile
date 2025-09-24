# === Stage 1: Build stage ===
FROM php:8.2-fpm-bullseye AS builder

# Set working directory
WORKDIR /var/www/html

# Copy project source
COPY . .

# Install system dependencies
RUN apt-get update \
    && apt-get install -y \
        libpq-dev \
        curl \
        gnupg2 \
        unzip \
        nodejs \
        npm \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_pgsql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Composer dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Build Vue assets
RUN npm ci --only=production \
    && npm run build \
    && rm -rf /root/.npm /root/.node-gyp

# Fix permissions
RUN chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

# === Stage 2: Production stage ===
FROM php:8.2-fpm-bullseye

WORKDIR /var/www/html

# Copy built app from builder
COPY --from=builder /var/www/html /var/www/html

# Copy Nginx config (Render supports custom Nginx config if needed)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy deploy script
COPY 00-laravel-deploy.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/00-laravel-deploy.sh

# Expose port if needed
EXPOSE 8080

# Start PHP-FPM (Render sẽ quản lý Nginx riêng)
CMD ["php-fpm"]
