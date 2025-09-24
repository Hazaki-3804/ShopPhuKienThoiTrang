# Stage 1: Build PHP dependencies
FROM composer:2.7 AS composer_build
WORKDIR /app
COPY . .
RUN composer install --no-dev --optimize-autoloader

# Stage 2: Build frontend assets
FROM node:20 AS node_build
WORKDIR /app
COPY . .
# Copy vendor folder from composer stage to enable `php artisan` during npm build
COPY --from=composer_build /app/vendor /app/vendor
RUN npm install
RUN npm run build

# Stage 3: Final image to run the application
FROM php:8.3-fpm-alpine
WORKDIR /app

# Copy necessary files from build stages
COPY --from=composer_build /app /app
COPY --from=node_build /app/public/build /app/public/build

# Install Nginx and required PHP extensions
RUN apk add --no-cache \
    nginx \
    libzip-dev \
    libpng-dev \
    jpeg-dev \
    postgresql-dev \
    oniguruma-dev && \
    docker-php-ext-configure gd --with-jpeg && \
    docker-php-ext-install -j$(nproc) gd pdo pdo_pgsql zip exif bcmath mbstring opcache && \
    rm -rf /var/cache/apk/*

# Expose port 8000 for Nginx
EXPOSE 8000

# Copy Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Set permissions
RUN chown -R www-data:www-data /app && \
    chmod -R 775 /app/storage /app/bootstrap/cache

# Define the start command
CMD sh -c "php artisan migrate --force && nginx && php-fpm"