#!/usr/bin/env bash
set -euo pipefail

if command -v apk >/dev/null 2>&1; then
  # *** Alpine ***
  apk add --no-cache \
    composer \
    php84 \
    php84-curl \
    php84-mbstring \
    php84-openssl \
    php84-phar \
    php84-xml \
    php84-zip

  if ! command -v php >/dev/null 2>&1 && command -v php84 >/dev/null 2>&1; then
    ln -sf /usr/bin/php84 /usr/local/bin/php
  fi
elif command -v dpkg >/dev/null 2>&1; then
  # *** Debian ***
  apt-get update
  apt-get install -y --no-install-recommends \
    composer \
    php-cli \
    php-curl \
    php-mbstring \
    php-xml \
    php-zip
  apt-get clean
  rm -rf /var/lib/apt/lists/*
elif command -v rpm >/dev/null 2>&1; then
  # *** RedHat/Fedora ***
  dnf install -y \
    composer \
    php-cli \
    php-common \
    php-curl \
    php-mbstring \
    php-xml \
    php-zip
  dnf clean all
else
  echo "Unsupported distro" >&2
  exit 1
fi

echo "php version output:"
php --version
echo "composer version output:"
composer --version
