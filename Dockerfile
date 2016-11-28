FROM php:7.0.12-cli

RUN curl --silent --location https://deb.nodesource.com/setup_6.x | bash -
# install the PHP extensions we need
RUN apt-get update && apt-get install -y --no-install-recommends libmagickwand-dev zlib1g-dev libjpeg62-turbo-dev libicu-dev libjpeg-dev libfreetype6-dev libgd-dev nodejs libmcrypt-dev libc-client-dev libkrb5-dev libbz2-dev libreadline-dev libxml2-dev libpng12-dev libjpeg-dev libpq-dev git libxslt-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr --with-freetype-dir=/usr \
	&& docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
	&& docker-php-ext-install imap gd calendar xsl bcmath bz2 intl exif pcntl mbstring opcache pdo pdo_mysql pdo_pgsql zip ftp soap mcrypt \
	&& pecl install imagick \
	&& docker-php-ext-enable imagick \
	&& curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
	&& curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
	&& php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" \
	&& php /tmp/composer-setup.php --filename=/tmp/composer \
	&& mv /tmp/composer /usr/bin/ \
	&& chmod +x /usr/bin/composer \
	&& npm install --global gulp-cli bower

ENV COMPOSER_ALLOW_SUPERUSER 1
