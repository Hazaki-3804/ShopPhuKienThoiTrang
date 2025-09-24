# Stage 1: The builder stage (Build all dependencies)
FROM php:8.3-fpm-alpine AS builder

# Install system dependencies
RUN apk add --no-cache \
    curl \
    git \
    libzip-dev \
    libpng-dev \
    jpeg-dev \
    postgresql-dev \
    oniguruma-dev

# Install PHP extensions
RUN docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_pgsql zip exif bcmath mbstring opcache

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | sh -
RUN apk add --no-cache nodejs

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory
WORKDIR /app

# Copy all application files
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Install Node.js dependencies and build assets
RUN npm install
RUN npm run build

# Stage 2: The final production image
FROM php:8.3-fpm-alpine
WORKDIR /app

# Copy the built application from the builder stage
COPY --from=builder /app /app

# Install Nginx and other runtime dependencies
RUN apk add --no-cache nginx

# Copy Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port for Nginx
EXPOSE 8000

# Set permissions
RUN chown -R www-data:www-data /app \
    && chmod -R 775 /app/storage /app/bootstrap/cache

# Define the start command
CMD sh -c "php artisan migrate --force && nginx && php-fpm"