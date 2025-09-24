FROM wyveo/nginx-php-fpm:php82

WORKDIR /var/www/html

COPY . .

# Cài GPG keys và PostgreSQL driver
RUN apt-get update && apt-get install -y gnupg2 wget ca-certificates \
    && mkdir -p /etc/apt/keyrings \
    && wget -qO /etc/apt/keyrings/sury-php.gpg https://packages.sury.org/php/apt.gpg \
    && wget -qO /etc/apt/keyrings/nginx.gpg http://nginx.org/keys/nginx_signing.key \
    && echo "deb [signed-by=/etc/apt/keyrings/sury-php.gpg] https://packages.sury.org/php bullseye main" > /etc/apt/sources.list.d/php.list \
    && echo "deb [signed-by=/etc/apt/keyrings/nginx.gpg] http://nginx.org/packages/mainline/debian bullseye nginx" > /etc/apt/sources.list.d/nginx.list \
    && apt-get update && apt-get install -y libpq-dev \
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