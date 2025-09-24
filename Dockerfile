# Base image
FROM wyveo/nginx-php-fpm:php82

WORKDIR /var/www/html

# Copy source code
COPY . .

# --- Remove problematic repos (Sury PHP, Nginx mainline) ---
RUN rm -f /etc/apt/sources.list.d/sury*.list \
    && rm -f /etc/apt/sources.list.d/nginx*.list

# --- Update apt & install PostgreSQL driver ---
RUN apt-get update \
    && apt-get install -y libpq-dev gnupg2 curl ca-certificates unzip \
    && docker-php-ext-install pdo_pgsql \
    && rm -rf /var/lib/apt/lists/*

# --- Install Composer dependencies ---
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer install --no-dev --optimize-autoloader --no-interaction

# --- Install Node.js & build Vue assets ---
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm ci --only=production \
    && npm run build \
    && rm -rf /var/lib/apt/lists/* /root/.npm /root/.node-gyp

# --- Set permissions for Laravel ---
RUN chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

# --- Copy Nginx config ---
COPY nginx.conf /etc/nginx/conf.d/default.conf

# --- Deploy script ---
COPY 00-laravel-deploy.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/00-laravel-deploy.sh

# --- Default command ---
CMD ["nginx-php-fpm"]
