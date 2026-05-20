FROM php:8.2-apache

# Set working directory
WORKDIR /var/www/html

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libssl-dev \
    libcurl4-openssl-dev \
    curl \
    && docker-php-ext-install mysqli curl \
    && docker-php-ext-enable mysqli \
    && a2enmod rewrite \
    && a2enmod headers \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy entire backend to the container
COPY . .

# Create necessary directories with proper permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Configure Apache virtual host
RUN cat > /etc/apache2/sites-available/000-default.conf <<'EOF'
<VirtualHost *:80>
    DocumentRoot /var/www/html
    
    <Directory /var/www/html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    # Enable CORS headers
    Header set Access-Control-Allow-Origin "*"
    Header set Access-Control-Allow-Methods "GET, POST, OPTIONS, DELETE, PUT"
    Header set Access-Control-Allow-Headers "Content-Type, Authorization, X-Requested-With"

    # Rewrite rules for clean API paths
    <IfModule mod_rewrite.c>
        RewriteEngine On
        RewriteBase /
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteRule ^api/(.*)$ api/$1 [L]
    </IfModule>

    # Logging
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

# Enable the default site
RUN a2ensite 000-default

# Set PHP configuration for production
RUN cat > /usr/local/etc/php/conf.d/custom.ini <<'EOF'
display_errors = Off
log_errors = On
error_log = /proc/stderr
max_upload_size = 50M
upload_max_filesize = 50M
post_max_size = 50M
memory_limit = 256M
default_socket_timeout = 60
EOF

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/api/health.php || exit 1

# Expose port (Render uses PORT env var, defaults to 80)
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
