# =========================
# Stage 1: Build Dependencies
# =========================
FROM php:8.2-apache AS build

# Install system dependencies
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
WORKDIR /var/www/html

# Copy composer binary
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy composer files and install PHP dependencies
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Copy package.json and install Node dependencies (include devDeps for build)
COPY package*.json ./
RUN npm ci

# Copy source code
COPY . .

# Generate Wayfinder types
RUN php artisan wayfinder:generate --with-form

# Build frontend assets
RUN npm run build

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 775 storage bootstrap/cache

# =========================
# Stage 2: Production Runtime
# =========================
FROM php:8.2-apache

# Install production dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpq-dev \
    && docker-php-ext-install zip pdo_pgsql pgsql \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN a2enmod rewrite headers

# Set working directory
WORKDIR /var/www/html

# Copy application from build stage
COPY --from=build /var/www/html ./

# Copy Apache configuration
COPY <<EOF /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    DocumentRoot /var/www/html/public
    
    <Directory /var/www/html/public>
        AllowOverride All
        Require all granted
    </Directory>
    
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 775 storage bootstrap/cache

# Cache Laravel configuration (will be overridden by environment variables)
RUN php artisan config:cache || true \
    && php artisan route:cache || true \
    && php artisan view:cache || true

# Create startup script
COPY <<EOF /usr/local/bin/start.sh
#!/bin/bash
set -e

# Wait for database if needed
if [ ! -z "\$DATABASE_URL" ] || [ ! -z "\$DB_HOST" ]; then
    echo "Waiting for database connection..."
    php artisan migrate --force || echo "Migration failed, continuing..."
fi

# Clear and cache config with environment variables
php artisan config:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Start Apache in foreground
exec apache2-foreground
EOF

RUN chmod +x /usr/local/bin/start.sh

# Expose port (Render will set PORT environment variable)
EXPOSE 80

# Start the application
CMD ["/usr/local/bin/start.sh"]
