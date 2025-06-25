FROM php:8.2-fpm

# Dépendances système pour composer, intl, zip, gd, pdo_mysql, etc.
RUN apt-get update && apt-get install -y \
    git unzip libicu-dev libzip-dev libpng-dev libjpeg-dev libfreetype6-dev openssl \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl pdo_mysql zip

# Extension MongoDB PHP
RUN pecl install mongodb && docker-php-ext-enable mongodb

# Installer Composer
COPY --from=composer:2.7 /usr/bin/composer /usr/bin/composer

# Travailler dans le dossier du projet (volume monté)
WORKDIR /var/www/html

# Droits (optionnel pour dev)
RUN usermod -u 1000 www-data

# Reco pour Symfony CLI en dev (si tu veux l’utiliser)
# RUN curl -sS https://get.symfony.com/cli/installer | bash && mv /root/.symfony5/bin/symfony /usr/local/bin/symfony

# Exposer le port (pas utile ici, mais tu peux le mettre)
# EXPOSE 9000

CMD ["php-fpm"]
