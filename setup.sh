# Setup script for the application
# Modify this file rather than the Dockerfile
# These steps are ran when building the image.

# Empty PHPBB Config
touch /persist/config.php
ln -s /persist/config.php /var/www/php/
chown -R www-data:www-data /persist/config.php