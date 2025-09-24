#!/bin/bash
set -e

echo "Deploying Laravel app..."

# Generate app key nếu chưa có
if [ -z "$APP_KEY" ]; then
    php artisan key:generate --no-interaction
fi

# Cache config
php artisan config:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Migrate (nếu dùng DB)
php artisan migrate --force

echo "Deploy complete!"