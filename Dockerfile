# ===============================
# Stage 1: Build stage
# ===============================
FROM php:8.2-fpm-bullseye AS builder

WORKDIR /var/www/html

# Copy source code
COPY . .

# Remove any problematic repos (Sury, Nginx mainline)
RUN rm -f /etc/apt/sources.list.d/sury*.list \
    && rm -f /etc/apt/sources.list.d/nginx*.list

# Install system dependencies + Node.js 18
RUN apt-get update \
    && apt-get install -y \
        libpq-dev \
        curl \
        gnupg2 \
        unzip \
        ca-certificates \
        git \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_pgsql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Build Vue assets
RUN npm ci --only=production \
    && npm run build \
    && rm -rf /root/.npm /root/.node-gyp

# Set permissions
RUN chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

# ===============================
# Stage 2: Production stage
# ===============================
FROM php:8.2-fpm-bullseye

WORKDIR /var/www/html

# Copy built app from builder
COPY --from=builder /var/www/html /var/www/html

# Copy Nginx config if needed (Render can also manage Nginx)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy deploy script
COPY 00-laravel-deploy.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/00-laravel-deploy.sh

# Expose port (Render container)
EXPOSE 8080

# Start PHP-FPM
CMD ["php-fpm"]
