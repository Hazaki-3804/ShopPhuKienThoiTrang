# ===============================
# Stage 1: Builder
# ===============================
FROM php:8.2-fpm-bullseye AS builder

WORKDIR /var/www/html

# Remove problematic repos
RUN rm -f /etc/apt/sources.list.d/sury*.list \
    && rm -f /etc/apt/sources.list.d/nginx*.list

# Install system dependencies + Node.js 18 LTS
RUN apt-get update && apt-get install -y \
    libpq-dev \
    curl \
    gnupg2 \
    unzip \
    ca-certificates \
    git \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && node -v \
    && npm -v \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_pgsql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy all source code
COPY . .

# Create Laravel writable dirs
RUN mkdir -p storage/logs bootstrap/cache \
    && chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

# Switch to non-root user for Composer
USER www-data

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Switch back to root to install Node deps
USER root

# Copy package.json & package-lock.json (for npm caching)
COPY package*.json ./

# Install Node deps including devDependencies (Vite/Tailwind require dev deps)
RUN npm ci

# Build Vue + Vite assets
RUN npm run build \
    && npm prune --production \
    && rm -rf /root/.npm /root/.node-gyp

# Ensure Laravel permissions
RUN chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

# ===============================
# Stage 2: Production
# ===============================
FROM php:8.2-fpm-bullseye

WORKDIR /var/www/html

# Copy built app from builder
COPY --from=builder /var/www/html /var/www/html

# Copy Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy deploy script
COPY 00-laravel-deploy.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/00-laravel-deploy.sh

# Expose port for Render
EXPOSE 8080

# Start PHP-FPM
CMD ["php-fpm"]
