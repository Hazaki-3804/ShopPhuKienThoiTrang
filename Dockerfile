# Stage 1: Build PHP dependencies and backend
FROM composer:2.7 AS composer_build
WORKDIR /app
COPY . .
RUN composer install --no-dev --optimize-autoloader

# Stage 2: Build Node dependencies and frontend
FROM node:20 AS node_build
WORKDIR /app
COPY . .
COPY --from=composer_build /app/vendor /app/vendor
RUN npm install
RUN npm run build

# Stage 3: Final image to run the application
FROM php:8.3-fpm-alpine
WORKDIR /app
COPY --from=composer_build /app/vendor /app/vendor
COPY --from=node_build /app/public/build /app/public/build
COPY --from=node_build /app/node_modules /app/node_modules
COPY --from=node_build /app/dist /app/dist
COPY . .

# Install PHP extensions and dependencies
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

# Copy Nginx configuration
COPY .docker/nginx.conf /etc/nginx/nginx.conf

# Set permissions
RUN chown -R www-data:www-data /app && \
    chmod -R 775 /app/storage /app/bootstrap/cache

# Define the start command
CMD sh -c "php artisan migrate --force && nginx && php-fpm"