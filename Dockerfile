# Stage 1: build frontend
FROM node:20-alpine AS node-builder

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: PHP + Laravel
FROM php:8.2-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpq-dev \
    unzip \
    git \
    curl \
    && docker-php-ext-install zip pdo_pgsql pgsql \
    && rm -rf /var/lib/apt/lists/*

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy Laravel app
COPY . .

# Copy built frontend
COPY --from=node-builder /app/dist ./public/build

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Permissions
RUN chmod -R 775 storage bootstrap/cache

# Clear & cache config
RUN php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache

# Expose port (PHP-FPM)
EXPOSE 9000

# Run PHP-FPM (production-ready)
CMD ["php-fpm"]
