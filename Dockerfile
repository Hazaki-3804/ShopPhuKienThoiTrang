# =========================
# Stage 1: Build PHP + Node (frontend + Wayfinder)
# =========================
FROM php:8.2-fpm AS build

# Cài dependencies cho PHP + Node
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpq-dev \
    unzip \
    git \
    curl \
    nodejs \
    npm \
    && docker-php-ext-install zip pdo_pgsql pgsql \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /var/www

# Copy composer files & install PHP deps
COPY composer.* ./
RUN composer install --no-dev --optimize-autoloader

# Copy package.json & install Node deps
COPY package*.json ./
RUN npm install

# Copy full source code
COPY . .

# Generate Wayfinder types (PHP có sẵn ở đây)
RUN php artisan wayfinder:generate --with-form

# Build frontend Vite
RUN npm run build

# Laravel permissions
RUN chmod -R 775 storage bootstrap/cache

# =========================
# Stage 2: Production runtime (PHP-FPM only)
# =========================
FROM php:8.2-fpm

WORKDIR /var/www

# Copy PHP extensions + composer from build stage
COPY --from=build /usr/local/lib/php/extensions /usr/local/lib/php/extensions
COPY --from=build /usr/bin/composer /usr/bin/composer

# Copy Laravel source + built frontend
COPY --from=build /var/www ./

# Permissions
RUN chmod -R 775 storage bootstrap/cache

# Cache config & routes
RUN php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache

# Expose port PHP-FPM
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm"]
