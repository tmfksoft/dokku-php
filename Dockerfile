FROM ubuntu

# Avoids tzdata wanting timezone info
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update

# Install Apache
RUN apt-get install apache2 -y

# Stop Apache for now
RUN service apache2 stop

# Copy in our modified config files
COPY ports.conf /etc/apache2/ports.conf
COPY 000-default.conf /etc/apache2/sites-enabled/000-default.conf

# Enable any modules
RUN a2enmod remoteip

# Install PHP and extensions (Latest PHP, currently 7.4)
RUN apt-get install -y libapache2-mod-php
RUN apt-get install -y php-mysqli php-xml php-gd php-curl php-mbstring

# Copy in the PHP files
COPY www /var/www/php
RUN chown -R www-data:www-data /var/www/

# Copy in the start script
COPY start.sh start.sh
RUN chmod +x start.sh

# Setup persistent storage
RUN mkdir /persist
VOLUME [ "/persist" ]

# Run the setup script for the application
COPY setup.sh setup.sh
RUN chmod +x setup.sh && ./setup.sh

EXPOSE 5000

# For now, expose the error logs.
CMD service apache2 start && tail -f /var/log/apache2/error.log