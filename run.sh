#!/bin/sh

COMPOSER_CACHE_DIR="$WERCKER_CACHE_DIR/weyforth/composer"
COMPOSER_CACHE_BIN_FILE=composer.phar
COMPOSER_CACHE_BIN="$COMPOSER_CACHE_DIR/$COMPOSER_CACHE_BIN_FILE"

mkdir -p "$COMPOSER_CACHE_DIR"

[ ! -f "$COMPOSER_CACHE_BIN" ] && \
  curl -sS https://getcomposer.org/installer | php -- --install-dir="$COMPOSER_CACHE_DIR" --filename="$COMPOSER_CACHE_BIN_FILE"

cp "$COMPOSER_CACHE_BIN" /usr/local/bin/composer
chmod +x /usr/local/bin/composer

COMPOSER_USER=${WERCKER_COMPOSER_USER:-$WERCKER_WP_CLI_ENV_USER}

COMPOSER_USER=${COMPOSER_USER:-root}

[ "$COMPOSER_USER" != "root" ] && chsh -s /bin/sh "$COMPOSER_USER"

su -c "composer install" - "$COMPOSER_USER"
