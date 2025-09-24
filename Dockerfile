FROM wyveo/nginx-php-fpm:php82

WORKDIR /var/www/html

COPY . .

# Cài PostgreSQL driver (từ Debian repo mặc định, không cần sury.org)
RUN apt-get update && apt-get install -y libpq-dev \
    && docker-php-ext-install pdo_pgsql

# Install Composer dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Install Node và build Vue assets
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm ci --only=production \
    && npm run build

# Permissions cho Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Copy Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Deploy script
COPY 00-laravel-deploy.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/00-laravel-deploy.sh

CMD ["nginx-php-fpm"]