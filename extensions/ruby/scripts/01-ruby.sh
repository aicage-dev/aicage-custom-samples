#!/usr/bin/env bash
set -euo pipefail

if command -v apk >/dev/null 2>&1; then
  # *** Alpine ***
  apk add --no-cache \
    ruby \
    ruby-dev \
    ruby-bundler
elif command -v dpkg >/dev/null 2>&1; then
  # *** Debian ***
  apt-get update
  apt-get install -y --no-install-recommends \
    bundler \
    ruby-dev \
    ruby-full
  apt-get clean
  rm -rf /var/lib/apt/lists/*
elif command -v rpm >/dev/null 2>&1; then
  # *** RedHat/Fedora ***
  dnf install -y \
    ruby \
    ruby-devel \
    rubygem-bundler
  dnf clean all
else
  echo "Unsupported distro" >&2
  exit 1
fi

echo "ruby version output:"
ruby --version
echo "gem version output:"
gem --version
echo "bundle version output:"
bundle --version
